// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{

	switch( codescripts\character::get_random_character(3) )
	{
	case 0:
		character\mp_character_us_army_assault_a::main();
		break;
	case 1:
		character\mp_character_us_army_assault_b::main();
		break;
	case 2:
		character\mp_character_us_army_assault_c::main();
		break;
	}
}

precache()
{
	character\mp_character_us_army_assault_a::precache();
	character\mp_character_us_army_assault_b::precache();
	character\mp_character_us_army_assault_c::precache();
}
