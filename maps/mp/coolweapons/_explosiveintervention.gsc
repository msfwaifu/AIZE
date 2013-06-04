/////////////////////////////////////////////////////
///////////Intervention Explosive Bullets///////////
///////////////////////////////////////////////////
Init()
{
	level.InterventionWeapon = "cheytac_mp";

	level.InterventionFX["impact"] = loadFX( "props/barrel_fire" );

	level.FX_count = 0;

	level thread onPlayerConnected();
}

onPlayerConnected()
{
	for( ;; )
	{
		level waittill( "connected", player );

		player thread doExplosiveInterventiongun();
	}
}

doExplosiveInterventiongun()
{
	for( ;; )
	{
		self waittill( "weapon_fired", weaponName );

		if( self getCurrentWeapon() != level.InterventionWeapon )
			continue;


		start = self getTagOrigin( "tag_eye" );
		end = self getTagOrigin( "tag_eye" ) + vecscale( anglestoforward( self getPlayerAngles() ), 100000 );
		trace = bulletTrace( start, end, true, self );
 

		thread InterventionFX( self getTagOrigin( "tag_flash" ), anglestoforward( self getPlayerAngles() ), trace["position"] );
	}	
}

InterventionFX( startPos, direction, endPos )
{
	doDamage = 1;

	for( i = 1; ; i ++ ) 
	{
		pos = startPos + vecscale( direction, i * 300 ); 

		if( distance( startPos, pos ) > 100000 ) 
		{
			doDamage = 0;
			break;
		}

		trace = bulletTrace( startPos, pos, true, self );

		if( !bulletTracePassed( startPos, pos, true, self ) )
		{
			impactFX = spawnFX( level.InterventionFX["impact"], bulletTrace( startPos, pos, true, self )["position"] );
			level.FX_count ++;
			triggerFX( impactFX );
			self playsound("explo_mine");

			wait( 0.2 );

			impactFX delete();
			level.FX_count --;
			
			break;
		}

		fireFX = spawnFX( level.InterventionFX["fire"], pos ); 
		level.FX_count ++;
		triggerFX( fireFX );

		fireFX thread deleteAfterTime( 0.1 );

		if( level.FX_count < 2000 ) 
		{
			for( j = 0; j < 3; j ++ )
			{
				fireFX = spawnFX( level.DeagleFX["fire"], pos - (randomInt( 50 ) / 3, randomInt( 50 ) / 3, randomInt( 50 ) / 2) - vecscale( direction, i * randomInt( 10 ) * 3 ) );
				level.FX_count ++;
				triggerFX( fireFX );

				fireFX thread deleteAfterTime( 1 + randomInt( 3 ) * 0.05 );
			}
		}

		wait( 0.05 );
	}

	if( doDamage )
		radiusDamage( endPos, 20, 100, 100, self );
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
