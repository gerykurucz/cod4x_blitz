/*
 * ============================================================
 *  COD4X - Blitz
 *  Version: 3.2
 *  Developer: Gery Kurucz (github.com/gerykurucz)
 * ============================================================
 */

main()
{
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_map_mp_carentan");

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "urban";
	game["axis_soldiertype"] = "urban";

	level.sunlight = 0.75;
}