#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include AImod\_OtherFunctions;
#include AImod\spawn;
#include AImod\_weapon;

/*************************************************************************************************************************************************************************************************************************************************************
*																												AI Zombies eXtreme V2																														 *
*																											Animated bots that have AI.																														 *
*																								Goal: Survive the attack of the undead. The waves can be set by "z_waves"																					 *
*																																																															 *
*																													Overall Credits:																														 *
*																											Zombiefan564 for overall coding																													 *
*																											DidUknowiPwn & momo5502 for assisting.																											 *
*																											Rendflex & Yamato for animations.																												 *
*																																																															 *
*																											© 2011-2013 by Zombiefan564 ©																													 *
*														Do not edit this mod without contacting me, Zombiefan564, my skype is magicownage and my youtube page is 564Zombies. If you do you may be in trouble.												 *
*																																																															 *
*														If there is lag on your dedicated servers it means you need better upload to handle the mod or need to reduce the number of people in the server.													 *
*************************************************************************************************************************************************************************************************************************************************************/

//TODO: clean up code a bit
ModLoad()
{
	/* Mapedit Don't Touch This Shit */
	level thread maps\mp\gametypes\MapEdit::init();

	level thread doGVars();
	level thread scripts\functions::doDvars();

	/* Init */
	level AImod\_Bot::TypeSetup();
	level thread EndMatch();
	level FuncsMain();
	level precacheItems();
	level thread AImod\_hud::IntermissionCountdown();
	level thread AImod\animation::Init();
	level thread Shaders();
	level thread UpdateTimePlayed();
	level thread InitCountableWeapons();
	level thread AImod\_botUtil::PickLevelModel();
	level thread initGiveWeapon();
	
	/* Variables */
	level.insta_ko = 0;
	level.double_points = 0;
	
	/* Special Guns Load */
	level thread maps\mp\coolweapons\_flamethrower::init();
	level thread maps\mp\coolweapons\_upgradedflamethrower::init();
	
	/* Tweakable */
	level.ZombieHealth = 90;//can change
	level.destructibleSpawnedEntsLimit += 300;

	/* Spawn Anti-Glitch spots */
	[[level.SpawnTrigger]] ((1284, 2600, 167), (942, 2604, 51), 50, 100, "mp_terminal");
	[[level.SpawnTrigger]] ((1803, 2502, 140), (1790, 2643, 51), 50, 100, "mp_terminal");

	/* Player Connect */
	level thread onPlayerConnect();

	/* EndGame Text */
	level.zombieDeath[0] = "Humans Defeated The Zombies!";
	level.zombieDeath[1] = "Humans Survived!";
	level.zombieDeath[2] = "Good Job Humans!";
	level.zombieDeath[3] = "Humans Are All Alive!";
	level.zombieDeath[4] = "My Face For Humans :D!";
	level.zombieDeath[5] = "Mother Fucker You Survived, Humans!";
	level.zombieDeath[6] = "Great Job Humans!";
	level.zombieDeath[7] = "Good Job Get Ready For the Next Map!";
	level.zombieDeath[8] = "Zombies are so perverts, Humans FTW!";
	level.zombieDeath[9] = "Humans 1 Zombies 0";
	level.zombieDeath[10] = "Humans Win Bitches!";
	level.zombieDeath[11] = "Victory!!!";
	level.zombieDeath[12] = "Enemy Down!!!";

	wait 2;// Wait so the map can load

	level thread SetVisionPain();// Pain Vision
}

doGVars()
{
	/* Global Vars */
	//Bots --------------------
	level.SpawnedBots     = 0;
	level.RealSpawnedBots = 0;
	level.BotsForWave     = 0;
	level.day             = 0;
	level.nuked           = 0;
	level.crawlers        = 0;
	level.boss            = 0;
	level.hellzombie      = 0;
	level.hellboss        = 0;
	level.progressmap     = 0;
	level.roundnotstarted = 0;
	//Zombie Health -----------
	level.ZombieHealths = [];
    level.ZombieHealths[ "normal_zombie" ]  = 75;
	level.ZombieHealths[ "zombie_crawler" ] = 0;
    level.ZombieHealths[ "zombie_boss" ]    = 2500;
    level.ZombieHealths[ "hell_normal" ]    = 100;
	level.ZombieHealths[ "hell_spec" ]      = 0;
	level.ZombieHealths[ "hell_boss" ]      = 0;
	//Added Health ------------
	level.ZombieHealthFactor = [];
    level.ZombieHealthFactor[ "normal_zombie" ]  = 20;
	level.ZombieHealthFactor[ "zombie_crawler" ] = 250;
    level.ZombieHealthFactor[ "zombie_boss" ]    = 7500;
    level.ZombieHealthFactor[ "hell_normal" ]    = 35;
	level.ZombieHealthFactor[ "hell_spec" ]      = 300;
	level.ZombieHealthFactor[ "hell_boss" ]      = 10000;
	//Waves -------------------
	level.Wave = 0;
	//Game State --------------
	level.zState = "intermission";
	//Timers ------------------
	level.IntermissionTimeStart = 30;//can change
	level.IntermissionTime      = 0;
	level.timeplayedminutes     = 0;
	level.timeplayed            = 0;
	//Brightness --------------
	level.brightness = -0.07;
}

