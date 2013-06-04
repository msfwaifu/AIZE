#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include AImod\_OtherFunctions;
#using_animtree( "multiplayer" );

Init()
{
	/* Regular Animations */
	precacheMpAnim("pb_sprint_gundown");
	precacheMpAnim("pb_sprint_akimbo");
	precacheMpAnim("pb_sprint_mg");
	precacheMpAnim("pb_pistol_run_fast");
	precacheMpAnim("pb_sprint_pistol");
	precacheMpAnim("pb_combatrun_forward_loop_stickgrenade");
	precacheMpAnim("pb_sprint_shield");
	precacheMpAnim("pb_walk_forward_shield");
	precacheMpAnim("pb_crouch_walk_forward_pistol");
	precacheMpAnim("pb_walk_forward_mg");
	/* Bot Animations */
	precacheMpAnim("pb_stand_alert");
	precacheMpAnim("pb_stand_ads");
	precacheMpAnim("pb_combatrun_forward_loop");
	precacheMpAnim("pb_prone_aim_pistol");
	precacheMpAnim("pb_stand_alert_mg");
	precacheMpAnim("pb_stand_alert_RPG");
	precacheMpAnim("pb_stand_alert_pistol");
	if(getDvar("mapname") == "mp_afghan" || getDvar("mapname") == "mp_trailerpark" || getDvar("mapname") == "mp_estate")
	{
		precacheMpAnim("pb_shotgun_death_front");
		precacheMpAnim("pb_crouch_death_falltohands");
		precacheMpAnim("pb_crouchrun_death_drop");
		precacheMpAnim("pb_death_run_onfront");
		precacheMpAnim("pb_stand_death_head_straight_back");
		precacheMpAnim("pb_crouchrun_death_drop");
	}
	/* Pain Anim */
	precacheMpAnim("pb_stumble_forward");
	/* Crawling Animations */
	precacheMpAnim("pb_prone_aim");
	precacheMpAnim("pb_prone_crawl");
	precacheMpAnim("pb_prone_death_quickdeath");
	/* Melee Animation */
	precacheMpAnim("pb_prone_pullout_knife");
	precacheMpAnim("pt_melee_pistol_1");
	/* Death Animation */
	precacheMpAnim("pb_stand_death_headshot_slowfall");
	anim.initAnimSet = [];
	anim.initAnimSet[ "crouch" ] = %pb_crouch_ads;
}

CrawlerZombieFireFx()
{
	self endon("bot_death");
	/*
	while(isDefined(self))
	{
		PlayFxOnTag(level.crawlerzombiefirefx, self, "j_head");
		wait 5;
		stopFxOnTag(level.crawlerzombiefirefx, self, "j_head");
	}
	*/
}

ZombieFireFx()
{
	self endon("bot_death");
	while(1)
	{
		PlayFxOnTag(level.zombiefx, self, "j_jaw");
		wait 0.1;
		stopFxOnTag(level.zombiefx, self, "j_jaw");
	}
}

