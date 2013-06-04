
//////////////////////////////////////////
//////////////////////////////////////////
///////////Intervention E.B.//////////////
//////////////////////////////////////////


Init()
{
	level.UpgradedInterventionWeapon = "cheytac_fmj_mp";

	level.UpgradedInterventionWeaponFX["largeexplosion"] = loadFX( "smoke/smoke_trail_black_heli" );

	level.FX_count = 0;

	level thread onPlayerConnected();
}

onPlayerConnected()
{
	for( ;; )
	{
		level waittill( "connected", player );

		player thread doUpgradedInterventiongun();
	}
}

doUpgradedInterventiongun()
{
	for( ;; )
	{
		self waittill( "weapon_fired", weaponName );

		if( self getCurrentWeapon() != level.UpgradedInterventionWeapon )
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
		pos = startPos + vecscale( direction, i * 3000 ); 

		if( distance( startPos, pos ) > 10000 ) 
		{
			doDamage = 0;
			break;
		}

		trace = bulletTrace( startPos, pos, true, self );

		if( !bulletTracePassed( startPos, pos, true, self ) )
		{
			largeexplosionFX = spawnFX( level.UpgradedInterventionWeaponFX["largeexplosion"], bulletTrace( startPos, pos, true, self )["position"] );
			level.FX_count ++;
			triggerFX( largeexplosionFX );
			self playsound("explo_mine");

			wait( 0.2 );

			largeexplosionFX delete();
			level.FX_count --;
			
			break;
		}

		fireFX = spawnFX( level.UpgradedInterventionWeaponFX["fire"], pos ); 
		level.FX_count ++;
		triggerFX( fireFX );

		fireFX thread deleteAfterTime( 0.1 );

		if( level.FX_count < 2000 ) 
		{
			for( j = 0; j < 3; j ++ )
			{
				fireFX = spawnFX( level.UpgradedInterventionWeaponFX["fire"], pos - (randomInt( 50 ) / 3, randomInt( 50 ) / 3, randomInt( 50 ) / 2) - vecscale( direction, i * randomInt( 10 ) * 3 ) );
				level.FX_count ++;
				triggerFX( fireFX );

				fireFX thread deleteAfterTime( 1 + randomInt( 3 ) * 0.05 );
			}
		}

		wait( 0.05 );
	}

	if( doDamage )
		radiusDamage( endPos, 100, 130, 130, self );
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