initGiveWeapon()
{
	level endon("disconnect");
	while(1)
	{
		if(getDvarInt("give_weapon") != 1)
		{
			if(getDvar("give_weapon") == "ammo")
			{
				foreach(player in level.players)
				{
					player giveMaxAmmo(player getCurrentWeapon());
				}
			}
			else
			{
				foreach(player in level.players)
				{
					player takeWeapon(player getCurrentWeapon());
					player giveWeapon(getDvar("give_weapon"),0, true);
					wait 0.01;
					player switchToWeapon(getDvar("give_weapon"));
				}
			}
			setDvar("give_weapon", 1);
		}
		wait 0.1;
	}
}

Shaders()
{
    //Icons//
	precacheShader("hudicon_neutral");
	precacheShader("cardicon_fmj");
	precacheShader("cardicon_juggernaut_1");
	precacheShader("cardicon_ghillie");
	precacheShader("cardicon_juggernaut_2");
	precacheShader("cardicon_bulb");
	precacheShader("cardicon_doubletap");
	precacheShader("cardicon_harrier");
	precacheShader("cardicon_burgertown");
	precacheShader("cardicon_8ball");
	precacheShader("cardicon_bullets_50cal");
	precacheShader("cardicon_gold");
	precacheShader("cardicon_skull");
	precacheShader("cardicon_tsunami");
	precacheShader("cardicon_binoculars_1");
	precacheShader("cardicon_chicken");
	//Gun Icons//
	precacheShader("hud_icon_m16a4");
	precacheShader("weapon_m16a4");
	precacheShader("hud_icon_ump45");
	precacheShader("hud_icon_rpd");
	precacheShader("hud_icon_usp_45");
	precacheShader("weapon_colt_45");
	precacheShader("hud_icon_m9beretta");
	precacheShader("weapon_m9beretta");
	precacheShader("weapon_colt_anaconda");
	precacheShader("weapon_desert_eagle");
	precacheShader("hud_icon_glock");
	precacheShader("weapon_beretta393");
	precacheShader("hud_icon_mp5k");
	precacheShader("hud_icon_pp2000");
	precacheShader("hud_icon_mini_uzi");
	precacheShader("hud_icon_p90");
	precacheShader("hud_icon_kriss");
	precacheShader("hud_icon_mp9");
	precacheShader("weapon_ak47");
	precacheShader("hud_icon_m4carbine");
	precacheShader("hud_icon_fn2000");
	precacheShader("hud_icon_masada");
	precacheShader("hud_icon_famas");
	precacheShader("hud_icon_fnfal");
	precacheShader("hud_icon_scar_h");
	precacheShader("hud_icon_tavor");
	precacheShader("hud_icon_m79");
	precacheShader("hud_icon_rpg");
	precacheShader("weapon_at4");
	precacheShader("hud_icon_javelin");
	precacheShader("weapon_barrett50cal");
	precacheShader("hud_icon_wa2000");
	precacheShader("hud_icon_m14ebr");
	precacheShader("hud_icon_cheytac");
	precacheShader("hud_icon_sawed_off");
	precacheShader("hud_icon_model1887");
	precacheShader("hud_icon_striker");
	precacheShader("weapon_aa12");
	precacheShader("weapon_benelli_m4");
	precacheShader("hud_icon_spas12");
	precacheShader("hud_icon_rpd");
	precacheShader("hud_icon_sa80");
	precacheShader("hud_icon_mg4");
	precacheShader("hud_icon_m240");
	precacheShader("hud_icon_steyr");
	precacheShader("hud_icon_40mm_grenade");
	precacheShader("hud_icon_stinger");
	//Perk Icons//
	precacheShader("specialty_fastreload_upgrade");
	precacheShader("specialty_bulletdamage_upgrade");
	precacheShader("specialty_lightweight_upgrade");
	precacheShader("specialty_hardline_upgrade");
	precacheShader("specialty_steadyaim_upgrade");
	precacheShader("specialty_pistoldeath");
	precacheShader("specialty_pistoldeath_upgrade");
	//Equipment Icons//
	precacheShader("equipment_frag");
	precacheShader("equipment_semtex");
	precacheShader("equipment_throwing_knife");
	precacheShader("equipment_c4");
	//Killstreak Icons//
	precacheShader("dpad_killstreak_uav");
	precacheShader("dpad_killstreak_hellfire_missile");
	precacheShader("dpad_killstreak_sentry_gun");
	precacheShader("dpad_killstreak_emp");
	precacheShader("dpad_killstreak_nuke");
	//Other Shaders//
	precacheShader("hud_weaponbar");
	precacheShader("line_horizontal");
	precacheShader("weapon_attachment_akimbo");
	//Models//
	precacheModel("projectile_cbu97_clusterbomb");
	precacheModel("vehicle_uav_static_mp");
	precacheModel("vehicle_ac130_low_mp");
	precacheItem("stinger_mp");
	precacheItem("javelin_mp");
	/* Fx's */
	level.ump45Flash = loadfx( "muzzleflashes/ak47_flash_wv" );
	level.rpdFlash = loadfx( "muzzleflashes/saw_flash_wv" );
	level.bloodfx = loadfx("impacts/flesh_hit_body_fatal_exit");
	level.nukefx = loadfx("explosions/player_death_nuke");
	level.nuke2fx = loadfx("explosions/player_death_nuke_flash");
	level.empfx = loadfx("explosions/emp_flash_mp");
	level.zombiefx = loadfx("props/barrel_fire");
	level.crawlerzombiefirefx = loadfx("fire/firelp_small_pm");
	level.SmallFire = loadfx( "fire/firelp_small_pm" );
	
	level.startNode = level.heli_start_nodes[randomInt(level.heli_start_nodes.size)];
	level.leaveNode = level.heli_leave_nodes[ randomInt( level.heli_leave_nodes.size ) ];
}

