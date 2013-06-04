#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\SolidStuff;
#include maps\mp\gametypes\MapSpawns;
#include AImod\_OtherFunctions;
#include AImod\_weapon;
#include AImod\_hud;

init()
{
	level.weapons[level.weapons.size] = "beretta_mp";
	level.weapons[level.weapons.size] = "usp_mp";
	level.weapons[level.weapons.size] = "deserteagle_mp";
	level.weapons[level.weapons.size] = "coltanaconda_mp";
	level.weapons[level.weapons.size] = "glock_mp";
	level.weapons[level.weapons.size] = "beretta393_mp";
	level.weapons[level.weapons.size] = "mp5k_mp";
	level.weapons[level.weapons.size] = "pp2000_mp";
	level.weapons[level.weapons.size] = "pp2000_eotech_mp";
	level.weapons[level.weapons.size] = "uzi_mp";
	level.weapons[level.weapons.size] = "p90_mp";
	level.weapons[level.weapons.size] = "kriss_mp";
	level.weapons[level.weapons.size] = "ump45_mp";
	level.weapons[level.weapons.size] = "tmp_mp";
	level.weapons[level.weapons.size] = "ak47_mp";
	level.weapons[level.weapons.size] = "m16_reflex_mp";
	level.weapons[level.weapons.size] = "m4_reflex_mp";
	level.weapons[level.weapons.size] = "fn2000_mp";
	level.weapons[level.weapons.size] = "masada_mp";
	level.weapons[level.weapons.size] = "famas_mp";
	level.weapons[level.weapons.size] = "fal_mp";
	level.weapons[level.weapons.size] = "scar_mp";
	level.weapons[level.weapons.size] = "tavor_mp";
	level.weapons[level.weapons.size] = "m79_mp";
	level.weapons[level.weapons.size] = "rpg_mp";
	level.weapons[level.weapons.size] = "at4_mp";
	level.weapons[level.weapons.size] = "javelin_mp";
	level.weapons[level.weapons.size] = "barrett_mp";
	level.weapons[level.weapons.size] = "wa2000_acog_mp";
	level.weapons[level.weapons.size] = "m21_acog_mp";
	level.weapons[level.weapons.size] = "cheytac_mp";
	level.weapons[level.weapons.size] = "ranger_mp";
	level.weapons[level.weapons.size] = "model1887_mp";
	level.weapons[level.weapons.size] = "striker_mp";
	level.weapons[level.weapons.size] = "aa12_mp";
	level.weapons[level.weapons.size] = "m1014_mp";
	level.weapons[level.weapons.size] = "spas12_mp";
	level.weapons[level.weapons.size] = "rpd_mp";
	level.weapons[level.weapons.size] = "sa80_mp";
	level.weapons[level.weapons.size] = "mg4_mp";
	level.weapons[level.weapons.size] = "m240_grip_mp";
	level.weapons[level.weapons.size] = "aug_mp";
	level.weapons[level.weapons.size] = "onemanarmy_mp";
	level.weapons[level.weapons.size] = "m4_silencer_mp";
	level.weapons[level.weapons.size] = "tmp_silencer_mp";
	level.weapons[level.weapons.size] = "deserteagle_tactical_mp";
	level.spawnlogic = [];
	level.boxicon = 0;
	level.box = 0;
	level.boxposition = 0;
	level.doCustomMap = 0;
	level.doorwait = 2;
	level thread mp\maps\mp_afghan::PrecacheAghan();
	level.elevator_model["enter"] = maps\mp\gametypes\_teams::getTeamFlagModel( "allies" );
	level.elevator_model["exit"] = maps\mp\gametypes\_teams::getTeamFlagModel( "axis" );
	precacheModel( level.elevator_model["enter"] );
	precacheModel( level.elevator_model["exit"] );
	precacheModel( "com_locker_double" );
	precacheModel( "com_teddy_bear" );
	wait 0.001;
	switch(getDvar("mapname"))
	{
		case "mp_afghan":
		/** Afghan **/ 
		switch(randomInt(2))
		{
			case 0:
			level thread Afghan();
			level.edit = 0;
			level thread mp\maps\mp_afghan::WaypointInit();
			break;
			case 1:
			level thread Afghan2();
			level.edit = 1;
			level thread mp\maps\mp_afghan::Afghan2Init();
			break;
		}
		break;
		case "mp_boneyard":
		/** Scrapyard **/ 
		level thread Scrapyard();
		level thread mp\maps\mp_scrapyard::WaypointInit();
		break;
		case "mp_brecourt":
		/** Wasteland **/ 
		level thread Wasteland();
		level thread mp\maps\mp_wasteland1::Init();
		level thread mp\maps\mp_wasteland1::WaypointInit();
		break;
		case "mp_checkpoint":
		/** Karachi **/ 
		level thread Karachi();
		break;
		case "mp_derail":
		/** Derail **/ 
		switch(randomInt(2))
		{
			case 0:
			level thread Derail();
			level.edit = 0;
			level thread mp\maps\mp_derail::WaypointInit();
			break;
			case 1:
			level thread Derail2();
			level.edit = 1;
			break;
		}
		break;
		case "mp_estate":
		/** Estate **/ 
		level thread Estate();
		level.power = 1;
		break;
		case "mp_favela":
		/** Favela **/ 
		switch(randomInt(3))
		{
			case 0:
			level thread Favela();
			level.edit = 0;
			break;
			case 1:
			level thread Favela2();
			level.edit = 1;
			break;
			case 2:
			level thread Favela3();
			level.edit = 2;
			break;
		}
		break;
		case "mp_highrise":
		/** HighRise **/ 
		switch(randomInt(2))
		{
			case 0: //High Hilton
			level thread HighRise();
			level.edit = 0;
			level thread mp\maps\mp_highrise::WaypointInit();
			break;
			case 1: //Infestation
			level thread HighRise2();
			level thread mp\maps\mp_highrise2::Init();
			level.edit = 1;
			break;
		}
		break;
		case "mp_nightshift":
		/** Skidrow **/
		switch(randomInt(3))
		{
			case 0:
			level thread Skidrow();
			level thread mp\maps\mp_skidrow::WaypointInit();
			level.edit = 0;
			break;
			case 1:
			level thread Skidrow2();
			level thread mp\maps\mp_skidrow2::Init();
			level thread mp\maps\mp_skidrow2::WaypointInit();
			level.edit = 1;
			break;
			case 2:
			level thread Skidrow3();
			level.edit = 2;
			break;
		}
		break;
		case "mp_invasion":
		/** Invasion **/ 
		level thread Invasion();
		level thread mp\maps\mp_invasion::Init();
		level thread mp\maps\mp_invasion::WaypointInit();
		break;
		case "mp_quarry":
		/** Quarry **/ 
		level thread Quarry();
		level thread mp\maps\mp_quarry::Init();
		level thread mp\maps\mp_quarry::WaypointInit();
		break;
		case "mp_rundown":
		/** Rundown **/ 
		level thread Rundown();
		level thread mp\maps\mp_rundown::Init();
		level thread mp\maps\mp_rundown::WaypointInit();
		break;
		case "mp_rust":
		/** Rust **/ 
		level thread Rust();
		level thread mp\maps\mp_rust::Init();
		level thread mp\maps\mp_rust::WaypointInit();
		break;
		case "mp_subbase":
		/** SubBase **/ 
		level thread SubBase();
		level thread mp\maps\mp_subbase::Init();
		level.power = 1;
		break;
		case "mp_terminal":
		/** Terminal **/ 
		level thread Terminal();
		level thread mp\maps\mp_terminal1::Init();
		level thread mp\maps\mp_terminal1::WaypointInit();
		break;
		case "mp_underpass":
		/** Underpass **/ 
		level thread Underpass();
		level thread mp\maps\mp_underpass::WaypointInit();
		break;
		case "mp_overgrown":
		/** Overgrown **/ 
		level thread Overgrown();
		level.power = 1;
		break;
		case "mp_trailerpark":
		/** TrailerPark **/ 
		level thread Trailerpark();
		level thread mp\maps\mp_trailerpark::WaypointInit();
		break;
		case "mp_compact":
		/** Salvage **/ 
		level thread Salvage();
		level thread mp\maps\mp_salvage::WaypointInit();
		break;
		case "mp_strike":
		/** Strike **/ 
		level thread Strike();
		break;
		case "mp_complex":
		/** Bailout **/
		level thread Bailout();
		level thread mp\maps\mp_bailout::WaypointInit();
		break;
		case "mp_abandon":
		/** Carnival **/
		level thread Carnival();
		level thread mp\maps\mp_carnival::WaypointInit();
		break;
		case "mp_vacant":
		/** Vacant **/
		level thread Vacant();
		level thread mp\maps\mp_vacant::WaypointInit();
		break;
		case "mp_storm":
		/** Storm **/
		level thread Storm();
		level thread mp\maps\mp_storm::WaypointInit();
		break;
		case "mp_fuel2":
		/** Fuel **/
		level thread Fuel();
		break;
		case "mp_crash":
		/** Crash **/
		level thread Crash();
		level thread mp\maps\mp_crash::WaypointInit();
		level.power = 1;
		break;
		case "estate":
		/** Safehouse **/
		level thread Safehouse();
		level thread mp\maps\safehouse::WaypointInit();
		break;
		case "co_hunted":
		/** Village **/
		level thread Village();
		break;
		case "arcadia":
		/** Arcadia **/
		level thread arcadia();
		break;
		case "oilrig":
		/** Oilrig **/
		level thread Oilrig();
		break;
		case "mp_nuked":
		/** Nuketown **/
		level thread Nuketown();
		level thread mp\maps\mp_nuked::Init();
		level thread mp\maps\mp_nuked::WaypointInit();
		break;
		case "invasion":
		/** BurgerTown **/
		level thread BurgerTown();
		level thread mp\maps\invasion::Init();
		level thread mp\maps\invasion::WaypointInit();
		break;
	}
}

