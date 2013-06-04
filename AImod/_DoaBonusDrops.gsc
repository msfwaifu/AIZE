#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include AImod\_OtherFunctions;
#include AImod\_weapon;
#include AImod\_text;

BonusDropsDeadOps()
{
    self endon("disconnect");
	self endon("bot_is_dead");
	random = randomInt(10);
	randomequels = randomInt(10);
	self waittill("bot_death");
	{
		if(random == randomequels)
		{
			switch(randomInt(10))
			{
				case 0:
				BonusDrop(self.origin, self.angles, "give_weapon", "high_powered_ak47", "hud_icon_ak47", "High Powered Assault Rifle", "ak47_fmj_shotgun_mp", "weapon_ak47_tactical", 1, "misc/flare_ambient");
				break;
				case 1:
				BonusDrop(self.origin, self.angles, "give_weapon", "automatic_shotgun", "hud_icon_aa12", "Automatic Shotgun", "aa12_grip_mp", "weapon_aa12", 1, "misc/flare_ambient_green");
				break;
				case 2:
				BonusDrop(self.origin, self.angles, "give_weapon", "high_power_pistol", "cardicon_fmj", "High Power Pistol", "coltanaconda_fmj_mp", "weapon_colt_anaconda", 1, "misc/aircraft_light_wingtip_green");
				break;
				case 3:
				BonusDrop(self.origin, self.angles, "give_weapon", "super_rpg", "cardicon_doubletap", "Rockets", "rpg_mp", "weapon_rpg7", 1, level.SmallFire);
				break;
				case 4:
				BonusDrop(self.origin, self.angles, "give_weapon", "auto_m16", "hud_icon_m16", "Fully Auto M16A4", "m16_mp", "weapon_m16", 1, "misc/flare_ambient");
				break;
				case 5:
				BonusDrop(self.origin, self.angles, "give_weapon", "auto_m9", "hud_icon_beretta393", "Fully Auto M9", "beretta393_akimbo_mp", "weapon_beretta_393", 1, "misc/aircraft_light_wingtip_green");
				break;
				case 6:
				BonusDrop(self.origin, self.angles, "give_weapon", "auto_50cal", "hud_icon_barrett50cal", "Fully Auto 50Cal", "barrett_fmj_mp", "weapon_m82", 1, "misc/flare_ambient");
				break;
				case 7:
				BonusDrop(self.origin, self.angles, "speed_boost", "speedy_boost", "cardicon_tsunami", "Speed Boost", "", "com_plasticcase_friendly", 0, level.SmallFire);
				break;
				case 8:
				BonusDrop(self.origin, self.angles, "nuke", "nuke_off", "dpad_killstreak_nuke", "Nuke!", "", "projectile_cbu97_clusterbomb", 0, level.SmallFire);
				break;
				case 9:
				BonusDrop(self.origin, self.angles, "chicken_bot", "chicken_taken", "cardicon_chicken", "Chicken Spawned!", "", AImod\_botUtil::GetHeadSpawnModel(), 0, "misc/flare_ambient_green");
				break;
			}
		}
	}
}

BonusDrop(pos, angle, type, killnotify, icon, text, gun, model, isGunModel ,fx)
{
	level.block = spawn("script_model", pos + (0, 0, 45) );
	level.block setModel(model);
	if(isGunModel == 1)
		level.block thread HideGunParts(gun);
	level.block.angles = angle;
	level.block notSolid();
	if(isGunModel < 1)
		level.block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	level.block.trigger = spawn( "trigger_radius", pos, 0, 75, 50 );
	level.block.trigger.angles = angle;
	level.block.fx = SpawnFX(loadFX(fx),level.block.origin);
	TriggerFX(level.block.fx);
	level.block thread BonusDropThink(pos, angle, gun, killnotify, icon, text, type);
	level.block thread BonusDropDestroy(killnotify);
	level.block thread BonusDropTimerDestroy(killnotify);
	level.block thread rotateDrop(killnotify);
	wait 0.01;
}