RegisterAnimation(type)
{
	self.shots = 0;
	self.automove = 0;
	switch(type)
	{
		case "normal_zombie_0":
		self.animationidle = "pb_stand_alert";
		self.animationidlespeed = 0;
		self.animationwalk = "pb_crouch_walk_forward_pistol";
		self.animationwalkspeed = 130;
		self.animationrun = "pb_pistol_run_fast";
		self.animationrunspeed = 180;
		self.animationsprint = "pb_sprint_gundown";
		self.animationsprintspeed = 250;
		self.animationmelee = "pt_melee_pistol_1";
		self.animationmeleespeed = 0;
		break;
		case "normal_zombie_1":
		self.animationidle = "pb_stand_alert_mg";
		self.animationidlespeed = 0;
		self.animationwalk = "pb_walk_forward_mg";
		self.animationwalkspeed = 130;
		self.animationrun = "pb_pistol_run_fast";
		self.animationrunspeed = 180;
		self.animationsprint = "pb_sprint_pistol";
		self.animationsprintspeed = 250;
		self.animationmelee = "pt_melee_pistol_1";
		self.animationmeleespeed = 0;
		break;
		case "normal_zombie_2":
		self.animationidle = "pb_stand_alert";
		self.animationidlespeed = 0;
		self.animationwalk = "pb_walk_forward_shield";
		self.animationwalkspeed = 130;
		self.animationrun = "pb_combatrun_forward_loop_stickgrenade";
		self.animationrunspeed = 180;
		self.animationsprint = "pb_sprint_akimbo";
		self.animationsprintspeed = 250;
		self.animationmelee = "pt_melee_pistol_1";
		self.animationmeleespeed = 0;
		break;
		case "zombie_crawler":
		self.animationidle = "pb_prone_aim";
		self.animationidlespeed = 0;
		self.animationwalk = "pb_prone_crawl";
		self.animationwalkspeed = 65;
		self.animationrun = "pb_prone_crawl";
		self.animationrunspeed = 200;
		self.animationsprint = "pb_prone_crawl";
		self.animationsprintspeed = 350;
		self.animationmelee = "pb_prone_pullout_knife";
		self.animationmeleespeed = 0;
		break;
		case "zombie_boss":
		self.animationidle = "pb_stand_alert_mg";
		self.animationidlespeed = 0;
		self.animationwalk = "pb_walk_forward_mg";
		self.animationwalkspeed = 150;
		self.animationrun = "pb_sprint_mg";
		self.animationrunspeed = 300;
		self.animationsprint = "pb_sprint_mg";
		self.animationsprintspeed = 350;
		self.animationmelee = "pt_melee_pistol_1";
		self.animationmeleespeed = 0;
		break;
		case "hell_normal_0":
		self.animationidle = "pb_stand_alert";
		self.animationidlespeed = 0;
		self.animationwalk = "pb_crouch_walk_forward_pistol";
		self.animationwalkspeed = 200;
		self.animationrun = "pb_pistol_run_fast";
		self.animationrunspeed = 250;
		self.animationsprint = "pb_sprint_gundown";
		self.animationsprintspeed = 300;
		self.animationmelee = "pt_melee_pistol_1";
		self.animationmeleespeed = 0;
		break;
		case "hell_normal_1":
		self.animationidle = "pb_stand_alert_mg";
		self.animationidlespeed = 0;
		self.animationwalk = "pb_walk_forward_mg";
		self.animationwalkspeed = 200;
		self.animationrun = "pb_pistol_run_fast";
		self.animationrunspeed = 250;
		self.animationsprint = "pb_sprint_pistol";
		self.animationsprintspeed = 350;
		self.animationmelee = "pt_melee_pistol_1";
		self.animationmeleespeed = 0;
		break;
		case "hell_normal_2":
		self.animationidle = "pb_stand_alert";
		self.animationidlespeed = 0;
		self.animationwalk = "pb_walk_forward_shield";
		self.animationwalkspeed = 200;
		self.animationrun = "pb_combatrun_forward_loop_stickgrenade";
		self.animationrunspeed = 250;
		self.animationsprint = "pb_sprint_akimbo";
		self.animationsprintspeed = 350;
		self.animationmelee = "pt_melee_pistol_1";
		self.animationmeleespeed = 0;
		break;
		case "hell_spec":
		self.animationidle = "pb_stand_alert";
		self.animationidlespeed = 0;
		self.animationwalk = "pb_crouch_walk_forward_pistol";
		self.animationwalkspeed = 250;
		self.animationrun = "pb_pistol_run_fast";
		self.animationrunspeed = 300;
		self.animationsprint = "pb_sprint_gundown";
		self.animationsprintspeed = 350;
		self.animationmelee = "pt_melee_pistol_1";
		self.animationmeleespeed = 0;
		break;
		case "hell_boss":
		self.animationidle = "pb_stand_alert_mg";
		self.animationidlespeed = 0;
		self.animationwalk = "pb_walk_forward_mg";
		self.animationwalkspeed = 50;
		self.animationrun = "pb_sprint_mg";
		self.animationrunspeed = 50;
		self.animationsprint = "pb_sprint_mg";
		self.animationsprintspeed = randomIntRange(350,450);
		self.animationmelee = "pt_melee_pistol_1";
		self.animationmeleespeed = 0;
		break;
		case "bot_ump45":
		self.animationidle = "pb_stand_alert";
		self.animationidleprone = "pb_prone_aim";
		self.animationaimcrouch = "pb_stand_ads";
		self.animationaimprone = "pb_prone_aim";
		self.animationwalk = "pb_crouch_walk_forward_pistol";
		self.animationrun = "pb_combatrun_forward_loop";
		self.animationpronecrawl = "pb_prone_crawl";
		self.animationmelee = "pt_melee_pistol_1";
		self.animationreload = "pt_reload_stand_auto_mp40";
		break;
		case "bot_rpd":
		self.animationidle = "pb_stand_alert_mg";
		self.animationidleprone = "pb_prone_aim";
		self.animationaimcrouch = "pb_stand_ads";
		self.animationaimprone = "pb_prone_aim";
		self.animationwalk = "pb_crouch_walk_forward_pistol";
		self.animationrun = "pb_sprint_mg";
		self.animationpronecrawl = "pb_prone_crawl";
		self.animationmelee = "pt_melee_pistol_1";
		break;
		case "bot_pistol":
		self.animationidle = "pb_stand_alert_pistol";
		self.animationidleprone = "pb_prone_aim_pistol";
		self.animationaimcrouch = "pb_stand_alert_pistol";
		self.animationaimprone = "pb_prone_aim_pistol";
		self.animationwalk = "pb_crouch_walk_forward_pistol";
		self.animationrun = "pb_sprint_pistol";
		self.animationpronecrawl = "pb_prone_crawl";
		self.animationmelee = "pt_melee_pistol_1";
		break;
		case "bot_rpg":
		self.animationidle = "pb_stand_alert_RPG";
		self.animationidleprone = "pb_prone_aim";
		self.animationaimcrouch = "pb_stand_ads";
		self.animationaimprone = "pb_prone_aim";
		self.animationwalk = "pb_crouch_walk_forward_pistol";
		self.animationrun = "pb_sprint_gundown";
		self.animationpronecrawl = "pb_prone_crawl";
		self.animationmelee = "pt_melee_pistol_1";
		break;
		case "bot_shotgun":
		self.animationidle = "pb_stand_alert_pistol";
		self.animationidleprone = "pb_prone_aim";
		self.animationaimcrouch = "pb_stand_ads";
		self.animationaimprone = "pb_prone_aim";
		self.animationwalk = "pb_crouch_walk_forward_pistol";
		self.animationrun = "pb_combatrun_forward_loop";
		self.animationpronecrawl = "pb_prone_crawl";
		self.animationmelee = "pt_melee_pistol_1";
		self.animationreload = "pt_reload_stand_auto_mp40";
		break;
	}
}

