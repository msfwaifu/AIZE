#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include AImod\_OtherFunctions;
#include AImod\animation;

SniperStreak()
{
	self notifyOnPlayerCommand("[{+actionslot 2}]", "+actionslot 2");
	self waittill("[{+actionslot 2}]");	
	self thread AImod\_Mod::TextPopup2("Sub Machine Gun Bot Spawned!");
	level thread SpawnChicken(self, "ump45_mp");
}

MachineGunStreak()
{
	self notifyOnPlayerCommand("[{+actionslot 2}]", "+actionslot 2");
	self waittill("[{+actionslot 2}]");	
	self thread AImod\_Mod::TextPopup2("Machine Gun Bot Spawned!");
	level thread SpawnChicken(self, "rpd_mp");
}

SpawnChicken(player, weapon)
{
	if(weapon == "rpd_mp")
		level.chicken = spawn("script_model", player.origin+(0,50,0));
	else if(weapon == "ump45_mp")
		level.chicken = spawn("script_model", player.origin-(0,50,0));
	level.chicken setModel(AImod\_botUtil::FriendlyModels());
	level.chicken.angles = (0,0,0);
	level.chicken.allowmove = 1;
	level.chicken.team = player.team;
	level.chicken.head = spawn("script_model", level.chicken getTagOrigin( "j_spine4" ));
	level.chicken.head setModel(AImod\_botUtil::GetHeadSpawnModel( ));
	level.chicken.head.angles = (270,0,270);
	level.chicken.head linkto( level.chicken, "j_spine4" );
	level.chicken PlaySound( maps\mp\gametypes\_teams::getTeamVoicePrefix( "allies" ) + "mp_rsp_yessir" );
	level.chicken.gun = spawn("script_model", level.chicken getTagOrigin( "tag_weapon_left" ));
	level.chicken.gun setModel(GetWeaponModel(weapon, 0));
	level.chicken.gun thread HideGunParts(weapon);
	level.chicken.gun.angles = level.chicken getTagAngles("tag_weapon_left");
	level.chicken.gun linkto( level.chicken, "tag_weapon_left" );
	if(weapon == "rpd_mp")
		level.chicken RegisterAnimation("bot_rpd");
	else if(weapon == "ump45_mp")
		level.chicken RegisterAnimation("bot_ump45");
	level.chicken setAnim(level.chicken.animationidle, 0, "idle");
	level.chicken.shooting = 0;
	level.chicken.target = undefined;
	if(weapon == "rpd_mp")
		level.chicken thread FireChickenGun(player, weapon, 100);
	else if(weapon == "ump45_mp")
		level.chicken thread FireChickenGun(player, weapon, 32);
	level.chicken thread MoveChicken(player, weapon);
	level.chicken thread KillChicken(player);
}

SpawnChickenFriend(player)
{
	if(isDefined(player.chickenf))
		return;
	player.chickenf = spawn("script_model", player.origin-(0,50,0));
	player.chickenf setModel(player.model);
	player.chickenf.angles = (0,0,0);
	player.chickenf.allowmove = 1;
	player.chickenf.team = player.team;
	player.chickenf.head = spawn("script_model", player.chickenf getTagOrigin( "j_spine4" ));
	player.chickenf.head setModel(player.headmodel);
	player.chickenf.head.angles = (270,0,270);
	player.chickenf.head linkto( player.chickenf, "j_spine4", (0,0,0), (0,0,0));
	player.chickenf PlaySound( maps\mp\gametypes\_teams::getTeamVoicePrefix( "allies" ) + "mp_rsp_yessir" );
	player.chickenf.shooting = 0;
	player.chickenf.chickenweapon = undefined;
	player.chickenf.target = undefined;
	player.chickenf thread UpdateChickenGun(player);
	player.chickenf thread MoveChicken(player);
	player.chickenf thread KillChickenonDeath(player);
	player.chickenf ClampchickenToGround();
}