BonusDropTimerDestroy(killnotify)
{
	self endon(killnotify);
	{
		wait 20;
		for(count = 10;count > -1;count--)
		{
			wait 0.5;
			self hide();
			wait 0.5;
			self show();
		}
		self notify("bonusdrop_done");
		self.fx delete();
		self.trigger delete();
		self delete();
		self notify(killnotify);
	}
}

rotateDrop(killnotify)
{
    self endon(killnotify);
	for(;;)
	{
		self rotateyaw(-360,5);
		wait 5;
	}
}

BonusDropDestroy(killnotify)
{
	self waittill(killnotify);
	self.fx delete();
	self delete();
}

BonusDropThink(pos, angle, gun, killnotify, icon, text, type)
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
				case "give_weapon":
				if(player getCurrentWeapon() != "mg4_mp" && player getCurrentWeapon() != "ak47_fmj_mp" && player getCurrentWeapon() != "ranger_fmj_mp" )
				{
					player takeWeapon(player getCurrentWeapon());
				}
				player notify("stop_current_bonus_drop_gun");
				player thread giveTheBonusDropGun(gun, icon, text);
				self notify(killnotify);
				self notify("random_drop_destroy");
				break;
				case "speed_boost":
				player notify("speed_bost");
				player thread SpeedBoost(icon, text);
				self notify(killnotify);
				self notify("random_drop_destroy");
				break;
				case "nuke":
				level thread GoBoom(player, text, icon);
				self notify(killnotify);
				break;
				case "chicken_bot":
				self notify(killnotify);
				player thread AImod\_text::BonusDropText(text, 0.85, (1,1,1),(0.3,1,0.3),1); 
				player thread AImod\_text::BonusDropIcon(icon);
				level thread SpawnChicken(player);
				break;
			}
			self notify("bonusdrop_done");
			self.trigger delete();
		}
		wait 0.1;
	}
}

GoBoom(player, text, icon)
{
	level thread maps\mp\killstreaks\_nuke::nukeEffects();
	if(getDvarInt("z_dedicated") == 0)
		setSlowMotion( 1.0, 0.4, 0.5 );
	foreach(player in level.players)
	{
		player playlocalsound( "nuke_explosion" );
		player playlocalsound( "nuke_wave" );
		earthquake(1,1.5, player.origin + (0,0,40), 60);
	}
	level thread AImod\_bonusdrops::NukeKill();
	level notify("nuke_drop_kill");
	wait 1.5;
	if(getDvarInt("z_dedicated") == 0)
		setSlowMotion( 0.4, 1, 2.0 );
	wait 3.5;
	foreach(player in level.players)
	{
		player.money += 400;
		player thread maps\mp\gametypes\_rank::giveRankXP("zombie_kill", 10);
		player.xpearned += 10;
		player thread AImod\_text::BonusDropText(text, 0.85, (1,1,1),(1,1,0),1); 
		player thread AImod\_text::BonusDropIcon(icon);
		player notify("MONEY");
		player thread maps\mp\gametypes\_rank::scorePopup( 400, 0, (0,1,0), 1 );
	}
}

giveTheBonusDropGun(gun, icon, text)
{ 
    level endon("disconnect");
	self endon("stop_current_bonus_drop_gun");
	{
		self thread AImod\_text::BonusDropText(text + "!", 0.85, (1,1,1),(1,0.5,0.3),1); 
		self thread AImod\_text::BonusDropIcon(icon);
		self playLocalSound("mp_level_up");
		self thread GunNoSwitch(gun);
		self thread GunTimer(text);
	    self giveWeapon(gun, 0, true);
		self switchToWeapon(gun);
		self GiveMaxAmmo(gun);
		self waittill("gun_time_ended");
		self notify("stop_gun_switch");
		self switchToWeapon("mg4_mp");
		self switchToWeapon("ak47_fmj_mp");
		self switchToWeapon("ranger_fmj_mp");
		self takeWeapon(gun);
		self.GunTimer destroy();
		wait 0.1;
		self thread AImod\_text::BonusDropText(text + " Ran out!", 0.85, (1,1,1),(0.9,0.3,0.3),1); 
		self thread AImod\_text::BonusDropIcon(icon);
		self playLocalSound("mp_level_up");
	}
	wait 0.1;
}

