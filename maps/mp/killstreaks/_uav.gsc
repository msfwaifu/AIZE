#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	precacheString( &"MP_WAR_RADAR_ACQUIRED" );
	precacheString( &"MP_WAR_RADAR_ACQUIRED_ENEMY" );
	precacheString( &"MP_WAR_RADAR_EXPIRED" );
	precacheString( &"MP_WAR_RADAR_EXPIRED_ENEMY" );
	
	precacheString( &"MP_WAR_COUNTER_RADAR_ACQUIRED" );	
	precacheString( &"MP_WAR_COUNTER_RADAR_ACQUIRED_ENEMY" );
	precacheString( &"MP_WAR_COUNTER_RADAR_EXPIRED" );
	precacheString( &"MP_WAR_COUNTER_RADAR_EXPIRED_ENEMY" );
	
	precacheModel( "vehicle_ac130_low_mp" );
	
	level.radarViewTime = 999999999; // time radar remains active
	level.uavBlockTime = 30; // this only seems to be used for the FFA version.
	
	assert( level.radarViewTime > 7 );
	assert( level.uavBlockTime > 7 );

	level.uav_fx[ "explode" ] = loadFx( "explosions/helicopter_explosion_cobra_low" );

	level.killStreakFuncs["uav"] = ::tryUseUAV;
	level.killStreakFuncs["double_uav"] = ::tryUseDoubleUAV;
	level.killStreakFuncs["counter_uav"] = ::tryUseCounterUAV;
	
	minimapOrigins = getEntArray( "minimap_corner", "targetname" );
	if ( miniMapOrigins.size )
		uavOrigin = maps\mp\gametypes\_spawnlogic::findBoxCenter( miniMapOrigins[0].origin, miniMapOrigins[1].origin );
	else
		uavOrigin = (0,0,0);
	
	level.radarMode["allies"] = "normal_radar";
	level.radarMode["axis"] = "normal_radar";
	level.activeUAVs["allies"] = 0;
	level.activeUAVs["axis"] = 0;
	level.activeCounterUAVs["allies"] = 0;
	level.activeCounterUAVs["axis"] = 0;
	
	level.uavModels["allies"] = [];
	level.uavModels["axis"] = [];
	wait 2;
	if(getdvar("mapname") == "mp_highrise" && level.edit == 0)
	{
	    level.UAVRig = spawn( "script_model", (-4162,12006,4954) );
	}
	if(getdvar("mapname") == "mp_highrise" && level.edit == 1)
	{
	    level.UAVRig = spawn( "script_model", (5395,8284,6450) );
	}
	else if(getdvar("mapname") == "mp_invasion")
	{
	    level.UAVRig = spawn( "script_model", (9212,6628,3347) );
	}
	else if(getdvar("mapname") == "mp_rust")
	{
	    level.UAVRig = spawn( "script_model", (1157,-7193,2164) );
	}
	else if(getdvar("mapname") == "mp_brecourt")
	{
	    level.UAVRig = spawn( "script_model", (10154,10188,3550) );
	}
	else if(getdvar("mapname") == "mp_afghan" && level.edit == 0)
	{
	    level.UAVRig = spawn( "script_model", (-5668,-1769,1469) );
	}
	else if(getdvar("mapname") == "mp_afghan" && level.edit == 1)
	{
	    level.UAVRig = spawn( "script_model", (7437,595,1687) );
	}
	else if(getdvar("mapname") == "mp_storm")
	{
	    level.UAVRig = spawn( "script_model", (4382,-4031,2282) );
	}
	else if(getdvar("mapname") == "mp_fuel2")
	{
	    level.UAVRig = spawn( "script_model", (12014,29169,14071) );
	}
	else if(getdvar("mapname") == "mp_complex")
	{
	    level.UAVRig = spawn( "script_model", (-834,994,1763) );
	}
	else if(getdvar("mapname") == "mp_overgrown")
	{
	    level.UAVRig = spawn( "script_model", (-1933,-7601,1306) );
	}
	else if(getdvar("mapname") == "mp_derail" && level.edit == 1)
	{
	    level.UAVRig = spawn( "script_model", (2126,-5037,1689) );
	}
	else if(getdvar("mapname") == "mp_crash")
	{
	    level.UAVRig = spawn( "script_model", (-2029,-868,2390) );
	}
	else
	{
		level.UAVRig = spawn( "script_model", uavOrigin );
	}
	level.UAVRig setModel( "c130_zoomrig" );
	level.UAVRig.angles = (0,115,0);
	level.UAVRig hide();

	level.UAVRig thread rotateUAVRig();
	level thread UAVTracker();
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		
		level.activeUAVs[ player.guid ] = 0;
		level.activeCounterUAVs[ player.guid ] = 0;
		
		level.radarMode[ player.guid ] = "normal_radar";
	}
}