RandomWeapon(pos, angle)
{
	level.block = spawn("script_model", pos);
	level.randomweaponbox = level.block;
	level.block setModel("com_plasticcase_friendly");
	level.block.angles = angle;
	level.block Solid();
	level.block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	level.block.headIcon = newHudElem();
	level.block.headIcon.x = level.block.origin[0];
	level.block.headIcon.y = level.block.origin[1];
	level.block.headIcon.z = level.block.origin[2] + 60;
	level.block.headIcon.alpha = 0.85;
	level.block.headIcon setShader( "weapon_m16a4", 10,30 );
	level.block.headIcon setWaypoint( true, true, false );
	level.block thread RandomWeaponThink(pos, angle);
	if(level.boxicon == 0)
	{
		curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
		objective_add( curObjID, "invisible", (0,0,0) );
		objective_position( curObjID, level.block.origin );
		objective_state( curObjID, "active" );
		objective_team( curObjID, "allies" );
		objective_icon( curObjID, "weapon_m16a4" );
		level thread RandomWeaponUpdateIconPosition(curObjID);
		level.boxicon = 1;
	}
	level.trigger = spawn( "trigger_radius", pos, 0, 50, 85 );
	level.trigger.angles = angle;
	wait 0.01;
	level.trigger thread RandomWeaponThink(pos, angle);
	level.block thread RandomBoxDeleteOnWeaponNoTake();
	level.block thread BoxDestroy();
}

RandomWeaponUpdateIconPosition(curObjID)
{
	while(1)
	{
		objective_position( curObjID, level.randomweaponbox.origin );
		wait 0.05;
	}
}

BoxDestroy()
{
	while(1)
    {
        level waittill ("box_delete");
        {
		    self delete();
			self.headIcon destroy();
			self.trigger delete();
			level.wep delete();
        }
	    wait 0.1;
	}
}

RandomWeaponThink(pos, angle)
{
	self endon("disconnect");
	self endon("box");
	level endon("endrandom");
	while(1)
	{
		self waittill( "trigger", player );
		if(Distance(pos, Player.origin) <= 75)
		{
			Player setLowerMessage("activate", "Hold ^3[{+activate}]^7 for a Random Weapon [^2$^3950^7]" );
		}
		if(Distance(pos, Player.origin) > 50)
		{
			Player ClearLowerMessage("activate", 1);
		}
		if(Distance(pos, Player.origin) <= 75 && player.money >= 950 && player.pers["team"] == "allies" && player useButtonPressed() && player.notusebox == 1)
		{
			player ClearLowerMessage("activate", 1);
			player iPrintlnbold("^1You may not use the box at this time!");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player.money >= 950 && player.pers["team"] == "allies" && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player.money -= 950;
			player notify("MONEY");
			player thread maps\mp\gametypes\_rank::scorePopup( -950, 0, (1,0,0), 1 );
			player thread AImod\_Mod::TextPopup( "Random Weapon!" );
			if(getDvarInt("z_dedicated") == 0)	
				self playSound("mp_bonus_start");
			level.box += 1;
			level.wep = spawn("script_model", pos+(0,5,0));
			level.wep.angles = angle;
			level.wep MoveTo(level.wep.origin+(0,0,40), 3);
			level thread RandomWeaponFast();
			wait 2;
			level notify("box_fast");
			wait 0.12;
			level thread RandomWeaponMedium();
			wait 1;
			level notify("box_medium");
			wait 0.2;
			level thread RandomWeaponSlow();
			wait 0.3;
			level notify("box_slow");
			wait 0.5;
			player thread giveWeaponFunc(pos);			
		}
		else if(Distance(pos, Player.origin) <= 75 && player.money <= 950 && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player iPrintln("^1Not enough money for a Random Weapon Need ^2$^3950!");
			wait 1;
		}
		wait 0.01;
	}
}

RandomWeaponFast()
{
	level endon("box_fast");
	while(1)
	{
		level.boxWeapon = level.weapons[RandomInt( 65535 ) % level.weapons.size];
		level.wep setModel(GetWeaponModel(level.boxWeapon, 0));
		level.wep thread HideGunParts(level.boxWeapon);
		wait 0.12;
	}
}

RandomWeaponMedium()
{
	level endon("box_medium");
	while(1)
	{
		level.boxWeapon = level.weapons[RandomInt( 65535 ) % level.weapons.size];
		if(level.boxWeapon == "pp2000_eotech_mp")
			level.wep setModel(GetWeaponModel(level.boxWeapon, 6));
		else if(level.boxWeapon == "tmp_silencer_mp")
			level.wep setModel(GetWeaponModel(level.boxWeapon, 8));
		else
			level.wep setModel(GetWeaponModel(level.boxWeapon, 0));
		level.wep thread HideGunParts(level.boxWeapon);
		wait 0.2;
	}
}

RandomWeaponSlow()
{
	level endon("box_slow");
	while(1)
	{
		level.boxWeapon = level.weapons[RandomInt( 65535 ) % level.weapons.size];
		if(level.boxWeapon == "pp2000_eotech_mp")
			level.wep setModel(GetWeaponModel(level.boxWeapon, 6));
		else if(level.boxWeapon == "tmp_silencer_mp")
			level.wep setModel(GetWeaponModel(level.boxWeapon, 8));
		else
			level.wep setModel(GetWeaponModel(level.boxWeapon, 0));
		level.wep thread HideGunParts(level.boxWeapon);
		wait 0.3;
	}
}

RandomWeaponSlowest()
{
	level endon("box_slowest");
	while(1)
	{
		level.boxWeapon = level.weapons[RandomInt( level.weapons.size )];
		if(level.boxWeapon == "pp2000_eotech_mp")
			level.wep setModel(GetWeaponModel(level.boxWeapon, 6));
		else if(level.boxWeapon == "tmp_silencer_mp")
			level.wep setModel(GetWeaponModel(level.boxWeapon, 8));
		else
			level.wep setModel(GetWeaponModel(level.boxWeapon, 0));
		level.wep thread HideGunParts(level.boxWeapon);
		wait 0.5;
	}
}