SpeedBoost(icon, text)
{
	self endon("disconnect");
	self endon("speed_bost");
	self thread AImod\_text::BonusDropText(text + "!", 0.85, (25.5,25.5,25.5),(0.9,0.3,0.3),0.60); 
	self thread AImod\_text::BonusDropIcon(icon);
	self playLocalSound("mp_level_up");
	self.moveSpeedScaler = 1.3;
	self maps\mp\gametypes\_weapons::updateMoveSpeedScale( "primary" );
	self thread BoostTimer();
	self waittill("boost_time_ended");
	self.BoostTimer destroy();
	self.moveSpeedScaler = 1.0;
	self maps\mp\gametypes\_weapons::updateMoveSpeedScale( "primary" );
	self thread AImod\_text::BonusDropText(text + " Has Ran Out!", 0.85, (25.5,25.5,25.5),(0.9,0.3,0.3),0.60); 
	self thread AImod\_text::BonusDropIcon(icon);
}

BoostTimer(text)
{
	self endon("disconnect");
	self endon("speed_bost");
	{
		time = 15;
		self.BoostTimer destroy();
		self.BoostTimer = self createFontString("objective", 1.5);
		self.BoostTimer setPoint("BOTTOMLEFT", "BOTTOMLEFT", 0, -45);
		self.BoostTimer.label = &"Boost Runs out in: ";
		self.BoostTimer.HideWhenInMenu = true;
		self.BoostTimer.color = (1,1,1);
		self.BoostTimer.glowColor = (0.3,0.9,0.3);
		self.BoostTimer.alpha = 1;
		self.BoostTimer.glowAlpha = 1;
		for(count = time;count > -1;count--)
		{
			self.BoostTimer setValue(time);
			time = count;
			wait 1;
		}
		self notify("boost_time_ended");
	}
}

GunTimer(text)
{
	self endon("disconnect");
	self endon("stop_current_bonus_drop_gun");
	{
		time = 30;
		self.GunTimer destroy();
		self.GunTimer = self createFontString("objective", 1.5);
		self.GunTimer setPoint("BOTTOMLEFT", "BOTTOMLEFT", 0, -30);
		self.GunTimer.label = &"Gun Runs out in: ";
		self.GunTimer.HideWhenInMenu = true;
		self.GunTimer.color = (1,1,1);
		self.GunTimer.glowColor = (0.9,0.3,0.3);
		self.GunTimer.alpha = 1;
		self.GunTimer.glowAlpha = 1;
		for(count = time;count > -1;count--)
		{
			self.GunTimer setValue(time);
			time = count;
			wait 1;
		}
		self notify("gun_time_ended");
	}
}

GunNoSwitch(gun)
{
    self endon("stop_current_bonus_drop_gun");
	self endon("stop_gun_switch");
    while(1)
	{
	    self switchToWeapon(gun);
		wait 0.1;
	}
}

SpawnChicken(player)
{
	level.chicken = spawn("script_model", player.origin+(0,50,0));
	level.chicken setModel(AImod\_botUtil::FriendlyModels());
	level.chicken.angles = (0,0,0);
	level.chicken.team = "allies";
	level.chicken.head = spawn("script_model", level.chicken getTagOrigin( "j_spine4" ));
	level.chicken.head setModel(AImod\_botUtil::GetHeadSpawnModel( ));
	level.chicken.head.angles = (270,0,270);
	level.chicken.head linkto( level.chicken, "j_spine4" );
	level.chicken.crate1 = spawn("script_model", level.chicken getTagOrigin( "j_spinelower" ) + (-5,0,-10)); 
	level.chicken.crate1 setModel("com_plasticcase_beige_big");
	level.chicken.crate1 CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	level.chicken.crate1.angles = (90,0,0);
	level.chicken.crate1 Solid();
	level.chicken.crate1 hide();
	level.chicken.crate1 linkto(level.chicken);
	level.chicken scriptModelPlayAnim("pb_stand_alert");
	level.chicken PlaySound( maps\mp\gametypes\_teams::getTeamVoicePrefix( "allies" ) + "mp_stm_iminposition" );
	level.chicken.chickenweapon = undefined;
	level.chicken thread UpdateChickenGun(player);
	level.chicken thread UpdateAngles(player);
	level.chicken thread MoveChicken(player);
	level.chicken thread KillChicken(player);
}

