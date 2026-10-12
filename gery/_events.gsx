/*
 * ============================================================
 *  COD4X - Blitz
 *  Version: 3.2
 *  Developer: Gery Kurucz (github.com/gerykurucz)
 * ============================================================
 */

init()
{
	precacheModel( "projectile_hellfire_missile" );
	precacheModel( "prop_suitcase_bomb" );
	precacheModel( "vehicle_mig29_desert" );
	precacheModel( "projectile_cbu97_clusterbomb" );
	precacheModel( "tag_origin" );

	PreCacheShellShock( "frag_grenade_mp" );

	precacheShader( "waypoint_kill" );
	precacheShader( "killiconsuicide" );
	precacheShader( "killiconmelee" );
	precacheShader( "killiconheadshot" );
	precacheShader( "faction_128_usmc" );
	precacheShader( "faction_128_arab" );
	precacheShader( "faction_128_ussr" );
	precacheShader( "faction_128_sas" );
	precacheShader( "gradient" );
	precacheShader( "gradient_fadein" );
	precacheShader( "gradient_top" );
	precacheShader( "gradient_bottom" );
	precacheShader( "line_horizontal" );

	level.hardEffects = [];
	level.hardEffects[ "artilleryExp" ] = loadfx("explosions/artilleryExp_dirt_brown");
	level.hardEffects[ "hellfireGeo" ] = loadfx("smoke/smoke_geotrail_hellfire");
	level.hardEffects[ "tankerExp" ] = loadfx( "explosions/tanker_explosion" );
	level.hardEffects[ "smallExp" ] = loadfx( "impacts/large_mud" );
	level.hardEffects[ "fire" ] = loadfx( "fire/tank_fire_engine" );

	level.nade_fx["nade"]["explode"] = loadfx ("explosions/grenadeexp_default");
	level.chopper_fx["explode"]["large"] = loadfx ("explosions/aerial_explosion_large");
	level.chopper_fx["fire"]["trail"]["medium"] = loadfx ("smoke/smoke_trail_black_heli");
	level.fx_airstrike_afterburner = loadfx ("fire/jet_afterburner");
	level.fx_airstrike_contrail = loadfx ("smoke/jet_contrail");

    level.camp_maxTime = 20;
    level.camp_checkInterval = 1;
    level.camp_minDistance = 250;
    level.camp_gracePeriod = 5;

	level gery\_prestige::init();
	level gery\_commands::init();
	level gery\_config::serverConfig();
	thread gery\_killcard::init();
	thread gery\_spray::init();
	thread gery\_killcard_select::init();
	
	for(i=0;i<61;i++)
	{
		precacheshader("killcard"+i+"_menu");
	}
	precacheShader( "popmenu_bg" );
	precacheShader( "fire_particles" );
	precacheShader( "white" );
}

gametype()
{
    level endon("game_ended");

	level thread gery\_common::deleteTurrets();
	level thread gery\_botsettings::init();
	level thread gery\_commands::rconSupport();
	level thread gery\_teambalance::autoTeamBalance();
	level thread gery\_teambalance::scoreBalanceLoop();
}

connect()
{
    self endon("disconnect");

	while( !isDefined( self ) )
        wait 0.1;
	self thread gery\_config::loadConfig();
	self thread gery\_config::playerConfig();
	self thread gery\_prestige::Prestige();

	if(!isDefined(self.pers["killcard"]))
	{
		self.pers["killcard"] = self getstat(71);
	}
}

spawn()
{
    self endon("disconnect");
    self endon("joined_spectators");
    self endon("death");

	self thread gery\_antinoob::disablePerks();
	self thread gery\_antinoob::disableGL();

	self thread gery\_shield::elevatorFix();
	self thread gery\_shield::spawnProtection();
	self thread gery\_shield::monitorCamp();
}