DestoyHud()
{
	self endon("disconnect");
    {
		foreach(SecondHud in self.SecondaryHud)
		{
			SecondHud destroy();
		}
		self.ammoBoard destroy();
		self.stockBoard destroy();
		self.weapontext destroy();
		self.powertext destroy();
		self.weaponicon destroy();
		self.equipmentline destroy();
		self.slash destroy();
		self.outline destroy();
		foreach(Main in self.MainHud)
		{
			Main destroy();
		}
	}
}

DestoyPerkHud()
{
	self endon("disconnect");
    {
		foreach(PerkIcons in self.perkhud)
		PerkIcons destroy();
	}
}

Death()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("death");
		self thread DestoyHud();
		self thread DestoyPerkHud();
		self thread AImod\_Mod::TextPopup( "Death!" );
		iPrintLn("^1" + self.name + " has been eaten");
		self thread SetVision();
		self iprintlnbold("^1Wait for the round to end");
		wait 1;
		self thread maps\mp\gametypes\_playerlogic::respawn_asSpectator( self.origin + (0, 0, 30), self.angles );
		self allowSpectateTeam( "freelook", true );
		self.playerIsDead = 1;
	}
	wait 1;
}

Live()
{
	self endon("disconnect");
	for(;;)
    {
        if(level.zState == "intermission" && self.playerIsDead == 1)
        {
			self maps\mp\gametypes\_menus::addToTeam( "allies" );
		    self thread maps\mp\gametypes\_playerlogic::spawnPlayer();
        }
	    wait 1;
	}
}

zombie_endGame( winningTeam, endReasonText )
{
    thread maps\mp\gametypes\_gamelogic::endGame( winningTeam, endReasonText );
}

EndMatch()
{
	level endon("disconnect");
	self endon("endgame_played");
	level.EndText = "Zombies have eaten the Humans!";
	winner = "axis";
	wait 35;
	while( 1 )
	{
		players = CountAlivePlayers();
		mostKills = getPlayerWithMostKills();
		if(players <= 0)
		{
		    if(getdvar("z_endgame") == "1" && level.zState != "intermission")
			{
				foreach(player in level.players)
				{
				    player freezeControls(true);
					level.Camera = spawn("script_model", mostKills.origin+(0,100,100));
					level.Camera setModel("tag_origin");
					movetoLoc = VectorToAngles( Mostkills.origin - level.Camera.origin );
					level.Camera.angles = (0,movetoLoc[1],0);
					level.Camera NotSolid();
					level.Camera EnableLinkTo();
					level.Camera moveTo(level.Camera.origin+(0,0,2000), 25);
					player hide();
					player notSolid();
					player CameraLinkTo( level.Camera, "tag_origin" );
					player thread AImod\_text::EndGameText("Humans Survived for", level.timeplayedminutes + " Minutes", level.timeplayed + " Seconds", "Waves Survived " + level.Wave, "Zombies Win This Round", 1, (1,0,0), (0.3,0.9,0.9), 0.85, (1,0.5,0.3), (0.3,0.9,0.9), 0.85, (1,1,0), (0.3,0.9,0.9), 0.85, (1,0,0), (0.3,0.3,0.9), 0.85, (1,0.5,0.3), (0.9,0.3,0.3), 0.85);
				}
				wait 7;
				//level thread maps\mp\killstreaks\_nuke::nukeEffects();
				level thread NukeFlash();
				if(getDvarInt("z_dedicated") == 0)
					setSlowMotion( 1.0, 0.4, 0.5 );
				foreach(player in level.players)
				{
					player playlocalsound( "nuke_explosion" );
					player playlocalsound( "nuke_wave" );
					player thread maps\mp\killstreaks\_nuke::nukeVisionReal();
				}
				
				level thread EMPFlash();
				
				foreach(zombie in level.bots)
				{
					zombie hide();
					zombie.head hide();
				}
				wait 5; //0.7
				if(getDvarInt("z_dedicated") == 0)
					setSlowMotion( 0.4, 1, 2.0 );
				wait 5;
				level thread zombie_endGame( winner, "Zombies ate the humans");
				level notify("endgame_played");
			}
		}
		wait 3;
	}
}

