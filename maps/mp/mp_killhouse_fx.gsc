main()
{

	level._effect[ "ground_smoke_launch_a" ]								 = loadfx( "smoke/ground_smoke_launch_a" );

 /#
	if ( common_scripts\utility::shouldRunServerSideEffects() )
		maps\createfx\mp_killhouse_fx::main();
#/

}
