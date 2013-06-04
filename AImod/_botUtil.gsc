#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include AImod\_OtherFunctions;
#include AImod\_zombie_spawns;

PickLevelModel()
{
	/* 
	0 = Arabian Models 
	1 = Arctic Models 
	2 = Airborne Models
	3 = Militia Models
	0 = TF141 Forest Models 
	1 = TF141 Desert Models 
	2 = TF141 Arctic Models
	3 = US Army Models
	4 = Seal Udt Models
	*/
	switch(getDvar("mapname"))
	{
		case "mp_afghan":
		level.zombieModel = 0;
		break;
		case "mp_derail":
		level.zombieModel = 1;
		break;
		case "mp_estate":
		level.zombieModel = 2;
		break;
		case "mp_favela":
		level.zombieModel = 3;
		break;
		case "mp_highrise":
		level.zombieModel = 2;
		break;
		case "mp_invasion":
		level.zombieModel = 0;
		break;
		case "mp_checkpoint":
		level.zombieModel = 0;
		break;
		case "mp_quarry":
		level.zombieModel = 3;
		break;
		case "mp_rundown":
		level.zombieModel = 3;
		break;
		case "mp_rust":
		level.zombieModel = 0;
		break;
		case "mp_boneyard":
		level.zombieModel = 0;
		break;
		case "mp_nightshift":
		level.zombieModel = 2;
		break;
		case "mp_subbase":
		level.zombieModel = 1;
		break;
		case "mp_terminal":
		level.zombieModel = 2;
		break;
		case "mp_underpass":
		level.zombieModel = 3;
		break;
		case "mp_brecourt":
		level.zombieModel = 2;
		break;
		case "mp_complex":
		level.zombieModel = 2;
		break;
		case "mp_crash":
		level.zombieModel = 0;
		break;
		case "mp_overgrown":
		level.zombieModel = 2;
		break;
		case "mp_compact":
		level.zombieModel = 1;
		break;
		case "mp_storm":
		level.zombieModel = 2;
		break;
		case "mp_abandon":
		level.zombieModel = 3;
		break;
		case "mp_fuel2":
		level.zombieModel = 0;
		break;
		case "mp_strike":
		level.zombieModel = 0;
		break;
		case "mp_trailerpark":
		level.zombieModel = 0;
		break;
		case "mp_vacant":
		level.zombieModel = 2;
		break;
		case "estate":
		level.zombieModel = 2;
		break;
		case "arcadia":
		level.zombieModel = 2;
		break;
		case "airport":
		level.zombieModel = 2;
		break;
		case "co_hunted":
		level.zombieModel = 3;
		break;
		case "oilrig":
		level.zombieModel = 1;
		break;
		case "mp_nuked":
		level.zombieModel = 2;
		break;
		case "invasion":
		level.zombieModel = 0;
		break;
	}
	switch(getDvar("mapname"))
	{
		case "mp_afghan":
		level.friendlyModel = 1;
		break;
		case "mp_derail":
		level.friendlyModel = 2;
		break;
		case "mp_estate":
		level.friendlyModel = 0;
		break;
		case "mp_favela":
		level.friendlyModel = 1;
		break;
		case "mp_highrise":
		level.friendlyModel = 3;
		break;
		case "mp_invasion":
		level.friendlyModel = 3;
		break;
		case "mp_checkpoint":
		level.friendlyModel = 4;
		break;
		case "mp_quarry":
		level.friendlyModel = 1;
		break;
		case "mp_rundown":
		level.friendlyModel = 1;
		break;
		case "mp_rust":
		level.friendlyModel = 1;
		break;
		case "mp_boneyard":
		level.friendlyModel = 1;
		break;
		case "mp_nightshift":
		level.friendlyModel = 3;
		break;
		case "mp_subbase":
		level.friendlyModel = 4;
		break;
		case "mp_terminal":
		level.friendlyModel = 3;
		break;
		case "mp_underpass":
		level.friendlyModel = 1;
		break;
		case "mp_brecourt":
		level.friendlyModel = 0;
		break;
		case "mp_complex":
		level.friendlyModel = 3;
		break;
		case "mp_crash":
		level.friendlyModel = 1;
		break;
		case "mp_overgrown":
		level.friendlyModel = 0;
		break;
		case "mp_compact":
		level.friendlyModel = 2;
		break;
		case "mp_storm":
		level.friendlyModel = 1;
		break;
		case "mp_abandon":
		level.friendlyModel = 3;
		break;
		case "mp_fuel2":
		level.friendlyModel = 3;
		break;
		case "mp_strike":
		level.friendlyModel = 3;
		break;
		case "mp_trailerpark":
		level.friendlyModel = 3;
		break;
		case "mp_vacant":
		level.friendlyModel = 3;
		break;
		case "estate":
		level.friendlyModel = 0;
		break;
		case "arcadia":
		level.friendlyModel = 3;
		break;
		case "airport":
		level.friendlyModel = 3;
		break;
		case "co_hunted":
		level.friendlyModel = 1;
		break;
		case "oilrig":
		level.friendlyModel = 4;
		break;
		case "mp_nuked":
		level.friendlyModel = 3;
		break;
		case "invasion":
		level.friendlyModel = 3;
		break;
	}
}

ZombieCount()
{
	zombCount = 0;
	for(i = 0;i < level.BotsForWave;i++)
	{
		if(isDefined(level.bots[i]) && level.bots[i].crate1.health >= 1 && level.bots[i].pers["isAlive"] == "true") 
			zombCount++;
	}
	//level.ZombieCount = zombCount;
	return zombCount;
}