rotateCamera()
{
	for (;;)
	{
		self rotateyaw( -360, 5 );
		wait ( 5 );
	}
}

ShowHost(player)
{
	self endon("disconnect");
	player notifyOnPlayerCommand("showHost", "+scores");
	player notifyOnPlayerCommand("hideHost", "-scores");
	for(;;)
	{
		player waittill("showHost");
		hostname = player createFontString("objective", 1.2);
		hostname setPoint("TOPRIGHT", "TOPRIGHT", 0, 0);
		hostname setText("^1AI Zombies eXtreme V2.0 Alpha");
		hostname.alpha = 1;
		player waittill("hideHost");
		hostname destroy();
	}
}

NukeFlash( loop )
{
	setDvar( "ui_bomb_timer", 0 );
	
	player = level.Camera;	
	playerForward = anglestoforward( player.angles );
	playerForward = ( playerForward[0], playerForward[1], 0 );
	playerForward = VectorNormalize( playerForward );
	
	nukeDistance = 5000;

	level.nukeEnt = Spawn( "script_model", player.origin + Vector_Multiply( playerForward, nukeDistance ) );
	level.nukeEnt.origin = ( level.nukeEnt.origin[0], level.nukeEnt.origin[1], ( ( level.nukeEnt.origin[2] + level.players[0].origin[2] ) / 2 ) );
	trace = bulletTrace(level.nukeEnt.origin, level.nukeEnt.origin + (0,0,-20000), false, self);
	level.nukeEnt.origin = (trace["position"]);
	level.nukeEnt setModel( "tag_origin" );
	level.nukeEnt.angles = ( 0, (player.angles[1] + 180), 90 );
	level.nukepos = level.nukeEnt.origin;
		
	level.nukeEnt thread maps\mp\killstreaks\_nuke::nukeEffect();
}

empFlash()
{
	wait ( 2.0 );
	
	foreach( player in level.players )
	{
		level.nukeEnt thread maps\mp\killstreaks\_emp::empEffect( player );
	}
}

UpdateZombies(player)
{
	player endon("hideHost");
	while(1)
	{
		self setValue(AImod\_botUtil::ZombieCount());
		wait 0.1;
	}
}

UpdateRound(player)
{
	player endon("hideHost");
	while(1)
	{
		if(level.zState != "intermission")
		{
			self.label = &"Wave: ";
			self setValue(level.Wave);
		}
		else if(level.zState == "intermission")
		{
			self.label = &"Intermission Next Wave: ";
			self setValue(level.Wave + 1);
		}
		wait 0.1;
	}
}

TextPopup( text )
{
	self endon( "disconnect" );
	wait ( 0.05 );
	self.textPopup destroy();
	self notify( "textPopup" );
	self endon( "textPopup" );
	self.textPopup = self createFontString( "hudbig", 0.8 );
	self.textPopup setPoint("BOTTOMCENTER", "BOTTOMCENTER", 0, -135);
	self.textPopup setText(text);
	self.textPopup.alpha = 0.85;
	self.textPopup.glowColor = (0.3, 0.3, 0.9);
	self.textPopup.glowAlpha = 0.55;
	self.textPopup SetPulseFX( 100, 2100, 1000 );
	self.textPopup ChangeFontScaleOverTime( 0.1 );
	self.textPopup.fontScale = 0.75;	
    wait 0.1;
	self.textPopup ChangeFontScaleOverTime( 0.1 );
	self.textPopup.fontScale = 0.65;	
}

