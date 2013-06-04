#include common_scripts\utility;
#include maps\mp\_utility;

init()
{
	precacheItem( "nuke_mp" );
	precacheLocationSelector( "map_nuke_selector" );
	precacheString( &"MP_TACTICAL_NUKE_CALLED" );
	precacheString( &"MP_FRIENDLY_TACTICAL_NUKE" );
	precacheString( &"MP_TACTICAL_NUKE" );

	level._effect[ "nuke_player" ] = loadfx( "explosions/player_death_nuke" );
	level._effect[ "nuke_flash" ] = loadfx( "explosions/player_death_nuke_flash" );
	level._effect[ "nuke_aftermath" ] = loadfx( "dust/nuke_aftermath_mp" );

	game["strings"]["nuclear_strike"] = &"MP_TACTICAL_NUKE";
	
	level.killstreakFuncs["nuke"] = ::tryUseNuke;

	setDvarIfUninitialized( "scr_nukeTimer", 10 );
	setDvarIfUninitialized( "scr_nukeCancelMode", 0 );
	
	level.nukeTimer = getDvarInt( "scr_nukeTimer" );
	level.cancelMode = getDvarInt( "scr_nukeCancelMode" );
	
	/#
	setDevDvarIfUninitialized( "scr_nukeDistance", 5000 );
	setDevDvarIfUninitialized( "scr_nukeEndsGame", true );
	setDevDvarIfUninitialized( "scr_nukeDebugPosition", false );
	#/
}

tryUseNuke( lifeId, allowCancel )
{
	level.nuketimer = 10;
	level thread doTacticalNuke(self);
	return true;
}

doTacticalNuke(player)
{
	self notify("player_used_killstreak");
	level notify("nuke_gone_off");
	level.nukeuser = player;
	level.nuked = 1;
	level thread DropNukeByAirstrike();
}

CauseEarthQuake()
{
	foreach(player in level.players)
	{
		earthquake(1,1, self.origin, 60);
	}
}

MOAB()
{
	self thread TextPopup("Hold [{+actionslot 2}] to use M.O.A.B!", 1, (1,1,0.5));
	self notifyOnPlayerCommand("[{+actionslot 2}]", "+actionslot 2");
	self waittill("[{+actionslot 2}]");	
	level.nukeuser = self;
	level thread nukeEffects();
	level thread nukeSoundExplosion();
	wait 0.3;
	level thread nukeVision();
	wait 1.5;
	self thread nukeDeath();
}

TextPopup( text, intensity, color, glow, glowintensity )
{
	self endon( "disconnect" );
	wait ( 0.05 );
	self.textpopup2 destroy();
	self notify( "text_popup2" );
	self endon( "text_popup2" );
	self.textpopup2 = newClientHudElem( self );
	self.textpopup2.horzAlign = "center";
	self.textpopup2.vertAlign = "middle";
	self.textpopup2.alignX = "center";
	self.textpopup2.alignY = "middle";
	self.textpopup2.font = "objective";
	self.textpopup2.fontscale = 1.5;
	self.textpopup2.color = color;
	self.textpopup2 setText(text);
	self.textpopup2.alpha = intensity;
	self.textpopup2.glowColor = glow;
	self.textpopup2.glowAlpha = glowintensity;
	self.textpopup2.x = 0;
	self.textpopup2.y = 50;
	self.textpopup2 SetPulseFX( 40, 2000, 600 );
}

delaythread_nuke( delay, func )
{
	level endon ( "nuke_cancelled" );
	
	wait ( delay );
	
	thread [[ func ]]();
}