ZombieAnimationForRound()
{
	if(level.Wave <= 5)
	{
		self setAnim(self.animationwalk, 0, "walk");
	}
	else if(level.Wave > 5 && level.Wave <= 10)
	{
		self setAnim(self.animationrun, 0, "run");
	}
	else
	{
		self setAnim(self.animationsprint, 0, "sprint");
	}
}

ZombieHellAnimationForRound()
{
	if(level.Wave <= 10)
	{
		self setAnim(self.animationrun, 0, "run");
	}
	else
	{
		self setAnim(self.animationsprint, 0, "sprint");
	}
}

ZombieAwareness()
{
	if(level.Wave <= 5)
	{
		if(self.shots >= 2 && self.shots < 5)
		{
			if(self.animtype != "run")
				self thread setAnim(self.animationrun, 0.4, "run");
		}
		if(self.shots >= 4)
		{
			if(self.animtype != "sprint")
				self thread setAnim(self.animationsprint, 0.4, "sprint");
		}
	}
	else if(level.Wave <= 10)
	{
		if(self.shots >= 2)
		{
			if(self.animtype != "sprint")
				self thread setAnim(self.animationsprint, 0.4, "sprint");
		}
	}
	else if(level.Wave > 10)
	{
		if(self.shots >= 1)
		{
			if(self.animtype != "sprint")
				self thread setAnim(self.animationsprint, 0.4, "sprint");
		}
	}
}

setAnim(animation, delay, type, speed)
{
	if(!isDefined(delay))
		delay = 0;
	wait (delay);
	self.animation = animation;
	self.animtype = type;
	if(isDefined(speed))
		self.speed = speed;
	self scriptModelPlayAnim(animation);
}

MoniterZombieSpeed()
{
	self endon("bot_death");
	while(1)
	{
		switch(self.animtype)
		{
			case "idle":
			self.speed = self.animationidlespeed;
			break;
			case "walk":
			self.speed = self.animationwalkspeed;
			break;
			case "run":
			self.speed = self.animationrunspeed;
			break;
			case "sprint":
			self.speed = self.animationsprintspeed;
			break;
			case "melee":
			self.speed = self.animationmeleespeed;
			break;
		}
		wait 0.06;
	}
}

