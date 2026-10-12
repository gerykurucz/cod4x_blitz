/*
 * ============================================================
 *  COD4X - Blitz
 *  Version: 3.2
 *  Developer: Gery Kurucz (github.com/gerykurucz)
 * ============================================================
 */
 
setHealth(health)
{
	self notify("end_healthregen");
	self.maxhealth = health;
	self.health = self.maxhealth;
	self setnormalhealth (self.health);
	self thread maps\mp\gametypes\_healthoverlay::playerHealthRegen();
}

isReallyPlaying()
{
    if ( !isDefined( self ) )
        return false;
    if ( self.sessionstate != "playing" || !isAlive( self ) || self.health <= 0 )
        return false;
    if ( isDefined( self.archivetime ) && self.archivetime > 0 )
        return false;

	if ( (isDefined(level.intermission) && level.intermission) ||
		 (isDefined(level.inPrematchPeriod) && level.inPrematchPeriod) ||
		 (isDefined(self.reaper) && self.reaper) ||
		 (isDefined(self.inPredator) && self.inPredator) )
	{
		return false;
	}

    return true;
}

hud( who, x, y, alpha, alignX, alignY, fontScale ) {
	if( isPlayer( who ) ) hud = newClientHudElem( who );
	else hud = newHudElem();
	hud.x = x;
	hud.y = y;
	hud.alpha = alpha;
	hud.alignX = alignX;
	hud.alignY = alignY;
	hud.fontScale = fontScale;
	return hud;
}

isRealWeapon(weapon)
{
    if(!isDefined(weapon) || weapon == "none")
        return false;

    if(isSubStr(weapon, "grenade") || isSubStr(weapon, "flash") || isSubStr(weapon, "smoke") || isSubStr(weapon, "concussion"))
        return false;

    switch(weapon)
    {
        case "knife_mp":
        case "knife_gloves_mp":
        case "radar_mp":
        case "hardpoint_lase_mp":
        case "location_selector_mp":
        case "briefcase_bomb_mp":
        case "airstrike_mp":
        case "helicopter_mp":
            return false;

        default:
            return true;
    }
}

checkCrosshair()
{
    self endon("disconnect");
    self endon("stop_crosshair_monitor");

    for(;;)
    {
        isSniperZoom = self SniperADS() && !(isDefined(self.pers["3rdPerson"]) && self.pers["3rdPerson"]);

        if( self.sessionstate != "playing" || !isAlive(self) || (isDefined(self.archivetime) && self.archivetime > 0) || level.intermission || level.inPrematchPeriod || isSniperZoom )
        {
            if(isDefined(self.customCrosshair) && self.customCrosshair.alpha != 0)
                self.customCrosshair.alpha = 0;
        }
        else
        {
            if(isDefined(self.customCrosshair) && self.customCrosshair.alpha != 1)
                self.customCrosshair.alpha = 1;
        }

        wait 0.5;

        if(!isDefined(self.customCrosshair))
            break;
    }
}

destroyCrosshair()
{
    self endon("disconnect");
	self endon("joined_spectators");

    self notify("stop_crosshair_monitor");

    if( isDefined( self.customCrosshair ) )
        self.customCrosshair destroy();
}

SoundOnOrigin(alias,origin)
{
	soundPlayer = spawn( "script_origin", origin );
	soundPlayer playsound( alias );
	wait 10;
	soundPlayer delete();
}

isWeaponHidden(weapon)
{
	switch(weapon)
	{
		case "none":
		case "knife_mp":
		case "frag_grenade_mp":
		case "smoke_grenade_mp":
		case "flash_grenade_mp":
		case "concussion_grenade_mp":
		case "c4_mp":
		case "claymore_mp":
		case "rpg_mp":
		case "briefcase_bomb_mp":
			return true;
	}

	return false;
}

getCleanWeaponName(weapon)
{
	toks = strTok(weapon, "_");
	base = toks[0];

	switch(base)
	{
		case "m16": 		return "M16A4";
		case "ak47": 		return "AK-47";
		case "m4": 			return "M4 Carbine";
		case "g3": 			return "G3";
		case "g36c": 		return "G36C";
		case "m14": 		return "M14";
		case "mp44": 		return "MP44";
		case "mp5": 		return "MP5";
		case "skorpion": 	return "Skorpion";
		case "uzi": 		return "Mini-Uzi";
		case "ak74u": 		return "AK-74u";
		case "p90": 		return "P90";
		case "m1014": 		return "M1014";
		case "winchester1200": return "W1200";
		case "saw": 		return "M249 SAW";
		case "rpd": 		return "RPD";
		case "m60e4": 		return "M60E4";
		case "m40a3": 		return "M40A3";
		case "barrett": 	return "Barrett .50";
		case "dragunov": 	return "Dragunov";
		case "remington700": return "R700";
		case "m21": 		return "M21";
		case "beretta": 	return "M9 Beretta";
		case "colt45": 		return "M1911";
		case "usp": 		return "USP .45";
		case "deserteagle": return "Desert Eagle";
		case "deserteaglegold": return "Golden Deagle";
		case "c4": 			return "C4";
		case "claymore": 	return "Claymore";
		default: 			return weapon;
	}
}