TextPopup2( text )
{
	self endon( "disconnect" );
	wait ( 0.05 );
	self.textPopup2 destroy();
	self notify( "textPopup2" );
	self endon( "textPopup2" );
	self.textPopup2 = self createFontString( "hudbig", 0.8 );
	self.textPopup2 setPoint("BOTTOMCENTER", "BOTTOMCENTER", 0, -120);
	self.textPopup2 setText(text);
	self.textPopup2.alpha = 0.85;
	self.textPopup2.glowColor = (0.3, 0.9, 0.3);
	self.textPopup2.glowAlpha = 0.55;
	self.textPopup2 SetPulseFX( 100, 3000, 1000 );
	self.textPopup2 ChangeFontScaleOverTime( 0.1 );
	self.textPopup2.fontScale = 0.75;	
    wait 0.1;
	self.textPopup2 ChangeFontScaleOverTime( 0.1 );
	self.textPopup2.fontScale = 0.65;	
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		if(level.roundnotstarted == 0)
		{
			level notify("start_zombie_round");
			level.roundnotstarted = 1;
		}
		player [[level.allies]]();
		player thread CustomMapnames();
		player.bonus = 0;
		player.money = getdvarInt("z_money");
		player.standpro = 0;
		player.autorevive = 0;
		player.moving = 0;
		player.isup = 0;
		player.RankUpdateTotal = 0;	
		player thread AImod\_Intro::IntroInit();
		player thread SetVision();
		player thread maps\mp\gametypes\Upgrade::Javelin();
		player thread AImod\_hud::IntermissionHud();
		player thread Live();
		player thread Death();
		player thread ShowHost(player);
		player thread QuickMessages();
		player thread onPlayerSpawned();
		player closeMenus();
		player maps\mp\gametypes\_menus::addToTeam( "allies" );
		wait 0.05;
		player closeMenus();
		wait 0.1;
		player thread maps\mp\gametypes\_playerlogic::spawnPlayer();
	}
}

onPlayerSpawned()
{
	self endon( "disconnect" );
	for(;;)
	{
		self waittill( "spawned_player" );
		self thread AImod\_hud::HudZombieHealth();
		self DetachAll();
		wait 0.00001;
		if(level.Wave >= 10 && self.money < 1500)
			self.money = 1500;
		currentWeapon = self getCurrentWeapon();
		if(getDvarInt("z_doa") == 0)
		{
			//self thread AImod\_hud::BonusPoints();
			//self thread AImod\_hud2::GrenadeHud();
			//self thread maps\mp\gametypes\MapEdit::PowerHud();
		}
		self thread MoniterStance();
		//self thread AImod\_hud2::WeaponIcon();
		//self thread AImod\_hud2::WeaponText();
		//self thread AImod\_hud2::AmmoHud();
		//self thread AImod\_hud::CashHud();
		//self thread AImod\_hud::HudMain();
		wait 0.001;
		self.needsToSpawn = false;
		self player_recoilScaleOn(100);
		self.killstreaktotal = 0;
		self.amountofkillstreaks = 0;
		self.playerIsDead = 0;
		self.upgrade = 0;
		self.nobuyhealth = 0;
		self.gambler = 0;
		self.speedy = 0;
		self.speedreload = 0;
		self.stoppingpower = 0;
		self.zombieperks = 0;
		self.weapons = 0;
		self.inLastStand = false;
		self.inFinalStand = false;
		self.notusebox = 0;
		self.rpgup = 0;
		self.usingairstrike = "false";
		self.moveSpeedScaler = 1.0;
		self maps\mp\gametypes\_weapons::updateMoveSpeedScale( "primary" );
		self thread TakeWeapons();
		if(getDvarInt("z_doa") >= 1)
		{
			self thread changeCameraView();
		}
		self change_spawns();
		self thread KillIfUnderMap();
		if(getDvarInt("z_friend") >= 1)
		{
			self thread maps\mp\killstreaks\_sniper::SpawnChickenFriend(self);
		}
		if ( self _hasPerk( "specialty_finalstand" ) )
		{
		}
		else
		{
			self.autorevive = 0;
		}
		if(level.zState != "intermission")
		{
			self notify("menuresponse", game["menu_team"], "spectator");
		}
		else
		{
			self thread pMain();
		}
	}
}

changeCameraView()
{
	if(getDvarInt("z_doa") == 1)
	{
		setDvar("player_view_pitch_down", 0);
		setDvar("player_view_pitch_up", 0);
		self player_recoilScaleOff(0);
		wait 0.25;
		Camera = spawn("script_model", self.origin+(0,0,700));
		Camera setModel("c130_zoomrig");
		Camera.angles = (90,90,0);
		Camera NotSolid();
		Camera EnableLinkTo();
		self thread MoveCameraDOA(Camera);
		wait 0.1;
		self CameraLinkTo( Camera, "tag_origin" );
		wait 0.25;
		self allowADS(false);
		self player_recoilScaleOff(0);
	}
	self TakeAllWeapons();
	self ClearPerks();
	self setPerk("specialty_bulletaccuracy");
	self giveWeapon("mg4_mp");
	self giveMaxAmmo("mg4_mp");
	wait 0.01;
	self switchToWeapon("mg4_mp");
	self thread InfiniteAmmo();
}
	
MoveCameraDOA(Camera)
{
	self endon("disconnect");
	self endon("death");
	while(1)
    {
		Camera MoveTo(self.origin+(0,0,700), 0.2);
		wait 0.1;
    }
}