rotateUAVRig()
{
	for (;;)
	{
		self rotateyaw( -360, 60 );
		wait ( 60 );
	}
}


launchUAV( )
{
    UAVModel = spawn( "script_model", level.UAVRig getTagOrigin( "tag_origin" ));
	UAVModel setModel( "vehicle_ac130_low_mp" );
			
	level.UAVspawn = UAVModel;

	UAVModel.team = "allies";
	UAVModel.owner = level;

	UAVModel thread handleIncomingStinger();

	addUAVModel( UAVModel );

	zOffset = randomIntRange( 10000, 11000 );

	angle = randomInt( 360 );
	radiusOffset = randomInt( 2000 ) + 5000;

	xOffset = cos( angle ) * radiusOffset;
	yOffset = sin( angle ) * radiusOffset;

	angleVector = vectorNormalize( (xOffset,yOffset,zOffset) );
	angleVector = vector_multiply( angleVector, randomIntRange( 6000, 7000 ) );
	
	UAVModel linkTo( level.UAVRig, "tag_origin", angleVector, (0,angle - 90,0) );

	UAVModel thread updateUAVModelVisibility();	

	UAVModel addActiveUAV();
	level waittill("delete_uav");
	UAVModel delete();
}


waittill_notify_or_timeout_hostmigration_pause( msg, timer )
{
	self endon( msg );
	
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( timer );
}


updateUAVModelVisibility()
{
	self endon ( "death" );
/*
	for ( ;; )
	{
		level waittill_either ( "joined_team", "uav_update" );
		
		self hide();
		foreach ( player in level.players )
		{
			if ( level.teamBased )
			{
				if ( player.team != self.team )
					self showToPlayer( player );
			}
			else
			{
				if ( isDefined( self.owner ) && player == self.owner )
					continue;
					
				self showToPlayer( player );
			}
		}
	}
	*/
}


damageTracker( isCounterUAV )
{
	level endon ( "game_ended" );
	
	self setCanDamage( true );
	self.maxhealth = 700;
	self.health = self.maxhealth;
	
	for ( ;; )
	{
		self waittill ( "damage", damage, attacker, direction_vec, point, sMeansOfDeath );
		
		if ( !isPlayer( attacker ) )
		{
			if ( !isDefined( self ) )
				return;
				
			continue;
		}
			
		attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "" );

		if ( attacker _hasPerk( "specialty_armorpiercing" ) && isDefined( self ) )
		{
			damageAdd = damage*level.armorPiercingMod;
			self.health -= int(damageAdd);
		}
		
		if ( !isDefined( self ) )
		{
			if ( isPlayer( attacker ) && (!isDefined(self.owner) || attacker != self.owner) )
			{
				if ( isCounterUAV )
					thread teamPlayerCardSplash( "callout_destroyed_counter_uav", attacker );
				else
					thread teamPlayerCardSplash( "callout_destroyed_uav", attacker );

				thread maps\mp\gametypes\_missions::vehicleKilled( self.owner, self, undefined, attacker, damage, sMeansOfDeath );
				attacker thread maps\mp\gametypes\_rank::giveRankXP( "kill", 50 );
				attacker notify( "destroyed_killstreak" );
			}
			return;
		}
	}
}


tryUseUAV( lifeId )
{
	return useUAV( "uav" );
}


