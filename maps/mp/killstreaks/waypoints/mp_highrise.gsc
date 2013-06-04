#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include AImod\_OtherFunctions;

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

WaypointsHeli(player)
{
	hWaypoint = undefined;
	switch(randomInt(5))
	{
		case 0:
		hWaypoint = (-8259,6216,3061);
		break;
		case 1:
		hWaypoint = (-9149,4843,2801);
		break;
		case 2:
		hWaypoint = (-9742,5183,2819);
		break;
		case 3:
		hWaypoint = (-9938,6095,2783);
		break;
		case 4:
		hWaypoint = (-10276,3995,2696);
		break;
	}
	return hWaypoint;
}