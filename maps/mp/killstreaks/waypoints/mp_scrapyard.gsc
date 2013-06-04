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
		hWaypoint = (892,-3240,538);
		break;
		case 1:
		hWaypoint = (810,-2197,384);
		break;
		case 2:
		hWaypoint = (-91,-2229,509);
		break;
		case 3:
		hWaypoint = (-600,-2416,433);
		break;
	}
	return hWaypoint;
}