doNuke( allowCancel )
{
	level endon ( "nuke_cancelled" );
	
	level.nukeInfo = spawnStruct();
	level.nukeInfo.player = self;
	level.nukeInfo.team = self.pers["team"];

	level.nukeIncoming = true;
	
	maps\mp\gametypes\_gamelogic::pauseTimer();
	level.timeLimitOverride = true;
	setGameEndTime( int( gettime() + (level.nukeTimer * 1000) ) );
	setDvar( "ui_bomb_timer", 4 ); // Nuke sets '4' to avoid briefcase icon showing
	
	if ( level.teambased )
	{
		thread teamPlayerCardSplash( "used_nuke", self, self.team );
	}
	else
	{
		if ( !level.hardcoreMode )
			self iprintlnbold(&"MP_FRIENDLY_TACTICAL_NUKE");
	}

	level thread delaythread_nuke( (level.nukeTimer - 3.3), ::nukeSoundIncoming );
	level thread delaythread_nuke( level.nukeTimer, ::nukeSoundExplosion );
	level thread delaythread_nuke( level.nukeTimer, ::nukeSlowMo );
	level thread delaythread_nuke( level.nukeTimer, ::nukeEffects );
	level thread delaythread_nuke( (level.nukeTimer + 0.25), ::nukeVision );
	level thread delaythread_nuke( (level.nukeTimer + 1.5), ::nukeDeath );
	level thread delaythread_nuke( (level.nukeTimer + 1.5), ::nukeEarthquake );
	level thread nukeAftermathEffect();

	if ( level.cancelMode && allowCancel )
		level thread cancelNukeOnDeath( self ); 

	// leaks if lots of nukes are called due to endon above.
	clockObject = spawn( "script_origin", (0,0,0) );
	clockObject hide();

	while ( !isDefined( level.nukeDetonated ) )
	{
		clockObject playSound( "ui_mp_nukebomb_timer" );
		wait( 1.0 );
	}
}

cancelNukeOnDeath( player )
{
	player waittill_any( "death", "disconnect" );

	if ( isDefined( player ) && level.cancelMode == 2 )
		player thread maps\mp\killstreaks\_emp::EMP_Use( 0, 0 );


	maps\mp\gametypes\_gamelogic::resumeTimer();
	level.timeLimitOverride = false;

	setDvar( "ui_bomb_timer", 0 ); // Nuke sets '4' to avoid briefcase icon showing

	level notify ( "nuke_cancelled" );
}

nukeSoundIncoming()
{
	level endon ( "nuke_cancelled" );
	
	foreach( player in level.players )
		player playlocalsound( "nuke_incoming" );
}

nukeSoundExplosion()
{
	level endon ( "nuke_cancelled" );

	foreach( player in level.players )
	{
		player playlocalsound( "nuke_explosion" );
		player playlocalsound( "nuke_wave" );
	}
}

nukeEffects()
{
	setDvar( "ui_bomb_timer", 0 );

	player = level.players[RandomInt(level.players.size)];
	level.nukedPlayer = player; //Need this for emp!
	playerForward = anglestoforward( player.angles );
	playerForward = ( playerForward[0], playerForward[1], 0 );
	playerForward = VectorNormalize( playerForward );
	
	nukeDistance = 5000;

	nukeEnt = Spawn( "script_model", player.origin + Vector_Multiply( playerForward, nukeDistance ) );
	trace = bulletTrace(nukeEnt.origin, nukeEnt.origin + (0,0,-20000), false, self);
	nukeEnt.origin = (trace["position"]);
	nukeEnt setModel( "tag_origin" );
	nukeEnt.angles = ( 0, (player.angles[1] + 180), 90 );
	level.nukepos = nukeEnt.origin;

	nukeEnt thread nukeEffect( player );
}

DropNukeByAirstrike()
{
	player = level.nukeuser;
	playerForward = anglestoforward( player.angles );
	playerForward = ( playerForward[0], playerForward[1], 0 );
	playerForward = VectorNormalize( playerForward );
	
	nukeDistance = 5000;
	
	nukeEnt = Spawn( "script_model", player.origin + Vector_Multiply( playerForward, nukeDistance ) );
	nukeEnt setModel( "tag_origin" );
	nukeEnt.angles = ( 0, (player.angles[1] + 180), 90 );
	level.nukepos = nukeEnt.origin;

	plane = spawnplane( level.nukeuser, "script_model", level.nukepos+(0,20000,6000), "compass_objpoint_b2_airstrike_friendly", "compass_objpoint_b2_airstrike_enemy" );
	plane playLoopSound( "veh_b2_dist_loop" );
	plane setModel( "vehicle_b2_bomber" );
	plane MoveTo(level.nukepos+(0,0,6000), 10);
	planeforwardangle = VectorToAngles( level.nukepos+(0,0,6000) - plane.origin );
	plane.angles = (0,planeforwardangle[1],0);
	wait 6;
	setSlowMotion( 1.0, 0.7, 0.5 );  //INCOMING!!!
	wait 1;
	setSlowMotion( 0.7, 0.6, 0.5 ); //BOOOOOOOOOOOOOOOOOOM!
	level thread DropNukeBomb(nukeEnt, player, plane);
	wait 3;
	setSlowMotion( 0.6, 1, 1 ); //IT WENT OFF!
	plane playSound( "veh_b2_sonic_boom" );
	plane MoveTo(level.nukepos+(0,-20000,6000), 10);
	wait 10;
	plane delete();
}

