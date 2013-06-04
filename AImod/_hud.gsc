#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include AImod\_OtherFunctions;

IntermissionCountdown()
{
	level endon("disconnect");
	level waittill("start_zombie_round");
	for(count = level.IntermissionTimeStart;count > -1;count--)
	{
		wait 1;
		level.IntermissionTime = count;
	}
	wait 2;
	level.activeUAVs["allies"]++;	
	level notify("uav_update");
	//TODO: add timer [Intermission Time]
	for(i=0;i < level.MaxWaves;i++)
	{
		level thread AImod\_Bot::BotMain();
		level waittill("round_ended");

		for( i = 20; i >= 0; i-- )
		{
			level.IntermissionTime = i;
			wait ( 1.0 );
		}
		
		wait ( 1.0 );
	}
}

HudMain()
{
	self endon("disconnect");
	{
		self.MainHud[0] destroy();
		self.MainHud[1] destroy();
		self.MainHud[0] = self createFontString("objective", 1.5);
		self.MainHud[0] setPoint("BOTTOMLEFT", "BOTTOMLEFT", 0, -15);
		self.MainHud[0].label = &"Zombies: ";
		self.MainHud[0].HideWhenInMenu = true;
		self.MainHud[0] thread UpdateZombies(self);
		self.MainHud[0].color = (1,0.5,0.2);
		self.MainHud[0].alpha = 1;
		self.MainHud[1] = self createFontString("objective", 1.5);
		self.MainHud[1] setPoint("BOTTOMLEFT", "BOTTOMLEFT", 0, 0);
		self.MainHud[1] thread UpdateRound(self);
		self.MainHud[1].color = (1,0.5,0.2);
		self.MainHud[1].alpha = 1;
	}
}

UpdateZombies(player)
{
	player endon("death");
	while(1)
	{
		if(AImod\_botUtil::ZombieCount() < 1)
		{
			self.color = (0.3,0.9,0.3);
			self setValue(AImod\_botUtil::ZombieCount());
		}
		else if(AImod\_botUtil::ZombieCount() <= 5)
		{
			self.color = (0.9,0.9,0.3);
			self setValue(AImod\_botUtil::ZombieCount());
		}
		else
		{
			self.color = (1,0.5,0.2);
			self setValue(AImod\_botUtil::ZombieCount());
		}
		level waittill_either("zombie_spawned", "zombie_died");
	}
}

UpdateRound(player)
{
	player endon("death");
	while(1)
	{
		if(level.zState != "intermission")
		{
			self.color = (1,0.5,0.2);
			self.label = &"Wave: ";
			self setValue(level.Wave);
		}
		else if(level.zState == "intermission")
		{
			self.color = (0.3,0.9,0.3);
			self.label = &"Intermission Next Wave: ";
			self setValue(level.Wave + 1);
		}
		level waittill("zombie_round_started_end");
	}
}

HudZombieHealth()
{
	widthofbar = 128;
	x = 10;
	y = 384;
	self.healthnum = newclienthudelem(self);
	self.healthnum.alignX = "left";
	self.healthnum.alignY = "middle";
	self.healthnum.horzAlign = "fullscreen";
	self.healthnum.vertAlign = "fullscreen";
	self.healthnum.x = x + 0;
	self.healthnum.y = y - 12;
	self.healthnum.alpha = 1;
	self.healthnum.color = (1,0.5,0);
	self.healthnum.glowColor = (1,0,0);
	self.healthnum.glowAlpha = 1;
	self.healthnum.sort = 2;
	self.healthnum.fontscale = 1.4;
	self.healthnum.label = &"Health: ";

	self.healthbar = newclienthudelem(self);
	self.healthbar.alignX = "left";
	self.healthbar.alignY = "middle";
	self.healthbar.horzAlign = "fullscreen";
	self.healthbar.vertAlign = "fullscreen";
	self.healthbar.x = x;
	self.healthbar.y = y;
	self.healthbar.alpha = 1;
	self.healthbar.sort = 2;
	self.healthbar.color = (0,1,0);
	self.healthbar setShader("white",128,6);

	self.healthbarback = newclienthudelem(self);
	self.healthbarback.alignX = "left";
	self.healthbarback.alignY = "middle";
	self.healthbarback.horzAlign = "fullscreen";
	self.healthbarback.vertAlign = "fullscreen";
	self.healthbarback.x = x;
	self.healthbarback.y = y;
	self.healthbarback.alpha = 0.5;
	self.healthbarback.sort = 1;
	self.healthbarback.color = (0,0,0);
	self.healthbarback setShader("white",128,10);
	while(1)
	{
		if(!isAlive(self) || !isDefined(self.zombiehealth) || self.zombiehealth.heath < 1)
		{
			self.healthnum.alpha = 0;
			self.healthbar.alpha = 0;
			self.healthbarback.alpha = 0;
			self.healthwarning.alpha = 0;
		}
		wait 0.05;
		{
			self.healthnum.alpha = 1;
			self.healthbar.alpha = 1;
			self.healthbarback.alpha = 0.5;
				warninghealth = int(self.zombiemaxhealth / 3);
			if(self.zombiehealth <= warninghealth)
				self.healthwarning.alpha = 1;
			else
				self.healthwarning.alpha = 0;
			width = int(self.zombiehealth/self.zombiemaxhealth*128);
			if(width <= 0)
				width = 1;
			green = (self.zombiehealth/self.zombiemaxhealth);
				red = (1 - green);
			self.healthbar setShader("white", width, 6);
			self.healthbar.color = (red,green,0);
			self.healthnum setValue(self.zombiehealth);
		}
	}
}

