#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include AImod\_OtherFunctions;
#include AImod\_Bot;
#include AImod\_weapon;
#include AImod\_text;
#include AImod\_DoaBonusDrops;

BonusDrops()
{
    self endon("disconnect");
	self endon("bonus_end");
	self endon("bot_is_dead");
	if(level.Wave <= 5)
	{
		random = randomInt(30);
		randomequels = randomInt(30);
	}
	else if(level.Wave <= 10)
	{
		random = randomInt(40);
		randomequels = randomInt(40);
	}
	else
	{
		random = randomInt(45);
		randomequels = randomInt(45);
	}
	self waittill("bot_death");
	if(random == randomequels)
	{
		switch(randomInt(6))
		{
			case 0:
			BonusDropReg(self.origin+(0,0,40), self.angles-(90,0,0), "nuke_drop", "nuke_drop_take", "dpad_killstreak_nuke", "Nuke", "", "projectile_cbu97_clusterbomb", 0, level.SmallFire);
			break;
			case 1:
			BonusDropReg(self.origin, self.angles, "double_points", "double_points_take", "cardicon_gold", "Double Points", "", "com_plasticcase_friendly", 0, loadFX("misc/flare_ambient"));
			break;
			case 2:
			BonusDropReg(self.origin, self.angles, "insta_kill_drop", "insta_kill_drop_take", "cardicon_fmj", "Insta-Kill", "", "com_plasticcase_friendly", 0, level.SmallFire);
			break;
			case 3:
			BonusDropReg(self.origin+(0,0,50), self.angles, "death_machine_drop", "death_machine_drop_take", "cardicon_skull", "Death Machine", "m240_grip_reflex_mp", "weapon_m240", 1, loadFX("misc/flare_ambient"));
			break;
			case 4:
			BonusDropReg(self.origin, self.angles, "ammo", "ammo_drop_take", "waypoint_ammo_friendly", "Max Ammo", "", "com_plasticcase_friendly", 0, loadFX("misc/flare_ambient_green"));
			break;
			case 5:
			BonusDropReg(self.origin, self.angles, "ammo", "ammo_drop_take", "waypoint_ammo_friendly", "Max Ammo", "", "com_plasticcase_friendly", 0, loadFX("misc/flare_ambient_green"));
			break;
		}
	}
}

BonusDropReg(pos, angle, type, killnotify, icon, text, gun, model, isGunModel, fx)
{
	level.block = spawn("script_model", pos+(0,0,10) );
	level.block setModel(model);
	if(isGunModel == 1)
		level.block thread HideGunParts(gun);
	level.block.angles = angle;
	level.block notSolid();
	if(isGunModel < 1)
		level.block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	level.block.trigger = spawn( "trigger_radius", pos, 0, 75, 50 );
	level.block.trigger.angles = angle;
	level.block.fx = SpawnFX(fx,level.block.origin);
	TriggerFX(level.block.fx);
	level.block thread BonusDropRegThink(pos, angle, gun, killnotify, icon, text, type);
	level.block thread BonusDropDestroy(killnotify);
	level.block thread BonusDropTimerDestroy(killnotify);
	level.block thread rotateDrop(killnotify);
	wait 0.01;
}

