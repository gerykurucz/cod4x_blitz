/*
 * ============================================================
 *  COD4X - Blitz
 *  Version: 3.2
 *  Developer: Gery Kurucz (github.com/gerykurucz)
 * ============================================================
 */
 
disableGL()
{
    self endon("death");
    self endon("disconnect");

    while( (isDefined(level.inPrematchPeriod) && level.inPrematchPeriod) || (isDefined(level.inGracePeriod) && level.inGracePeriod) )
    {
        curWeap = self GetCurrentWeapon();

        if( IsSubStr( curWeap, "_gl_" ) )
        {
            toks = strTok( curWeap, "_" );
            baseWeap = toks[0] + "_" + toks[2];

            self takeWeapon(curWeap);
            self giveWeapon(baseWeap);
            self setSpawnWeapon(baseWeap);
            self giveStartAmmo(baseWeap);
        }
        wait 0.1;
    }

    curWeap = self GetCurrentWeapon();
    if( IsSubStr( curWeap, "_gl_" ) )
    {
        toks = strTok( curWeap, "_" );
        baseWeap = toks[0] + "_" + toks[2];

        self takeWeapon(curWeap);
        self giveWeapon(baseWeap);
        self setSpawnWeapon(baseWeap);
        self giveStartAmmo(baseWeap);
    }

}

disablePerks()
{
    self endon("death");
    self endon("disconnect");

    while( (isDefined(level.inPrematchPeriod) && level.inPrematchPeriod) || (isDefined(level.inGracePeriod) && level.inGracePeriod) )
    {
        self removeWeapons();
        self applyCustomPerks();
        wait 0.1;
    }

    self removeWeapons();
    self applyCustomPerks();
}

applyCustomPerks()
{
    if( self hasPerk( "specialty_twoprimaries" ) )
    {
        currentWeapon = self getCurrentWeapon();
        allWeapons = self getWeaponsList();

        for( i = 0; i < allWeapons.size; i++ )
        {
            wep = allWeapons[i];

            if( wep == currentWeapon )
                continue;

            if( isSubStr( wep, "grenade" ) )
                continue;

            if( wep == "radar_mp" || wep == "airstrike_mp" || wep == "helicopter_mp" )
                continue;

            wepClass = WeaponClass( wep );

            isMainWeapon = (wepClass == "rifle" || wepClass == "smg" || wepClass == "mg" || wepClass == "spread" || wepClass == "sniper");

            isNotEquipment = (wep != "frag_grenade_mp" && wep != "concussion_grenade_mp" && wep != "flash_grenade_mp" && wep != "smoke_grenade_mp");
            isNotScorestreak = (wep != "radar_mp" && wep != "airstrike_mp" && wep != "helicopter_mp");

            if ( wep != currentWeapon && isMainWeapon && isNotEquipment && isNotScorestreak )
            {
                self takeWeapon( wep );
            }
        }

        if( !self hasWeapon( "deserteagle_mp" ) )
        {
            self giveWeapon( "deserteagle_mp" );
            self giveMaxAmmo( "deserteagle_mp" );
        }

        self setSpawnWeapon( currentWeapon );
    }

    if( self HasPerk("specialty_extraammo") && self HasPerk("specialty_fastreload") && self HasPerk("specialty_bulletaccuracy") )
        return;

    self clearPerks();
    wait 0.1;
    if(!self HasPerk("specialty_extraammo"))
    {
        self SetPerk("specialty_extraammo");
    }

    if(!self HasPerk("specialty_fastreload"))
    {
        self SetPerk("specialty_fastreload");
    }

    if(!self HasPerk("specialty_bulletaccuracy"))
    {
        self SetPerk("specialty_bulletaccuracy");
    }
}

removeWeapons()
{
    badItems = [];
    badItems[0] = "weapon_rpg7_mp";
    badItems[1] = "rpg_mp";

    for(i = 0; i < badItems.size; i++)
    {
        item = badItems[i];
        if(self HasWeapon(item))
        {
            self TakeWeapon(item);
        }
    }

    if(self HasWeapon("frag_grenade_mp"))
    {
        if(self GetWeaponAmmoStock("frag_grenade_mp") > 1)
        {
            self SetWeaponAmmoStock("frag_grenade_mp", 1);
        }
    }

    specGrens = [];
    specGrens[0] = "flash_grenade_mp";
    specGrens[1] = "concussion_grenade_mp";
    specGrens[2] = "smoke_grenade_mp";

    for(i = 0; i < specGrens.size; i++)
    {
        grenade = specGrens[i];
        if(self HasWeapon(grenade))
        {
            if(self GetWeaponAmmoStock(grenade) > 1)
            {
                self SetWeaponAmmoStock(grenade, 1);
            }
        }
    }
    if( !self HasWeapon("claymore_mp") || !self hasWeapon("c4_mp") )
    {
        if( self HasWeapon("claymore_mp") )
            self TakeWeapon("claymore_mp");

        if( self hasWeapon("c4_mp") )
            self TakeWeapon("c4_mp");

        self SetActionSlot( 1, "" );
        self SetActionSlot( 3, "" );
        
        self giveWeapon( "claymore_mp" );
        self setWeaponAmmoStock( "claymore_mp", 2 );
        self setActionSlot( 3, "weapon", "claymore_mp" );

        self giveWeapon( "c4_mp" );
        self setWeaponAmmoStock( "c4_mp", 2 );
        self SetActionSlot( 1, "weapon", "c4_mp" );
    }
}