FireChickenFriendGun(player,weapon,clip)
{
	self notify("chicken_out");
	self endon("chicken_out");
	self endon("chicken_died");
	while(1)
	{
		for(i=0;i < clip;i++)
		{
			TmpDist = 999999999;
			pTarget = undefined;
			foreach(zombie in level.bots)
			{
				if(zombie.pers["isAlive"] != "true")
				{
					continue;
				}
				if(WeaponClass(weapon) == "spread")
				{
					if( !bulletTracePassed( self.gun.origin, zombie.origin+(0,0,70), false, self.gun ) || Distance( self.origin, zombie.origin ) >= 250)
					{
						continue;
					}
				}
				else
				{
					if( !bulletTracePassed( self.origin+(0,0,30), zombie.origin+(0,0,70), false, self ) )
					{
						continue;
					}
				}
				if(distancesquared(self.origin, zombie.origin) < TmpDist)
				{
					TmpDist = distancesquared(self.origin, zombie.origin);
					pTarget = zombie;
				}
			}
			movetoLoc = VectorToAngles( pTarget.origin - self.origin );
			self RotateTo((0,movetoLoc[1],0), 0.4);
			if(isDefined(pTarget) & self.allowmove == 1)
			{
				switch(randomInt(50))
				{
					case 10:
					self playSound(maps\mp\gametypes\_teams::getTeamVoicePrefix(self.team)+ "mp_stm_enemyspotted");
					break;
				}
				self.shooting = 1;
				self.origin = self.origin;
				if(player getStance() == "prone")
				{
					if(self.animtype != "prone_aim") self setAnim(self.animationaimprone, 0, "prone_aim");
				}
				else
				{
					if(self.animtype != "crouch_aim") self setAnim(self.animationaimcrouch, 0, "crouch_aim");
				}
				MagicBullet(weapon, self.gun getTagOrigin("tag_flash"), pTarget.origin+(randomInt(30),randomInt(30),randomIntRange(25,55)), player );
				if(!IsSubStr(weapon,"silencer"))
				{
					switch(randomInt(2))
					{
						case 0:
						playFxOnTag(level.ump45Flash, self.gun, "tag_flash");
						break;
						case 1:
						playFxOnTag(level.rpdFlash, self.gun, "tag_flash");
						break;
					}
				}
				if(WeaponClass(weapon) == "pistol")
					wait 0.3;
				else if(WeaponClass(weapon) == "smg")
					wait 0.076;
				else if(WeaponClass(weapon) == "rifle")
					wait 0.095;
				else if(WeaponClass(weapon) == "spread")
					wait 1;
				else if(WeaponClass(weapon) == "mg")
					wait 0.076;
				else if(WeaponClass(weapon) == "sniper")
					wait 0.5;
				else if(WeaponClass(weapon) == "rocketlauncher")
					wait 2;
				else
					wait 0.095;
			}
			else
			{
				self.shooting = 0;
				i--;
				wait 0.07;
			}
		}
		self.shooting = 1;
		self.gun HidePart("tag_clip");
		if(WeaponClass(weapon) == "pistol")
		{
			self playSound("weap_m9_reload_npc");
			wait 1.5;
		}
		else if(WeaponClass(weapon) == "smg")
		{
			self playSound("weap_miniuzi_reload_npc");
			wait 2;
		}
		else if(WeaponClass(weapon) == "rifle")
		{
			self playSound("weap_ak47_reload_npc");
			wait 3;
		}
		else if(WeaponClass(weapon) == "spread")
		{
			self playSound("weap_winch1200_reload_npc");
			wait 3;		
		}
		else if(WeaponClass(weapon) == "mg")
		{
			self playSound("weap_rpd_reload_npc");
			wait 6;
		}
		else if(WeaponClass(weapon) == "sniper")
		{
			self playSound("weap_m82_reload_npc");
			wait 4;
		}
		else
			wait 3;
		self.gun2 delete();
		self.gun showPart("tag_clip");
		self setAnim(self.animationidle, 0, "idle");
		self.shooting = 0;
	}
}