tryUseDoubleUAV( lifeId )
{
	return useUAV( "double_uav" );
}


tryUseCounterUAV( lifeId )
{
	return useUAV( "counter_uav" );
}

resetOnDeath( )
{
	self waittill("death");
	self.usingUAV = false;
}

useUAV( uavType )
{
	self notify("player_used_killstreak");
	self thread UAVLauncherMissiles( uavType );
	return true;
}

DropRPGs(player, zombie)
{
	self endon("mig29_left");
	for(i = 0; i < 5; i += 1)
	{
		TmpDist = 999999999;
		pTarget = undefined;
		foreach( zombie in level.bots )
		{
			if(zombie.pers["isAlive"] == "false")
				continue;
				
			if(distancesquared(level.UAVspawn.origin, zombie.origin) < TmpDist)
			{
				TmpDist = distancesquared(self.origin, zombie.origin);
				pTarget = zombie;
			}
		}
		MagicBullet( "ac130_40mm_mp", self.origin+(0,0,-100), pTarget.origin+(randomIntRange(-200,200),randomIntRange(-200,200),0), player );
		wait 0.08;
	}
}

SpawnJet(zombie, player)
{
	planeStartOrigin = undefined;
	switch(randomInt(4))
	{
		case 0: planeStartOrigin = zombie.origin+(0,20000,0);
		break;
		case 1: planeStartOrigin = zombie.origin+(20000,0,0);
		break;
		case 2: planeStartOrigin = zombie.origin+(0,-20000,0);
		break;
		case 3: planeStartOrigin = zombie.origin+(-20000,0,0);
		break;
	}
	plane = spawnplane( player, "script_model", zombie.origin+(planeStartOrigin[0],planeStartOrigin[1],3000), "compass_objpoint_airstrike_friendly", "compass_objpoint_airstrike_friendly" );
	plane setModel( "vehicle_mig29_desert" );
	plane playloopsound( "veh_mig29_dist_loop" );
	planeforwardangle = VectorToAngles( zombie.origin+(0,0,3000) - plane.origin );
	plane.angles = (0,planeforwardangle[1],0);
	plane thread maps\mp\killstreaks\_airstrike::playPlaneFx();
	plane MoveTo(zombie.origin+(0,0,3000), 6);
	wait 4;
	plane thread DropRPGs(player, zombie);
	wait 2;
	plane MoveTo(zombie.origin-(planeStartOrigin[0],planeStartOrigin[1],-3000), 6);
	wait 2;
	plane playSound( "veh_b2_sonic_boom" );
	wait 4;
	plane notify("mig29_left");
	plane delete();
}

SpawnAC130(zombie, player)
{
	planeStartOrigin = undefined;
	switch(randomInt(4))
	{
		case 0: planeStartOrigin = zombie.origin+(0,25000,0);
		break;
		case 1: planeStartOrigin = zombie.origin+(25000,0,0);
		break;
		case 2: planeStartOrigin = zombie.origin+(0,-25000,0);
		break;
		case 3: planeStartOrigin = zombie.origin+(-25000,0,0);
		break;
	}
	plane = spawnplane( player, "script_model", zombie.origin+(planeStartOrigin[0],planeStartOrigin[1],3000), "compass_objpoint_ac130_friendly", "compass_objpoint_ac130_friendly" );
	plane setModel( "vehicle_ac130_low_mp" );
	plane playloopsound( "veh_ac130_dist_loop" );
	planeforwardangle = VectorToAngles( zombie.origin+(0,0,3000) - plane.origin );
	plane.angles = (0,planeforwardangle[1],0);
	plane thread maps\mp\killstreaks\_airstrike::playPlaneFx();
	plane MoveTo(zombie.origin+(0,0,3000), 20);
	wait 16;
	plane thread ShootAC130Rounds(player, zombie);
	wait 4;
	plane MoveTo(zombie.origin-(planeStartOrigin[0],planeStartOrigin[1],-3000), 35);
	wait 35;
	plane notify("ac130_left");
	plane delete();
}