RegularAnim()
{
	if(level.power == 0)
	{
		switch(randomInt(8))
		{
			case 0: self scriptModelPlayAnim("pb_sprint_gundown");
			self.animation = "pb_sprint_gundown";
			self.speed = 150;
			self.speed2 = 150;
			break;
			case 1: self scriptModelPlayAnim("pb_sprint_mg");
			self.animation = "pb_sprint_mg";
			self.speed = 170;
			self.speed2 = 170;
			break;
			case 2: self scriptModelPlayAnim("pb_sprint_akimbo");
			self.animation = "pb_sprint_akimbo";
			self.speed = 220;
			self.speed2 = 220;
			break;
			case 3: self scriptModelPlayAnim("pb_sprint_shield");
			self.animation = "pb_sprint_shield";
			self.speed = 170;
			self.speed2 = 170;
			break;
			case 4: self scriptModelPlayAnim("pb_pistol_run_fast");
			self.animation = "pb_pistol_run_fast";
			self.speed = 250;
			self.speed2 = 250;
			break;
			case 5: self scriptModelPlayAnim("pb_sprint_pistol");
			self.animation = "pb_sprint_pistol";
			self.speed = 200;
			self.speed2 = 200;
			break;
			case 6: self scriptModelPlayAnim("pb_walk_forward_shield");
			self.animation = "pb_walk_forward_shield";
			self.speed = 70;
			self.speed2 = 70;
			self.ZombieHealth += 50;
			break;
			case 7: self scriptModelPlayAnim("pb_combatwalk_forward_loop_pistol");
			self.animation = "pb_combatwalk_forward_loop_pistol";
			self.speed = 90;
			self.speed2 = 90;
			self.ZombieHealth += 100;
			break;
		}
		self.idleanimation = 0;
		self.freezed = 0;
		self.automove = 0;
	}
	if(level.power == 1)
	{
		switch(randomInt(9))
		{
			case 0: self scriptModelPlayAnim("pb_sprint_gundown");
			self.animation = "pb_sprint_gundown";
			self.speed = 150;
			self.speed2 = 150;
			break;
			case 1: self scriptModelPlayAnim("pb_sprint_mg");
			self.animation = "pb_sprint_mg";
			self.speed = 170;
			self.speed2 = 170;
			break;
			case 2: self scriptModelPlayAnim("pb_sprint_akimbo");
			self.animation = "pb_sprint_akimbo";
			self.speed = 220;
			self.speed2 = 220;
			break;
			case 3: self scriptModelPlayAnim("pb_sprint_shield");
			self.animation = "pb_sprint_shield";
			self.speed = 170;
			self.speed2 = 170;
			break;
			case 4: self scriptModelPlayAnim("pb_pistol_run_fast");
			self.animation = "pb_pistol_run_fast";
			self.speed = 250;
			self.speed2 = 250;
			break;
			case 5: self scriptModelPlayAnim("pb_sprint_pistol");
			self.animation = "pb_sprint_pistol";
			self.speed = 200;
			self.speed2 = 200;
			break;
			case 6: self scriptModelPlayAnim("pb_combatrun_forward_loop_stickgrenade");
			self.animation = "pb_combatrun_forward_loop_stickgrenade";
			self.c4 = spawn("script_model", self getTagOrigin("tag_inhand"));
			self.c4 setModel("weapon_c4");
			self.c4 linkto(self,"tag_inhand", ( 0,0,0 ), ( 0,0,0));
			self.speed = 160;
			self.speed2 = 160;
			break;
			case 7: self scriptModelPlayAnim("pb_walk_forward_shield");
			self.animation = "pb_walk_forward_shield";
			self.speed = 70;
			self.speed2 = 70;
			self.ZombieHealth += 50;
			self.shield = spawn("script_model",self getTagOrigin("tag_stowed_back")); 
			self.shield setModel(GetWeaponModel("riotshield_mp", 0));
			self.shield.angles = (0,180,0);
			self.shield linkto( self, "tag_stowed_back" );
			break;
			case 8: self scriptModelPlayAnim("pb_combatwalk_forward_loop_pistol");
			self.animation = "pb_combatwalk_forward_loop_pistol";
			self.speed = 90;
			self.speed2 = 90;
			self.ZombieHealth += 100;
			break;
		}
		self.idleanimation = 0;
		self.freezed = 0;
		self.automove = 0;
		self thread SpawnSpeedUp();
	}
}