FireChickenGun(player,weapon,clip)
{
	self notify("chicken_out");
	self endon("chicken_out");
	self endon("chicken_died");
	while(1)
	{
		for(i=0;i < clip;i++)
		{
			TmpDist = 999999999;
			pTarget = undefined;
			foreach(zombie in level.bots)
			{
				if(zombie.pers["isAlive"] != "true")
				{
					continue;
				}
				if( !bulletTracePassed( self.origin+(0,0,30), zombie.origin+(0,0,70), false, self ))
				{
					continue;
				}
				if(distancesquared(self.origin, zombie.origin) < TmpDist)
				{
					TmpDist = distancesquared(self.origin, zombie.origin);
					pTarget = zombie;
				}
			}
			movetoLoc = VectorToAngles( pTarget.origin - self.origin );
			self RotateTo((0,movetoLoc[1],0), 0.4);
			if(isDefined(pTarget) & self.allowmove == 1)
			{
				switch(randomInt(50))
				{
					case 10:
					self playSound(maps\mp\gametypes\_teams::getTeamVoicePrefix(self.team)+ "mp_stm_enemyspotted");
					break;
				}
				self.shooting = 1;
				self.origin = self.origin;
				if(player getStance() == "prone")
				{
					if(self.animtype != "prone_aim") self setAnim(self.animationaimprone, 0, "prone_aim");
				}
				else
				{
					if(self.animtype != "crouch_aim") self setAnim(self.animationaimcrouch, 0, "crouch_aim");
				}
				if(weapon == "ump45_mp")
				{
					wait 0.085;
					MagicBullet(weapon, self.gun.origin, pTarget.origin+(randomInt(35),randomInt(35),randomInt(75)), player );
					playFxOnTag(level.ump45Flash, self.gun, "tag_flash");
				}
				if(weapon == "rpd_mp")
				{
					wait 0.085;
					MagicBullet(weapon, self.gun.origin, pTarget.origin+(randomInt(35),randomInt(35),randomInt(75)), player );
					playFxOnTag(level.rpdFlash, self.gun, "tag_flash");
				}
			}
			else
			{
				self.shooting = 0;
				i--;
				wait 0.07;
			}
		}
		self.shooting = 1;
		self.gun HidePart("tag_clip");
		if(WeaponClass(weapon) == "pistol")
		{
			self playSound("weap_m9_reload_npc");
			wait 1.5;
		}
		else if(WeaponClass(weapon) == "smg")
		{
			self playSound("weap_miniuzi_reload_npc");
			wait 2;
		}
		else if(WeaponClass(weapon) == "rifle")
		{
			self playSound("weap_m4carbine_reload_npc");
			wait 3;
		}
		else if(WeaponClass(weapon) == "spread")
		{
			self playSound("weap_winch1200_reload_npc");
			wait 6;		
		}
		else if(WeaponClass(weapon) == "mg")
		{
			self playSound("weap_rpd_reload_npc");
			wait 6;
		}
		else if(WeaponClass(weapon) == "sniper")
		{
			self playSound("weap_m82_reload_npc");
			wait 4;
		}
		else
			wait 3;
		self.gun showPart("tag_clip");
		self setAnim(self.animationidle, 0, "idle");
		self.shooting = 0;
	}
}

KillChicken(player)
{
	wait 120;
	self notify("chicken_died");
	self thread AImod\animation::DeathSound();
	self.gun delete();
	self startRagDoll(1);
	wait 0.01;
	PhysicsExplosionSphere( self.origin, 75, 75, randomIntRange(1,3) );
	wait 2;
	self delete();
	self.head delete();
	self.gun delete();
}

KillChickenonDeath(player)
{
	player waittill("death");
	self notify("chicken_died");
	self thread AImod\animation::DeathSound();
	self.gun delete();
	self startRagDoll(1);
	wait 0.01;
	PhysicsExplosionSphere( self.origin, 75, 75, randomIntRange(1,3) );
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
			if(zombie.pers["isAlive"] != "true")
			{
				continue;
			}
			if( !bulletTracePassed( self.origin+(0,0,30), zombie.origin+(0,0,70), false, self ) )
			{
                continue;
			}
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
			self RotateTo((0,movetoLoc[1],0), 0.4);
		}
		wait 1;
	}
}