BonusDropRegThink(pos, angle, gun, killnotify, icon, text, type)
{
	self endon("disconnect");
	self endon("bonusdrop_done");
	while(1)
	{
		self.trigger waittill( "trigger", player );
		if(Distance(pos, Player.origin) <= 75)
		{
			switch(type)
			{
				case "ammo":
				{
					foreach(player in level.players)
					{
						player playLocalSound("mp_level_up");
						player thread MaxAmmo();
						player thread BonusDropText(text, 0.85, (1,1,1),(1,1,0.3),1); 
						player thread BonusDropIcon(icon);
					}
				}
				break;
				case "nuke_drop":
				{
					self delete();
					player thread KaBoom(pos);
					foreach(player in level.players)
					{
						player thread BonusDropText(text, 0.85, (1,1,1),(1,0.3,0.3),1); 
						player thread BonusDropIcon(icon);
					}
				}
				break;
				case "insta_kill_drop":
				{
					level thread InstaKill();
				}
				break;
				case "double_points":
				{
					level thread DoublePoints();
				}
				break;
				case "death_machine_drop":
				{
					player thread DeathMachineStart();
					player thread BonusDropText(text, 0.85, (1,1,1),(1,0.3,0.3),1); 
					player thread BonusDropIcon(icon);
				}
				break;
			}
			self notify(killnotify);
			self.trigger delete();
			self.fx delete();
			self notify("random_drop_destroy");
			self notify("bonusdrop_done");
		}
		wait 0.1;
	}
}

KaBoom(pos)
{
	level thread NukeKill();
	setSlowMotion( 1.0, 0.3, 1 );
	wait 0.3;
	PhysicsExplosionSphere( pos, 5000000, 5000000, 10 );
	wait 1;
	setSlowMotion( 0.3, 1, 0.5 );
	foreach(player in level.players)
	{
		player.money += 400;
		player notify("MONEY");
		player thread maps\mp\gametypes\_rank::scorePopup( 400, 0, (0,1,0), 1 );
	}
}

NukeKill()
{
    level endon("nuke_drop_end");
	{
		foreach(zombie in level.bots)
		{
			playFx(loadFx("props/barrelexp"), zombie getTagOrigin("j_head"));
			PhysicsExplosionSphere( zombie.origin, 230, 0, 3 );
			zombie playSound("explo_mine");
			zombie.head hide();
			zombie.crate1.health -= 99999999;
			zombie.crate1 notify("damage", 99999999);
		}
		level.players[0] playSound("exp_suitcase_bomb_main");
	}
}

DoublePoints()
{ 
	level notify("double_points_start");
	level endon("double_points_start");
	{
		level.double_points = 1;
		foreach(player in level.players)
		{
			player playLocalSound("mp_level_up");
			player thread AImod\_text::BonusDropText("Double Points!", 0.85, (25.5,25.5,25.5),(0.3,0.9,0.3),0.75); 
			player thread AImod\_text::BonusDropIcon("cardicon_gold");
			player thread DoublePointsTimer();
		}
		wait 30;
		foreach(player in level.players)
		{
			player playLocalSound("mp_level_up");
			player thread AImod\_text::BonusDropText("Double Points Gone!", 0.85, (25.5,25.5,25.5),(0.9,0.3,0.3),0.75); 
			player thread AImod\_text::BonusDropIcon("cardicon_gold");
		}
		level.double_points = 0;
	}
	wait 0.1;
}

InstaKill()
{ 
	level notify("insta_kill_start");
	level endon("insta_kill_start");
	{
		level.insta_ko = 1;
		foreach(player in level.players)
		{
			player playLocalSound("mp_level_up");
			player thread AImod\_text::BonusDropText("Insta-Kill!", 0.85, (25.5,25.5,25.5),(0.9,0.3,0.3),0.75); 
			player thread AImod\_text::BonusDropIcon("cardicon_fmj");
			player thread InstaKillTimer();
		}
		wait 30;
		foreach(player in level.players)
		{
			player playLocalSound("mp_level_up");
			player thread AImod\_text::BonusDropText("Insta-Kill Over!", 0.85, (25.5,25.5,25.5),(0.9,0.3,0.3),0.75); 
			player thread AImod\_text::BonusDropIcon("cardicon_fmj");
		}
		level.insta_ko = 0;
	}
	wait 0.1;
}

MaxAmmo()
{ 
    level endon("disconnect");
	{
		foreach(player in level.players)
		{
			weaponList = player GetWeaponsListAll();
			foreach ( weaponName in weaponList )
			{	
				player giveMaxAmmo( weaponName );
			}
			
			player setweaponammoclip("frag_grenade_mp",3);
		}
	}
}

