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
		hWaypoint = (1546,2887,344);
		break;
		case 1:
		hWaypoint = (874,3624,867);
		break;
		case 2:
		hWaypoint = (1381,3708,599);
		break;
		case 3:
		hWaypoint = (1176,4093,575);
		break;
		case 4:
		hWaypoint = (1181,3582,843);
		break;
	}
	return hWaypoint;
}