ShootAC130Rounds(player, zombie)
{
	self endon("ac130_left");
	for(i = 0; i < 100; i += 1)
	{
		TmpDist = 999999999;
		pTarget = undefined;
		foreach( zombie in level.bots )
		{
			if(zombie.pers["isAlive"] == "false")
				continue;
				
			if(distancesquared(level.UAVspawn.origin, zombie.origin) < TmpDist)
			{
				TmpDist = distancesquared(self.origin, zombie.origin);
				pTarget = zombie;
			}
		}
		switch(randomInt(3))
		{
			case 0:
			for(a = 0; a < 10; a += 1)
			{
				MagicBullet( "ac130_25mm_mp", self.origin+(0,0,-100), pTarget.origin+(randomIntRange(-200,200),randomIntRange(-200,200),0), player );
			}
			break;
			case 1:
			for(b = 0; b < 2; b += 1)
			{
				MagicBullet( "ac130_40mm_mp", self.origin+(0,0,-100), pTarget.origin+(randomIntRange(-200,200),randomIntRange(-200,200),0), player );
			}
			break;
			case 3:
			MagicBullet( "ac130_105mm_mp", self.origin+(0,0,-100), pTarget.origin+(randomIntRange(-200,200),randomIntRange(-200,200),0), player );
			break;
		}
		wait 0.3;
	}
}

UAVLauncherMissiles( uavType )
{
	zombie = undefined;
	if(uavType == "uav")
	{
		self SayAll("^5Airstrike Inbound");
		self thread AImod\_Mod::TextPopup( "Airstrike!" );
		self thread maps\mp\gametypes\_rank::scorePopup( 500, 0, (0,1,2), 1 );
		self.money += 500;
		self notify("MONEY");
		level.UAVspawn.user = self;
		self thread resetOnDeath();
		for(i = 0; i < 3; i += 1)
		{	
			TmpDist = 999999999;
			pTarget = undefined;
			foreach( zombie in level.bots )
			{
				if( !zombie.pers["isAlive"] )
					continue;
				
				if(distancesquared(level.UAVspawn.origin, zombie.origin) < TmpDist)
				{
					TmpDist = distancesquared(level.UAVspawn.origin, zombie.origin);
					pTarget = zombie;
				}
			}
			if(!isDefined(pTarget))
				pTarget = self;
			thread SpawnJet(pTarget, self);
			wait 2;
		}
	}
	if(uavType == "counter_uav")
	{
		self SayAll("^5Super Airstrike Inbound");
		self thread AImod\_Mod::TextPopup( "Super Airstrike!" );
		self thread maps\mp\gametypes\_rank::scorePopup( 750, 0, (0,1,2), 1 );
		self.money += 750;
		self notify("MONEY");
		level.UAVspawn.user = self;
		self thread resetOnDeath();
		for(i = 0; i < 1; i += 1)
		{	
			TmpDist = 999999999;
			pTarget = undefined;
		
			foreach( zombie in level.bots )
			{
				if( !zombie.pers["isAlive"] )
					continue;
				
				if(distancesquared(level.UAVspawn.origin, zombie.origin) < TmpDist)
				{
					pTarget = zombie;
				}
			}
			if(!isDefined(pTarget))
				pTarget = self;
			thread SpawnAC130(pTarget, self);
			wait 2;
		}
	}
}

UAVTracker()
{
	level endon ( "game_ended" );
	
	for ( ;; )
	{
		level waittill ( "uav_update" );
		
		if ( level.teamBased )
		{
			updateTeamUAVStatus( "allies" );
			updateTeamUAVStatus( "axis" );		
		}
		else
		{
			updatePlayersUAVStatus();
		}
	}
}


updateTeamUAVStatus( team )
{
	activeUAVs = level.activeUAVs[team];
	activeCounterUAVs = level.activeCounterUAVs[level.otherTeam[team]];

	if ( !activeCounterUAVs )
		unblockTeamRadar( team );
	else
		blockTeamRadar( team );
		
	if ( !activeUAVs )
	{
		setTeamRadarWrapper( team, 0 );
		return;
	}

	if ( activeUAVs > 1 )
		level.radarMode[team] = "fast_radar";
	else
		level.radarMode[team] = "normal_radar";

	updateTeamUAVType();
	setTeamRadarWrapper( team, 1 );	
}


