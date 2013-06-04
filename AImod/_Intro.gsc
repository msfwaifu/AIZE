#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include AImod\_OtherFunctions;

WelcomeText( text, text2, text3, text4, text5, intensity, color, glow, glowintensity, color2, glow2, glowintensity2, color3, glow3, glowintensity3, color4, glow4, glowintensity4, color5, glow5, glowintensity5 )
{
	self endon( "disconnect" );
	wait ( 0.05 );
	if(isDefined(self.welcometext[0]))
		self.welcometext[0] destroy();
	if(isDefined(self.welcometext[1]))
		self.welcometext[1] destroy();
	if(isDefined(self.welcometext[2]))
		self.welcometext[2] destroy();
	if(isDefined(self.welcometext[3]))
		self.welcometext[3] destroy();
	if(isDefined(self.welcometext[4]))
		self.welcometext[4] destroy();
	self notify( "welcome_text" );
	self endon( "welcome_text" );
	self.welcometext[0] = self createFontString("objective", 1.5);
	self.welcometext[0] setPoint("TOPMIDDLE", "TOPMIDDLE", 0, 45);
	self.welcometext[0].fontscale = 6;
	self.welcometext[0].color = color;
	self.welcometext[0] setText(text);
	self.welcometext[0].alpha = 0;
	self.welcometext[0].glowColor = glow;
	self.welcometext[0].glowAlpha = glowintensity;
	self.welcometext[0] ChangeFontScaleOverTime( 0.2 );
	self.welcometext[0] fadeOverTime( 0.2 );
	self.welcometext[0].alpha = intensity;
	self.welcometext[0].fontScale = 1.5;
	wait 0.5;
	self.welcometext[1] = self createFontString("objective", 1.5);
	self.welcometext[1] setPoint("TOPMIDDLE", "TOPMIDDLE", 0, 60);
	self.welcometext[1].fontscale = 6;
	self.welcometext[1].color = color2;
	self.welcometext[1] setText(text2);
	self.welcometext[1].alpha = 0;
	self.welcometext[1].glowColor = glow2;
	self.welcometext[1].glowAlpha = glowintensity2;
	self.welcometext[1] ChangeFontScaleOverTime( 0.2 );
	self.welcometext[1] fadeOverTime( 0.2 );
	self.welcometext[1].alpha = intensity;
	self.welcometext[1].fontScale = 1.5;
	wait 0.5;
	self.welcometext[2] = self createFontString("objective", 1.5);
	self.welcometext[2] setPoint("TOPMIDDLE", "TOPMIDDLE", 0, 75);
	self.welcometext[2].fontscale = 6;
	self.welcometext[2].color = color3;
	self.welcometext[2] setText(text3);
	self.welcometext[2].alpha = 0;
	self.welcometext[2].glowColor = glow3;
	self.welcometext[2].glowAlpha = glowintensity3;
	self.welcometext[2] ChangeFontScaleOverTime( 0.2 );
	self.welcometext[2] fadeOverTime( 0.2 );
	self.welcometext[2].alpha = intensity;
	self.welcometext[2].fontScale = 1.5;
	wait 0.5;
	self.welcometext[3] = self createFontString("objective", 1.5);
	self.welcometext[3] setPoint("TOPMIDDLE", "TOPMIDDLE", 0, 90);
	self.welcometext[3].fontscale = 6;
	self.welcometext[3].color = color4;
	self.welcometext[3] setText(text4);
	self.welcometext[3].alpha = 0;
	self.welcometext[3].glowColor = glow4;
	self.welcometext[3].glowAlpha = glowintensity4;
	self.welcometext[3] ChangeFontScaleOverTime( 0.2 );
	self.welcometext[3] fadeOverTime( 0.2 );
	self.welcometext[3].alpha = intensity;
	self.welcometext[3].fontScale = 1.5;
	wait 0.5;
	self.welcometext[4] = self createFontString("objective", 1.5);
	self.welcometext[4] setPoint("TOPMIDDLE", "TOPMIDDLE", 0, 105);
	self.welcometext[4].fontscale = 6;
	self.welcometext[4].color = color5;
	self.welcometext[4] setText(text5);
	self.welcometext[4].alpha = 0;
	self.welcometext[4].glowColor = glow5;
	self.welcometext[4].glowAlpha = glowintensity5;
	self.welcometext[4] ChangeFontScaleOverTime( 0.2 );
	self.welcometext[4] fadeOverTime( 0.2 );
	self.welcometext[4].alpha = intensity;
	self.welcometext[4].fontScale = 1.5;
	wait 0.5;
	wait 3.5;
	self.welcometext[0] ChangeFontScaleOverTime( 0.2 );
	self.welcometext[0] fadeOverTime( 0.2 );
	self.welcometext[0].alpha = 0;
	self.welcometext[0].fontScale = 4.5;
	wait 0.5;
	self.welcometext[1] ChangeFontScaleOverTime( 0.2 );
	self.welcometext[1] fadeOverTime( 0.2 );
	self.welcometext[1].alpha = 0;
	self.welcometext[1].fontScale = 4.5;
	wait 0.5;
	self.welcometext[2] ChangeFontScaleOverTime( 0.2 );
	self.welcometext[2] fadeOverTime( 0.2 );
	self.welcometext[2].alpha = 0;
	self.welcometext[2].fontScale = 4.5;
	wait 0.5;
	self.welcometext[3] ChangeFontScaleOverTime( 0.2 );
	self.welcometext[3] fadeOverTime( 0.2 );
	self.welcometext[3].alpha = 0;
	self.welcometext[3].fontScale = 4.5;
	wait 0.5;
	self.welcometext[4] ChangeFontScaleOverTime( 0.2 );
	self.welcometext[4] fadeOverTime( 0.2 );
	self.welcometext[4].alpha = 0;
	self.welcometext[4].fontScale = 4.5;
	wait 0.4;
	self.welcometext[0] destroy();
	self.welcometext[1] destroy();
	self.welcometext[2] destroy();
	self.welcometext[3] destroy();
	self.welcometext[4] destroy();
}

IntroInit()
{
	self waittill("spawned_player");
	if(getDvar("g_gametype") == "doa" || getDvar("g_gametype") == "doa2")	
		self thread WelcomeText("Welcome " + self.name, "AI Zombies eXtreme", "Gametype: Dead Ops Arcade", "Made By Zombiefan564, DidUknowiPwn, momo5502", "", 1, (1,1,1), (0.3,0.9,0.3), 0.85, (1,1,1), (0.9,0.3,0.3), 0.85, (1,1,1), (1,0.5,0.3), 0.85, (1,1,1), (0.3,0.9,0.3), 0.85, (1,1,1), (0.3,0.9,0.9), 0.85);
	else
		self thread WelcomeText("Welcome " + self.name, "AI Zombies eXtreme V2.0 Alpha", "Map: " + CustomMapnames(), "Made By Zombiefan564, DidUknowiPwn, momo5502", "Survive " + getDvarInt("z_waves") + " Waves", 1, (1,1,1), (0.3,0.9,0.3), 0.85, (1,1,1), (0.9,0.3,0.3), 0.85, (1,1,1), (1,0.5,0.3), 0.85, (1,1,1), (0.3,0.9,0.3), 0.85, (1,1,1), (0.3,0.9,0.9), 0.85);
}