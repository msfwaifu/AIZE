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
		bWaypoint = (-412,-4849,16);
		break;
		case 1:
		bWaypoint = (-259,-4838,16);
		break;
		case 2:
		bWaypoint = (-364,-5308,16);
		break;
		case 3:
		bWaypoint = (-427,-3898,16);
		break;
		case 4:
		bWaypoint = (-252,-3914,16);
		break;
		case 5:
		bWaypoint = (-196,-4394,76);
		break;
		case 6:
		bWaypoint = (-375,-4316,16);
		break;
		case 7:
		bWaypoint = (-339,-6460,48);
		break;
		case 8:
		bWaypoint = (-259,-6458,48);
		break;
		case 9:
		bWaypoint = (-335,-5448,16);
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
		hWaypoint = (157,-5876,698);
		break;
		case 1:
		hWaypoint = (-975,-5241,582);
		break;
		case 2:
		hWaypoint = (-391,-4247,385);
		break;
		case 3:
		hWaypoint = (-412,-5241,502);
		break;
		case 4:
		hWaypoint = player.origin+(0,0,500);
		break;
	}
	return hWaypoint;
}