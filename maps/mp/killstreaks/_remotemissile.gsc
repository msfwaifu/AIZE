#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	mapname = getDvar( "mapname" );
	if ( mapname == "mp_afghan" )
	{
		level.missileRemoteLaunchVert = 1000000;
		level.missileRemoteLaunchHorz = 10000;
		level.missileRemoteLaunchTargetDist = 5000;
	}
	else if ( mapname == "mp_mainstreet" )
	{
		level.missileRemoteLaunchVert = 1000000;
		level.missileRemoteLaunchHorz = 10000;
		level.missileRemoteLaunchTargetDist = 5000;
	}
	else
	{
		level.missileRemoteLaunchVert = 1000000;
		level.missileRemoteLaunchHorz = 10000;
		level.missileRemoteLaunchTargetDist = 5000;

	}	
	precacheItem( "remotemissile_projectile_mp" );
	precacheString( &"MP_CIVILIAN_AIR_TRAFFIC" );
	
	level.rockets = [];
	
	level.killstreakFuncs["predator_missile"] = ::tryUsePredatorMissile;
	
	level.missilesForSightTraces = [];
}

SpawnBombJet(zombie, player)
{
	planeStartOrigin = undefined;
	switch(randomInt(4))
	{
		case 0: planeStartOrigin = zombie.origin+(0,30000,0);
		break;
		case 1: planeStartOrigin = zombie.origin+(30000,0,0);
		break;
		case 2: planeStartOrigin = zombie.origin+(0,-30000,0);
		break;
		case 3: planeStartOrigin = zombie.origin+(-30000,0,0);
		break;
	}
	plane = spawnplane( player, "script_model", zombie.origin+(planeStartOrigin[0],planeStartOrigin[1],3000), "hud_minimap_harrier_green", "hud_minimap_harrier_green" );
	plane setModel( "vehicle_av8b_harrier_jet_mp" );
	plane playloopsound( "veh_mig29_dist_loop" );
	planeforwardangle = VectorToAngles( zombie.origin+(0,0,3000) - plane.origin );
	plane.angles = (0,planeforwardangle[1],0);
	plane thread maps\mp\killstreaks\_airstrike::playPlaneFx();
	plane MoveTo(zombie.origin+(0,0,3000), 6);
	wait 5;
	plane thread DropBomb(zombie, player, plane);
	wait 1;
	plane MoveTo(zombie.origin-(planeStartOrigin[0],planeStartOrigin[1],-3000), 6);
	plane playSound( "veh_b2_sonic_boom" );
	wait 2;
	wait 4;
	plane notify("mig29_left");
	plane delete();
}

DropBomb(zombie, player, plane)
{
	bomb = spawn("script_model", plane.origin+(0,0,-100));
	bomb setModel("projectile_cbu97_clusterbomb");
	bombangle = VectorToAngles( zombie.origin - bomb.origin );
	bomb.angles = (0,bombangle[1],0);
	bomb moveTo(zombie.origin, 2);
	wait 2;
	foreach(zombie in level.bots)
	{
		if(distance(bomb.origin, zombie.origin) >= 400)
		{
			continue;
		}
		zombie.crate1.health -= 500;
		zombie.crate1 notify("damage", 500, player);
	}
	playFX(loadfx("explosions/tanker_explosion"), bomb.origin);
	bomb playSound("exp_suitcase_bomb_main");
	wait 0.1;
	PhysicsExplosionSphere( bomb.origin, 400, 200, 7 );
	bomb delete();
}

tryUsePredatorMissile( lifeId )
{
	TmpDist = 99999999;
	pTarget = undefined;
	self clearUsingRemote();
	self SayTeam("^1Bomb Incoming");
	self thread AImod\_Mod::TextPopup( "Bomb!" );
	self thread maps\mp\gametypes\_rank::scorePopup( 100, 0, (0,1,2), 1 );
	self.money += 100;
	self notify("MONEY");
	foreach(zombie in level.bots)
	{
		if(zombie.pers["isAlive"] == "false")
			continue;
		if(distancesquared(zombie.origin, zombie.origin) < TmpDist)
		{
			TmpDist = distancesquared(zombie.origin, zombie.origin);
			pTarget = zombie;
		}
	}
	self thread SpawnBombJet(pTarget, self);
	return true;
}

DropMissile()
{
	TmpDist = 99999999;
	pTarget = undefined;
	self clearUsingRemote();
	i = 0;
	a = 0;
	self SayTeam("^3Predator Missile ^1Inbound");
	self thread AImod\_Mod::TextPopup( "Predator Missile!" );
	self thread maps\mp\gametypes\_rank::scorePopup( 100, 0, (0,1,2), 1 );
	self.money += 100;
	self notify("MONEY");
	bomb = spawn("script_model", self.origin+(0,0,5000) );
	bomb setModel("projectile_cbu97_clusterbomb");
	bomb.angles = (90,0,0);
	bomb CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	bomb setContents(0);
	foreach(zombie in level.bots)
	{
		if(zombie.pers["isAlive"] == "false")
			continue;
		if(distancesquared(bomb.origin, zombie.origin) < TmpDist)
		{
			TmpDist = distancesquared(bomb.origin, zombie.origin);
			pTarget = zombie;
		}
	}
	bomb moveTo(pTarget.origin,4);
	movetoLoc = VectorToAngles( pTarget getTagOrigin("j_head") - bomb.origin );
	bomb RotateTo((movetoLoc[1],0,0), 0.1);
	wait 4;
	playFx(loadFx("explosions/aerial_explosion"), bomb.origin);
	bomb playSound("cobra_helicopter_hit");
	bomb playSound("cobra_helicopter_crash");
	foreach(zombie in level.bots)
	{
		if(distance(bomb.origin, zombie.origin) >= 400)
		{
			continue;
		}
		zombie.health -= 150;
		a += 1;
		if(zombie.health <= 0)
		{
			zombie notify("bot_death");
			zombie.knife delete();
			zombie scriptModelPlayAnim("pb_death_run_stumble");
			zombie.crate1 thread AImod\_bot::DeleteZombie();
			zombie.speed = 1;
			zombie thread AImod\_bot::DeleteZombie();
			zombie notify("bot_is_dead");
			i += 1;
		}
	}
	if(i >= 1)
	{
		self.money += i;
		self thread maps\mp\gametypes\_rank::scorePopup( i*60, 0, (0,1,2), 1 );
		self thread maps\mp\gametypes\_rank::giveRankXP("zombie_kill", i*25);
		self.xpearned += i;
	}
	a = a*5;
	self.money += a;
	self thread maps\mp\gametypes\_rank::scorePopup( a, 0, (0,1,2), 1 );
	self notify("MONEY");
	bomb delete();
}