ZombieCountForHud()
{
	count = ZombieCount();
	ZombieCount = level.bots.size;
	
	if( count < ZombieCount )
	{
		ZombieCount = count;
	}
	
	level.ZombieCount = ZombieCount;
	
	return level.ZombieCount;
}

SpawnTrigger(Torigin, gotoOrigin, width, height, map_name)
{
	trig = spawn("trigger_radius", Torigin,0,width,height);
	trig.goto = gotoOrigin;
	trig thread waitfortrig(map_name);
	return trig;
}

waitfortrig(map_name)
{
	while(getdvar("mapname") == map_name)
	{
		self waittill("trigger",player);
		if(player.sessionstate != "playing") 
		{
			continue;
		}
		player setOrigin(self.goto);
		player iPrintlnBold("Anti-Glitch");
		wait 0.05;
	}
}

GetMapSpawnPoint( )
{
	level endon("game_ended");
	spawnpoint = [];
	switch( getDvar("mapname") )
	{
		case "mp_afghan":
		if(level.edit == 0)
		{
			spawnpoint[spawnpoint.size] = (-3883,-553,-1448);
			spawnpoint[spawnpoint.size] = (-3975,3,-1448);
			spawnpoint[spawnpoint.size] = (-3828,-1164,-1448);
			spawnpoint[spawnpoint.size] = (-4523,1006,-1449);
			spawnpoint[spawnpoint.size] = (-4422,1209,-1449);
		}
		else if(level.edit == 1)
		{
			spawnpoint[spawnpoint.size] = (9201,1505,120);
			spawnpoint[spawnpoint.size] = (8659,1252,100);
			spawnpoint[spawnpoint.size] = (8356,1223,59);
			spawnpoint[spawnpoint.size] = (7308,2900,36);
			spawnpoint[spawnpoint.size] = (7260,2234,-51);
		}
		break;
		case "mp_highrise": 
		if(level.edit == 0)
		{
			spawnpoint[spawnpoint.size] = (-2727,11367,2275);
			spawnpoint[spawnpoint.size] = (-1677,11280,2179);
			spawnpoint[spawnpoint.size] = (-1684,11124,2179);
			spawnpoint[spawnpoint.size] = (-558,9998,2179);
			spawnpoint[spawnpoint.size] = (-2362,11359,2275);
		}
		else if(level.edit == 1)
		{
			spawnpoint[spawnpoint.size] = ZombieSpawnsHighrise2(level.progressmap);
		}
		break;
		case "mp_quarry":
		{
		/*	spawnpoint[spawnpoint.size] = (-1327,1228,912);
			spawnpoint[spawnpoint.size] = (-1323,1105,912);
			spawnpoint[spawnpoint.size] = (-1324,1023,912);
		*/
			spawnpoint[spawnpoint.size] = (-4570, -650.1, -162);
			spawnpoint[spawnpoint.size] = (-4570, -846.1, -132);
			spawnpoint[spawnpoint.size] = (-2015.8, 456.7, -0.9);
			spawnpoint[spawnpoint.size] = (-2007.5, 190.4, -33.8);
			spawnpoint[spawnpoint.size] = (-3270.9, 1575.8, 11.1);
			spawnpoint[spawnpoint.size] = (-5146.8, 361.7, -188.9);
			spawnpoint[spawnpoint.size] = (-4909.1, 474.3, -27.6);
			spawnpoint[spawnpoint.size] = (-4347, 1784.2, -145.2);
			spawnpoint[spawnpoint.size] = (-4658.5, 1568.2, -220.5);
		}
		break;
		case "mp_brecourt":
		{
			spawnpoint[spawnpoint.size] = (10961,6828,358);
			spawnpoint[spawnpoint.size] = (10955,6688,358);
			spawnpoint[spawnpoint.size] = (9850,8886,358);
			spawnpoint[spawnpoint.size] = (9693,8883,358);
			spawnpoint[spawnpoint.size] = (12867,7423,1486);
			spawnpoint[spawnpoint.size] = (12856,7070,1486);
		}
		break;
		case "mp_rust": 
		if(level.edit == 0)
		{
			spawnpoint[spawnpoint.size] = (-401,-202,-209);
			spawnpoint[spawnpoint.size] = (-417,1748,-226);
			spawnpoint[spawnpoint.size] = (1600,1779,-216);
			spawnpoint[spawnpoint.size] = (756,1777,-214);
			spawnpoint[spawnpoint.size] = (1498,936,-214);
			spawnpoint[spawnpoint.size] = (1542,249,-225);
			spawnpoint[spawnpoint.size] = (854,501,-227);
			spawnpoint[spawnpoint.size] = (572,-17,-209);
		}
		break;
		case "mp_terminal":
		{
			spawnpoint[spawnpoint.size] = (3173,5006,203);
			spawnpoint[spawnpoint.size] = (3933,4143,203);
			spawnpoint[spawnpoint.size] = (3581,2516,204);
			spawnpoint[spawnpoint.size] = (3389,2715,206);
			spawnpoint[spawnpoint.size] = (2001,4507,208);
			spawnpoint[spawnpoint.size] = (1944,4572,208);
		}
		break;
		case "mp_boneyard":
		{
			spawnpoint[spawnpoint.size] = (-674,-3297,-12);
			spawnpoint[spawnpoint.size] = (1287,-2771,-52);
			spawnpoint[spawnpoint.size] = (1268,-2908,-52);
			spawnpoint[spawnpoint.size] = (1205,-2046,-52);
			spawnpoint[spawnpoint.size] = (1440,-4082,-52);
			spawnpoint[spawnpoint.size] = (-1036,-3259,-12);
			spawnpoint[spawnpoint.size] = (-1212,-2318,-7);
		}
		break;
		case "mp_underpass":
		{
			spawnpoint[spawnpoint.size] = (2811,3147,400);
			spawnpoint[spawnpoint.size] = (3009,2663,424);
			spawnpoint[spawnpoint.size] = (2799,2946,395);
			spawnpoint[spawnpoint.size] = (4036,3602,432);
		}
		break;
		case "mp_derail":
		if(level.edit == 0)
		{
			spawnpoint[spawnpoint.size] = (981,3216,192);
			spawnpoint[spawnpoint.size] = (1042,3240,192);
			spawnpoint[spawnpoint.size] = (914,1633,198);
			spawnpoint[spawnpoint.size] = (933,1567,176);
			spawnpoint[spawnpoint.size] = (2760,819,186);
			spawnpoint[spawnpoint.size] = (2987,823,188);
			spawnpoint[spawnpoint.size] = (2541,3475,247);
			spawnpoint[spawnpoint.size] = (1695,2781,129);
		}
		if(level.edit == 1)
		{
			spawnpoint[spawnpoint.size] = (779,-3849,143);
			spawnpoint[spawnpoint.size] = (848,-3842,141);
			spawnpoint[spawnpoint.size] = (925,-3820,142);
			spawnpoint[spawnpoint.size] = (843,-4019,139);
			spawnpoint[spawnpoint.size] = (576,-4018,125);
			spawnpoint[spawnpoint.size] = (1063,-4184,136);
		}
		break;
		case "mp_nightshift": 
		if(level.edit == 0)
		{
			spawnpoint[spawnpoint.size] = (-103,-1894,11);
			spawnpoint[spawnpoint.size] = (48,927,91);
			spawnpoint[spawnpoint.size] = (48,805,91);
			spawnpoint[spawnpoint.size] = (-1856,-2192,11);
			spawnpoint[spawnpoint.size] = (-1803,-2203,16);
			spawnpoint[spawnpoint.size] = (-323,-713,7);
			spawnpoint[spawnpoint.size] = (-364,-538,7);
		}
		else if(level.edit == 1)
		{
			spawnpoint[spawnpoint.size] = (-610,-1922,16);
			spawnpoint[spawnpoint.size] = (1904,-1258,3);
			spawnpoint[spawnpoint.size] = (-205,-745,16);
			spawnpoint[spawnpoint.size] = (-107,672,24);
			spawnpoint[spawnpoint.size] = (-6,593,24);
			spawnpoint[spawnpoint.size] = (-611,-1873,16);
		}
		else if(level.edit == 2)
		{
			spawnpoint[spawnpoint.size] = (1963,-3377,8);
			spawnpoint[spawnpoint.size] = (1740,-3359,16);
			spawnpoint[spawnpoint.size] = (1666,-3366,16);
			spawnpoint[spawnpoint.size] = (1599,-3368,16);
		}
		break;
		case "mp_estate":
		{
			spawnpoint[spawnpoint.size] = (-2602,-2388,-490);
			spawnpoint[spawnpoint.size] = (-2698,-2395,-491);
			spawnpoint[spawnpoint.size] = (-2771,-2384,-489);
			spawnpoint[spawnpoint.size] = (-4069,-5,106);
			spawnpoint[spawnpoint.size] = (-4164,-81,100);
			spawnpoint[spawnpoint.size] = (-2316,-2096,-610);
		}
		break;
		case "mp_favela":
		if(level.edit == 0)
		{
			spawnpoint[spawnpoint.size] = (2951,3108,296);
			spawnpoint[spawnpoint.size] = (2892,3025,296);
			spawnpoint[spawnpoint.size] = (2699,3120,296);
		}
		if(level.edit == 1)
		{
			spawnpoint[spawnpoint.size] = (-4460,549,-854);
			spawnpoint[spawnpoint.size] = (-4764,1051,-877);
			spawnpoint[spawnpoint.size] = (-4945,1542,-901);
			spawnpoint[spawnpoint.size] = (-5048,2363,-935);
			spawnpoint[spawnpoint.size] = (-5257,2878,-966);
		}
		if(level.edit == 2)
		{
			spawnpoint[spawnpoint.size] = (-1875,-7895,-820);
			spawnpoint[spawnpoint.size] = (-2368,-7172,-820);
			spawnpoint[spawnpoint.size] = (-2979,-7269,-820);
			spawnpoint[spawnpoint.size] = (-2591,-7756,-820);
			spawnpoint[spawnpoint.size] = (-4692,-9608,-418);
		}
		break;
		case "mp_invasion":
		{
			spawnpoint[spawnpoint.size] = (-607,41,264);
			spawnpoint[spawnpoint.size] = (-539,40,264);
			spawnpoint[spawnpoint.size] = (-366,417,348);
		}
		break;
		case "mp_checkpoint":
		{
			spawnpoint[spawnpoint.size] = (2584,5298,-15);
			spawnpoint[spawnpoint.size] = (2280,5295,-15);
			spawnpoint[spawnpoint.size] = (-42,3239,16);
			spawnpoint[spawnpoint.size] = (-39,3020,16);
			spawnpoint[spawnpoint.size] = (4030,2730,-28);
			spawnpoint[spawnpoint.size] = (4083,3150,-28);
			spawnpoint[spawnpoint.size] = (-68,2785,19);
			spawnpoint[spawnpoint.size] = (4308,2511,3);
		}
		break;
		case "mp_subbase":
		{
			spawnpoint[spawnpoint.size] = (-422,-6429,16);
			spawnpoint[spawnpoint.size] = (-339,-6430,16);
			spawnpoint[spawnpoint.size] = (-252,-6434,16);
		}
		break;
		case "mp_trailerpark":
		{
			spawnpoint[spawnpoint.size] = (2772,-2118,16);
			spawnpoint[spawnpoint.size] = (2785,-2068,16);
			spawnpoint[spawnpoint.size] = (2754,-1988,17);
			spawnpoint[spawnpoint.size] = (-1299,-2064,16);
			spawnpoint[spawnpoint.size] = (-1176,-1980,16);
			spawnpoint[spawnpoint.size] = (-1203,-2142,16);
		}
		break;
		case "mp_rundown":
		{
			spawnpoint[spawnpoint.size] = (445,1859,121);
			spawnpoint[spawnpoint.size] = (1581,2081,-5);
			spawnpoint[spawnpoint.size] = (-86,2560,146);
			spawnpoint[spawnpoint.size] = (117,2234,213);
			spawnpoint[spawnpoint.size] = (514,3748,41);
		}
		break;
		case "mp_compact":
		{
			spawnpoint[spawnpoint.size] = (3764,2701,285);
			spawnpoint[spawnpoint.size] = (1050,2000,116);
			spawnpoint[spawnpoint.size] = (1072,1943,133);
			spawnpoint[spawnpoint.size] = (3763,2759,285);
		}
		break;
		case "mp_strike":
		{
			spawnpoint[spawnpoint.size] = (-3888,1311,17);
			spawnpoint[spawnpoint.size] = (-3879,1459,16);
		}
		break;
		case "mp_complex":
		{
			spawnpoint[spawnpoint.size] = (197,-1142,416);
			spawnpoint[spawnpoint.size] = (-577,692,402);
			spawnpoint[spawnpoint.size] = (1369,744,395);
			spawnpoint[spawnpoint.size] = (-2105,-164,412);
			spawnpoint[spawnpoint.size] = (-2076,-426,412);
			spawnpoint[spawnpoint.size] = (-1925,-1220,412);
		}
		break;
		case "mp_abandon":
		{
			spawnpoint[spawnpoint.size] = (-1249,1119,3);
			spawnpoint[spawnpoint.size] = (-2064,1635,3);
			spawnpoint[spawnpoint.size] = (-1143,1217,3);
			spawnpoint[spawnpoint.size] = (-842,2015,3);
			spawnpoint[spawnpoint.size] = (-290,3437,3);
			spawnpoint[spawnpoint.size] = (-829,4036,3);
			spawnpoint[spawnpoint.size] = (-2844,5341,3);
			spawnpoint[spawnpoint.size] = (-3144,5303,3);
			spawnpoint[spawnpoint.size] = (-3674,4526,3);
			spawnpoint[spawnpoint.size] = (-4415,3575,3);
			spawnpoint[spawnpoint.size] = (-4112,1326,1);
			spawnpoint[spawnpoint.size] = (-3793,1030,1);
			spawnpoint[spawnpoint.size] = (-3395,777,1);
		}
		break;
		case "mp_vacant":
		{
			spawnpoint[spawnpoint.size] = (-1768,1765,-87);
			spawnpoint[spawnpoint.size] = (-1830,1769,-87);
			spawnpoint[spawnpoint.size] = (-734,1782,-97);
			spawnpoint[spawnpoint.size] = (68,-1375,-88);
			spawnpoint[spawnpoint.size] = (494,-1189,-85);
			spawnpoint[spawnpoint.size] = (-972,-1366,-91);
		}
		break;
		case "mp_storm":
		{
			spawnpoint[spawnpoint.size] = (5136,-1295,48);
			spawnpoint[spawnpoint.size] = (5120,-1105,48);
			spawnpoint[spawnpoint.size] = (4957,851,-47);
			spawnpoint[spawnpoint.size] = (4787,794,-48);
			spawnpoint[spawnpoint.size] = (2851,-1777,8);
			spawnpoint[spawnpoint.size] = (4210,-837,8);
		}
		break;
		case "mp_fuel2":
		{
			spawnpoint[spawnpoint.size] = (-5488,3207,-125);
			spawnpoint[spawnpoint.size] = (-5784,3263,-125);
			spawnpoint[spawnpoint.size] = (-6124,3322,-125);
			spawnpoint[spawnpoint.size] = (-6633,3433,-128);
			spawnpoint[spawnpoint.size] = (-5712,3658,-125);
			spawnpoint[spawnpoint.size] = (-5319,3649,-125);
		}
		break;
		case "mp_overgrown":
		{
			spawnpoint[spawnpoint.size] = (-2766,-6210,-143);
			spawnpoint[spawnpoint.size] = (-2773,-6079,-143);
			spawnpoint[spawnpoint.size] = (-2766,-5974,-143);
			spawnpoint[spawnpoint.size] = (-2764,-5577,-144);
			spawnpoint[spawnpoint.size] = (-1999,-6752,-143);
			spawnpoint[spawnpoint.size] = (-1461,-6547,-144);
			spawnpoint[spawnpoint.size] = (-1169,-6295,-144);
			spawnpoint[spawnpoint.size] = (-879,-6137,-150);
			spawnpoint[spawnpoint.size] = (-1522,-6546,-144);
		}
		break;
		case "mp_crash":
		{
			spawnpoint[spawnpoint.size] = (-908,-3844,61);
			spawnpoint[spawnpoint.size] = (-1052,-3826,61);
			spawnpoint[spawnpoint.size] = (-1156,-3821,62);
			spawnpoint[spawnpoint.size] = (-426,-1637,88);
			spawnpoint[spawnpoint.size] = (-472,-1567,93);
			spawnpoint[spawnpoint.size] = (-436,-1701,88);
		}
		break;
		case "estate":
		{
			spawnpoint[spawnpoint.size] = (946,147,184);
			spawnpoint[spawnpoint.size] = (515,1031,168);
			spawnpoint[spawnpoint.size] = (469,1038,168);
			spawnpoint[spawnpoint.size] = (325,-537,23);
			spawnpoint[spawnpoint.size] = (269,-529,23);
			spawnpoint[spawnpoint.size] = (834,653,33);
		}
		break;
		case "arcadia":
		{
			spawnpoint[spawnpoint.size] = (2797,-6722,2388);
			spawnpoint[spawnpoint.size] = (2758,-6797,2388);
			spawnpoint[spawnpoint.size] = (2726,-6861,2388);
			spawnpoint[spawnpoint.size] = (5439,-8426,2385);
			spawnpoint[spawnpoint.size] = (5482,-8351,2388);
			spawnpoint[spawnpoint.size] = (5533,-8248,2388);
		}
		break;
		case "airport":
		{
			spawnpoint[spawnpoint.size] = (-4823,3246,107);
			spawnpoint[spawnpoint.size] = (-4792,2698,-52);
			spawnpoint[spawnpoint.size] = (-5588,3342,-52);
		}
		break;
		case "co_hunted":
		{
			spawnpoint[spawnpoint.size] = (3206,8298,196);
			spawnpoint[spawnpoint.size] = (1719,9493,239);
			spawnpoint[spawnpoint.size] = (4378,9375,147);
			spawnpoint[spawnpoint.size] = (4656,8803,131);
		}
		break;
		case "oilrig":
		{
			spawnpoint[spawnpoint.size] = (1080,1205,-1383);
			spawnpoint[spawnpoint.size] = (1069,1026,-1379);
			spawnpoint[spawnpoint.size] = (1006,790,-1383);
			spawnpoint[spawnpoint.size] = (820,619,-1383);
		}
		break;
		case "mp_nuked":
		{
			spawnpoint[spawnpoint.size] = (-167,-503,-49);
			spawnpoint[spawnpoint.size] = (279,-482,-49);
			spawnpoint[spawnpoint.size] = (2011,232,-52);
			spawnpoint[spawnpoint.size] = (1836,607,-52);
			spawnpoint[spawnpoint.size] = (-1829,578,-53);
			spawnpoint[spawnpoint.size] = (-1966,259,-53);
		}
		break;
		case "invasion":
		{
			spawnpoint[spawnpoint.size] = (-199,5480,2334);
			spawnpoint[spawnpoint.size] = (-188,5328,2333);
			spawnpoint[spawnpoint.size] = (-195,5039,2382);
			spawnpoint[spawnpoint.size] = (384,4131,2313);
			spawnpoint[spawnpoint.size] = (851,4028,2306);
			spawnpoint[spawnpoint.size] = (946,4014,2305);
		}
		break;
	}
	spawnpoint = spawnpoint[randomInt(spawnpoint.size)];
	return Spawnpoint;
}