giveWeaponFunc(pos)
{
	level endon("disconnect");
	level endon("box");
	level notify("endrandom");
	level.boxWeapon = level.weapons[RandomInt( level.weapons.size )];
	if(level.boxWeapon == "pp2000_eotech_mp")
		level.wep setModel(GetWeaponModel(level.boxWeapon, 6));
	else if(level.boxWeapon == "tmp_silencer_mp")
		level.wep setModel(GetWeaponModel(level.boxWeapon, 8));
	else
		level.wep setModel(GetWeaponModel(level.boxWeapon, 0));
	level.wep thread HideGunParts(level.boxWeapon);
	while(1)
	{
		if(Distance(pos, self.origin) <= 75 && self.notusebox == 0)
		{
			self setLowerMessage("trade", "Hold ^3[{+activate}]^7 to Trade Weapons" );
		}
		else if(Distance(pos, self.origin) <= 75 && self.notusebox == 1)
		{
			self setLowerMessage("trade", "^1Glitcher get out of here");
		}
		else
		{
			if(Distance(pos, self.origin) >50) self ClearLowerMessage("trade", 1);
		}
		if(Distance(pos, self.origin) <= 75 && self getAllWeapons(level.boxWeapon) == false && self.weapons == 0 && self useButtonPressed() && self.notusebox == 0)
		{
			self ClearLowerMessage("trade", 1);
			self notify("newWeapon");
			wait 0.1;
			if(level.boxWeapon == "pp2000_eotech_mp")
				self _giveWeapon(level.boxWeapon, 6);
			else if(level.boxWeapon == "tmp_silencer_mp")
				self _giveWeapon(level.boxWeapon, 8);
			else
				self _giveWeapon(level.boxWeapon, 0);
			self switchToWeapon(level.boxWeapon);
			self giveMaxAmmo(level.boxWeapon);
			self.weapons = 1;
			wait 0.01;
			level notify("stopspawner");
			level.wep delete();
			level thread RandomBoxDeleteOnWeaponTake();
			level notify("box");
		}
		else if(Distance(pos, self.origin) <= 75 && self getAllWeapons(level.boxWeapon) == true && self.weapons == 0 && self useButtonPressed() && self.notusebox == 0)
		{
			self ClearLowerMessage("trade", 1);
			self notify("newWeapon");
			self switchToWeapon(level.boxWeapon);
			self giveMaxAmmo(level.boxWeapon);
			wait 0.01;
			level notify("stopspawner");
			level.wep delete();
			level thread RandomBoxDeleteOnWeaponTake();
			level notify("box");
		}
		if(Distance(pos, self.origin) <= 75 && self getAllWeapons(level.boxweapon) == false && self.weapons == 1 && self useButtonPressed() && self.notusebox == 0)
		{
			self ClearLowerMessage("trade", 1);
			self notify("newWeapon");
			self takeWeapon(self getCurrentWeapon());
			wait 0.1;
			if(level.boxWeapon == "pp2000_eotech_mp")
				self _giveWeapon(level.boxWeapon, 6);
			else if(level.boxWeapon == "tmp_silencer_mp")
				self _giveWeapon(level.boxWeapon, 8);
			else
				self _giveWeapon(level.boxWeapon, 0);
			self switchToWeapon(level.boxWeapon);
			self giveMaxAmmo(level.boxWeapon);
			wait 0.01;
			level notify("stopspawner");
			level.wep delete();
			level thread RandomBoxDeleteOnWeaponTake();
			level notify("box");
		}
		else if(Distance(pos, self.origin) <= 75 && self getAllWeapons(level.boxweapon) == true && self.weapons == 1 && self useButtonPressed() && self.notusebox == 0)
		{
			self ClearLowerMessage("trade", 1);
			self notify("newWeapon");
			self switchToWeapon(level.boxWeapon);
			self giveMaxAmmo(level.boxWeapon);
			wait 0.01;
			level notify("stopspawner");
			level.wep delete();
			level thread RandomBoxDeleteOnWeaponTake();
			level notify("box");
		}
		else if(Distance(pos, self.origin) <= 75 && self useButtonPressed() && self.notusebox == 0)
		{
			self iPrintlnbold("trade", "^1Trying to glitch eh get out of here FU");
		}
		wait 0.01;
	}
}

Upgrade(pos, angle, gunspawn)
{
	block = spawn("script_model", pos + (0, 0, -15) );
	block setModel("com_plasticcase_beige_big");
	block.angles = angle;
	block Solid();
	block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	block2 = spawn("script_model", pos + (0,0,30));
	block2 setModel("com_plasticcase_friendly");
	block2.angles = angle;
	block2 Solid();
	block2 hide();
	block2 CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	block.headIcon = newHudElem();
	block.headIcon.x = block.origin[0];
	block.headIcon.y = block.origin[1];
	block.headIcon.z = block.origin[2] + 50;
	block.headIcon.alpha = 0.85;
	block.headIcon setShader( "cardicon_juggernaut_1", 10,10 );
	block.headIcon setWaypoint( true, true, false );
	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
	objective_add( curObjID, "invisible", (0,0,0) );
	objective_position( curObjID, block.origin );
	objective_state( curObjID, "active" );
	objective_team( curObjID, "allies" );
	objective_icon( curObjID, "cardicon_juggernaut_1" );
	trigger = spawn( "trigger_radius", pos, 0, 75, 50 );
	trigger.angles = angle;
	trigger thread UpgradeThink(pos, angle, gunspawn);
	wait 0.01;
}

UpgradeThink(pos, angle, gunspawn)
{
	self endon("disconnect");
	while(1)
	{
		self waittill( "trigger", player );
		if(Distance(pos, Player.origin) <= 75 && level.power == 0)
		{
			Player setLowerMessage("activate", "Power needs to be activated" );
		}
		else if(Distance(pos, Player.origin) <= 75)
		{
			Player setLowerMessage("activate", "Hold ^3[{+activate}]^7 to Upgrade your ^1Current Weapon^7 [^2$^45000^7]" );
		}
		if(Distance(pos, Player.origin) >=50)
		{
			Player ClearLowerMessage("activate", 1);
		}
		if(Distance(pos, Player.origin) <= 75 && player.pers["team"] == "allies" && level.power == 0 && player useButtonPressed())
		{
			player iPrintln("^1Power needs to be activated!");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player getCurrentWeapon() == level.weapons && player.money <= 5000 && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player iPrintln("You do not have enough money for Weapon Upgrade Need $5000!");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player getCurrentWeapon() == level.weapons && player.money >= 5000 && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player.money -= 5000;
			player notify("MONEY");
			player thread maps\mp\gametypes\_rank::scorePopup( -5000, 0, (1,0,0), 1 );
			player thread AImod\_Mod::TextPopup("Weapon Upgraded!");
			player.gun = player getCurrentWeapon();
			player.gunup = player.gun;
			level.upgradeweapon = spawn("script_model", player.origin+(0,0,50));
			if(player.gunup == "pp2000_eotech_mp")
				level.upgradeweapon setModel(GetWeaponModel(player.gunup, 6));
			else if(player.gunup == "tmp_silencer_mp")
				level.upgradeweapon setModel(GetWeaponModel(player.gunup, 8));
			else
				level.upgradeweapon setModel(GetWeaponModel(player.gunup, 0));
			level.upgradeweapon.angles = angle;
			level.upgradeweapon thread HideGunParts(player.gunup);
			player takeWeapon(player getCurrentWeapon());
			player switchtoRandomWeapon();
			wait 0.4;
			player playSound( maps\mp\gametypes\_teams::getTeamVoicePrefix( player.team )+"mp_rsp_comeon" );
			level.upgradeweapon MoveTo(pos+(0,0,10), 2);
			wait 2;
			level.upgradeweapon delete();
			player maps\mp\gametypes\Upgrade::giveUpgradedWeapon(pos, angle, player.gunup);
			wait 1;
			player ClearLowerMessage("upgradetrade", 1);
		}
		wait 0.01;
	}
}

Ammo(pos, angle)
{
	block = spawn("script_model", pos );
	block setModel("com_plasticcase_friendly");
	block.angles = angle;
	block Solid();
	block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	laptop = spawn("script_model", pos+(0,0,17) );
	laptop setModel("com_laptop_2_open");
	laptop.angles = angle;
	laptop Solid();
	laptop thread rotateLaptop();
	block.headIcon = newHudElem();
	block.headIcon.x = block.origin[0];
	block.headIcon.y = block.origin[1];
	block.headIcon.z = block.origin[2] + 50;
	block.headIcon.alpha = 0.85;
	block.headIcon setShader( "waypoint_ammo_friendly", 10,10 );
	block.headIcon setWaypoint( true, true, false );
	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
	objective_add( curObjID, "invisible", (0,0,0) );
	objective_position( curObjID, block.origin );
	objective_state( curObjID, "active" );
	objective_team( curObjID, "allies" );
	objective_icon( curObjID, "waypoint_ammo_friendly" );
	trigger = spawn( "trigger_radius", pos, 0, 75, 50 );
	trigger.angles = angle;
	trigger thread AmmoThink(pos);
	wait 0.01;
}