UpdateChickenGun(player)
{
	self endon("chicken_died");
	while(1)
	{
		if(self.chickenweapon != player getCurrentWeapon())
		{
			playergun = player getCurrentWeapon();
			self.gun delete();
			self.gun = spawn("script_model", self getTagOrigin( "tag_weapon_left" ));
			self.gun setModel(GetWeaponModel(playergun, 0));
			self.chickenweapon = playergun;
			self.gun thread HideGunParts(player getCurrentWeapon());
			self thread FireChickenGun(player);
			self.gun.angles = self getTagAngles("tag_weapon_left");
			self.gun linkto( self, "tag_weapon_left" );
		}
		wait 0.1;
	}
}

FireChickenGun(player)
{
	self notify("chicken_out");
	self endon("chicken_out");
	self endon("chicken_died");
	while(1)
	{
		TmpDist = 999999999;
		pTarget = undefined;
		foreach(zombie in level.bots)
		{
			if(zombie.pers["isAlive"] != "true")
			{
				continue;
			}
			if( !bulletTracePassed( self.origin+(0,0,30), zombie.origin+(0,0,70), false, self ) )
				continue;
				
			if(distancesquared(self.origin, zombie.origin) < TmpDist)
			{
				TmpDist = distancesquared(self.origin, zombie.origin);
				pTarget = zombie;
			}
		}
		if(isDefined(pTarget))
		{
			self scriptModelPlayAnim("pt_stand_shoot_auto");
			MagicBullet( self.chickenweapon, self.gun.origin, pTarget.origin, player );
			playFx(loadFX("muzzleflashes/aa12_flash_view"),self.gun.origin);
			if(self.chickenweapon == "mg4_mp")
				wait 0.07;
			if(self.chickenweapon == "coltanaconda_fmj_mp")
				wait 0.25;
			if(self.chickenweapon == "aa12_grip_mp")
				wait 0.15;
			if(self.chickenweapon == "deserteagle_akimbo_mp")
				wait 0.085;
			if(self.chickenweapon == "wa2000_thermal_mp")
				wait 0.3;
			wait 0.01;
			self scriptModelPlayAnim("pb_stand_alert");
		}
		if(!isDefined(pTarget))
		{
			wait 0.07;
		}
	}
}

KillChicken(player)
{
	wait 60;
	self notify("chicken_died");
	self thread AImod\animation::DeathRegular();
	self thread AImod\animation::DeathSound();
	self.crate1 delete();
	wait 2;
	self startRagDoll(1);
	wait 2;
	self delete();
	self.head delete();
	self.gun delete();
}

UpdateAngles(owner)
{
	self endon("chicken_died");
	while(1)
	{
		TmpDist = 999999999;
		pTarget = undefined;
		pAngle = "none";
		foreach(zombie in level.bots)
		{
			if( !bulletTracePassed( self.origin+(0,0,30), zombie.origin+(0,0,70), false, self ) )
                continue;
				
			if(distancesquared(self.origin, zombie.origin) < TmpDist)
			{
				TmpDist = distancesquared(self.origin, zombie.origin);
				pTarget = zombie;
				pAngle = "zombie";
			}
		}
		if(pAngle == "zombie")
		{
			movetoLoc = VectorToAngles( pTarget.origin - self.origin );
			self RotateTo((0,movetoLoc[1],0), 0.1);
		}
		wait 0.07;
	}
}

MoveChicken(player)
{
	self endon("chicken_died");
	while(1)
	{				
		if(self.origin != player.origin+(0,50,0))
		{
			self MoveTo(player.origin+(0,50,0),(distance(self.origin, player.origin) / 150));
		}
		wait 0.07;
	}
}