GetHeadSpawnModelZombie( )
{
	/* 
	0 = Arabian Models 
	1 = Arctic Models 
	2 = Airborne Models
	3 = Militia Models
	0 = TF141 Forest Models 
	1 = TF141 Desert Models 
	2 = TF141 Arctic Models
	3 = US Army Models
	4 = Seal Udt Models
	*/
	rModel = undefined;
	switch(level.zombieModel)
	{
		case 0:
		switch(randomInt(5))
		{
			case 0: rModel = "head_opforce_arab_a";
			break;
			case 1: rModel = "head_opforce_arab_b";
			break;
			case 2: rModel = "head_opforce_arab_c";
			break;
			case 3: rModel = "head_opforce_arab_d_hat";
			break;
			case 4: rModel = "head_opforce_arab_e";
			break;
		}
		break;
		case 1:
		switch(randomInt(4))
		{
			case 0: rModel = "head_opforce_arctic_a";
			break;
			case 1: rModel = "head_opforce_arctic_b";
			break;
			case 2: rModel = "head_opforce_arctic_c";
			break;
			case 3: rModel = "head_opforce_arctic_d";
			break;
		}
		break;
		case 2:
		switch(randomInt(5))
		{
			case 0: rModel = "head_airborne_a";
			break;
			case 1: rModel = "head_airborne_b";
			break;
			case 2: rModel = "head_airborne_c";
			break;
			case 3: rModel = "head_airborne_d";
			break;
			case 4: rModel = "head_airborne_e";
			break;
		}
		break;
		case 3:
		switch(randomInt(4))
		{
			case 0: rModel = "head_militia_ba_blk";
			break;
			case 1: rModel = "head_militia_bb_blk_hat";
			break;
			case 2: rModel = "head_militia_bc_blk";
			break;
			case 3: rModel = "head_militia_bd_blk";
			break;
		}
		break;
	}
	return rModel;
}

