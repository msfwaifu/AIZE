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
		hWaypoint = (1285,2956,660);
		break;
		case 1:
		hWaypoint = (2324,2787,551);
		break;
		case 2:
		hWaypoint = (2000,2770,558);
		break;
		case 3:
		hWaypoint = (1656,2971,583);
		break;
		case 4:
		hWaypoint = (2716,2586,550);
		break;
	}
	return hWaypoint;
}