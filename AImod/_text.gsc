#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include AImod\_OtherFunctions;

HudRightMessage( text, color, glow, intensity, glowintensity )
{
	while(isDefined(self.message))
		wait 0.2;
	self.message destroy();
	self notify( "message_text" );
	self endon( "message_text" );
	self.message = self createFontString( "OBJECTIVE", 1.7 );
	self.message setPoint( "TOPLEFT", "TOPLEFT", 115, 0);
	self.message.color = color;
	self.message setText(text);
	self.message.alpha = intensity;
	self.message.glowColor = glow;
	self.message.glowAlpha = glowintensity;
	self.message SetPulseFX( 50, 4000, 1000 );
	wait 5;
	self.message destroy();
}

TextWithIcon( text, icon, sound )
{
	notifyData = spawnstruct();
	notifyData.iconName = icon;
	notifyData.titleText = text;
	notifyData.glowColor = (0.3, 0.6, 0.3);
	notifyData.sound = sound;
	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}

TextWithIcon2( text, text2, icon, sound )
{
	notifyData = spawnstruct();
	notifyData.iconName = icon;
	notifyData.titleText = text;
	notifyData.notifyText = text2;
	notifyData.glowColor = (0.3, 0.6, 0.3);
	notifyData.sound = sound;
	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}

Icon( icon, sound )
{
	notifyData = spawnstruct();
	notifyData.iconName = icon;
	notifyData.sound = sound;
	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}

TextWith2Lines( text, text2 )
{
	notifyData = spawnstruct();
	notifyData.titleText = text;
	notifyData.notifyText = text2;
	notifyData.glowColor = (0.3, 0.6, 0.3);
	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}

MuliKillTextPopup( text, color, glow )
{
	self.multikilltext destroy();
	self notify( "multikilltext" );
	self endon( "multikilltext" );
	self.multikilltext = self createFontString( "hudbig", 0.65 );
	self.multikilltext setPoint("BOTTOMCENTER", "BOTTOMCENTER", 0, -100);
	self.multikilltext.color = color;
	self.multikilltext setText(text);
	self.multikilltext.alpha = 0.85;
	self.multikilltext.glowColor = glow;
	self.multikilltext.glowAlpha = 0.55;
	self.multikilltext SetPulseFX( 100, 3700, 1000 );
}

BonusDropText( text, intensity, color, glow, glowintensity )
{
	self endon( "disconnect" );
	wait ( 0.05 );
	self.bonusdroptext destroy();
	self notify( "bonus_drop_text" );
	self endon( "bonus_drop_text" );
	self.bonusdroptext = newClientHudElem( self );
	self.bonusdroptext.horzAlign = "center";
	self.bonusdroptext.vertAlign = "middle";
	self.bonusdroptext.alignX = "center";
	self.bonusdroptext.alignY = "middle";
	self.bonusdroptext.font = "objective";
	self.bonusdroptext.fontscale = 2;
	self.bonusdroptext.color = color;
	self.bonusdroptext setText(text);
	self.bonusdroptext.alpha = intensity;
	self.bonusdroptext.glowColor = glow;
	self.bonusdroptext.glowAlpha = glowintensity;
	self.bonusdroptext.x = 0;
	self.bonusdroptext.y = 140;
	self.bonusdroptext moveOverTime( 2.00 );
	self.bonusdroptext fadeOverTime( 2.00 );
	self.bonusdroptext.x = 0;
	self.bonusdroptext.y = 80;
	self.bonusdroptext.alpha = 0;
	wait 2;
	self.bonusdroptext destroy();
}

NukeTimerText()
{
	self endon( "disconnect" );
	level endon("nuke_gone_off");
	while(1)
	{
		if(!isDefined(self.nuketimertext))
		{
			self.nuketimertext = newClientHudElem( self );
			self.nuketimertext.horzAlign = "center";
			self.nuketimertext.vertAlign = "middle";
			self.nuketimertext.alignX = "center";
			self.nuketimertext.alignY = "middle";
			self.nuketimertext.font = "objective";
			self.nuketimertext.fontscale = 2;
			self.nuketimertext.color = (1,1,0.5);
			self.nuketimertext.label = &"Nuke Incoming In: ";
			self.nuketimertext setValue(level.nuketimer);
			self.nuketimertext.alpha = 1;
			self.nuketimertext.x = 0;
			self.nuketimertext.y = 0;
		}
		if(level.nuketimer >= 1)
		{
			self.nuketimertext setValue(level.nuketimer);
			self.nuketimertext ChangeFontScaleOverTime(0.2);
			self.nuketimertext.fontscale = 2.4;
			wait 0.2;
			self.nuketimertext ChangeFontScaleOverTime(0.2);
			self.nuketimertext.fontscale = 2;
		}
		if(level.nuketimer < 1)
		{
			self.nuketimertext destroy();
			wait 0.1;
		}
		level waittill("update_nuke_timer");
	}
}

