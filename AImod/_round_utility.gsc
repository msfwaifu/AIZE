#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include AImod\_OtherFunctions;

SetNormalRound()
{
	if(getDvarInt("z_doa") == 0)
	{
		if(level.BotsForWave >= 350)
		{
			level.BotsForWave = 350;
		}
		if(level.Wave == 6)
		{
			level.BotsForWave = 60;
			level.ZombieHealth = 160;
		}
		else if(level.Wave == 11)
		{
			level.BotsForWave = 110;
			level.ZombieHealth = 210;
		}
		else if(level.Wave == 16)
		{
			level.BotsForWave = 160;
			level.ZombieHealth = 260;
		}
		else if(level.Wave == 21)
		{
			level.BotsForWave = 210;
			level.ZombieHealth = 310;
		}
		else if(level.Wave == 26)
		{
			level.BotsForWave = 260;
			level.ZombieHealth = 360;
		}
	}
	if(getDvarInt("z_doa") >= 1)
	{
		if(level.Wave == 6)
		{
			level.BotsForWave = 120;
			level.ZombieHealth = 160;
		}
		else if(level.Wave == 11)
		{
			level.BotsForWave = 180;
			level.ZombieHealth = 210;
		}
		else if(level.Wave == 16)
		{
			level.BotsForWave = 270;
			level.ZombieHealth = 260;
		}
		else if(level.Wave == 21)
		{
			level.BotsForWave = 340;
			level.ZombieHealth = 310;
		}
		else if(level.Wave == 26)
		{
			level.BotsForWave = 450;
			level.ZombieHealth = 360;
		}
	}
}

SetCrawlerRound()
{
	if(getDvarInt("z_doa") == 0)
	{
		if(level.Wave == 5)
		{
			level.BotsForWave = 50;
			level.ZombieHealth = 100;
			wait 0.05;
		}
		else if(level.Wave == 15)
		{
			level.BotsForWave = 100;
			level.ZombieHealth = 300;
			wait 0.05;
		}
		else if(level.Wave == 25)
		{
			level.BotsForWave = 200;
			level.ZombieHealth = 500;
			wait 0.05;
		}
	}
	if(getDvarInt("z_doa") >= 1)
	{
		if(level.Wave == 5)
		{
			level.BotsForWave = 150;
			level.ZombieHealth = 100;
			wait 0.05;
		}
		else if(level.Wave == 15)
		{
			level.BotsForWave = 250;
			level.ZombieHealth = 300;
			wait 0.05;
		}
		else if(level.Wave == 25)
		{
			level.BotsForWave = 350;
			level.ZombieHealth = 500;
			wait 0.05;
		}
	}
}

SetHellRound()
{
	if(level.Wave == 5)
	{
		level.BotsForWave = 150;
		level.ZombieHealth = 200;
		wait 0.05;
	}
	else if(level.Wave == 15)
	{
		level.BotsForWave = 300;
		level.ZombieHealth = 400;
		wait 0.05;
	}
	else if(level.Wave == 25)
	{
		level.BotsForWave = 450;
		level.ZombieHealth = 600;
		wait 0.05;
	}
}

SetHellBossRound()
{
	if(level.Wave == 10)
	{
		level.BotsForWave = 1;
		wait 0.05;
	}
	else if(level.Wave == 20)
	{
		level.BotsForWave = 3;
		wait 0.05;
	}
	else if(level.Wave == 30)
	{
		level.BotsForWave = 6;
		wait 0.05;
	}
}

SetBotWaveHellRound()
{
	if(level.Wave == 6)
	{
		level.BotsForWave = 40;
		level.ZombieHealth = 255;
	}
	else if(level.Wave == 11)
	{
		level.BotsForWave = 75;
		level.ZombieHealth = 300;
	}
	else if(level.Wave == 16)
	{
		level.BotsForWave = 100;
		level.ZombieHealth = 315;
	}
	else if(level.Wave == 21)
	{
		level.BotsForWave = 200;
		level.ZombieHealth = 435;
	}
	else if(level.Wave == 26)
	{
		level.BotsForWave = 260;
		level.ZombieHealth = 500;
	}
}