MoveChicken(player)
{
	self endon("chicken_died");
	oldtarget = undefined;
	target = (0,0,0);
	distancetoStop = randomIntrange(45,150);
	while(1)
	{				
		while(self.shooting == 1)
			wait 0.01;
		switch(randomInt(1))
		{
			case 0:
			target = player.origin+(randomIntrange(35,85),randomIntrange(35,85),0);
			break;
		}
		oldtarget = target;
		if(Distance( self.origin, target ) >= 200)
		{
			if(player getStance() == "prone")
			{
				if(self.animtype != "prone_crawl")
				{
					self setAnim(self.animationpronecrawl, 0, "prone_crawl");
					switch(randomInt(10))
					{
						case 9:
						self playSound(maps\mp\gametypes\_teams::getTeamVoicePrefix(self.team)+ "mp_rsp_onmyway");
						break;
					}
				}
				self MoveTo(target,(distance(self.origin, target) / 45));
			}
			else
			{
				if(self.animtype != "run")
				{
					switch(randomInt(10))
					{
						case 9:
						self playSound(maps\mp\gametypes\_teams::getTeamVoicePrefix(self.team)+ "mp_rsp_onmyway");
						break;
					}
					self setAnim(self.animationrun, 0, "run");
				}
				self MoveTo(target,(distance(self.origin, target) / 130));
			}
			anglesToWaypoint = VectorToAngles( target - self.origin );
			self rotateTo((0,anglesToWaypoint[1],0), 0.4);
		}
		else if(Distance( self.origin, target ) <= 100)
		{
			self.origin = self.origin;
			if(player getStance() == "prone")
			{
				if(self.animtype != "idle_prone")
				{
					self setAnim(self.animationidleprone, 0, "idle_prone");
					self ClampchickenToGround();
					switch(randomInt(10))
					{
						case 9:
						self playSound(maps\mp\gametypes\_teams::getTeamVoicePrefix(self.team)+ "mp_stm_iminposition");
						break;
					}
				}
			}
			else
			{
				if(self.animtype != "idle")
				{
					self setAnim(self.animationidle, 0, "idle");
					self ClampchickenToGround();
					switch(randomInt(10))
					{
						case 9:
						self playSound(maps\mp\gametypes\_teams::getTeamVoicePrefix(self.team)+ "mp_stm_iminposition");
						break;
					}
				}
			}
		}
		wait 0.07;
	}
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
			if(WeaponClass(playergun) == "pistol")
			{
				self RegisterAnimation("bot_pistol");
				self.gun.angles = (90,0,0);
				self.gun linkto( self, "tag_weapon_right", (0,0,0), (0,0,0) );
			}
			else if(WeaponClass(playergun) == "mg")
			{
				self.gun.angles = self getTagAngles("tag_weapon_left");
				self.gun linkto( self, "tag_weapon_left" );
				self RegisterAnimation("bot_rpd");
			}
			else if(WeaponClass(playergun) == "rocketlauncher")
			{
				self.gun.angles = self getTagAngles("tag_weapon_left");
				self.gun linkto( self, "tag_weapon_left" );
				self RegisterAnimation("bot_rpg");
			}
			else if(WeaponClass(playergun) == "spread")
			{
				self.gun linkto( self, "tag_weapon_right", (0,0,0), (0,0,0) );
				self RegisterAnimation("bot_shotgun");
			}
			else
			{
				self.gun.angles = self getTagAngles("tag_weapon_left");
				self.gun linkto( self, "tag_weapon_left" );
				self RegisterAnimation("bot_ump45");
			}
			self setAnim(self.animationidle, 0, "idle");
			self thread FireChickenFriendGun(player, playergun, WeaponClipSize(playergun));
		}
		wait 0.1;
	}
}

ClampchickenToGround()
{
	trace = bulletTrace(self.origin + (0,0,50), self.origin + (0,0,-40), false, self);
	if(isdefined(trace["entity"]) && isDefined(trace["entity"].targetname) && trace["entity"].targetname == "bot")
		trace = bulletTrace(self.origin + (0,0,50), self.origin + (0,0,-40), false, trace["entity"]);
	self.origin = (trace["position"]);
	self.currentsurface = trace["surfacetype"];
	if(self.currentsurface == "none")
		self.currentsurface = "default";
}