CashHud()
{
	self endon("disconnect");
	self endon("death");
	self.SecondaryHud[0] destroy();
	self.SecondaryHud[0] = self createFontString("hudbig", 0.750);
	self.SecondaryHud[0] setPoint("TOPRIGHT", "TOPRIGHT", 0, 0);
	self.SecondaryHud[0].HideWhenInMenu = true;
	self.SecondaryHud[0].alpha = 1;
	//self.equipmentline = self createIcon( "line_horizontal", 150, 2 );
	//self.equipmentline setPoint("BOTTOMRIGHT", "BOTTOMRIGHT", -35, -40);
	if(getDvarInt("z_doa") == 0) self.SecondaryHud[0].label = &"Money $";
	if(getDvarInt("z_doa") >= 1) self.SecondaryHud[0].label = &"Points: ";
	while(1)
	{
		if(self.money <= 500)
		{
			self.SecondaryHud[0] setValue(self.money);
			self.SecondaryHud[0].color = (1,1,1);
			self.SecondaryHud[0].glowColor = (0.9,0.3,0.3);
			self.SecondaryHud[0].glowAlpha = 0.85;
		}
		else if(self.money <= 1000)
		{
			self.SecondaryHud[0] setValue(self.money);
			self.SecondaryHud[0].color = (1,1,1);
			self.SecondaryHud[0].glowColor = (1,1,0.5);
			self.SecondaryHud[0].glowAlpha = 0.85;
		}
		else
		{
			self.SecondaryHud[0] setValue(self.money);
			self.SecondaryHud[0].color = (1,1,1);
			self.SecondaryHud[0].glowColor = (0.3,0.9,0.3);
			self.SecondaryHud[0].glowAlpha = 0.85;
		}
		self.SecondaryHud[0] ChangeFontScaleOverTime( 0.1 );
		self.SecondaryHud[0].fontScale = 1.0;
		wait 0.1;
		self.SecondaryHud[0] ChangeFontScaleOverTime( 0.1 );
		self.SecondaryHud[0].fontScale = 0.750;
		self waittill("MONEY");
	}
}

IntermissionHud()
{
	self endon("disconnect");
	self.intermissionTimer[0] = self createFontString( "objective", 1.3 );
	self.intermissionTimer[0] setPoint( "TOP", "TOP", 0, 0 );
	self.intermissionTimer[0].color = (1, 0, 0);
	self.intermissionTimer[0].alpha = 1;
	self.intermissionTimer[1] = self createFontString( "hudbig", 0.9 );
	self.intermissionTimer[1] setPoint( "TOP", "TOP", 0, 15 );
	self.intermissionTimer[1].color = (1, 1, 0);
	self.intermissionTimer[1].alpha = 1;
	while(1)
	{
		if(level.IntermissionTime > 0)
		{
			self.intermissionTimer[0] setText(game["strings"]["MP_HORDE_BEGINS_IN"]);
			self.intermissionTimer[0].alpha = 1;
			self.intermissionTimer[1] setValue(level.IntermissionTime);
			self.intermissionTimer[1].alpha = 1;
			self.intermissionTimer[1] ChangeFontScaleOverTime( 0.1 );
			self.intermissionTimer[1].fontScale = 1.2;
			wait 0.1;
			self.intermissionTimer[1] ChangeFontScaleOverTime( 0.1 );
			self.intermissionTimer[1].fontScale = 0.9;
		}
		else
		{
			self.intermissionTimer[1] fadeOverTime( 1.00 );
			self.intermissionTimer[1].alpha = 0;
			wait 1;
			self.intermissionTimer[0] fadeOverTime( 1.00 );
			self.intermissionTimer[0].alpha = 0;
			wait 1;
			self.intermissionTimer[0] setText("");
			self.intermissionTimer[1] setText("");
		}
		wait 0.9;
	}
}

BonusPoints()
{
    self endon("disconnect");
	self endon("death");
	while(1)
	{
	    self.SecondaryHud[1] destroy();
		self.SecondaryHud[1] = self createFontString("objective", 1.5);
		self.SecondaryHud[1] setPoint("TOPRIGHT", "TOPRIGHT", 0, 15);
		self.SecondaryHud[1].foreground = true;
		self.SecondaryHud[1].alpha = 1;	
		self.SecondaryHud[1].HideWhenInMenu = true;
		self.SecondaryHud[1].label = &"Bonus Points: ";
		self.SecondaryHud[1] setValue(self.bonus);
		self.SecondaryHud[1].color = (1,1,1);
		self.SecondaryHud[1].glowColor = (0,1,1);
		self.SecondaryHud[1].glowAlpha = 0.85;
		self.SecondaryHud[1] ChangeFontScaleOverTime( 0.1 );
	    self.SecondaryHud[1].fontScale = 1.65;	
		wait 0.1;
	    self.SecondaryHud[1] ChangeFontScaleOverTime( 0.1 );
	    self.SecondaryHud[1].fontScale = 1.5;
		self waittill("BONUS");
	}
}