GetBossSpawnModel( )
{
	/* 
	0 = Arabian Models 
	1 = Arctic Models 
	2 = Airborne Models
	3 = Militia Models
	0 = TF141 Forest Models 
	1 = TF141 Desert Models 
	2 = TF141 Arctic Models
	3 = US Army Models
	4 = Seal Udt Models
	*/
	rModel = undefined;
	switch(level.zombieModel)
	{
		case 0:
		rModel = "mp_body_riot_op_arab";
		break;
		case 1:
		rModel = "mp_body_riot_op_arctic";
		break;
		case 2:
		rModel = "mp_body_riot_op_airborne";
		break;
		case 3:
		rModel = "mp_body_riot_op_militia";
		break;
	}
	return rModel;
}

GetBossHeadSpawnModel( )
{
	/* 
	0 = Arabian Models 
	1 = Arctic Models 
	2 = Airborne Models
	3 = Militia Models
	0 = TF141 Forest Models 
	1 = TF141 Desert Models 
	2 = TF141 Arctic Models
	3 = US Army Models
	4 = Seal Udt Models
	*/
	rModel = undefined;
	switch(level.zombieModel)
	{
		case 0:
		rModel = "head_riot_op_arab";
		break;
		case 1:
		rModel = "head_riot_op_arctic";
		break;
		case 2:
		rModel = "head_riot_op_airborne";
		break;
		case 3:
		rModel = "head_riot_op_militia";
		break;
	}
	return rModel;
}

