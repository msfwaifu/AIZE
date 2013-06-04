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
		bWaypoint = (1882,-2589,19);
		break;
		case 1:
		bWaypoint = (1853,-1710,12);
		break;
		case 2:
		bWaypoint = (1553,-2027,18);
		break;
		case 3:
		bWaypoint = (595,-2204,11);
		break;
		case 4:
		bWaypoint = (448,-2064,14);
		break;
		case 5:
		bWaypoint = (17,-1960,11);
		break;
		case 6:
		bWaypoint = (2464,-2345,11);
		break;
		case 7:
		bWaypoint = (2360,-1846,22);
		break;
		case 8:
		bWaypoint = (535,-1868,20);
		break;
		case 9:
		bWaypoint = (-531,-1543,11);
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
		hWaypoint = (2734,-2099,618);
		break;
		case 1:
		hWaypoint = (743,-2109,499);
		break;
		case 2:
		hWaypoint = (1640,-2632,540);
		break;
		case 3:
		hWaypoint = (672,-2379,843);
		break;
		case 4:
		hWaypoint = player.origin+(0,0,500);
		break;
	}
	return hWaypoint;
}