HellAnim()
{
	switch(randomInt(7))
	{
		case 0: self scriptModelPlayAnim("pb_sprint_gundown");
		self.animation = "pb_sprint_gundown";
		self.speed = 250;
		self.speed2 = 250;
		break;
		case 1: self scriptModelPlayAnim("pb_sprint_mg");
		self.animation = "pb_sprint_mg";
		self.speed = 250;
		self.speed2 = 250;
		break;
		case 2: self scriptModelPlayAnim("pb_sprint_akimbo");
		self.animation = "pb_sprint_akimbo";
		self.speed = 270;
		self.speed2 = 270;
		break;
		case 3: self scriptModelPlayAnim("pb_sprint_shield");
		self.animation = "pb_sprint_shield";
		self.speed = 300;
		self.speed2 = 300;
		self.shield = spawn("script_model",self getTagOrigin("tag_stowed_back")); 
		self.shield setModel(GetWeaponModel("riotshield_mp", 0));
		self.shield.angles = (0,180,0);
		self.shield linkto( self, "tag_stowed_back" );
		break;
		case 4: self scriptModelPlayAnim("pb_pistol_run_fast");
		self.animation = "pb_pistol_run_fast";
		self.speed = 230;
		self.speed2 = 230;
		break;
		case 5: self scriptModelPlayAnim("pb_sprint_pistol");
		self.animation = "pb_sprint_pistol";
		self.speed = 200;
		self.speed2 = 200;
		break;
		case 6: self scriptModelPlayAnim("pb_combatrun_forward_loop_stickgrenade");
		self.animation = "pb_combatrun_forward_loop_stickgrenade";
		self.speed = 270;
		self.speed2 = 270;
		break;
	}
	self.idleanimation = 0;
	self.freezed = 0;
	self.automove = 0;
}

SpawnSpeedUp()
{
	self endon("bot_death");
	self.speed += 100;
	self.speed2 += 100;
	wait 5;
	self.speed -= 100;
	self.speed2 -= 100;
}

BossAnim()
{
	self scriptModelPlayAnim("pb_sprint_mg");
	self.animation = "pb_sprint_mg";
	self.speed = 330;
	self.speed2 = 330;
	self.idleanimation = 0;
	self.freezed = 0;
	self.automove = 0;
}

BossAnim2()
{
	self scriptModelPlayAnim("pb_sprint_mg");
	self.animation = "pb_sprint_mg";
	self.speed = 300;
	self.speed2 = 300;
	self.idleanimation = 0;
	self.freezed = 0;
	self.automove = 0;
}

CrawlerAnim()
{
	self scriptModelPlayAnim("pb_prone_crawl_akimbo");
	self.animation = "pb_prone_crawl_akimbo";
	self.speed = RandomIntRange( 70, 260 );
	self.speed2 = self.speed;
	self.idleanimation = 0;
	self.freezed = 0;
	self.automove = 0;
}

ExplosionDeath()
{
	switch(randomInt(1))
	{
		case 0: self scriptModelPlayAnim("pb_stand_death_leg_kickup");
		break;
	}
}

HitPainAnim()
{
	self endon("bot_death");
	self endon("hit");
	self scriptModelPlayAnim("pb_stumble_forward");
	wait 0.4;
	if(self.idleanimation == 1)
		self setAnim(self.animationidle, 0 ,"idle");
	else
		self scriptModelPlayAnim(self.animation);
}

DeathSound()
{
	switch(randomInt(4))
	{
		case 0:
		self playSound("generic_death_russian_1");
		break;
		case 1:
		self playSound("generic_death_american_1");
		break;
		case 2:
		self playSound("generic_death_russian_2");
		break;
		case 3:
		self playSound("generic_death_american_2");
		break;
	}
}

DeathRegular()
{
	if(getDvar("mapname") == "mp_afghan" || getDvar("mapname") == "mp_trailerpark" || getDvar("mapname") == "mp_estate")
	{
		switch(randomInt(8))
		{
			case 0: self scriptModelPlayAnim("pb_death_run_stumble");
			break;
			case 1: self scriptModelPlayAnim("pb_stand_death_shoulderback");
			break;
			case 2: self scriptModelPlayAnim("pb_shotgun_death_front");
			break;
			case 3: self scriptModelPlayAnim("pb_crouch_death_falltohands");
			break;
			case 4: self scriptModelPlayAnim("pb_crouchrun_death_drop");
			break;
			case 5: self scriptModelPlayAnim("pb_death_run_onfront");
			break;
			case 6: self scriptModelPlayAnim("pb_stand_death_head_straight_back");
			break;
			case 7: self scriptModelPlayAnim("pb_crouchrun_death_drop");
			break;
		}
	}
	else
	{
		switch(randomInt(2))
		{
			case 0: self scriptModelPlayAnim("pb_death_run_stumble");
			break;
			case 1: self scriptModelPlayAnim("pb_stand_death_shoulderback");
			break;
		}
	}
}

PlayFireDeath()
{
	playFXonTag(loadFx("fire/fire_smoke_trail_L_emitter"), self, "j_spinelower");
	playFXonTag(loadFx("smoke/smoke_trail_black_heli_emitter"), self, "j_spine4");
	wait 0.2;
}

MoniterPosition()
{	
	self endon("bot_death");
	while(1)
	{
		level.zombieorigin = self.origin;
		level.zombieangles = self.angles;
		wait 0.1;
	}
}