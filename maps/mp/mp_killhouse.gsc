#include common_scripts\utility;
 
main()
{

 
        maps\mp\_load::main();
	maps\mp\mp_killhouse_fx::main();

	//setexpfog(874.792, 2740, 0.776471, 0.588235, 0.47451, 0.5, 0, 0.803922, 0.717647, 0.6, (-0.432962, -0.395847, 0.809845), 0, 61.0525, 5.68252);
	ambientPlay( "ambient_mp_rural" );

    game[ "attackers" ] = "allies";
    game[ "defenders" ] = "axis";
 
    maps\mp\_compass::setupMiniMap( "compass_map_mp_killhouse" );
 	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	setdvar("compassmaxrange","2200");
	
	VisionSetNaked("mp_killhouse", 0 );
}
