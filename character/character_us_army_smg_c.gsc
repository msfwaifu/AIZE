// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("body_us_army_smg_c");
	codescripts\character::attachHead( "alias_us_army_heads", xmodelalias\alias_us_army_heads::main() );
	self.voice = "american";
}

precache()
{
	precacheModel("body_us_army_smg_c");
	codescripts\character::precacheModelArray(xmodelalias\alias_us_army_heads::main());
}
