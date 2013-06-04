
/////////////////////////////////////////////
/////////////Upgraded Raygun////////////////
///////////////////////////////////////////


Init()
{
	level.raygunWeapon = "pp2000_eotech_xmags_mp";

	level.raygunFX["upgradedraygun"] = loadFX( "misc/aircraft_light_wingtip_red" );
	level.raygunFX["impact"] = loadFX( "misc/flare_ambient" );

	level.FX_count = 0;

	level thread onPlayerConnected();
}

onPlayerConnected()
{
	for( ;; )
	{
		level waittill( "connected", player );

		player thread doRaygun();
	}
}

doRaygun()
{
	for( ;; )
	{
		self waittill( "weapon_fired", weaponName );

		if( self getCurrentWeapon() != level.raygunWeapon )
			continue;

		start = self getTagOrigin( "tag_eye" );
		end = self getTagOrigin( "tag_eye" ) + vecscale( anglestoforward( self getPlayerAngles() ), 100000 );
		trace = bulletTrace( start, end, true, self );

		thread doLaserFX( self getTagOrigin( "tag_eye" ), anglestoforward( self getPlayerAngles() ), trace["position"] );
	}	
}

doLaserFX( startPos, direction, endPos )
{
	doDamage = 1;

	for( i = 1; ; i ++ ) 
	{
		pos = startPos + vecscale( direction, i * 150 ); 

		if( distance( startPos, pos ) > 9000 ) 
		{
			doDamage = 0;
			break;
		}

		trace = bulletTrace( startPos, pos, true, self );

		if( !bulletTracePassed( startPos, pos, true, self ) )
		{
			impactFX = spawnFX( level.raygunFX["impact"], bulletTrace( startPos, pos, true, self )["position"] );
			level.FX_count ++;
			triggerFX( impactFX );

			wait( 0.2 );

			impactFX delete();
			level.FX_count --;
			
			break;
		}

		laserFX = spawnFX( level.raygunFX["upgradedraygun"], pos );
		level.FX_count ++;
		triggerFX( laserFX );

		laserFX thread deleteAfterTime( 0.1 );

		if( level.FX_count < 200 ) 
		{
			for( j = 0; j < 3; j ++ )
			{
				laserFX = spawnFX( level.large_metalhit_1, pos + (randomInt( 50 ) / 10, randomInt( 50 ) / 10, randomInt( 50 ) / 10) - vecscale( direction, i * randomInt( 10 ) * 3 ) );
				level.FX_count ++;
				triggerFX( laserFX );

				laserFX thread deleteAfterTime( 0.05 + randomInt( 3 ) * 0.05 );
			}
		}

		wait( 0.05 );
	}

	if( doDamage )
		radiusDamage( endPos, 20, 90, 90, self );
}

deleteAfterTime( time )
{
	wait( time );

	self delete();
	level.FX_count --;
}

vecscale( vec, scalar )
{
	return ( vec[0] * scalar, vec[1] * scalar, vec[2] * scalar );
}
