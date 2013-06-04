#include common_scripts\utility;
#include maps\mp\_utility;

main()
{
	precache_masked_destructibles()

	maps\createart\arcadia_art::main(); //remove fog/fix load vision

	ambientPlay( "ambient_arcadia_ext3" ); //play sounds
	
	maps\mp\_load::main();

	game[ "attackers" ] = "allies";
	game[ "defenders" ] = "axis";

	maps\mp\arcadia_fx::main();

	//compass stuff
	maps\mp\_compass::setupMiniMap( "compass_map_arcadia" );
	setdvar( "compassmaxrange", "5000" );

	//airstrike stuff
	level.airstrikeHeightScale = 3;
}
precache_masked_destructibles()
{
	loadfx( "smoke/car_damage_whitesmoke" );
	loadfx( "smoke/car_damage_blacksmoke" );
	loadfx( "smoke/car_damage_blacksmoke_fire" );
	loadfx( "explosions/small_vehicle_explosion" );
	loadfx( "props/car_glass_large" );
	loadfx( "props/car_glass_med" );
	loadfx( "props/car_glass_headlight" );
	loadfx( "smoke/motorcycle_damage_blacksmoke_fire" );
	loadfx( "props/car_glass_brakelight" );
	loadfx( "props/mail_box_explode" );
	loadfx( "props/garbage_spew_des" );
	loadfx( "props/garbage_spew" );
	loadfx( "explosions/wallfan_explosion_dmg" );
	loadfx( "explosions/wallfan_explosion_des" );
	loadfx( "props/filecabinet_dam" );
	loadfx( "props/filecabinet_des" );
	loadfx( "misc/light_blowout_runner" );
	loadfx( "props/electricbox4_explode" );
	loadfx( "explosions/ceiling_fan_explosion" );
	loadfx( "props/firehydrant_leak" );
	loadfx( "props/firehydrant_exp" );
	loadfx( "props/firehydrant_spray_10sec" );
	loadfx( "explosions/tv_flatscreen_explosion" );
}