updatePlayersUAVStatus()
{
	totalActiveCounterUAVs = 0;
	counterUAVPlayer = undefined;
	
	foreach ( player in level.players )
	{
		activeUAVs = level.activeUAVs[ player.guid ];
		activeCounterUAVs = level.activeCounterUAVs[ player.guid ];
		
		if ( activeCounterUAVs )
		{
			totalActiveCounterUAVs++;
			counterUAVPlayer = player;
		}
		
		if ( !activeUAVs )
		{
			player.hasRadar = false;
			player.radarMode = "normal_radar";
			continue;
		}
		
		if ( activeUAVs > 1 )
			player.radarMode = "fast_radar";
		else
			player.radarMode = "normal_radar";
			
		player.hasRadar = true;
	}
	
	foreach ( player in level.players )
	{
		if ( !totalActiveCounterUAVs )
		{
			player.isRadarBlocked = false;
			continue;
		}
		
		if ( totalActiveCounterUAVs == 1 && player == counterUAVPlayer )
			player.isRadarBlocked = false;
		else
			player.isRadarBlocked = true;
	}
}


blockPlayerUAV()
{
	self endon ( "disconnect" );
	
	self notify ( "blockPlayerUAV" );
	self endon ( "blockPlayerUAV" );

	self.isRadarBlocked = true;
	
	wait ( level.uavBlockTime );

	self.isRadarBlocked = false;

	//self iPrintLn( &"MP_WAR_COUNTER_RADAR_EXPIRED" );
}


updateTeamUAVType()
{
	foreach ( player in level.players )
	{
		if ( player.team == "spectator" )
			continue;
		
		player.radarMode = level.radarMode[player.team];
	}
}



usePlayerUAV( doubleUAV, useTime )
{
	level endon("game_ended");
	self endon("disconnect");

	self notify ( "usePlayerUAV" );
	self endon ( "usePlayerUAV" );
	
	if ( doubleUAV )
		self.radarMode = "fast_radar";
	else
		self.radarMode = "normal_radar";

	self.hasRadar = true;
	
	wait ( useTime );
	
	self.hasRadar = false;
	
	//self iPrintLn( &"MP_WAR_RADAR_EXPIRED" );
}


setTeamRadarWrapper( team, value )
{
	setTeamRadar( team, value );
	level notify( "radar_status_change", team );
}



handleIncomingStinger()
{
	level endon ( "game_ended" );
	self endon ( "death" );
	
	for ( ;; )
	{
		level waittill ( "stinger_fired", player, missile, lockTarget );
		
		if ( !IsDefined( lockTarget ) || (lockTarget != self) )
			continue;
		
		missile destroy();
		//missile thread stingerProximityDetonate( lockTarget, player );
	}
}


stingerProximityDetonate( targetEnt, player )
{
	self endon ( "death" );

	minDist = distance( self.origin, targetEnt GetPointInBounds( 0, 0, 0 ) );
	lastCenter = targetEnt GetPointInBounds( 0, 0, 0 );

	for ( ;; )
	{
		// UAV already destroyed
		if ( !isDefined( targetEnt ) )
			center = lastCenter;
		else
			center = targetEnt GetPointInBounds( 0, 0, 0 );
			
		lastCenter = center;		
		
		curDist = distance( self.origin, center );
		
		if ( curDist < minDist )
			minDist = curDist;
		
		if ( curDist > minDist )
		{
			if ( curDist > 1536 )
				return;
				
			radiusDamage( self.origin, 1536, 600, 600, player );
			playFx( level.stingerFXid, self.origin );

			//self playSound( "remotemissile_explode" );
			self hide();
			
			self notify("deleted");
			wait ( 0.05 );
			self delete();
			player notify( "killstreak_destroyed" );
		}
		
		wait ( 0.05 );
	}	
}