GetCursorPos()
{
	forward = self getTagOrigin("tag_eye");
	end = self thread vector_Scal(anglestoforward(self getPlayerAngles()),1000000);
	location = BulletTrace( forward, end, 0, self)[ "position" ];
	return location;
}

vector_scal(vec, scale) 
{
    vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
    return vec;
}

DeathMachineStart()
{ 
    level endon("disconnect");
	self endon("no_deathmachine");
	{
		self thread AImod\_text::BonusDropText("Death Machine!", 0.85, (25.5,25.5,25.5),(0.3,0.3,0.9),0.60); 
		self thread AImod\_text::BonusDropIcon("cardicon_skull");
		self playLocalSound("mp_level_up");
		self thread DeathMachine();
		self thread DeathMachineNoSwitch();
	    self giveWeapon( "m240_grip_reflex_mp", 0, true);
		self switchToWeapon("m240_grip_reflex_mp");
		self GiveMaxAmmo("m240_grip_reflex_mp");
		self.notusebox = 1;
		wait 30;
		self.notusebox = 0;
		self takeWeapon("m240_grip_reflex_mp");
		wait 0.1;
		self switchtoRandomWeapon();
		self thread AImod\_text::BonusDropText("Death Machine!", 0.85, (25.5,25.5,25.5),(0.3,0.3,0.9),0.60); 
		self thread AImod\_text::BonusDropIcon("cardicon_skull");
		self playLocalSound("mp_level_up");
		level notify("bonus_end");
		self notify("no_deathmachine");
	}
	wait 0.1;
}

DeathMachineNoSwitch()
{
    self endon("no_deathmachine");
    while(1)
	{
	    self switchToWeapon("m240_grip_reflex_mp");
		wait 0.1;
	}
}

DeathMachine()
{
    self endon("death");
	self endon("no_deathmachine");
    for( ;; )
    {
        self waittill( "weapon_fired" );
        if ( self getCurrentWeapon() == "m240_grip_reflex_mp" )
        {
			self GiveMaxAmmo("m240_grip_reflex_mp");
			self setWeaponAmmoClip( "m240_grip_reflex_mp", 9999, "right" );
			self setWeaponAmmoClip( "m240_grip_reflex_mp", 9999, "left" );
        }
    }
}

InstaKillTimer()
{
	self endon("disconnect");
	level endon("insta_kill_start");
	{
		time = 30;
		self.KoTimer destroy();
		self.KoTimer = self createFontString("objective", 1.5);
		self.KoTimer setPoint("BOTTOMCENTER", "BOTTOMCENTER", 0, -30);
		self.KoTimer.label = &"Insta-Kill for: ";
		self.KoTimer.HideWhenInMenu = true;
		self.KoTimer.color = (1,1,1);
		self.KoTimer.glowColor = (0.9,0.3,0.3);
		self.KoTimer.alpha = 1;
		for(count = time;count > -1;count--)
		{
			time = count;
			self.KoTimer setValue(time);
			wait 1;
		}
		self.KoTimer destroy();
	}
}

DoublePointsTimer()
{
	self endon("disconnect");
	level endon("double_points_start");
	{
		time = 29;
		self.DoublePointsTimer destroy();
		self.DoublePointsTimer = self createFontString("objective", 1.5);
		self.DoublePointsTimer setPoint("BOTTOMCENTER", "BOTTOMCENTER", 0, -15);
		self.DoublePointsTimer.label = &"Double Points for: ";
		self.DoublePointsTimer.HideWhenInMenu = true;
		self.DoublePointsTimer.color = (1,1,1);
		self.DoublePointsTimer.glowColor = (0.3,0.9,0.3);
		self.DoublePointsTimer.alpha = 1;
		self.DoublePointsTimer.glowAlpha = 1;
		for(count = time;count > -1;count--)
		{
			time = count;
			self.DoublePointsTimer setValue(time);
			wait 1;
		}
		self.DoublePointsTimer destroy();
	}
}