GetCrawlerHeadModel( )
{
	level endon("game_ended");
	rModel = "";
	switch( getDvar("mapname") )
	{
		case "mp_underpass": rModel = "head_op_sniper_ghillie_forest";
		break;
		case "mp_quarry": rModel = "head_allies_sniper_ghillie_desert";
		break;
		case "mp_afghan": rModel = "head_allies_sniper_ghillie_desert";
		break;
		case "mp_strike": rModel = "head_allies_sniper_ghillie_desert";
		break;
		case "mp_rust": rModel = "head_allies_sniper_ghillie_desert";
		break;
		case "mp_boneyard": rModel = "head_allies_sniper_ghillie_desert";
		break;
		case "mp_trailerpark": rModel = "head_opforce_arab_d_hat";
		break;
		case "mp_derail": rModel = "head_allies_sniper_ghillie_arctic";
		break;
		case "mp_compact": rModel = "head_opforce_arctic_c";
		break;
		case "mp_highrise": rModel = "head_allies_sniper_ghillie_urban";
		break;
		case "mp_terminal": rModel = "head_allies_sniper_ghillie_urban";
		break;
		case "mp_complex": rModel = "head_allies_sniper_ghillie_urban";
		break;
		case "mp_brecourt": rModel = "head_allies_sniper_ghillie_forest";
		break;
		case "mp_nightshift": rModel = "head_allies_sniper_ghillie_urban";
		break;
		case "mp_estate": rModel = "head_allies_sniper_ghillie_forest";
		break;
		case "mp_favela": rModel = "head_allies_sniper_ghillie_urban";
		break;
		case "mp_invasion": rModel = "head_allies_sniper_ghillie_urban";
		break;
		case "mp_checkpoint": rModel = "head_allies_sniper_ghillie_urban";
		break;
		case "mp_subbase": rModel = "head_allies_sniper_ghillie_urban";
		break;
		case "mp_rundown": rModel = "head_allies_sniper_ghillie_desert";
		break;
		case "mp_abandon": rModel = "head_allies_sniper_ghillie_urban";
		break;
		case "mp_vacant": rModel = "head_allies_sniper_ghillie_urban";
		break;
		case "mp_storm": rModel = "head_allies_sniper_ghillie_urban";
		break;
		case "mp_fuel2": rModel = "head_allies_sniper_ghillie_desert";
		break;
		case "mp_overgrown": rModel = "head_allies_sniper_ghillie_forest";
		break;
		case "mp_crash": rModel = "head_allies_sniper_ghillie_urban";
		break;
		case "estate": rModel = "head_allies_sniper_ghillie_forest";
		break;
		case "arcadia": rModel = "head_allies_sniper_ghillie_urban";
		break;
		case "mp_nuked": rModel = "head_allies_sniper_ghillie_urban";
		break;
		case "invasion": rModel = "head_allies_sniper_ghillie_urban";
		break;
	}
	return rModel;
}