addUAVModel( UAVModel )
{
	if ( level.teamBased )
		level.UAVModels[UAVModel.team][level.UAVModels[UAVModel.team].size] = UAVModel;
	else
		level.UAVModels[UAVModel.owner.guid + "_" + getTime()] = UAVModel;	
}	


removeUAVModel( UAVModel )
{
	UAVModels = [];

	if ( level.teamBased )
	{
		team = UAVModel.team;
		
		foreach ( uavModel in level.UAVModels[team] )
		{
			if ( !isDefined( uavModel ) )
				continue;
				
			UAVModels[UAVModels.size] = uavModel;
		}

		level.UAVModels[team] = UAVModels;
	}
	else
	{
		foreach ( uavModel in level.UAVModels )
		{
			if ( !isDefined( uavModel ) )
				continue;
				
			UAVModels[UAVModels.size] = uavModel;
		}

		level.UAVModels = UAVModels;
	}	
}


addActiveUAV()
{
	if ( level.teamBased )
		level.activeUAVs[self.team]++;	
	else
		level.activeUAVs[self.owner.guid]++;
/*
	if ( level.teamBased )
	{
		foreach ( player in level.players )
		{
			if ( player.team == self.team )
				player iPrintLn( &"MP_WAR_RADAR_ACQUIRED", self.owner, level.radarViewTime );
			else if ( player.team == level.otherTeam[self.team] )
				player iPrintLn( &"MP_WAR_RADAR_ACQUIRED_ENEMY", level.radarViewTime  );
		}
	}	
	else
	{
		foreach ( player in level.players )
		{
			if ( player == self.owner )
				player iPrintLn( &"MP_WAR_RADAR_ACQUIRED", self.owner, level.radarViewTime );
			else
				player iPrintLn( &"MP_WAR_RADAR_ACQUIRED_ENEMY", level.radarViewTime );
		}
	}
*/
}


addActiveCounterUAV()
{
	if ( level.teamBased )
		level.activeCounterUAVs[self.team]++;	
	else
		level.activeCounterUAVs[self.owner.guid]++;	
/*
	if ( level.teamBased )
	{
		foreach ( player in level.players )
		{
			if ( player.team == self.team )
				player iPrintLn( &"MP_WAR_COUNTER_RADAR_ACQUIRED", self.owner, level.uavBlockTime );
			else if ( player.team == level.otherTeam[self.team] )
				player iPrintLn( &"MP_WAR_COUNTER_RADAR_ACQUIRED_ENEMY", level.uavBlockTime );
		}
	}	
	else
	{
		foreach ( player in level.players )
		{
			if ( player == self.owner )
				player iPrintLn( &"MP_WAR_COUNTER_RADAR_ACQUIRED", self.owner, level.uavBlockTime );
			else
				player iPrintLn( &"MP_WAR_COUNTER_RADAR_ACQUIRED_ENEMY", level.uavBlockTime );
		}
	}
*/
}


removeActiveUAV()
{
	if ( level.teamBased )
	{
		level.activeUAVs[self.team]--;
		
		if ( !level.activeUAVs[self.team] )
		{
			//printOnTeam( &"MP_WAR_RADAR_EXPIRED", self.team );
			//printOnTeam( &"MP_WAR_RADAR_EXPIRED_ENEMY", level.otherTeam[self.team] );
		}
	}
	else if ( isDefined( self.owner ) )
	{
		level.activeUAVs[self.owner.guid]--;
	}
}


removeActiveCounterUAV()
{
	if ( level.teamBased )
	{
		level.activeCounterUAVs[self.team]--;

		if ( !level.activeCounterUAVs[self.team] )
		{
			//printOnTeam( &"MP_WAR_COUNTER_RADAR_EXPIRED", self.team );
			//printOnTeam( &"MP_WAR_COUNTER_RADAR_EXPIRED_ENEMY", level.otherTeam[self.team] );
		}
	}
	else if ( isDefined( self.owner ) )
	{
		level.activeCounterUAVs[self.owner.guid]--;
	}
}
