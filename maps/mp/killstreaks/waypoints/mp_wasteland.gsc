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
	switch(randomInt(4))
	{
		case 0:
		hWaypoint = (9855,6719,808);
		break;
		case 1:
		hWaypoint = (10366,6509,826);
		break;
		case 2:
		hWaypoint = (10448,6747,2227);
		break;
		case 3:
		hWaypoint = (9788,7139,2150);
		break;
	}
	return hWaypoint;
}