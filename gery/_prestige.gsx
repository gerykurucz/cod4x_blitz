/*
 * ============================================================
 *  COD4X - Blitz
 *  Version: 3.2
 *  Developer: Gery Kurucz (github.com/gerykurucz)
 * ============================================================
 */

#include gery\_common;

init()
{
	level.prestigeicons[1] = "rank_prestige2";
	level.prestigeicons[2] = "rank_prestige3";
	level.prestigeicons[3] = "rank_prestige4";
	level.prestigeicons[4] = "rank_prestige5";
	level.prestigeicons[5] = "rank_prestige8";
	level.prestigeicons[6] = "rank_prestige9";
	level.prestigeicons[7] = "rank_prestige10";

	for(i=1;i<level.prestigeicons.size+1;i++)
		precacheStatusIcon(level.prestigeicons[i]);
	for(i=1;i<level.prestigeicons.size+1;i++)
		PreCacheShader(level.prestigeicons[i]);
}

Prestige()
{
	self endon("disconnect");
	
	self setStat(634, 0); 
	self setStat(635, 0);
	
	wait .05;

	self thread WatchKillstreakPrestige();
	self thread StatusIcon();
}

WatchKillstreakPrestige()
{
	self endon("disconnect");

	self.last_unlocked_prestige = 0;

	for(;;)
	{
		streak = self.cur_kill_streak;
		
		if(!isDefined(streak)) {
			wait 1;
			continue;
		}


		targetPrestige = 0;
		if(streak >= 43) 	  targetPrestige = 7;
		else if(streak >= 38) targetPrestige = 6;
		else if(streak >= 33) targetPrestige = 5;
		else if(streak >= 28) targetPrestige = 4;
		else if(streak >= 23) targetPrestige = 3;
		else if(streak >= 18) targetPrestige = 2;
		else if(streak >= 13) targetPrestige = 1;

		if(targetPrestige > self.last_unlocked_prestige)
		{
			self.last_unlocked_prestige = targetPrestige;
			self thread LevelUp(targetPrestige);
		}

		wait 0.5;
	}
}

LevelUp(targetLv)
{
	self setStat(634, targetLv);
	self setStat(635, 0);

	notifyData = spawnStruct();
	notifyData.titleText = "Prestige Promotion";
	notifyData.iconName = self getPrestigeIcon();
	notifyData.sound = "mp_level_up";
	notifyData.duration = 4.0;
	
	rankname = "";
	switch(targetLv)
	{
		case 1: rankname = "You have achived the 1st prestige level!"; break;
		case 2: rankname = "You have achived the 2nd prestige level!"; break;
		case 3: rankname = "You have achived the 3rd prestige level!"; break;
		case 4: rankname = "You have achived the 4th prestige level!"; break;
		case 5: rankname = "You have achived the 5th prestige level!"; break;
		case 6: rankname = "You have achived the 6th prestige level!"; break;	
		case 7: rankname = "You have achived all prestige levels in this game!"; break;
	}
	
	notifyData.notifyText = rankname;
	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
	
	self.statusicon = self getPrestigeIcon();
}

StatusIcon()
{
	self endon("disconnect");

	for(;;) 
	{
		if(!isDefined(self)) return;
		
		pIcon = self getPrestigeIcon();
		if(isDefined(pIcon) && self.statusicon != pIcon)
		{
			self.statusicon = pIcon;
		}
		
		self common_scripts\utility::waittill_any("update_score","spawned_player", "disconnect");
		wait 0.1;
	}
}

getPrestigeIcon() {
	pLv = self getStat(634);
	if(!isDefined(pLv) || pLv == 0) return "";
	return level.prestigeicons[pLv];
}