AmmoThink(pos, angle)
{
	self endon("disconnect");
	while(1)
	{
		self waittill( "trigger", player );
		if(Distance(pos, Player.origin) <= 75)
		{
			Player setLowerMessage("activate", "Hold ^3[{+activate}]^7 for Ammo[^2$^34500^7]" );
		}
		if(Distance(pos, Player.origin) > 50)
		{
			Player ClearLowerMessage("activate", 1);
		}
		if(Distance(pos, Player.origin) <= 75 && player.money >= 4500 && player.pers["team"] == "allies" && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player.money -= 4500;
			player notify("MONEY");
			player thread maps\mp\gametypes\_rank::scorePopup( -4500, 0, (1,0,0), 1 );
			player thread AImod\_Mod::TextPopup( "Ammo!" );
			weaponList = player GetWeaponsListAll();
			foreach ( weaponName in weaponList )
			{
				if(weaponName == "beretta_akimbo_xmags_mp")
				{
					continue;
				}	
				player giveMaxAmmo( weaponName );
				player setweaponammoclip("frag_grenade_mp", 4); //we'll set it to 2.
			}		
			level notify("boxend");
			player playLocalSound( "ammo_crate_use" );
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player.money <= 4500 && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player iPrintln("^1Not enough money for Ammo Need $4500!");
			wait 1;
		}
		wait 0.01;
	}
}

KillstreakBox(pos, angle)
{
	block = spawn("script_model", pos );
	block setModel("com_plasticcase_friendly");
	block.angles = angle;
	block Solid();
	block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	laptop = spawn("script_model", pos+(0,0,17) );
	laptop setModel("com_laptop_2_open");
	laptop.angles = angle;
	laptop Solid();
	laptop thread rotateLaptop();
	block.headIcon = newHudElem();
	block.headIcon.x = block.origin[0];
	block.headIcon.y = block.origin[1];
	block.headIcon.z = block.origin[2] + 50;
	block.headIcon.alpha = 0.85;
	block.headIcon setShader( "cardicon_harrier", 10,10 );
	block.headIcon setWaypoint( true, true, false );
	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
	objective_add( curObjID, "invisible", (0,0,0) );
	objective_position( curObjID, block.origin );
	objective_state( curObjID, "active" );
	objective_team( curObjID, "allies" );
	objective_icon( curObjID, "cardicon_harrier" );
	trigger = spawn( "trigger_radius", pos, 0, 75, 50 );
	trigger.angles = angle;
	trigger thread KillstreakBoxThink(pos);
	wait 0.01;
}

KillstreakBoxThink(pos, angle)
{
	self endon("disconnect");
	while(1)
	{
		self waittill( "trigger", player );
		if(Distance(pos, Player.origin) <= 75)
		{
			Player setLowerMessage("activate", "Hold ^3[{+activate}]^7 for a Random Killstreak[^5Need 200 Bonus Points^7]" );
		}
		if(Distance(pos, Player.origin) > 50)
		{
			Player ClearLowerMessage("activate", 1);
		}
		if(Distance(pos, Player.origin) <= 75 && player.bonus >= 200 && player.pers["team"] == "allies" && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player.bonus -= 200;
			player notify("BONUS");
			player thread KillStreakRandom();
			player thread maps\mp\gametypes\_rank::scorePopup( -200, 0, (1,0,0), 1 );	
			level notify("boxend");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player.bonus <= 200 && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player iPrintln("^1Not enough money for Random Killstreak Need 200 Bonus Points!");
			wait 1;
		}
		wait 0.01;
	}
}

KillStreakRandom()
{
	self endon("disconnect");
	switch(randomInt(4))
	{
		case 0: Announcement(self.name + " Bought ^3Predator Missile!");
		self maps\mp\killstreaks\_killstreaks::giveKillstreak( "predator_missile", true );
		self maps\mp\gametypes\_hud_message::killstreakSplashNotify( "predator_missile_pickup");
		break;
		case 1: Announcement(self.name + " Bought an ^3Airstrike");
		self maps\mp\killstreaks\_killstreaks::giveKillstreak( "uav", true );
		wait 3.0;
		self maps\mp\gametypes\_hud_message::killstreakSplashNotify( "airstrike");
		break;
		case 2: 
		Announcement(self.name + " Bought a Super Airstrike");
		self maps\mp\killstreaks\_killstreaks::giveKillstreak( "counter_uav", true );
		wait 3.0;
		self maps\mp\gametypes\_hud_message::killstreakSplashNotify( "ac130");
		break;
		case 3: 
		Announcement(self.name + " Bought a Sentry Gun");
		self maps\mp\killstreaks\_killstreaks::giveKillstreak( "sentry", true );
		wait 3.0;
		self maps\mp\gametypes\_hud_message::killstreakSplashNotify( "sentry");
		break;
	}
}

Gambler(pos, angle)
{
	block = spawn("script_model", pos );
	block setModel("com_plasticcase_friendly");
	block.angles = angle;
	block Solid();
	laptop = spawn("script_model", pos+(0,0,17) );
	laptop setModel("com_laptop_2_open");
	laptop.angles = angle;
	laptop Solid();
	laptop thread rotateLaptop();
	block.headIcon = newHudElem();
	block.headIcon.x = block.origin[0];
	block.headIcon.y = block.origin[1];
	block.headIcon.z = block.origin[2] + 50;
	block.headIcon.alpha = 0.85;
	block.headIcon setShader( "cardicon_8ball", 10,10 );
	block.headIcon setWaypoint( true, true, false );
	block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
	objective_add( curObjID, "invisible", (0,0,0) );
	objective_position( curObjID, block.origin );
	objective_state( curObjID, "active" );
	objective_team( curObjID, "allies" );
	objective_icon( curObjID, "cardicon_8ball" );
    trigger = spawn( "trigger_radius", pos, 0, 75, 50 );
    trigger.angles = angle;
	trigger thread GamblerThink(pos, angle, laptop);
    wait 0.01;
}

rotateLaptop()
{
	for(;;)
	{
		self rotateyaw(-360,7);
		wait 7;
	}
}

GamblerThink(pos, angle, laptop)
{
	self endon("disconnect");
	while(1)
	{
		self waittill( "trigger", player );
		if(Distance(pos, Player.origin) <= 75)
		{
			Player setLowerMessage("activate", "Hold ^3[{+activate}]^7 for Gambler [^2$^31000^7]" );
		}
		if(Distance(pos, Player.origin) >= 50)
		{
			Player ClearLowerMessage("activate", 1);
		}
		if(Distance(pos, Player.origin) <= 75 && player.money >= 1000 && player.gambler == 0 && player.pers["team"] == "allies" && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player.money -= 1000;
			player notify("MONEY");
			player thread maps\mp\gametypes\_rank::scorePopup( -1000, 0, (1,0,0), 1 );
			player thread AImod\_Mod::TextPopup( "Gambler!" );
			player.gambler = 1;
			laptop MoveTo(laptop.origin+(0,0,30), 2);
			player iPrintlnBold(" ^2Your results will show in 10 seconds");
			wait 1.0;
			player iPrintlnBold(" ^29");
			wait 1.0;
			player iPrintlnBold(" ^28");
			wait 1.0;
			player iPrintlnBold(" ^27");
			wait 1.0;
			player iPrintlnBold(" ^26");
			wait 1.0;
			player iPrintlnBold(" ^25");
			wait 1.0;
			player iPrintlnBold(" ^24");
			wait 1.0;
			player iPrintlnBold(" ^23");
			wait 1.0;
			laptop MoveTo(laptop.origin-(0,0,30), 2);
			player iPrintlnBold(" ^22");
			wait 1.0;
			player iPrintlnBold(" ^21");
			wait 1.0;
			player thread MoneyGambler();
			player playLocalSound("mp_bonus_end");
			level notify("boxend");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player.money <= 1000 && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player iPrintln("^1Not enough money for Gambler Need $1000!");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player.money >= 1000 && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player iPrintln("^1You may only use the gambler once per round!");
			wait 1;
		}
		wait 0.01;
	}
}