PerkHud( shader, color, text )
{
	perksAmount = self.zombieperks - 1;
	MultiplyTimes = 28 * perksAmount;
	self.perktext[perksAmount] = NewClientHudElem( self );
	self.perktext[perksAmount].alignX = "center";
	self.perktext[perksAmount].vertAlign = "middle";
	self.perktext[perksAmount].alignY = "middle";
	self.perktext[perksAmount].horzAlign = "center";
	self.perktext[perksAmount].font = "objective";
	self.perktext[perksAmount].fontscale = 1.5;
	self.perktext[perksAmount].x = 0;
	self.perktext[perksAmount].y = 0;
	self.perktext[perksAmount].foreground = true;
	self.perktext[perksAmount].color = color;
	self.perktext[perksAmount].alpha = 0;
	self.perktext[perksAmount] setText(text);
	self.perkhud[perksAmount] = NewClientHudElem( self );
	self.perkhud[perksAmount].alignX = "center";
	self.perkhud[perksAmount].vertAlign = "middle";
	self.perkhud[perksAmount].alignY = "middle";
	self.perkhud[perksAmount].horzAlign = "center";
	self.perkhud[perksAmount].x = 0;
	self.perkhud[perksAmount].y = 0;
	self.perkhud[perksAmount].foreground = true;
	self.perkhud[perksAmount] setIconShader( shader );
	self.perkhud[perksAmount] setIconSize( 50, 50 );
	self.perkhud[perksAmount].alpha = 1;
	wait 0.3;
	self.perktext[perksAmount].alpha = 0;
	self.perkhud[perksAmount] moveOverTime( 0.50 );
	self.perkhud[perksAmount].x = -200;
	self.perkhud[perksAmount].y = 0;
	wait 0.50;
	self playLocalSound("weap_barrett_fire_plr");
	self.perktext[perksAmount].alpha = 1;
	wait 3;
	self.perktext[perksAmount] fadeOverTime(0.25);
	self.perktext[perksAmount].alpha = 0;
	self.perkhud[perksAmount] scaleOverTime( 1, 25, 25 );
	self.perkhud[perksAmount] moveOverTime( 1 );
	self.perkhud[perksAmount].x = -410 + MultiplyTimes;
	self.perkhud[perksAmount].y = 187;
	wait 1;
	self.perktext[perksAmount] destroy();
}

PerkLastStandPro(shader, color, text)
{
	self.laststandprotext = NewClientHudElem( self );
	self.laststandprotext.alignX = "center";
	self.laststandprotext.vertAlign = "middle";
	self.laststandprotext.alignY = "middle";
	self.laststandprotext.horzAlign = "center";
	self.laststandprotext.font = "objective";
	self.laststandprotext.fontscale = 1.5;
	self.laststandprotext.x = 0;
	self.laststandprotext.y = 0;
	self.laststandprotext.foreground = true;
	self.laststandprotext.color = color;
	self.laststandprotext.alpha = 0;
	self.laststandprotext setText(text);
	self.laststandpro = NewClientHudElem( self );
	self.laststandpro.alignX = "center";
	self.laststandpro.vertAlign = "middle";
	self.laststandpro.alignY = "middle";
	self.laststandpro.horzAlign = "center";
	self.laststandpro.x = 0;
	self.laststandpro.y = 0;
	self.laststandpro.foreground = true;
	self.laststandpro setIconShader( shader );
	self.laststandpro setIconSize( 45, 45 );
	self.laststandpro.alpha = 1;
	wait 0.3;
	self.laststandprotext.alpha = 0;
	self.laststandpro moveOverTime( 0.50 );
	self.laststandpro.x = 200;
	self.laststandpro.y = 0;
	wait 0.50;
	self playLocalSound("weap_barrett_fire_plr");
	self.laststandprotext.alpha = 1;
	wait 3;
	self.laststandprotext fadeOverTime(0.25);
	self.laststandprotext.alpha = 0;
	self.laststandpro scaleOverTime( 1, 25, 25 );
	self.laststandpro moveOverTime( 1 );
	self.laststandpro.x = 390;
	self.laststandpro.y = 217;
	wait 1;
	self.laststandprotext destroy();
}

ChangeFontScaleFinalStandIcon()
{
    self endon("disconnect");
    self endon("revive");
    while(1)
	{
		self.laststandpro fadeOverTime( 1 );
		self.laststandpro.alpha = 0;
		wait 1;
		self.laststandpro fadeOverTime( 1 );
		self.laststandpro.alpha = 1;
		wait 1;
	}
}