GetCrawlerSpawnModel( )
{
	level endon("game_ended");
	rModel = "";
	switch( getDvar("mapname") )
	{
		case "mp_underpass": rModel = "mp_body_op_sniper_ghillie_forest";
		break;
		case "mp_quarry": rModel = "mp_body_ally_sniper_ghillie_desert";
		break;
		case "mp_afghan": rModel = "mp_body_ally_sniper_ghillie_desert";
		break;
		case "mp_strike": rModel = "mp_body_ally_sniper_ghillie_desert";
		break;
		case "mp_rust": rModel = "mp_body_ally_sniper_ghillie_desert";
		break;
		case "mp_boneyard": rModel = "mp_body_ally_sniper_ghillie_desert";
		break;
		case "mp_trailerpark": rModel = "mp_body_opforce_arab_lmg_a";
		break;
		case "mp_derail": rModel = "mp_body_ally_sniper_ghillie_arctic";
		break;
		case "mp_compact": rModel = "mp_body_opforce_arctic_lmg_c";
		break;
		case "mp_highrise": rModel = "mp_body_ally_sniper_ghillie_urban";
		break;
		case "mp_terminal": rModel = "mp_body_ally_sniper_ghillie_urban";
		break;
		case "mp_complex": rModel = "mp_body_ally_sniper_ghillie_urban";
		break;
		case "mp_brecourt": rModel = "mp_body_ally_sniper_ghillie_forest";
		break;
		case "mp_nightshift": rModel = "mp_body_op_sniper_ghillie_urban";
		break;
		case "mp_estate": rModel = "mp_body_op_sniper_ghillie_forest";
		break;
		case "mp_favela": rModel = "mp_body_ally_sniper_ghillie_urban";
		break;
		case "mp_invasion": rModel = "mp_body_op_sniper_ghillie_urban";
		break;
		case "mp_checkpoint": rModel = "mp_body_ally_sniper_ghillie_urban";
		break;
		case "mp_subbase": rModel = "mp_body_ally_sniper_ghillie_urban";
		break;
		case "mp_rundown": rModel = "mp_body_ally_sniper_ghillie_desert";
		break;
		case "mp_abandon": rModel = "mp_body_ally_sniper_ghillie_urban";
		break;
		case "mp_vacant": rModel = "mp_body_op_sniper_ghillie_urban";
		break;
		case "mp_storm": rModel = "mp_body_op_sniper_ghillie_urban";
		break;
		case "mp_fuel2": rModel = "mp_body_ally_sniper_ghillie_desert";
		break;
		case "mp_overgrown": rModel = "mp_body_op_sniper_ghillie_forest";
		break;
		case "mp_crash": rModel = "mp_body_op_sniper_ghillie_urban";
		break;
		case "estate": rModel = "mp_body_op_sniper_ghillie_forest";
		break;
		case "arcadia": rModel = "mp_body_op_sniper_ghillie_urban";
		break;
		case "mp_nuked": rModel = "mp_body_op_sniper_ghillie_urban";
		break;
		case "invasion": rModel = "mp_body_op_sniper_ghillie_urban";
		break;
	}
	return rModel;
}