SpeedReload(pos, angle)
{
	block = spawn("script_model", pos+(0,0,50) );
	block setModel("com_plasticcase_friendly");
	block.angles = angle;
	block Solid();
	block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	block moveto(pos,3);
	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
	objective_add( curObjID, "invisible", (0,0,0) );
	objective_position( curObjID, block.origin );
	objective_state( curObjID, "active" );
	objective_team( curObjID, "allies" );
	objective_icon( curObjID, "specialty_fastreload_upgrade" );
    trigger = spawn( "trigger_radius", pos, 0, 75, 50 );
    trigger.angles = angle;
	trigger thread SpeedReloadThink(pos);
    wait 0.01;
}

SpeedReloadThink(pos, angle)
{
	self endon("disconnect");
	while(1)
	{
		self waittill( "trigger", player );
		if(Distance(pos, Player.origin) <= 75 && level.power == 0)
		{
			Player setLowerMessage("activate", "Power needs to be activated" );
		}
		if(Distance(pos, Player.origin) <= 75 && level.power == 1)
		{
			Player setLowerMessage("activate", "Hold ^3[{+activate}]^7 for Speed Cola [^2$^33000^7]" );
		}
		if(Distance(pos, Player.origin) >50)
		{
			Player ClearLowerMessage("activate", 1);
		}
		if(Distance(pos, Player.origin) <= 75 && player.pers["team"] == "allies" && level.power == 0 && player useButtonPressed())
		{
			player iPrintln("^1Power needs to be activated!");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player.money >= 0 && player.speedreload == 1 && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player iPrintln("^1You have already bought Speed Cola!");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player.money >= 3000 && player.pers["team"] == "allies" && level.power == 1 && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player.money -= 3000;
			player notify("MONEY");
			player thread maps\mp\gametypes\_rank::scorePopup( -3000, 0, (0,1,0), 1 );
			player thread AImod\_Mod::TextPopup( "Speed Reload!" );
			player _setPerk("specialty_fastreload");
			player _setPerk("specialty_quickdraw");
			player.speedreload = 1;
			player.zombieperks += 1;
			wait 0.1;
			player thread PerkHud( "specialty_fastreload_upgrade", (0.3,0.9,0.3), "Reload Lightning Fast");
			level notify("boxend");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player.money <= 3000 && level.power == 1 && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player iPrintln("^1Not enough money for Speed Cola Need $3000!");
			wait 1;
		}
		wait 0.01;
	}
}

DoubleTap(pos, angle)
{
	block = spawn("script_model", pos+(0,0,50) );
	block setModel("com_plasticcase_friendly");
	block.angles = angle;
	block Solid();
	block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	block moveto(pos,3);
	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
	objective_add( curObjID, "invisible", (0,0,0) );
	objective_position( curObjID, block.origin );
	objective_state( curObjID, "active" );
	objective_team( curObjID, "allies" );
	objective_icon( curObjID, "cardicon_doubletap" );
    trigger = spawn( "trigger_radius", pos, 0, 75, 50 );
    trigger.angles = angle;
	trigger thread DoubleTapThink(pos);
    wait 0.01;
}

DoubleTapThink(pos, angle)
{
	self endon("disconnect");
	while(1)
	{
		self waittill( "trigger", player );
		if(Distance(pos, Player.origin) <= 75 && level.power == 0)
		{
			Player setLowerMessage("activate", "Power needs to be activated" );
		}
		else if(Distance(pos, Player.origin) <= 75)
		{
			Player setLowerMessage("activate", "Hold ^3[{+activate}]^7 for Double Tap 2.0 [^2$^32000^7]" );
		}
		if(Distance(pos, Player.origin) >50)
		{
			Player ClearLowerMessage("activate", 1);
		}
		if(Distance(pos, Player.origin) <= 75 && player.pers["team"] == "allies" && level.power == 0 && player useButtonPressed())
		{
			player iPrintln("^1Power needs to be activated!");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player.money <= 2000 && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player iPrintln("^1Not enough money for Double Tap 2.0 Need $2000!");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player.money >= 2000 && player.stoppingpower == 1 && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player iPrintln("^1You have already bought Double Tap 2.0!");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player.money >= 2000 && player.pers["team"] == "allies" && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player.money -= 2000;
			player notify("MONEY");
			player thread maps\mp\gametypes\_rank::scorePopup( -2000, 0, (1,0,0), 1 );
			player thread AImod\_Mod::TextPopup( "Double Tap!" );
			player.stoppingpower = 1;
			player.zombieperks += 1;
			wait 0.1;
			player thread PerkHud( "cardicon_doubletap", (0.9,0.5,0.2), "Doubles the Damage of all Guns" );
			level notify("boxend");
			wait 1;
		}
		wait 0.01;
	}
}

LastStandPro(pos, angle)
{
	block = spawn("script_model", pos+(0,0,50) );
	block setModel("com_plasticcase_friendly");
	block.angles = angle;
	block Solid();
	block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	block moveto(pos,3);
	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
	objective_add( curObjID, "invisible", (0,0,0) );
	objective_position( curObjID, block.origin );
	objective_state( curObjID, "active" );
	objective_team( curObjID, "allies" );
	objective_icon( curObjID, "specialty_pistoldeath_upgrade" );
	trigger = spawn( "trigger_radius", pos, 0, 75, 50 );
	trigger.angles = angle;
	trigger thread LastStandProThink(pos);
	wait 0.01;
}

LastStandProThink(pos, angle)
{
	self endon("disconnect");
	while(1)
	{
		self waittill( "trigger", player );
		if(Distance(pos, Player.origin) <= 75 && level.power == 0)
		{
			Player setLowerMessage("activate", "Power needs to be activated" );
		}
		else if(Distance(pos, Player.origin) <= 75)
		{
			Player setLowerMessage("activate", "Hold ^3[{+activate}]^7 for Quick Revive Pro [^2$^32500^7]" );
		}
		if(Distance(pos, Player.origin) >50)
		{
			Player ClearLowerMessage("activate", 1);
		}
		if(Distance(pos, Player.origin) <= 75 && player.pers["team"] == "allies" && level.power == 0 && player useButtonPressed())
		{
			player iPrintln("^1Power needs to be activated!");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player.money >= 2500 && player.autorevive == 1 && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player iPrintln("^1You have already bought Quick Revive Pro!");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player.money >= 2500 && player.autorevive >= 0 && player.standpro >= 3 && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player iPrintln("^1You have already bought Quick Revive Pro 3 Times!");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player.money >= 2500 && player.pers["team"] == "allies" && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player.money -= 2500;
			player notify("MONEY");
			player thread maps\mp\gametypes\_rank::scorePopup( -2500, 0, (1,0,0), 1 );
			player thread AImod\_Mod::TextPopup( "Quick Revive Pro!" );
			player.autorevive += 1;
			player.standpro += 1;
			wait 0.1;
			player thread PerkLastStandPro("specialty_pistoldeath_upgrade", (0,1,1), "Quick Revive Pro");
			level notify("boxend");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player.money <= 2500 && player useButtonPressed())
		{
			player iPrintln("^1Not enough money for Last Stand Pro Need $2500!");
			wait 1;
		}
		wait 0.01;
	}
}

Speedy(pos, angle)
{
	block = spawn("script_model", pos+(0,0,50) );
	block setModel("com_plasticcase_friendly");
	block.angles = angle;
	block Solid();
	block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	block moveto(pos,3);
	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
	objective_add( curObjID, "invisible", (0,0,0) );
	objective_position( curObjID, block.origin );
	objective_state( curObjID, "active" );
	objective_team( curObjID, "allies" );
	objective_icon( curObjID, "specialty_lightweight_upgrade" );
    trigger = spawn( "trigger_radius", pos, 0, 75, 50 );
    trigger.angles = angle;
	trigger thread SpeedyThink(pos);
    wait 0.01;
}

