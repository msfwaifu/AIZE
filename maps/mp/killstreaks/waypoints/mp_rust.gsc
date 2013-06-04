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
	switch(randomInt(8))
	{
		case 0:
		bWaypoint = (1546,-9911,-175);
		break;
		case 1:
		bWaypoint = (2344,-9757,-253);
		break;
		case 2:
		bWaypoint = (1629,-9450,-185);
		break;
		case 3:
		bWaypoint = (768,-9298,-235);
		break;
		case 4:
		bWaypoint = (-192,-9774,-218);
		break;
		case 5:
		bWaypoint = (-457,-9619,-244);
		break;
		case 6:
		bWaypoint = (2322,-10359,-202);
		break;
		case 7:
		bWaypoint = (3108,-10669,-175);
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
		hWaypoint = (191,-9724,445);
		break;
		case 1:
		hWaypoint = player.origin+(0,0,500);
		break;
		case 2:
		hWaypoint = (2237,-10500,497);
		break;
		case 3:
		hWaypoint = (2872,-9792,490);
		break;
	}
	return hWaypoint;
}