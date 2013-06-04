// _createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 

	//* Fog section * 

	setDevDvar( "scr_fog_disable", "0" );

	VisionSetNaked( "mp_rust", 0 );
	wait 1;
	if(level.edit == 0)
		setExpFog( 172.376, 1707.07, 0.548461, 0.468579, 0.381201, 0.658073, 0 );
	if(level.edit == 1)
		setExpFog( 172.376, 1707.07, 0.548461, 0.468579, 0.381201, 0.658073, 0 );
	if(level.edit == 2)
		setExpFog( 0, 2228.18, 0.894118, 0.8962, 0.929412, 0.776943, 0 );

}