SpeedyThink(pos, angle)
{
	self endon("disconnect");
	while(1)
	{
		self waittill( "trigger", player );
		if(Distance(pos, Player.origin) <= 75 && level.power == 0)
		{
			Player setLowerMessage("activate", "Power needs to be activated" );
		}
		else if(Distance(pos, Player.origin) <= 75 && level.power == 1)
		{
			Player setLowerMessage("activate", "Hold ^3[{+activate}]^7 for Stamin-Up [^2$^32500^7]" );
		}
		if(Distance(pos, Player.origin) >50)
		{
			Player ClearLowerMessage("activate", 1);
		}
		if(Distance(pos, Player.origin) <= 75 && player.pers["team"] == "allies" && level.power == 0 && player useButtonPressed())
		{
			player iPrintln("^1Power needs to be activated!");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player.money <= 2500 && player.speedy == 0 && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player iPrintln("^1Not enough money for Stamin-Up Need $2500!");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player.money >= 0 && player.speedy == 1 && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player iPrintln("^1You have already bought Stamin-Up!");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player.money >= 2500 && player.pers["team"] == "allies" && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player.money -= 2500;
			player notify("MONEY");
			player thread maps\mp\gametypes\_rank::scorePopup( -2500, 0, (1,0,0), 1 );
			player thread AImod\_Mod::TextPopup( "Stamin-Up!" );
			player _setPerk("specialty_marathon");
			player _setPerk("specialty_lightweight");
			player _setPerk("specialty_fastsprintrecovery");
			player.speedy = 1;
			player.zombieperks += 1;
			wait 0.1;
			player thread PerkHud( "specialty_lightweight_upgrade", (0.9,0.9,0.3), "Run and Sprint Longer and Faster");
			level notify("boxend");
			wait 1;
		}
		wait 0.01;
	}
}
	
Health(pos, angle)
{
	block = spawn("script_model", pos+(0,0,50) );
	block setModel("com_plasticcase_friendly");
	block.angles = angle;
	block Solid();
	block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	block moveto(pos,3);
	curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();	
	objective_add( curObjID, "invisible", (0,0,0) );
	objective_position( curObjID, block.origin );
	objective_state( curObjID, "active" );
	objective_team( curObjID, "allies" );
	objective_icon( curObjID, "cardicon_juggernaut_2" );
    trigger = spawn( "trigger_radius", pos, 0, 75, 50 );
    trigger.angles = angle;
	trigger thread HealthThink(pos);
    wait 0.01;
}

HealthThink(pos, angle)
{
	self endon("disconnect");
	while(1)
	{
		self waittill( "trigger", player );
		if(Distance(pos, Player.origin) <= 75 && level.power == 0)
		{
			Player setLowerMessage("activate", "Power needs to be activated" );
		}
		else if(Distance(pos, Player.origin) <= 75)
		{
			Player setLowerMessage("activate", "Hold ^3[{+activate}]^7 for Juggernog [^2$^32500^7]" );
		}
		if(Distance(pos, Player.origin) >50)
		{
			Player ClearLowerMessage("activate", 1);
		}
		if(Distance(pos, Player.origin) <= 75 && player.pers["team"] == "allies" && level.power == 0 && player useButtonPressed())
		{
			player iPrintln("^1Power needs to be activated!");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player.money <= 2500 && player.maxhealth <= 100 && player.nobuyhealth == 0 && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player iPrintln("^1Not enough money for Juggernog $2500!");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player.money >= 0 && player useButtonPressed() && player.maxhealth > 100 && player.nobuyhealth == 0)
		{
			player ClearLowerMessage("activate", 1);
			player iPrintln("^1You have already bought Juggernog!");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 75 && player.money >= 0 && player useButtonPressed() && player.nobuyhealth == 1)
		{
			player ClearLowerMessage("activate", 1);
			player iPrintln("^1You may not buy Juggernog at this time!");
			wait 1;
		}
		if(Distance(pos, Player.origin) <= 75 && player.money >= 2500 && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player.money -= 2500;
			player notify("MONEY");
			player thread maps\mp\gametypes\_rank::scorePopup( -2500, 0, (1,0.3,0.3), 1 );
			player thread AImod\_Mod::TextPopup( "Juggernog!" );
			player.maxhealth += 100;
			player.zombieperks += 1;
			wait 0.1;
			player thread PerkHud( "cardicon_juggernaut_2", (1,0.3,0.3), "200 Health");
			level notify("boxend");
			wait 1;
		}
		wait 0.01;
	}
}

Power3(pos, angle)
{
	level endon("Destroy"); 
	block = spawn("script_model", pos );
	block setModel("com_plasticcase_friendly");
	block.angles = angle;
	block Solid();
	level.power = 0;
	block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	block.headIcon = newHudElem();
	block.headIcon.x = block.origin[0];
	block.headIcon.y = block.origin[1];
	block.headIcon.z = block.origin[2] + 50;
	block.headIcon.alpha = 0.85;
	block.headIcon setShader( "cardicon_bulb", 10,10 );
	block.headIcon setWaypoint( true, true, false );
	block.headIcon thread PowerDestroy();
    trigger = spawn( "trigger_radius", pos, 0, 75, 50 );
    trigger.angles = angle;
	trigger thread Power3Think(pos, angle, block);
	block thread PowerDestroy();
    wait 0.01;
}   

Power3Think(pos, angle, block)
{
	self endon("disconnect");
	level endon("Destroy");
	while(1)
	{
		self waittill( "trigger", player );
		if(Distance(pos, Player.origin) <= 75)
		{
			Player setLowerMessage("activate", "Hold ^3[{+activate}]^7 to activate power [^2$^110000^7]" );
		}
		if(Distance(pos, Player.origin) >50)
		{
			Player ClearLowerMessage("activate", 1);
		}
		if(Distance(pos, Player.origin) <= 75 && player.money >= 10000 && player.pers["team"] == "allies" && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player.money -= 10000;
			player notify("MONEY");
			block moveTo(block.origin+(0,0,1000), 2.3);
			wait 2.3;
			player thread EmpEffect(block);
			player playSound( "nuke_explosion" );
			player thread maps\mp\gametypes\_rank::scorePopup( -10000, 0, (1,0,0), 1 );
			level.playername = player.name;
			foreach(player in level.players)
			{
			    player thread AImod\_Mod::TextPopup( "Power!" );
				player thread AImod\_Intro::WelcomeText(level.playername, "Activated Power", "", "", "", 1, (1,1,1), (1,0.5,0.3), 0.85, (1,1,1), (1,0.5,0.3), 0.85, (1,1,1), (0.3,0.9,0.9), 0.85, (1,1,1), (0.3,0.9,0.3), 0.85, (1,1,1), (0.3,0.9,0.9), 0.85);
			}
			if(getDvarInt("z_dedicated") == 0)
			{
				foreach(player in level.players)
				{
					player playLocalSound("mp_killstreak_carepackage");
					player setClientDvar("ui_power", 1);
				}
			}
			level.power = 1;
			level notify("power_activated");
			level notify("Destroy");
			wait 1;
		}
		else if(Distance(pos, Player.origin) <= 10000 && player.money <= 750 && player useButtonPressed())
		{
			player ClearLowerMessage("activate", 1);
			player iPrintln("^1Not enough money for Power Need $10000!");
			wait 1;
		}
		wait 0.01;
	}
}

PowerDestroy()
{
	while(1)
    {
        if(level.power == 1)
        {
		    self delete();
			self.headIcon destroy();
        }
	    wait 0.1;
	}
}

CreateElevator(enter, exit, angle)
{
	flag = spawn( "script_model", enter );
	flag setModel( level.elevator_model["enter"] );
	wait 0.01;
	flag = spawn( "script_model", exit );
	flag setModel( level.elevator_model["exit"] );
	wait 0.01;
	self thread ElevatorThink(enter, exit, angle);
}

CreateBlocks(pos, angle)
{
	block = spawn("script_model", pos );
	block setModel("com_plasticcase_friendly");
	block.angles = angle;
	block Solid();
	block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	wait 0.01;
}

CreateDoors(open, close, angle, size, height, hp, range)
{

}

CreateRamps(top, bottom)
{
	D = Distance(top, bottom);
	blocks = roundUp(D/30);
	CX = top[0] - bottom[0];
	CY = top[1] - bottom[1];
	CZ = top[2] - bottom[2];
	XA = CX/blocks;
	YA = CY/blocks;
	ZA = CZ/blocks;
	CXY = Distance((top[0], top[1], 0), (bottom[0], bottom[1], 0));
	Temp = VectorToAngles(top - bottom);
	BA = (Temp[2], Temp[1] + 90, Temp[0]);
	for(b = 0;b < blocks;b++)
	{
		block = spawn("script_model", (bottom + ((XA, YA, ZA) * b)));
		block setModel("com_plasticcase_friendly");
		block.angles = BA;
		block Solid();
		block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
		wait 0.01;
	}
	block = spawn("script_model", (bottom + ((XA, YA, ZA) * blocks) - (0, 0, 5)));
	block setModel("com_plasticcase_friendly");
	block.angles = (BA[0], BA[1], 0);
	block Solid();
	block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	wait 0.001;
}