BonusDropIcon(shader, color)
{
    self endon( "disconnect" );
	wait ( 0.05 );
	self.bonusdropicon destroy();
	self notify( "bonus_drop_icon" );
	self endon( "bonus_drop_icon" );
	self.bonusdropicon = NewClientHudElem( self );
	self.bonusdropicon.alignX = "center";
	self.bonusdropicon.alignY = "middle";
	self.bonusdropicon.horzAlign = "center";
	self.bonusdropicon.vertAlign = "middle";
	self.bonusdropicon.x = 0;
	self.bonusdropicon.y = 125;
	self.bonusdropicon.color = color;
	self.bonusdropicon.foreground = true;
	self.bonusdropicon setIconShader( shader );
	self.bonusdropicon setIconSize( 30, 30 );
	self.bonusdropicon.alpha = 1;
	self.bonusdropicon moveOverTime( 2.00 );
	self.bonusdropicon fadeOverTime( 2.00 );
	self.bonusdropicon.x = 0;
	self.bonusdropicon.y = 65;
	self.bonusdropicon.alpha = 0;
	wait 2;
	self.bonusdropicon destroy();
}

RoundStartText( text, intensity, color, glow, glowintensity )
{
	self endon( "disconnect" );
	wait ( 0.05 );
	self.startext destroy();
	self notify( "round_start_text" );
	self endon( "round_start_text" );
	self.startext = newClientHudElem( self );
	self.startext.horzAlign = "center";
	self.startext.vertAlign = "middle";
	self.startext.alignX = "center";
	self.startext.alignY = "middle";
	self.startext.font = "hudbig";
	self.startext.fontscale = 6;
	self.startext.color = color;
	self.startext setText(text);
	self.startext.alpha = 0;
	self.startext.glowColor = glow;
	self.startext.glowAlpha = glowintensity;
	self.startext.x = 0;
	self.startext.y = -160;
	self.startext ChangeFontScaleOverTime( 0.2 );
	self.startext fadeOverTime( 0.2 );
	self.startext moveOverTime( 0.2 );
	self.startext.alpha = intensity;
	self.startext.fontScale = 1;
	self.startext.x = 0;
	self.startext.y = -220;
	wait 2.5;
	self.startext ChangeFontScaleOverTime( 0.2 );
	self.startext fadeOverTime( 0.2 );
	self.startext moveOverTime( 0.2 );
	self.startext.alpha = 0;
	self.startext.fontScale = 4.5;
	self.startext.x = 0;
	self.startext.y = -160;
	wait 0.4;
	self.startext destroy();
}

RoundEndText( text, intensity, color, glow, glowintensity )
{
	self endon( "disconnect" );
	wait ( 0.05 );
	self.endtext destroy();
	self notify( "round_end_text" );
	self endon( "round_end_text" );
	self.endtext = newClientHudElem( self );
	self.endtext.horzAlign = "center";
	self.endtext.vertAlign = "middle";
	self.endtext.alignX = "center";
	self.endtext.alignY = "middle";
	self.endtext.font = "hudbig";
	self.endtext.fontscale = 0.150;
	self.endtext.color = color;
	self.endtext setText(text);
	self.endtext.alpha = 0;
	self.endtext.glowColor = glow;
	self.endtext.glowAlpha = glowintensity;
	self.endtext.x = 0;
	self.endtext.y = -220;
	self.endtext ChangeFontScaleOverTime( 0.2 );
	self.endtext fadeOverTime( 0.2 );
	self.endtext.fontscale = 1;
	self.endtext.alpha = intensity;
	wait 2.5;
	self.endtext ChangeFontScaleOverTime( 0.2 );
	self.endtext fadeOverTime( 0.2 );
	self.endtext.alpha = 0;
	self.endtext.fontScale = 0.150;
	wait 0.4;
	self.endtext destroy();
}