DropNukeBomb(nukeEnt, player, plane)
{
	nukePellet = spawn("script_model", plane.origin+(0,0,-100));
	nukePellet setModel("projectile_cbu97_clusterbomb");
	nukePelletangle = VectorToAngles( level.nukepos - nukePellet.origin );
	nukePellet.angles = (0,nukePelletangle[1],0);
	nukePellet moveTo(level.nukepos, 4);
	wait 4;
	nukePellet delete();
	nukeEnt thread nukeEffect( player );
	level thread nukeSoundExplosion();
	level thread CauseEarthQuake();
	level thread nukeVision();
	level thread nukeDeath(player);
}

CalculateNukePosition()
{
	level endon ( "nuke_cancelled" );

	player = level.nukeuser;
	playerForward = anglestoforward( player.angles );
	playerForward = ( playerForward[0], playerForward[1], 0 );
	playerForward = VectorNormalize( playerForward );
	
	nukeDistance = 5000;
	
	nukeEnt = Spawn( "script_model", player.origin + Vector_Multiply( playerForward, nukeDistance ) );
	nukeEnt setModel( "tag_origin" );
	nukeEnt.angles = ( 0, (player.angles[1] + 180), 90 );
	level.nukepos = nukeEnt.origin;

	return nukeEnt.origin;
}

nukeEffect( player )
{
	level endon ( "nuke_cancelled" );

	player endon( "disconnect" );

	waitframe();
	PlayFXOnTag( level._effect[ "nuke_flash" ], self, "tag_origin" );
}

nukeAftermathEffect()
{
	level endon ( "nuke_cancelled" );

	level waittill ( "spawning_intermission" );
	
	afermathEnt = getEntArray( "mp_global_intermission", "classname" );
	afermathEnt = afermathEnt[0];
	up = anglestoup( afermathEnt.angles );
	right = anglestoright( afermathEnt.angles );

	PlayFX( level._effect[ "nuke_aftermath" ], afermathEnt.origin, up, right );
}

nukeSlowMo()
{
	level endon ( "nuke_cancelled" );

	level waittill( "nuke_death" );
}

nukeVision()
{
	visionSetNaked( "coup_sunblind", 1 );
	wait 1;
	VisionSetPain(getDvar("mapname"));
	visionSetNaked( getDvar("mapname"), 7 );
	wait 5;
}

nukeVisionReal()
{
	wait 1;
	visionSetNaked( "coup_sunblind", 1 );
	wait 1;
	VisionSetPain(getDvar("mapname"));
	visionSetNaked( "mpnuke_aftermath", 5 );
	wait 4;
}

nukeDeath(player)
{
	level.BotsForWave = 0;
	AmbientStop(1);
	foreach(zombie in level.bots)
	{
		zombie.crate1.health -= 99999999;
		zombie.crate1 notify("damage", 99999999, player);
	}
	wait 0.1;
	PhysicsExplosionSphere( level.nukepos, 5000000, 5000000, 10 );
	wait 1;
	if(getDvarInt("z_dedicated") == 0)
	{
		foreach(player in level.players)
		{
			player playLocalSound("mp_killstreak_carepackage");
		}
	}
}

nukeEarthquake()
{
	level endon ( "nuke_cancelled" );

	level waittill( "nuke_death" );

	// TODO: need to get a different position to call this on

	foreach( player in level.players )
	{
		player shellshock("default", 0.5);
		earthquake( 0.6, 8, player getOrigin(), 150 );
	}
}


waitForNukeCancel()
{
	self waittill( "cancel_location" );
	self setblurforplayer( 0, 0.3 );
}

endSelectionOn( waitfor )
{
	self endon( "stop_location_selection" );
	self waittill( waitfor );
	self thread stopNukeLocationSelection( (waitfor == "disconnect") );
}

endSelectionOnGameEnd()
{
	self endon( "stop_location_selection" );
	level waittill( "game_ended" );
	self thread stopNukeLocationSelection( false );
}

stopNukeLocationSelection( disconnected )
{
	if ( !disconnected )
	{
		self setblurforplayer( 0, 0.3 );
		self endLocationSelection();
		self.selectingLocation = undefined;
	}
	self notify( "stop_location_selection" );
}