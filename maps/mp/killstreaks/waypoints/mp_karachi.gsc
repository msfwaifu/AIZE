#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include AImod\_OtherFunctions;

Init(bot)
{
	self endon("died");
	nextWaypoint = spawnStruct();
	while(1)
	{
		nextWaypoint.origin = Waypoints();
		wait 20;
		self.allowfire = "false";
		wait 1;
		movetoLoc = VectorToAngles( nextWaypoint.origin - self.origin );
		self RotateTo((0,movetoLoc[1],0), 0.5);
		if(distance(self.origin, nextWaypoint.origin) >= 300 && self.pers["type"] == "smg")
		{
			self scriptModelPlayAnim("pb_sprint");
			self MoveTo(nextWaypoint.origin, (distance(self.origin, nextWaypoint.origin) / 150));
		}
		else if(distance(self.origin, nextWaypoint.origin) <= 299 && self.pers["type"] == "smg")
		{
			self scriptModelPlayAnim("pb_stand_shoot_walk_forward");
			self MoveTo(nextWaypoint.origin, (distance(self.origin, nextWaypoint.origin) / 50));
		}
		if(distance(self.origin, nextWaypoint.origin) >= 300 && self.pers["type"] == "lmg")
		{
			self scriptModelPlayAnim("pb_sprint_mg");
			self MoveTo(nextWaypoint.origin, (distance(self.origin, nextWaypoint.origin) / 150));
		}
		else if(distance(self.origin, nextWaypoint.origin) <= 299 && self.pers["type"] == "lmg")
		{
			self scriptModelPlayAnim("pb_walk_forward_mg");
			self MoveTo(nextWaypoint.origin, (distance(self.origin, nextWaypoint.origin) / 50));
		}
		while(self.origin != nextWaypoint.origin)
		{
			wait 0.05;
		}
		if(self.pers["type"] == "smg")
			self scriptModelPlayAnim("pb_stand_alert");
		if(self.pers["type"] == "lmg")
			self scriptModelPlayAnim("pb_stand_alert_mg");
		self.allowfire = "true";
		self notify("Clamp");
	}
}

InitHeli(player)
{
	self endon("heli_leaving");
	while(1)
	{
		wait 15;
		self Vehicle_SetSpeed(50,70);
		self setvehgoalpos(WaypointsHeli(player),1);
	}
}

Waypoints()
{
	bWaypoint = undefined;
	switch(randomInt(10))
	{
		case 0:
		bWaypoint = (2416,3496,11);
		break;
		case 1:
		bWaypoint = (2431,3047,11);
		break;
		case 2:
		bWaypoint = (2424,2576,11);
		break;
		case 3:
		bWaypoint = (2423,2146,14);
		break;
		case 4:
		bWaypoint = (2681,2722,3);
		break;
		case 5:
		bWaypoint = (2422,1957,3);
		break;
		case 6:
		bWaypoint = (2730,2644,8);
		break;
		case 7:
		bWaypoint = (2257,3660,-10);
		break;
		case 8:
		bWaypoint = (2440,3725,-19);
		break;
		case 9:
		bWaypoint = (2605,2810,3);
		break;
	}
	return bWaypoint;
}

WaypointsHeli(player)
{
	hWaypoint = undefined;
	switch(randomInt(5))
	{
		case 0:
		hWaypoint = (2334,3560,596);
		break;
		case 1:
		hWaypoint = (1316,3101,599);
		break;
		case 2:
		hWaypoint = (3055,2878,512);
		break;
		case 3:
		hWaypoint = (1680,2405,519);
		break;
		case 4:
		hWaypoint = player.origin+(0,0,500);
		break;
	}
	return hWaypoint;
}