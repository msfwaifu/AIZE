#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include AImod\_OtherFunctions;

MegaStreakInit()
{
	self notifyOnPlayerCommand("[{+actionslot 2}]", "+actionslot 2");
	self waittill("[{+actionslot 2}]");
	self thread AImod\_Mod::TextPopup2("Mega Strike Inbound!");	
	level thread MegaStrike(self);
}

MegaStrike(player)
{
	TmpDist = 999999999;
	pTarget = undefined;
	foreach( zombie in level.bots )
	{
		if(zombie.pers["isAlive"] == "false") continue;
		if(distancesquared(player.origin, zombie.origin) < TmpDist)
		{
			TmpDist = distancesquared(level.UAVspawn.origin, zombie.origin);
			pTarget = zombie;
		}
	}
	if(!isDefined(pTarget)) 
		pTarget = player;
	level thread SpawnJet(pTarget, player);
	level thread SpawnJet2(pTarget, player);
	level thread SpawnJet3(pTarget, player);
	level thread SpawnJet(pTarget, player);
	level thread SpawnJet2(pTarget, player);
	level thread SpawnJet3(pTarget, player);
	level thread SpawnJet4(pTarget, player);
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
	plane notSolid();
	plane playloopsound( "veh_mig29_dist_loop" );
	planeforwardangle = VectorToAngles( zombie.origin+(0,0,3000) - plane.origin );
	plane.angles = (0,planeforwardangle[1],0);
	plane thread maps\mp\killstreaks\_airstrike::playPlaneFx();
	plane MoveTo(zombie.origin+(0,0,3000), 6);
	wait 4;
	plane thread Drop40MM(player, zombie);
	wait 2;
	plane MoveTo(zombie.origin-(planeStartOrigin[0],planeStartOrigin[1],-3000), 6);
	wait 2;
	plane playSound( "veh_b2_sonic_boom" );
	wait 4;
	plane delete();
}

SpawnJet2(zombie, player)
{
	planeStartOrigin = undefined;
	planeStartOrigin = zombie.origin+(0,20000,0);
	harrier = spawnplane( player, "script_model", zombie.origin+(planeStartOrigin[0],planeStartOrigin[1],3000), "hud_minimap_harrier_green", "hud_minimap_harrier_green" );
	harrier setModel( "vehicle_av8b_harrier_jet_mp" );
	harrier notSolid();
	harrier playloopsound( "vehicle_av8b_harrier_jet_mp" );
	planeforwardangle = VectorToAngles( zombie.origin+(0,0,3000) - harrier.origin );
	harrier.angles = (0,planeforwardangle[1],0);
	harrier thread maps\mp\killstreaks\_airstrike::playPlaneFx();
	harrier MoveTo(zombie.origin+(0,0,3000), 6);
	wait 4;
	harrier thread Drop105MM(player, zombie);
	wait 2;
	harrier MoveTo(zombie.origin-(planeStartOrigin[0],planeStartOrigin[1],-3000), 6);
	wait 2;
	harrier playSound( "veh_b2_sonic_boom" );
	wait 4;
	harrier delete();
}

SpawnJet3(zombie, player)
{
	planeStartOrigin = undefined;
	planeStartOrigin = zombie.origin+(0,20000,0);
	stealth = spawnplane( player, "script_model", zombie.origin+(planeStartOrigin[0],planeStartOrigin[1],3000), "compass_objpoint_b2_airstrike_friendly", "compass_objpoint_b2_airstrike_friendly" );
	stealth setModel( "vehicle_b2_bomber" );
	stealth notSolid();
	stealth playloopsound( "veh_b2_dist_loop" );
	planeforwardangle = VectorToAngles( zombie.origin+(0,0,3000) - stealth.origin );
	stealth.angles = (0,planeforwardangle[1],0);
	stealth thread maps\mp\killstreaks\_airstrike::playPlaneFx();
	stealth MoveTo(zombie.origin+(0,0,3000), 10);
	wait 8;
	stealth thread DropBombs(player, zombie);
	wait 2;
	stealth MoveTo(zombie.origin-(planeStartOrigin[0],planeStartOrigin[1],-3000), 10);
	wait 2;
	stealth playSound( "veh_b2_sonic_boom" );
	wait 8;
	stealth delete();
}

SpawnJet4(zombie, player)
{
	planeStartOrigin = undefined;
	planeStartOrigin = zombie.origin+(0,20000,0);
	stealth2 = spawnplane( player, "script_model", zombie.origin+(planeStartOrigin[0],planeStartOrigin[1],3000), "compass_objpoint_b2_airstrike_enemy", "compass_objpoint_b2_airstrike_enemy" );
	stealth2 setModel( "vehicle_b2_bomber" );
	stealth2 notSolid();
	stealth2 playloopsound( "veh_b2_dist_loop" );
	planeforwardangle = VectorToAngles( zombie.origin+(0,0,3000) - stealth2.origin );
	stealth2.angles = (0,planeforwardangle[1],0);
	stealth2 thread maps\mp\killstreaks\_airstrike::playPlaneFx();
	stealth2 MoveTo(zombie.origin+(0,0,3000), 10);
	wait 8;
	stealth2 thread DropSuperBomb(player, zombie);
	wait 2;
	stealth2 MoveTo(zombie.origin-(planeStartOrigin[0],planeStartOrigin[1],-3000), 10);
	wait 2;
	stealth2 playSound( "veh_b2_sonic_boom" );
	wait 8;
	stealth2 delete();
}

DropSuperBomb(player, zombie)
{
	pTarget = undefined;
	for(i = 0; i < 1; i += 1)
	{
		TmpDist = 999999999;
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
		thread DropSuperMegaBomb(pTarget, player, self);
		wait 1;
	}
}

DropSuperMegaBomb(zombie, player, plane)
{
	bomb = spawn("script_model", plane.origin+(0,0,-100));
	bomb setModel("projectile_cbu97_clusterbomb");
	bombangle = VectorToAngles( zombie.origin - bomb.origin );
	bomb.angles = (0,bombangle[1],0);
	bomb moveTo(zombie.origin, 2);
	wait 2;
	foreach(zombie in level.bots)
	{
		zombie.crate1.health -= 5000;
		zombie.crate1 notify("damage", 5000, player);
	}
	playFX(loadfx("explosions/tanker_explosion"), bomb.origin);
	bomb playSound("exp_suitcase_bomb_main");
	bomb delete();
}

DropBombs(player, zombie)
{
	pTarget = undefined;
	for(i = 0; i < 2; i += 1)
	{
		TmpDist = 999999999;
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
		thread DropHugeBomb(pTarget, player, self);
		wait 1;
	}
}

DropHugeBomb(zombie, player, plane)
{
	bomb = spawn("script_model", plane.origin+(0,0,-100));
	bomb setModel("projectile_cbu97_clusterbomb");
	bombangle = VectorToAngles( zombie.origin - bomb.origin );
	bomb.angles = (0,bombangle[1],0);
	bomb moveTo(zombie.origin, 2);
	wait 2;
	foreach(zombie in level.bots)
	{
		if(distance(bomb.origin, zombie.origin) >= 700)
		{
			continue;
		}
		zombie.crate1.health -= 700;
		zombie.crate1 notify("damage", 700, player);
	}
	playFX(loadfx("explosions/tanker_explosion"), bomb.origin);
	bomb playSound("exp_suitcase_bomb_main");
	bomb delete();
}


Drop40MM(player, zombie)
{
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

Drop105MM(player, zombie)
{
	for(i = 0; i < 3; i += 1)
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