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
		hWaypoint = (2849,10326,574);
		break;
		case 1:
		hWaypoint = (3006,11598,520);
		break;
		case 2:
		hWaypoint = (4007,11774,503);
		break;
		case 3:
		hWaypoint = (3434,10723,573);
		break;
		case 4:
		hWaypoint = (2840,10654,684);
		break;
	}
	return hWaypoint;
}