GetSpawnModel( )
{
	/* 
	0 = Arabian Models 
	1 = Arctic Models 
	2 = Airborne Models
	3 = Militia Models
	0 = TF141 Forest Models 
	1 = TF141 Desert Models 
	2 = TF141 Arctic Models
	3 = US Army Models
	4 = Seal Udt Models
	*/
	rModel = undefined;
	switch(level.zombieModel)
	{
		case 0:
		switch(randomInt(4))
		{
			case 0: rModel = "mp_body_opforce_arab_lmg_a";
			break;
			case 1: rModel = "mp_body_opforce_arab_shotgun_a";
			break;
			case 2: rModel = "mp_body_opforce_arab_smg_a";
			break;
			case 3: rModel = "mp_body_opforce_arab_assault_a";
			break;
		}
		break;
		case 1:
		switch(randomInt(12))
		{
			case 0: rModel = "mp_body_opforce_arctic_lmg_c";
			break;
			case 1: rModel = "mp_body_opforce_arctic_assault_b";
			break;
			case 2: rModel = "mp_body_opforce_arctic_assault_c";
			break;
			case 3: rModel = "mp_body_opforce_arctic_lmg";
			break;
			case 4: rModel = "mp_body_opforce_arctic_lmg_b";
			break;
			case 5: rModel = "mp_body_opforce_arctic_shotgun";
			break;
			case 6: rModel = "mp_body_opforce_arctic_shotgun_b";
			break;
			case 7: rModel = "mp_body_opforce_arctic_shotgun_c";
			break;
			case 8: rModel = "mp_body_opforce_arctic_smg";
			break;
			case 9: rModel = "mp_body_opforce_arctic_smg_b";
			break;
			case 10: rModel = "mp_body_opforce_arctic_smg_c";
			break;
			case 11: rModel = "mp_body_opforce_arctic_assault_a";
			break;
		}
		break;
		case 2:
		switch(randomInt(12))
		{
			case 0: rModel = "mp_body_airborne_assault_a";
			break;
			case 1: rModel = "mp_body_airborne_assault_b";
			break;
			case 2: rModel = "mp_body_airborne_assault_c";
			break;
			case 3: rModel = "mp_body_airborne_lmg";
			break;
			case 4: rModel = "mp_body_airborne_lmg_b";
			break;
			case 5: rModel = "mp_body_airborne_lmg_c";
			break;
			case 6: rModel = "mp_body_airborne_shotgun";
			break;
			case 7: rModel = "mp_body_airborne_shotgun_b";
			break;
			case 8: rModel = "mp_body_airborne_shotgun_c";
			break;
			case 9: rModel = "mp_body_airborne_smg";
			break;
			case 10: rModel = "mp_body_airborne_smg_b";
			break;
			case 11: rModel = "mp_body_airborne_smg_c";
			break;
		}
		break;
		case 3:
		switch(randomInt(11))
		{
			case 0: rModel = "mp_body_militia_assault_aa_blk";
			break;
			case 1: rModel = "mp_body_militia_assault_aa_wht";
			break;
			case 2: rModel = "mp_body_militia_assault_ab_blk";
			break;
			case 3: rModel = "mp_body_militia_assault_ac_blk";
			break;
			case 4: rModel = "mp_body_militia_lmg_aa_blk";
			break;
			case 5: rModel = "mp_body_militia_lmg_ab_blk";
			break;
			case 6: rModel = "mp_body_militia_lmg_ac_blk";
			break;
			case 7: rModel = "mp_body_militia_smg_aa_blk";
			break;
			case 8: rModel = "mp_body_militia_smg_aa_wht";
			break;
			case 9: rModel = "mp_body_militia_smg_ab_blk";
			break;
			case 10: rModel = "mp_body_militia_smg_ac_blk";
			break;
		}
		break;
	}
	return rModel;
}