CreateGrids(corner1, corner2, angle)
{
	W = Distance((corner1[0], 0, 0), (corner2[0], 0, 0));
	L = Distance((0, corner1[1], 0), (0, corner2[1], 0));
	H = Distance((0, 0, corner1[2]), (0, 0, corner2[2]));
	CX = corner2[0] - corner1[0];
	CY = corner2[1] - corner1[1];
	CZ = corner2[2] - corner1[2];
	ROWS = roundUp(W/55);
	COLUMNS = roundUp(L/30);
	HEIGHT = roundUp(H/20);
	XA = CX/ROWS;
	YA = CY/COLUMNS;
	ZA = CZ/HEIGHT;
	center = spawn("script_model", corner1);
	for(r = 0;r <= ROWS;r++)
	{
		for(c = 0;c <= COLUMNS;c++)
		{
			for(h = 0;h <= HEIGHT;h++)
			{
				block = spawn("script_model", (corner1 + (XA * r, YA * c, ZA * h)));
				block setModel("com_plasticcase_friendly");
				block.angles = (0, 0, 0);
				block Solid();
				block LinkTo(center);
				block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
				wait 0.001;
			}
		}
	}
	center.angles = angle;
}

CreateWalls(start, end)
{
	D = Distance((start[0], start[1], 0), (end[0], end[1], 0));
	H = Distance((0, 0, start[2]), (0, 0, end[2]));
	blocks = roundUp(D/55);
	height = roundUp(H/30);
	CX = end[0] - start[0];
	CY = end[1] - start[1];
	CZ = end[2] - start[2];
	XA = (CX/blocks);
	YA = (CY/blocks);
	ZA = (CZ/height);
	TXA = (XA/4);
	TYA = (YA/4);
	Temp = VectorToAngles(end - start);
	Angle = (0, Temp[1], 90);
	for(h = 0;h < height;h++)
	{
		block = spawn("script_model", (start + (TXA, TYA, 10) + ((0, 0, ZA) * h)));
		block setContents(1);
		block.angles = Angle;
		wait 0.0001;
		block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
		block hide();
		for(i = 1;i < blocks;i++)
		{
			block = spawn("script_model", (start + ((XA, YA, 0) * i) + (0, 0, 10) + ((0, 0, ZA) * h)));
			block setContents(1);
			block.angles = Angle;
			block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
			block hide();
			wait 0.0001;
		}
		block = spawn("script_model", ((end[0], end[1], start[2]) + (TXA * -1, TYA * -1, 10) + ((0, 0, ZA) * h)));
		block setContents(1);
		block.angles = Angle;
		block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
		block hide();
		wait 0.0001;
	}
}

CreateVisableWalls(start, end)
{
	D = Distance((start[0], start[1], 0), (end[0], end[1], 0));
	H = Distance((0, 0, start[2]), (0, 0, end[2]));
	blocks = roundUp(D/55);
	height = roundUp(H/30);
	CX = end[0] - start[0];
	CY = end[1] - start[1];
	CZ = end[2] - start[2];
	XA = (CX/blocks);
	YA = (CY/blocks);
	ZA = (CZ/height);
	TXA = (XA/4);
	TYA = (YA/4);
	Temp = VectorToAngles(end - start);
	Angle = (0, Temp[1], 90);
	for(h = 0;h < height;h++)
	{
		block = spawn("script_model", (start + (TXA, TYA, 10) + ((0, 0, ZA) * h)));
		block setModel("com_plasticcase_friendly");
		block.angles = Angle;
		wait 0.0001;
		block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
		for(i = 1;i < blocks;i++)
		{
			block = spawn("script_model", (start + ((XA, YA, 0) * i) + (0, 0, 10) + ((0, 0, ZA) * h)));
			block setModel("com_plasticcase_friendly");
			block.angles = Angle;
			block solid();
			block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
			wait 0.0001;
		}
		block = spawn("script_model", ((end[0], end[1], start[2]) + (TXA * -1, TYA * -1, 10) + ((0, 0, ZA) * h)));
		block setModel("com_plasticcase_friendly");
		block.angles = Angle;
		block solid();
		block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
		wait 0.0001;
	}
}

CreateCluster(amount, pos, radius)
{
	for(i = 0; i < amount; i++)
	{
		half = radius / 2;
		power = ((randomInt(radius) - half), (randomInt(radius) - half), 500);
		block = spawn("script_model", pos + (0, 0, 1000) );
		block setModel("com_plasticcase_friendly");
		block.angles = (90, 0, 0);
		block PhysicsLaunchServer((0, 0, 0), power);
		block Solid();
		block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
		block thread ResetCluster(pos, radius);
		wait 0.05;
	}
}

ElevatorThink(enter, exit, angle)
{
	self endon("disconnect");
	while(1)
	{
		foreach(player in level.players)
		{
			if(Distance(enter, player.origin) <= 50){
				player SetOrigin(exit);
				player SetPlayerAngles(angle);
			}
		}
		wait .25;
	}
}

CreateHurtArea(pos, radius, height)
{
	HurtTrigger = spawn( "trigger_radius", pos, 0, radius, height );
	HurtTrigger thread HurtTriggerThink();
}
	
HurtTriggerThink()
{
	self endon("disconnect");
	while(1)
	{
		self waittill( "trigger", player );
		player thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper( self, self, 20, 0, "MOD_MELEE", "none", player.origin, player.origin, "none", 0, 0 );
		player iprintlnbold("^1Get out");
		wait 1;
	}
}

ResetCluster(pos, radius)
{
	wait 5;
	self RotateTo(((randomInt(36)*10), (randomInt(36)*10), (randomInt(36)*10)), 1);
	level waittill("RESETCLUSTER");
	self thread CreateCluster(1, pos, radius);
	self delete();
}

roundUp( floatVal )
{
	if ( int( floatVal ) != floatVal )
	{
		return int( floatVal+1 );
	}
	else
	{
		return int( floatVal );
	}
}

CreateProgressArea(pos, radius, height, repeat, forceNum)
{
	level.spawnlogic = spawn( "trigger_radius", pos, 0, radius, height );
	Hasfound = 0;
	if( !Isdefined(forcenum) )
	{
		forcenum = 0;
	}
	level.spawnlogic thread playerEnterArea(radius, Hasfound, repeat, forcenum);
}

playerEnterArea(radius, didfind, repeat, forcenum, range)
{
	for(;;)
	{
		self waittill( "trigger", player );	
		level.progressmap = forcenum;
	}
}

CreateProgressAreaDebug(pos, radius, height, repeat, forceNum)
{
	Areatrigger = spawn( "trigger_radius", pos, 0, radius, height );
	Hasfound = 0;
	if( !Isdefined(forcenum) )
	{
		forcenum = 0;
	}
	Areatrigger thread playerEnterAreaDebug(radius, Hasfound, repeat, forcenum);
	foreach(player in level.players)
	{
		player.rTouch = 0;
	}
}

playerEnterAreaDebug(radius, didfind, repeat, forcenum, range)
{
	for( ;; )
	{
		wait 0.000000000000000000001;
		if(repeat == 1 && didfind == 1)
		{
			foreach(player in level.players)
			{
				if(Distance(self.origin, player.origin) >= radius * 1 && didfind == 1 && player.rTouch != 0)
				{
					level.progressmap = forcenum;
					didfind = 0;
					player iprintlnbold("You left " + level.progressmap);
				}
			}
		}
		self waittill( "trigger", player );
		currentProgressNum = level.progressmap;
		wait 0.000001;		
		if(repeat == 1)
		{
			if(Distance(self.origin, player.origin) <= radius)
			{
				player.rTouch = 1;
				level.progressmap = forcenum;
				didfind = 1;
				player iprintlnbold("Area " + level.progressmap);
			}

		}
	}
}

