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
		bWaypoint = (-2734,-939,-1440);
		break;
		case 1:
		bWaypoint = (-2536,-657,-1440);
		break;
		case 2:
		bWaypoint = (-2114,-981,-1440);
		break;
		case 3:
		bWaypoint = (-3295,-1199,-1406);
		break;
		case 4:
		bWaypoint = (-2834,-392,-1333);
		break;
		case 5:
		bWaypoint = (-3987,583,-1444);
		break;
		case 6:
		bWaypoint = (-3848,239,-1444);
		break;
		case 7:
		bWaypoint = (-3740,1239,-1443);
		break;
		case 8:
		bWaypoint = (-4054,1240,-1440);
		break;
		case 9:
		bWaypoint = (-3147,-291,-1441);
		break;
	}
	return bWaypoint;
}

WaypointsHeli(player)
{
	hWaypoint = undefined;
	switch(randomInt(4))
	{
		case 0:
		hWaypoint = (-2968,-803,-693);
		break;
		case 1:
		hWaypoint = (-3790,89,-926);
		break;
		case 2:
		hWaypoint = (-2518,-1159,-908);
		break;
		case 3:
		hWaypoint = (-4682,2005,-994);
		break;
	}
	return hWaypoint;
}