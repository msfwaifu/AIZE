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
		hWaypoint = (-2431,1494,355);
		break;
		case 1:
		hWaypoint = (-3524,1425,377);
		break;
		case 2:
		hWaypoint = (-3115,1292,349);
		break;
		case 3:
		hWaypoint = (-3874,1380,499);
		break;
		case 4:
		hWaypoint = (-3172,1446,390);
		break;
	}
	return hWaypoint;
}