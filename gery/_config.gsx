/*
 * ============================================================
 *  COD4X - Blitz
 *  Version: 3.2
 *  Developer: Gery Kurucz (github.com/gerykurucz)
 * ============================================================
 */
 
#include gery\_common;

serverConfig()
{

	setDvar( "player_breath_gasp_lerp", "0" );
	setDvar( "player_breath_gasp_time", "0" );
	setDvar( "player_breath_gasp_scale", "0" );
	setDvar( "player_scopeSelfPlayerInhibit", "0" );
	setDvar( "perk_bulletPenetrationMultiplier", "3" );
	setDvar( "bullet_penetrationMinDistance", "100" );
	setDvar( "player_adsExitDelay", "0" );
	setDvar( "perk_weapSpreadMultiplier", "0.10" );
	setDvar( "perk_weapRecoilMultiplier", "0.10" );
	setDvar( "perk_weapRateMultiplier", "1.0" );
	setDvar( "weapon_adsFovBlur", "0" );
	setDvar( "player_sprinttime", 8 );
	setDvar( "g_gravity", 600 );
	setDvar( "g_speed", 210 );
	setDvar( "jump_height", 45 );
	setDvar( "player_sprintspeedscale", 1.6 );
	setDvar( "perk_explosiveDamageMultiplier", "1.0" );


    setDvar( "scr_team_fftype", 0 );
    setDvar( "scr_team_teamkillpointloss", 0 );


    setDvar( "scr_player_forcerespawn", 1 );
    setDvar( "scr_player_suicidespawndelay", 0 );
    setDvar( "scr_game_deathpointloss", 0 );
    setDvar( "scr_game_suicidepointloss", 0 );
    setDvar( "scr_game_matchstarttime", 15 );
    setDvar( "scr_game_allowkillcam", 1 );
    setDvar( "scr_game_spectatetype", 2 );


    setDvar( "bg_fallDamageMinHeight", 140 );
    setDvar( "bg_fallDamageMaxHeight", 350 );
    setDvar( "bg_bobMax", 0 );
    setDvar( "player_sustainAmmo", 0 );
    setDvar( "player_throwBackInnerRadius", 0 );
    setDvar( "player_throwBackOuterRadius", 0 );

	setDvar( "g_inactivity", 0 );
	setDvar( "g_no_script_spam", 1 );
	setDvar( "g_antilag", 1 );
	setDvar( "g_smoothClients", 1 );
	setDvar( "sv_allowDownload", 0 );
	setDvar( "sv_maxPing", 0 );
	setDvar( "sv_minPing", 0 );
	setDvar( "sv_reconnectlimit", 3 );
	setDvar( "sv_timeout", 240 );
	setDvar( "sv_zombietime", 2 );
	setDvar( "sv_floodprotect", 0 );
	setDvar( "sv_kickBanTime", 0 );
	setDvar( "sv_disableClientConsole", 0 );
	setDvar( "sv_voice", 0 );
	setDvar( "sv_clientarchive", 1 );
	setDvar( "timescale", 1 );

    setDvar( "scr_enable_hiticon", 2 );
    setDvar( "scr_enable_scoretext", 1 );
    setDvar( "scr_hardcore", 0 );
    setDvar( "loc_warnings", 0 );
    setDvar( "g_redCrosshairs", 1 );
	exec( "sets Mod Blitz by Gery" );

	// YOB SPECIFIC

	setDvar( "ui_uav_allies", 1 );
	setDvar( "ui_uav_axis", 1 );
	setDvar( "ui_uav_client", 1 );
}

playerConfig()
{
	self endon("disconnect");

	for(;;)
	{
		self forceDvar("ui_drawCrosshair", "1");
		self forceDvar("rate", "100000");
		self forceDvar("snaps", "50");
		self forceDvar("cl_maxpackets", "100");
		self forceDvar("developer", "0");
		self forceDvar("r_dlightlimit", "0");
		self forceDvar("r_zfeather", "0");
		self forceDvar("r_fog", "0");
		self forceDvar("sm_enable", "0");
		self forceDvar("dynent_active", "0");
		self forceDvar("ui_hud_hardcore", "0");
		self forceDvar("cg_huddamageiconheight", "64");
		self forceDvar("cg_huddamageiconwidth", "128");
		self forceDvar("cg_huddamageiconinscope", "0");
		self forceDvar("cg_huddamageiconoffset", "128");
		self forceDvar("cg_huddamageicontime", "2000");

		self forceDvar("aim_automelee_enabled", "0");
		self forceDvar("aim_automelee_range", "0");
		self forceDvar("cg_nopredict", "0");
		self forceDvar("cg_crosshairenemycolor", "1");
		self forceDvar("cg_drawMuzzleFlash", "0");
		self forceDvar("cg_drawMantleHint", "0");
		self forceDvar("cg_cursorHints", "0");
		self forceDvar("cg_descriptiveText", "0");
		self forceDvar("cg_drawBreathHint", "0");

		self forceDvar("cg_scoreboardmycolor", "0.1 0.7 0.1 1");
		self forceDvar("cg_scoreboarditemheight", "15");
		self forceDvar("cg_scoreboardwidth", "450");
		self forceDvar("cg_ScoresPing_MaxBars", "10" );
		self forceDvar("cg_ScoresPing_MedColor", "0.1 0.7 0.1 1" );
		self forceDvar("cg_ScoresPing_LowColor", "0.1 0.7 0.1 1" );
		self forceDvar("cg_ScoresPing_BgColor", "0 0 0 0" );
		self forceDvar("cg_ScoresPing_HighColor", "0.1 0.7 0.1 1" );
		self forceDvar("cg_ScoresPing_Interval", "100" );
		self forceDvar("cg_scoreboardPingGraph", "1" );
		self forceDvar("cg_scoreboardPingHeight", "0.7" );
		self forceDvar("cg_scoreboardPingText", "1" );
        self forceDvar("cg_enemyNameFadeOut", "250" );
		self forceDvar("cg_enemyNameFadeIn", "0" );
		self forceDvar("cg_drawThroughWalls", "0" );
        
		wait 5;
	}
}

loadConfig()
{
	self endon( "disconnect" );

	if( !isDefined( self.pers["fullbright"] ) )
        self.pers["fullbright"] = self getStat( 3190 );

    if( !isDefined( self.pers["fov"] ) )
        self.pers["fov"] = self getStat( 3191 );

    if( !isDefined( self.pers["filmtweaks"] ) )
        self.pers["filmtweaks"] = self getStat( 3192 );

	wait 0.05;

	if( self.pers["fov"] == 1 )
	{
		self setClientDvar( "cg_fovscale", 1.125 );
		self setClientDvar( "cg_fov", 80 );
	}

	if( self.pers["fov"] == 2 )
	{
		self setClientDvar( "cg_fovscale", 1.25 );
		self setClientDvar( "cg_fov", 90 );
	}

	if( self.pers["fullbright"] == 1 )
		self setClientDvar( "r_fullbright", 1 );


	if( self.pers["filmtweaks"] == 1 )
	{
		self SetClientDvars("r_filmusetweaks", "1",
							"r_filmTweakenable", "1",
							"r_filmTweakInvert", "0",
							"r_filmTweakBrightness", "0",
							"r_filmTweakContrast", "1.2",
							"r_filmTweakDesaturation", "0",
							"r_filmtweakLighttint", "0.8 0.8 1",
							"r_filmTweakDarkTint", "1.8 1.8 2");
	}
}