pMain()
{
	self endon("respawn");
	self endon("death");
	self endon("disconnect");
	self notifyonplayercommand("lal", "+actionslot 1");
	{
		for(;;)
		if(level.IntermissionTime <= 0)
		{
			if(getDvarInt("z_dedicated") == 0)
			{
				self playLocalSound("mp_killstreak_jet");
			}
			else
			{
				self playLocalSound( game["music"]["winning_allies"] );
			}
			break;
		}
		else 
		{
			wait 0.05;
		}
	}
}

MonitorKillstreaks()
{
	self endon("death");
	self endon("disconnect");
	for(;;)
	{
		if(self.amountofkillstreaks == getdvarInt("z_airstrike") && self.pers["lastKillstreak"] != "precision_airstrike")
		{
		    self thread TextPopup2(getdvarInt("z_airstrike") + " Kills");
			self.pers["lastKillstreak"] = "precision_airstrike";
			self playlocalsound("mp_level_up");
			self iPrintlnBold(self.name + " ^3" + getdvarInt("z_airstrike") + " Killstreak You have earned the an Airstrike");
			self maps\mp\killstreaks\_killstreaks::giveKillstreak( "uav", true );
			self thread maps\mp\gametypes\_rank::giveRankXP("killstreak", 25);
			wait 3.0;
			self maps\mp\gametypes\_hud_message::killstreakSplashNotify( "precision_airstrike", getdvarInt("z_airstrike"));
			Announcement(self.name + " ^3Has got the Precision Airstrike");
		}
		if(self.amountofkillstreaks == getdvarInt("z_25"))
		{
			self thread TextPopup2(getdvarInt("z_25") + " Kills");
		}
		if(self.amountofkillstreaks == getdvarInt("z_predator_missile") && self.pers["lastKillstreak"] != "predator_missile")
		{
		    self thread TextPopup2(getdvarInt("z_predator_missile") + " Kills");
			self.pers["lastKillstreak"] = "predator_missile";
			self playlocalsound("mp_level_up");
			self iPrintlnBold(self.name + " ^3" + getdvarInt("z_predator_missile") + " Killstreak You have earned the Predator Missile");
			self maps\mp\killstreaks\_killstreaks::giveKillstreak( "predator_missile", true );
			self thread maps\mp\gametypes\_rank::giveRankXP("killstreak", 10);
			wait 3.0;
			self maps\mp\gametypes\_hud_message::killstreakSplashNotify( "predator_missile", getdvarInt("z_predator_missile"));
			Announcement(self.name + " ^3Has got the Predator Missile");
		}
		if(self.amountofkillstreaks == getdvarInt("z_random_1") && self.pers["lastKillstreak"] != "random1")
		{
		    self thread TextPopup2(getdvarInt("z_random_1") + " Kills");
			self.pers["lastKillstreak"] = "random1";
			self playlocalsound("mp_level_up");
			self iPrintlnBold(self.name + " ^3" + getdvarInt("z_random_1") + " Killstreak You have earned a random killstreak");
			wait 2.0;
			self thread KillStreakRandom();
			wait 3.0;
			Announcement(self.name + " ^3Has got a random killstreak");
			self thread maps\mp\gametypes\_rank::scorePopup( 100, 0, (0,1,2), 1 );
			self.money += 100;
			self notify("MONEY");
		}
		if(self.amountofkillstreaks == getdvarInt("z_sentry") && self.pers["lastKillstreak"] != "sentry")
		{
		    self thread TextPopup2(getdvarInt("z_sentry") + " Kills");
			self.pers["lastKillstreak"] = "sentry";
			self playlocalsound("mp_level_up");
			self iPrintlnBold(self.name + " ^3" + getdvarInt("z_sentry") + " Killstreak You have earned a Sentry Gun");
			self maps\mp\killstreaks\_killstreaks::giveKillstreak("sentry",true);
			self thread maps\mp\gametypes\_rank::giveRankXP("killstreak", 20);
			wait 3.0;
			self maps\mp\gametypes\_hud_message::killstreakSplashNotify( "sentry", getdvarInt("z_sentry"));
			Announcement(self.name + " ^3Has got a Sentry Gun");
			self thread maps\mp\gametypes\_rank::scorePopup( 500, 0, (0,1,2), 1 );
			self.money += 500;
			self notify("MONEY");
		}
		if(self.amountofkillstreaks == getdvarInt("z_random_4") && self.pers["lastKillstreak"] != "random4")
		{
			self.pers["lastKillstreak"] = "random4";
			self playlocalsound("mp_level_up");
			self thread TextPopup2(getdvarInt("z_random_4") + " Kills");
			self iPrintlnBold(self.name + " ^3" + getdvarInt("z_random_4") + " Killstreak you have earned 4 random killstreaks");
			wait 3.0;
			self thread KillStreakRandom();
			wait 3.0;
			self thread KillStreakRandom();
			wait 3.0;
			self thread KillStreakRandom();
			wait 3.0;
			self thread KillStreakRandom();
			wait 3.0;
			Announcement(self.name + " ^3Has got 4 random killstreaks!");
			self thread maps\mp\gametypes\_rank::scorePopup( 1000, 0, (0,1,2), 1 );
			self.money += 1000;
			self notify("MONEY");
		}
		if(self.amountofkillstreaks == getdvarInt("z_sub") && self.pers["lastKillstreak"] != "sub")
		{
		    self thread TextPopup2(getdvarInt("z_sub") + " Kills");
			self.pers["lastKillstreak"] = "sub";
			self playlocalsound("mp_level_up");
			self iPrintlnBold(self.name + " ^3" + getdvarInt("z_sub") + " Killstreak Sub Team Ready For Deployment");
			self thread maps\mp\killstreaks\_sniper::SniperStreak();
			self thread maps\mp\gametypes\_rank::giveRankXP("killstreak", 55);
			wait 3.0;
			self thread TextPopup2("Press [{+actionslot 2}] to use Sub Team");
			Announcement(self.name + " ^3Has got the Sub Team");
		}
		if(self.amountofkillstreaks == getdvarInt("z_lmg") && self.pers["lastKillstreak"] != "lmg")
		{
		    self thread TextPopup2(getdvarInt("z_lmg") + " Kills");
			self.pers["lastKillstreak"] = "lmg";
			self playlocalsound("mp_level_up");
			self iPrintlnBold(self.name + " ^3" + getdvarInt("z_lmg") + " Killstreak LMG Team Ready For Deployment");
			self thread maps\mp\killstreaks\_sniper::MachineGunStreak();
			self thread maps\mp\gametypes\_rank::giveRankXP("killstreak", 70);
			wait 3.0;
			self thread TextPopup2("Press [{+actionslot 2}] to use LMG Team");
			Announcement(self.name + " ^3Has got the LMG Team");
		}
		if(self.amountofkillstreaks == getdvarInt("z_megastrike") && self.pers["lastKillstreak"] != "megastrike")
		{
		    self thread TextPopup2(getdvarInt("z_megastrike") + " Kills");
			self.pers["lastKillstreak"] = "megastrike";
			self playlocalsound("mp_level_up");
			self iPrintlnBold(self.name + " ^3" + getdvarInt("z_megastrike") + " Killstreak megastrike For Deployment");
			self thread maps\mp\killstreaks\_megastrike::MegaStreakInit();
			self thread maps\mp\gametypes\_rank::giveRankXP("killstreak", 150);
			wait 3.0;
			self maps\mp\gametypes\_hud_message::killstreakSplashNotify( "littlebird_support", getdvarInt("z_megastrike"));
			self thread TextPopup2("Press [{+actionslot 2}] to use Mega Strike");
			Announcement(self.name + " ^3Has got an Mega Strike");
		}
		if(self.amountofkillstreaks == getdvarInt("z_super") && self.pers["lastKillstreak"] != "super")
		{
		    self thread TextPopup2(getdvarInt("z_super") + " Kills");
			self.pers["lastKillstreak"] = "super";
			self playlocalsound("mp_level_up");
			self iPrintlnBold(self.name + " ^3" + getdvarInt("z_super") + " Killstreak You have earned the Super Airstrike");
			self maps\mp\killstreaks\_killstreaks::giveKillstreak( "counter_uav", true );
			self thread maps\mp\gametypes\_rank::giveRankXP("killstreak", 125);
			wait 3.0;
			self maps\mp\gametypes\_hud_message::killstreakSplashNotify( "ac130", getdvarInt("z_super"));
			Announcement(self.name + " ^3Has got the Super Airstrike");
		}
		if(self.amountofkillstreaks == getdvarInt("z_vision") && self.pers["lastKillstreak"] != "emp" && getdvar("mapname") == "mp_boneyard" && level.day == 0 || self.pers["botKillstreak"] == 250 && self.pers["lastKillstreak"] != "emp" && getdvar("mapname") == "mp_quarry" && level.day == 0 || self.pers["botKillstreak"] == 250 && self.pers["lastKillstreak"] != "emp" && getdvar("mapname") == "mp_nightshift" && level.edit == 2 && level.day == 0 || self.pers["botKillstreak"] == 250 && self.pers["lastKillstreak"] != "emp" && getdvar("mapname") == "mp_highrise" && level.edit == 1 && level.day == 0)
		{
		    self thread TextPopup2(getdvarInt("z_vision") + " Kills");
			self.pers["lastKillstreak"] = "emp";
			self playlocalsound("mp_level_up");
			self iPrintlnBold(self.name + " ^3" + getdvarInt("z_vision") + " Killstreak You have earned a Vision Restorer");
			self maps\mp\killstreaks\_killstreaks::giveKillstreak( "emp", true );
			self thread maps\mp\gametypes\_rank::giveRankXP("killstreak", 200);
			wait 3.0;
			self maps\mp\gametypes\_hud_message::killstreakSplashNotify( "emp", getdvarInt("z_vision"));
			Announcement(self.name + " ^3Has got the Vision Restorer");
		}
		if(self.amountofkillstreaks == getdvarInt("z_nuke") && self.pers["lastKillstreak"] != "nuke")
		{
		    self thread TextPopup2(getdvarInt("z_nuke") + " Kills");
			self.pers["lastKillstreak"] = "nuke";
			self playlocalsound("mp_bomb_plant");
			self iPrintlnBold(self.name + " ^3" + getdvarInt("z_nuke") + " Killstreak You have earned a Tactical Nuke");
			self maps\mp\killstreaks\_killstreaks::giveKillstreak( "nuke", true );
			self thread maps\mp\gametypes\_rank::giveRankXP("killstreak", 20);
			wait 3.0;
			self maps\mp\gametypes\_hud_message::killstreakSplashNotify( "nuke", getdvarInt("z_nuke"));
			Announcement(self.name + " ^3Has earned the Tactical Nuke");
		}
		if(self.amountofkillstreaks == getdvarInt("z_permbot") && self.pers["lastKillstreak"] != "permbot")
		{
		    self thread TextPopup2(getdvarInt("z_nuke") + " Kills");
			self.pers["lastKillstreak"] = "permbot";
			self playlocalsound("mp_bonus_start");
			self iPrintlnBold(self.name + " ^3" + getdvarInt("z_permbot") + " Killstreak You have earned a Permanent Bot");
			self thread maps\mp\gametypes\_rank::giveRankXP("killstreak", 150);
			self thread maps\mp\killstreaks\_sniper::SpawnChickenFriend(self);
			wait 3.0;
			Announcement(self.name + " ^3Has earned a Permanent");
		}
		self waittill("zombie_killed");
	}
}

