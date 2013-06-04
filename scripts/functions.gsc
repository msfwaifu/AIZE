#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include AImod\_hud;
#include AImod\_OtherFunctions;
#include AImod\_botUtil;

init()
{	
	level thread onPlayerConnect();
	level thread UICounters();
	level thread UICounterCash();
	level.allowupdate = true;
}

onPlayerConnect()
{
	self endon("disconnect");
	for(;;)
	{
		level waittill( "connected", player);
		player thread onPlayerSpawned();
		player thread ResetUI();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");
		self thread doDvars2();
		self thread checkGun();
		self thread Grenadex3();
		//self TakeIt();
		self setClientDvar("ui_power", level.power);
	}
}

doDvars2()
{
	wait 0.1;
	if(getDvarInt("cg_gun_z") != 0)
	{
		self setClientDvar("cg_gun_z", 0);
	}
	//I only put this here because of I just wanted to be sure players 
	//don't spawn in with a screwed up cg_gun_z, because it happened to me when I restarted.
}
checkGun()
{
   self endon( "death" );
   self endon( "disconnect" );
   
   self.gunz = 0;
   
   for(;;)
   {
      self waittill( "weapon_change", newWeapon );
      
      if( isSubStr( newWeapon, "m21" ) )
      {
         if( newWeapon == "m21_acog_mp" && self.gunz != 1.2 ) {
            self.gunz = -1.2;
            self setClientDvar( "cg_gun_z", 1.2 );
         }
         else if ( newWeapon == "m21_acog_xmags_mp" && self.gunz != 1.2 ) {
            self.gunz = 1.2;
            self setClientDvar( "cg_gun_z", 1.2 );
         }
      }   
      else  {         
         if ( self.gunz != 0 ) {
            self.gunz = 0;
            self setClientDvar( "cg_gun_z", 0 );
         }
      }
   }
}

Grenadex3()
{
	wait 0.5;
	self setweaponammoclip("frag_grenade_mp",3); //this will give it 3 in stock.
}

UICounters()
{
	while( true )
	{
		level waittill_any("zombie_spawned", "zombie_died", "zombie_round_started_end");
		AImod\_botUtil::ZombieCountForHud();
		foreach( player in level.players )
		{
			player setClientDvar("ui_wave", level.wave);
			player setClientDvar("ui_zombies", level.ZombieCount);
			wait ( 1/30 ); // Could also do waitframe();
		}
	}
}

UICounterCash()
{
	while( true )
	{
		wait 0.05;
		foreach( player in level.players )
		{
			player setClientDvar("ui_money", player.money);
			player setClientDvar("ui_bonus", player.bonus);
		}
	}
}

ResetUI()
{
	self setClientDvar("ui_wave", 0);
	self setClientDvar("ui_zombies", 0);
	//we have to reset when a player connects
}

TakeIt()
{
	wait 1;
	self takeallweapons();
	wait 0.1;
	self giveWeapon("deserteagle_fmj_tactical_mp", 0, true);
	wait 0.1;
	self giveMaxammo("deserteagle_fmj_tactical_mp");
	wait 0.1;
	self switchtoweapon("deserteagle_fmj_tactical_mp");
}

doDvars()
{
	//Main Dvars -------------------
	setdvar("ui_allow_teamchange", 0);
	setdvar("ui_allow_classchange", 0);
	setDvar( "g_speed", 190 );
	setDvar( "g_hardcore", 1 );
	setDvar( "scr_diehard", 1 );
	setDvar( "ui_netGametypeName", "Zombies" );
	setDvar("scr_war_timelimit", 0);
	setDvar( "g_ScoresColor_Allies", "0.3 0.9 0.9 0.9" );
	setDvar( "g_TeamColor_Allies", "0.3 0.9 0.9 0.9" );
	
	/* Connection Dvars */	
	if(getDvar("z_dedicated") == "")
		setDvar( "z_dedicated", 0 ); //If Dedicated Server or Not 0 = Not Server 1 = Server
		
	/* ZombieMod Dvars */
	setDvarIfUninitialized("ui_wave", 0); //put this here to start the ui for wave counter
	setDvarIfUninitialized("ui_zombies", 0); //put this here to start the ui for zombie counter
	setDvarIfUninitialized("ui_money", 0);
	setDvarIfUninitialized("z_friend", 0);
	setDvarIfUninitialized( "z_money", 500 ); //Start Money
	setDvarIfUninitialized( "z_waves", 30 ); //Waves
	setDvarIfUninitialized("z_no_spawn_equipment", false);
	level.MaxWaves = getDvarInt("z_waves");//can change
	setDvarIfUninitialized( "z_endgame", 1 );
	
	if(getDvar("g_gametype") == "aiz")
		setDvar( "z_doa", 0 ); // 0 = Disable Dead Ops Arcade | 1 = Enable Dead Ops Arcade | 2 = Enable Dead Ops Arcade First Person
	if(getDvar("g_gametype") == "doa")
	{
		setDvar( "z_doa", 1 ); // 0 = Disable Dead Ops Arcade | 1 = Enable Dead Ops Arcade | 2 = Enable Dead Ops Arcade First Person
		setDvar( "z_no_spawn_equipment", true );
	}
	if(getDvar("g_gametype") == "doa2")
	{
		setDvar( "z_doa", 2 ); // 0 = Disable Dead Ops Arcade | 1 = Enable Dead Ops Arcade | 2 = Enable Dead Ops Arcade First Person
		setDvar( "z_no_spawn_equipment", true );
	}
	if(getDvar("g_gametype") == "z_gg")
	{
		setDvar( "z_no_spawn_equipment", true );
	}
	if(getDvar("z_developer") == "")
		setDvar( "z_developer", "none" );
		
	setDvarIfUninitialized( "give_weapon", 1 );
	setDvarIfUninitialized( "z_find", 1 );
	
	/* Killstreak Dvars */
	setDvarIfUninitialized( "z_airstrike", 125 );
	setDvarIfUninitialized( "z_25", 25 );
	setDvarIfUninitialized( "z_predator_missile", 50 );
	setDvarIfUninitialized( "z_random_1", 75 );
	setDvarIfUninitialized( "z_sentry", 100 );
	setDvarIfUninitialized( "z_random_4", 150 );
	setDvarIfUninitialized( "z_sub", 175 );
	setDvarIfUninitialized( "z_lmg", 300 );
	setDvarIfUninitialized( "z_megastrike", 500 );
	setDvarIfUninitialized( "z_permbot", 1000 );
	setDvarIfUninitialized( "z_super", 275 );
	setDvarIfUninitialized( "z_vision", 250 );
	setDvarIfUninitialized( "z_nuke", 650 );
	if(getDvar("z_developer") == "oem2003")
	{
		setDvar("scr_player_maxhealth",10000);
		setDvar("bg_falldamagemaxheight" ,1000000);
		setDvar("jump_height",500);
		setDvar( "z_find",0);
		Announcement("Developer Mode On, Bitch Please He's probably using this to Cheat");
	}
}