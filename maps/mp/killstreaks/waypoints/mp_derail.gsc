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
		hWaypoint = (2107,1374,538);
		break;
		case 1:
		hWaypoint = (1793,1484,507);
		break;
		case 2:
		hWaypoint = (2808,1497,521);
		break;
		case 3:
		hWaypoint = (2597,1200,519);
		break;
	}
	return hWaypoint;
}