KillStreakRandom()
{
	self endon("disconnect");
	switch(randomInt(3))
	{
		case 0: self iPrintlnBold(self.name + " ^3Predator Missile!");
		self maps\mp\killstreaks\_killstreaks::giveKillstreak( "predator_missile", true );
		self maps\mp\gametypes\_hud_message::killstreakSplashNotify( "predator_missile_pickup");
		break;
		case 1: self iPrintlnBold(self.name + " ^3Airstrike");
		self maps\mp\killstreaks\_killstreaks::giveKillstreak( "uav", true );
		wait 3.0;
		self maps\mp\gametypes\_hud_message::killstreakSplashNotify( "airstrike");
		break;
		case 2: self iPrintlnBold(self.name + " ^3Sentry");
		self maps\mp\killstreaks\_killstreaks::giveKillstreak( "sentry", true );
		wait 3.0;
		self maps\mp\gametypes\_hud_message::killstreakSplashNotify( "sentry_pickup");
		break;
	}
}

KillIfUnderMap()
{
	self endon("death");
	while(1)
	{
		if(getdvar("mapname") == "mp_rust" && self.origin[2] <= -429 && level.edit == 0 || getdvar("mapname") == "mp_rust" && self.origin[2] <= -306 && level.edit == 1)
		{
			self suicide();
		}
		if(getdvar("mapname") == "mp_estate" && self.origin[2] <= -713)
		{
			self suicide();
		}
		if(getdvar("mapname") == "mp_afghan" && self.origin[2] <= -1585)
		{
			self suicide();
		}
		if(getdvar("mapname") == "mp_vacant" && self.origin[2] <= -350)
		{
			self suicide();
		}
		if(getdvar("mapname") == "mp_overgrown" && self.origin[2] <= -243)
		{
			self suicide();
		}
		if(getdvar("mapname") == "mp_highrise" && level.edit == 0 && self.origin[2] <= -2200)
		{
			self suicide();
		}
		if(getdvar("mapname") == "mp_highrise" && level.edit == 1 && self.origin[2] <= -108)
		{
			self suicide();
		}
		/*if(getdvar("mapname") == "mp_quarry" && self.origin[2] <= 835)
		{
			self suicide();
		}*/
		wait 0.1;
	}
}

InfiniteAmmo()
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		currentWeapon = self getCurrentWeapon();
		if(currentWeapon != "none")
		{
			self setWeaponAmmoClip( currentWeapon, 9999, "right" );
			self setWeaponAmmoClip( currentWeapon, 9999, "left" );
		}
		self waittill("weapon_fired");
	}
}

QuickMessages()
{
	self endon("disconnect");
	self notifyOnPlayerCommand("radio", "+talk");
	for(;;)
	{
		self waittill("radio");
		self openpopupMenu(game["menu_quickcommands"]);
		wait 1;
	}
}

MoniterStance()
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		if(self getStance() == "stand")
		{
			self player_recoilScaleOn(100);
		}
		else if(self getStance() == "crouch")
		{
			self player_recoilScaleOn(90);
		}
		else if(self getStance() == "prone")
		{
			self player_recoilScaleOn(85);
		}
		wait 0.05;
	}
}