RandomBoxDeleteOnWeaponNoTake()
{
	level endon("disconnect");
	level endon("stopspawner");
	{
		level waittill("endrandom");
		level.wep MoveTo(level.wep.origin+(0,0,-30), 12);
		wait 12;
		level notify("box_move");
		level notify("box");
		level.block delete();
		level.block.headIcon destroy();
		level.block.trigger delete();
		level.wep delete();
		level thread SpawnRandomBoxLocation();
		wait 1;
	}
}

RandomBoxDeleteOnWeaponTake()
{
	level endon("disconnect");
	{
		wait 1;
		level notify("box_delete");
		level notify("box");
		level.block delete();
		level.block.headIcon destroy();
		level.block.trigger delete();
		foreach(weaps in level.wep)
		{
			weaps delete();
		}
		level thread SpawnRandomBoxLocation();
		wait 1;
	}
}

EmpEffect(block)
{
	level._effect["empuse"] = loadfx ("explosions/emp_flash_mp");
	PlayFx(level._effect["empuse"],block.origin);
}

CreateFXonPos(pos,fx)
{
    playFX(fx, pos);
    angles = (90, 90, 0);
	wait 0.01;
}

PowerHud()
{
	self endon("disconnect");
	if(!isDefined(self.powertext))
	{
		self.powertext = self createFontString( "default", 1.5 );
		self.powertext setPoint( "TOPRIGHT", "TOPRIGHT", 0, 30);
		self.powertext.HideWhenInMenu = true;
	}
	while(1)
	{
		if(level.power <= 0)
		{
			self.powertext setText ("Power Not Activated");
			self.powertext.fontScale = 1.5;
			self.powertext.glowColor = (1,0.5,0.3);
			self.powertext.glowAlpha = 1;
		}
		else
		{
			self.powertext fadeOverTime( 3.00 );
			self.powertext.alpha = 0;
			wait 3.0;
			self.powertext setText ("Power Activated");
			self.powertext.fontScale = 1.5;
			self.powertext.glowColor = (0.3,0.9,0.3);
			self.powertext.glowAlpha = 1;
			self.powertext fadeOverTime( 2.00 );
			self.powertext.alpha = 1;
			wait 2.0;
			self.powertext ChangeFontScaleOverTime( 0.1 );
			self.powertext.fontScale = 1.750;
			wait 0.1;
			self.powertext ChangeFontScaleOverTime( 0.1 );
			self.powertext.fontScale = 1.5;
		}
		level waittill("power_activated");
	}
}

MoneyGambler()
{
	self endon("disconnect");
	switch(randomInt(17))
	{
		case 0: self iPrintlnBold(" ^2You have won $500");
		self.money += 500;
		self thread Money();
		self notify("MONEY");
		break;
		case 1: self iPrintlnBold(" ^2You have won $1000");
		self.money += 1000;
		self thread Money();
		self notify("MONEY");
		break;
		case 2: self iPrintlnBold(" ^1You have lost -$1000");
		self.money -= 1000;
		self notify("MONEY");
		break;
		case 3: self iPrintlnBold(" ^2You have won $1500");
		self.money += 1500;
		self thread Money();
		self notify("MONEY");
		break;
		case 4: self iPrintlnBold(" ^2You have won $2000");
		self.money += 2000;
		self thread Money();
		self notify("MONEY");
		break;
		case 5: self iPrintlnBold(" ^2You have won $5000");
		self.money += 5000;
		self thread Money();
		self notify("MONEY");
		break;
		case 6: self iPrintlnBold(" ^2You have won $10000");
		self.money += 10000;
		self thread Money();
		self notify("MONEY");
		break;
		case 7: self iPrintlnBold(" ^2You have won $7500");
		self.money += 7500;
		self thread Money();
		self notify("MONEY");
		break;
		case 8: self iPrintlnBold(" ^1You have lost all your cash");
		self.money = 0;
		self notify("MONEY");
		break;
		case 9: self iPrintlnBold(" ^1You have lost -$500");
		self.money -= 500;
		self notify("MONEY");
		break;
		case 10: self iPrintlnBold(" ^2You have won a Extra Weapon Slot");
		self giveWeapon("defaultweapon_mp",10,false);
		wait 0.1;
		self switchToWeapon("defaultweapon_mp",10,false);
		break;
		case 11: self iPrintlnBold(" ^2You have won a Model 1887");
		self.curWeap = self getCurrentWeapon();
		self takeWeapon(self.curWeap);
		self giveWeapon("model1887_mp",0,false);
		wait 0.1;
		self switchToWeapon("model1887_mp",0,false);
		self giveMaxAmmo("model1887_mp",0,false);
		break;
		case 12: self iPrintlnBold("^2God decides if you live or die in 5 seconds");
		wait 1;
		self iPrintlnBold("^24");
		wait 1;
		self iPrintlnBold("^23");
		wait 1;
		self iPrintlnBold("^22");
		wait 1;
		self iPrintlnBold("^21");
		wait 1;
		self thread Die();
		break;
		case 13: self iPrintlnBold("^3You have a 1/2 Chance of a Max Ammo");
		wait 2;
		self thread MaxAmmoRandom();
		break;
		case 14: self iPrintlnBold("^2You get infinite health for 30 seconds");
		self thread InfiniteHealth();
		break;
		case 15: self iPrintlnBold("^2You get double health for 30 seconds");
		self thread DoubleHealth();
		break;
		case 16: self iPrintlnBold("^1All Perks Taken away and $200");
		self thread TakePerks();
		break;
	}
}

Money()
{
	level._effect["money"] = loadfx ("props/cash_player_drop");
	PlayFx(level._effect["money"],self.origin);
}

Die()
{
	switch(randomInt(4))
	{
		case 0: self notify("menuresponse", game["menu_team"], "spectator");
		break;
		case 1: self iPrintlnBold("^2You live");
		break;
		case 2: self iPrintlnBold("^2You live");
		break;
		case 3: self iPrintlnBold("^2You live");
		break;
	}
}

MaxAmmoRandom()
{
	switch(randomInt(2))
	{
		case 0: self iPrintlnBold("^2You have won the MaxAmmo!");
		self maps\mp\killstreaks\_airdrop::refillAmmo();
		break;
		case 1: self iPrintlnBold("^1No Max Ammo For You!");
		break;
	}
}

InfiniteHealth()
{
	if(self.health == 100)
	{
		self.maxhealth = 999999;
		self.health = self.maxhealth;
		self.nobuyhealth = 1;
		wait 30;
		self notify("infinite_health_end");
		self.maxhealth = 100;
		self.health = self.maxhealth;
		self iPrintlnBold("^1Infinite Health Over!");
		self.nobuyhealth = 0;
	}
	else if(self.health == 200)
	{
		self.maxhealth = 999999;
		self.health = self.maxhealth;
		self.health = 20000;
		self.nobuyhealth = 1;
		wait 30;
		self notify("infinite_health_end");
		self.maxhealth = 200;
		self.health = self.maxhealth;
		self iPrintlnBold("^1Infinite Health Over!");
		self.nobuyhealth = 0;
	}
}

DoubleHealth()
{
	if(self.health == 100)
	{
		self.maxhealth = 200;
		self.health = self.maxhealth;
		self.nobuyhealth = 1;
		wait 30;
		self notify("double_health_end");
		self.maxhealth = 100;
		self.health = self.maxhealth;
		self iPrintlnBold("^1Double Health Over!");
		self.nobuyhealth = 0;
	}
	else if(self.health == 200)
	{
		self.maxhealth = 400;
		self.health = self.maxhealth;
		self.nobuyhealth = 1;
		wait 30;
		self notify("double_health_end");
		self.maxhealth = 200;
		self.health = self.maxhealth;
		self iPrintlnBold("^1Double Health Over!");
		self.nobuyhealth = 0;
	}
}

TakePerks()
{
	if ( self _hasPerk( "specialty_finalstand" ) )
	{
		self _ClearPerks();
		self maps\mp\perks\_perks::givePerk( "specialty_finalstand" );
	}
	else
	{
		self _ClearPerks();
	}
	self.speedy = 0;
	self.stoppingpower = 0;
	self.steadyaim = 0;
	self.speedreload = 0;
	self.maxhealth = 100;
	self.health = self.maxhealth;
	self.ammomatic = 0;
	self.extra = 1;
	self.zombieperks = 0;
	self thread AImod\_Mod::DestoyPerkHud();
	self.money -= 200;
}