getClipSizeForWeapon(weapon)
{
	toks = strTok(weapon, "_");
	base = toks[0];

	switch(base)
	{
		case "m16":
		case "ak47":
		case "m4":
		case "g3":
		case "g36c":
		case "m14":
		case "mp44":
		case "mp5":
		case "ak74u": 		return 30;
		case "p90": 		return 50;
		case "uzi": 		return 32;
		case "skorpion": 	return 20;
		case "m1014": 		return 7;
		case "winchester1200": return 7;
		case "saw":
		case "rpd":
		case "m60e4": 		return 100;
		case "m40a3":
		case "remington700":
		case "m21": 		return 5;
		case "barrett":
		case "dragunov": 	return 10;
		case "beretta":
		case "usp": 		return 15;
		case "colt45": 		return 8;
		case "deserteagle":
		case "deserteaglegold": return 7;
		default: 			return 30;
	}
}

addDesign(name, index, color, alpha, shader, width, height, al, y)
{
    if(!isDefined(level.designs))
        level.designs = [];

    if(!isDefined(level.designs[name]))
        level.designs[name] = [];

    level.designs[name][index] = [];

    level.designs[name][index][0] = color;
    level.designs[name][index][1] = alpha;
    level.designs[name][index][2] = shader;
    level.designs[name][index][3] = width;
    level.designs[name][index][4] = height;
    level.designs[name][index][5] = al;
    level.designs[name][index][6] = y;

    precacheShader(shader);
}

getDesign(index)
{
    name = self.pers["design"];

    if(isDefined(level.designs[name]) && isDefined(level.designs[name][index]) && isArray(level.designs[name][index]))
        return level.designs[name][index];

    return level.designs["default"][index];
}

array(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20)
{
	r=[];
	r[0] = a1;
	r[1] = a2;
	r[2] = a3;
	r[3] = a4;
	r[4] = a5;
	r[5] = a6;
	r[6] = a7;
	r[7] = a8;
	r[8] = a9;
	r[9] = a10;
	r[10] = a11;
	r[11] = a12;
	r[12] = a13;
	r[13] = a14;
	r[14] = a15;
	r[15] = a16;
	r[16] = a17;
	r[17] = a18;
	r[18] = a19;
	r[19] = a20;
	return r;
}

forceDvar(dvar, value)
{
    if (getDvar(dvar) != value)
    {
        self setClientDvar(dvar, value);
    }
}

addDvar( dvarName, dvarType, dvarDefault, minValue, maxValue )
{
	dvarValue = "";

	if ( getdvar( dvarName ) == "" )
	{
		dvarValue = dvarDefault;
		setDvar( dvarName, dvarValue );
	}

	else
	{
		switch ( dvarType )
		{
			case "int":
				dvarValue = getdvarint( dvarName );
				break;

			case "float":
				dvarValue = getdvarfloat( dvarName );
				break;

			case "string":
				dvarValue = getdvar( dvarName );
				break;
		}
	}

	if ( isDefined( minValue ) && dvarValue < minValue )
	{
		dvarValue = minValue;
	}

	if ( isDefined( maxValue ) && dvarValue > maxValue )
	{
		dvarValue = maxValue;
	}

	level.dvar[ dvarName ] = dvarValue;
}

deleteTurrets()
{
	turrets = getEntArray( "misc_turret", "classname" );
	for( i = 0; i < turrets.size; i++ )
	{
		turrets[ i ] delete();
	}
}

getAllPlayers()
{
	return getEntArray( "player", "classname" );
}

fadeOut(time)
{
	if(!isDefined(self)) return;
	self fadeOverTime(time);
	self.alpha = 0;
	wait time;
	if(!isDefined(self)) return;
	self destroy();
}

isSniperWeapon(weapon)
{
    if(!isDefined(weapon)) return false;

    if( weapon == "m40a3_mp" ||
        weapon == "remington700_mp" ||
        weapon == "dragunov_mp" ||
        weapon == "barrett_mp" ||
        weapon == "m21_mp" )
    {
        return true;
    }

    return false;
}
SniperADS()
{
    weapon = self getCurrentWeapon();

    if(!isDefined(weapon) || weapon == "none")
        return false;

    if( isSniperWeapon(weapon) )
    {

        if( self playerAds() >= 0.9 )
        {
            return true;
        }
    }

    return false;
}

strip(s)
{
	if(s=="")
		return "";

	s2="";
	s3="";

	i=0;
	while(i<s.size && s[i]==" ")
		i++;

	if(i==s.size)
		return "";

	for(;i<s.size;i++)
		s2 += s[i];

	i=s2.size-1;
	while(s2[i]==" " && i>0)
		i--;

	for(j=0;j<=i;j++)
		s3 += s2[j];

	return s3;
}

// ADDITIONAL

removeColor( string )
{
	output = "";
	for(i=0;i<string.size;i++)
	{
		if(string[i] == "^")
		{
			if(i < string.size - 1)
			{
				if ( string[i + 1] == "0" || string[i + 1] == "1" || string[i + 1] == "2" || string[i + 1] == "3" || string[i + 1] == "4" ||
					 string[i + 1] == "5" || string[i + 1] == "6" || string[i + 1] == "7" || string[i + 1] == "8" || string[i + 1] == "9" ) {
					i++;
					continue;
				}
			}
		}
		output += string[i];
	}
	return output;
}

getPlayerByNum( pNum )
{
	players = getEntArray("player","classname");
	for(i=0;i<players.size;i++)
		if ( players[i] getEntityNumber() == int(pNum) ) 
			return players[i];
}

setCvar(dvar,value) {
	return "";
}

getCvar(dvar) {
	return "";
}
getCvarInt(dvar) {
	return int(getCvar(dvar));
}