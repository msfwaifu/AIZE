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

Waypoints()
{
	bWaypoint = undefined;
	switch(randomInt(10))
	{
		case 0:
		bWaypoint = (879,2971,75);
		break;
		case 1:
		bWaypoint = (488,3360,123);
		break;
		case 2:
		bWaypoint = (541,2821,76);
		break;
		case 3:
		bWaypoint = (383,2590,114);
		break;
		case 4:
		bWaypoint = (967,2422,70);
		break;
		case 5:
		bWaypoint = (1605,2432,61);
		break;
		case 6:
		bWaypoint = (1638,3284,75);
		break;
		case 7:
		bWaypoint = (1103,3075,75);
		break;
		case 8:
		bWaypoint = (799,3310,74);
		break;
		case 9:
		bWaypoint = (567,3126,72);
		break;
	}
	return bWaypoint;
}