FriendlyModels()
{
	/* 
	0 = Arabian Models 
	1 = Arctic Models 
	2 = Airborne Models
	3 = Militia Models
	0 = TF141 Forest Models 
	1 = TF141 Desert Models 
	2 = TF141 Arctic Models
	3 = US Army Models
	4 = Seal Udt Models
	*/
	fModel = undefined;
	switch(level.friendlyModel)
	{
		case 0:
		switch(randomInt(5))
		{
			case 0: fModel = "mp_body_forest_tf141_assault_a";
			break;
			case 1: fModel = "mp_body_forest_tf141_assault_b";
			break;
			case 2: fModel = "mp_body_forest_tf141_lmg";
			break;
			case 3: fModel = "mp_body_forest_tf141_smg";
			break;
			case 4: fModel = "mp_body_forest_tf141_shotgun";
			break;
		}
		break;
		case 1:
		switch(randomInt(5))
		{
			case 0: fModel = "mp_body_desert_tf141_assault_a";
			break;
			case 1: fModel = "mp_body_desert_tf141_lmg";
			break;
			case 2: fModel = "mp_body_desert_tf141_smg";
			break;
			case 3: fModel = "mp_body_desert_tf141_shotgun";
			break;
			case 4: fModel = "mp_body_desert_tf141_assault_b";
			break;
		}
		break;
		case 2:
		switch(randomInt(5))
		{
			case 0: fModel = "mp_body_tf141_assault_a";
			break;
			case 1: fModel = "mp_body_tf141_assault_b";
			break;
			case 2: fModel = "mp_body_tf141_lmg";
			break;
			case 3: fModel = "mp_body_tf141_smg";
			break;
			case 4: fModel = "mp_body_tf141_shotgun";
			break;
		}
		break;
		case 3:
		switch(randomInt(12))
		{
			case 0: fModel = "mp_body_us_army_lmg";
			break;
			case 1: fModel = "mp_body_us_army_lmg_b";
			break;
			case 2: fModel = "mp_body_us_army_lmg_c";
			break;
			case 3: fModel = "mp_body_us_army_assault_a";
			break;
			case 4: fModel = "mp_body_us_army_assault_b";
			break;
			case 5: fModel = "mp_body_us_army_assault_c";
			break;
			case 6: fModel = "mp_body_us_army_shotgun";
			break;
			case 7: fModel = "mp_body_us_army_shotgun_b";
			break;
			case 8: fModel = "mp_body_us_army_shotgun_c";
			break;
			case 9: fModel = "mp_body_us_army_smg";
			break;
			case 10: fModel = "mp_body_us_army_smg_b";
			break;
			case 11: fModel = "mp_body_us_army_smg_c";
			break;
		}
		break;
		case 4:
		switch(randomInt(4))
		{
			case 0: fModel = "mp_body_seal_udt_lmg";
			break;
			case 1: fModel = "mp_body_seal_udt_assault_a";
			break;
			case 2: fModel = "mp_body_seal_udt_assault_b";
			break;
			case 3: fModel = "mp_body_seal_udt_smg";
			break;
		}
		break;
	}
	return fModel;
}

GetHeadSpawnModel( )
{
	/* 
	0 = Arabian Models 
	1 = Arctic Models 
	2 = Airborne Models
	3 = Militia Models
	0 = TF141 Forest Models 
	1 = TF141 Desert Models 
	2 = TF141 Arctic Models
	3 = US Army Models
	4 = Seal Udt Models
	*/
	rModel = undefined;
	switch(level.friendlyModel)
	{
		case 0:
		switch(randomInt(4))
		{
			case 0: rModel = "head_tf141_forest_a";
			break;
			case 1: rModel = "head_tf141_forest_b";
			break;
			case 2: rModel = "head_tf141_forest_c";
			break;
			case 3: rModel = "head_tf141_forest_d";
			break;
		}
		break;
		case 1:
		switch(randomInt(4))
		{
			case 0: rModel = "head_tf141_desert_a";
			break;
			case 1: rModel = "head_tf141_desert_b";
			break;
			case 2: rModel = "head_tf141_desert_c";
			break;
			case 3: rModel = "head_tf141_desert_d";
			break;
		}
		break;
		case 2:
		switch(randomInt(4))
		{
			case 0: rModel = "head_tf141_arctic_a";
			break;
			case 1: rModel = "head_tf141_arctic_b";
			break;
			case 2: rModel = "head_tf141_arctic_c";
			break;
			case 3: rModel = "head_tf141_arctic_d";
			break;
		}
		break;
		case 3:
		switch(randomInt(5))
		{
			case 0: rModel = "head_us_army_a";
			break;
			case 1: rModel = "head_us_army_b";
			break;
			case 2: rModel = "head_us_army_c";
			break;
			case 3: rModel = "head_us_army_d";
			break;
			case 4: rModel = "head_us_army_f";
			break;
		}
		break;
		case 4:
		switch(randomInt(4))
		{
			case 0: rModel = "head_seal_udt_a";
			break;
			case 1: rModel = "head_seal_udt_c";
			break;
			case 2: rModel = "head_seal_udt_d";
			break;
			case 3: rModel = "head_seal_udt_e";
			break;
		}
		break;
	}
	return rModel;
}

SpawnWeapon(weapName, coords, angles)
{
	point = spawn("script_origin", coords);
	weap = SpawnWeap(weapName, point.origin);
	if(isDefined(angles))
	{
		weap.angles = angles;
	}
	weap linkto( point );
	return point;
}

SpawnWeap(weapName, coords)
{
	return spawn( "weapon_" + weapName, coords + (0,0,5) );
}