IntermissionText( text, intensity, color, glow, glowintensity )
{
	self endon( "disconnect" );
	wait ( 0.05 );
	self.intermissiontext destroy();
	self notify( "intermission_end_text" );
	self endon( "intermission_end_text" );
	self.intermissiontext = newClientHudElem( self );
	self.intermissiontext.horzAlign = "center";
	self.intermissiontext.vertAlign = "middle";
	self.intermissiontext.alignX = "center";
	self.intermissiontext.alignY = "middle";
	self.intermissiontext.font = "hudbig";
	self.intermissiontext.fontscale = 0.001;
	self.intermissiontext.color = color;
	self.intermissiontext setText(text);
	self.intermissiontext.alpha = 0;
	self.intermissiontext.glowColor = glow;
	self.intermissiontext.glowAlpha = glowintensity;
	self.intermissiontext.x = 0;
	self.intermissiontext.y = -195;
	self.intermissiontext ChangeFontScaleOverTime( 0.2 );
	self.intermissiontext fadeOverTime( 0.2 );
	self.intermissiontext.fontscale = 1;
	self.intermissiontext.alpha = intensity;
	wait 2.5;
	self.intermissiontext ChangeFontScaleOverTime( 0.2 );
	self.intermissiontext fadeOverTime( 0.2 );
	self.intermissiontext.alpha = 0;
	self.intermissiontext.fontScale = 0.001;
	wait 0.4;
	self.intermissiontext destroy();
}

EndGameText( text, text2, text3, text4, text5, intensity, color, glow, glowintensity, color2, glow2, glowintensity2, color3, glow3, glowintensity3, color4, glow4, glowintensity4, color5, glow5, glowintensity5 )
{
	self.endgametext[0] = self createFontString("hudbig", 0.850);
	self.endgametext[0] setPoint("TOPMIDDLE", "TOPMIDDLE", 0, 60);
	self.endgametext[0].color = color;
	self.endgametext[0] setText(text);
	self.endgametext[0].alpha = intensity;
	self playLocalSound("weap_barrett_fire_plr");
	earthquake(0.1,0.1, self.origin, 5000);
	wait 0.9;
	self.endgametext[1] = self createFontString("hudbig", 0.850);
	self.endgametext[1] setPoint("TOPMIDDLE", "TOPMIDDLE", 0, 75);
	self.endgametext[1].color = color2;
	self.endgametext[1] setText(text2);
	self.endgametext[1].alpha = intensity;
	self playLocalSound("weap_barrett_fire_plr");
	earthquake(0.1,0.1, self.origin, 5000);
	wait 0.9;
	self.endgametext[2] = self createFontString("hudbig", 0.850);
	self.endgametext[2] setPoint("TOPMIDDLE", "TOPMIDDLE", 0, 90);
	self.endgametext[2].color = color3;
	self.endgametext[2] setText(text3);
	self.endgametext[2].alpha = intensity;
	self playLocalSound("weap_barrett_fire_plr");
	earthquake(0.1,0.1, self.origin, 5000);
	wait 0.9;
	self.endgametext[3] = self createFontString("hudbig", 0.850);
	self.endgametext[3] setPoint("TOPMIDDLE", "TOPMIDDLE", 0, 105);
	self.endgametext[3].color = color4;
	self.endgametext[3] setText(text4);
	self.endgametext[3].alpha = intensity;
	self playLocalSound("weap_barrett_fire_plr");
	earthquake(0.1,1, self.origin, 5000);
	wait 0.9;
	self.endgametext[4] = self createFontString("hudbig", 0.850);
	self.endgametext[4] setPoint("TOPMIDDLE", "TOPMIDDLE", 0, 120);
	self.endgametext[4].color = color5;
	self.endgametext[4] setText(text5);
	self.endgametext[4].alpha = intensity;
	self playLocalSound("weap_barrett_fire_plr");
	earthquake(0.1,0.1, self.origin, 5000);
	wait 3;
	self.endgametext[0] destroy();
	self.endgametext[1] destroy();
	self.endgametext[2] destroy();
	self.endgametext[3] destroy();
	self.endgametext[4] destroy();
}