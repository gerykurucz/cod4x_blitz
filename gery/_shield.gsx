/*
 * ============================================================
 *  COD4X - Blitz
 *  Version: 3.2
 *  Developer: Gery Kurucz (github.com/gerykurucz)
 * ============================================================
 */
 
#include gery\_common;

elevatorFix()
{
	self endon("disconnect");
	self endon("death");
	self endon("joined_spectators");

	for(;;)
    {
		oldorigin = self.origin;
		wait 0.05;

		if(oldorigin[0] == self.origin[0] && oldorigin[1] == self.origin[1] && !self IsOnLadder() && oldorigin[2] < self.origin[2])
        {
			wait 0.1;
			if(oldorigin[0] == self.origin[0] && oldorigin[1] == self.origin[1] && !self IsOnLadder() && (oldorigin[2] + getDvarInt("jump_height") < self.origin[2]) && !self IsOnGround())
            {
				for(i=0;i<340;i++)
                {
					pos = BulletTrace( self.origin+((50*cos(i+10)),(50*sin(i+10)),0), self.origin+((50*cos(i+10)),(50*sin(i+10)),-200), 0, self)[ "position" ];
					if(BulletTracePassed(self.origin+((50*cos(i)),(50*sin(i)),0),self.origin+((50*cos(i+20)),(50*sin(i+20)),0),0,self) && pos[2] < oldorigin[2])
                    {
                        self iPrintLn("^2Nektum Shield: ^7Detected Elevator");
 						self setOrigin(pos);
 						break;
 					}
 				}
			}
		}
	}
}

spawnProtection()
{
	self endon( "disconnect" );
	self endon( "joined_spectators" );
	self endon( "death" );

	if( level.inPrematchPeriod )
		level waittill( "prematch_over" );

	waittillframeend;

	self setHealth( 9999 );

	startPos = self.origin;
	time = 40;

	while( time > 0 )
	{
		if( distancesquared( startPos, self.origin ) > 250000 )
			break;

		if( self attackButtonPressed() || self meleeButtonPressed() || self fragButtonPressed() )
			break;

		wait 0.05;
		time--;
	}

	self setHealth( 30 );
}

monitorCamp()
{
    self endon("disconnect");
    self endon("joined_spectators");
    self endon("death");

	if( level.inPrematchPeriod )
		level waittill( "prematch_over" );
        
    self.hidden = false;
    self.reaper = false;
    
    self.campTimer = 0;
    self.lastOrigin = self.origin;

    for(;;)
    {
        wait level.camp_checkInterval;
        
        if (!isDefined(self.origin) || !isDefined(self.lastOrigin))
            continue;

        currentDistance = distance(self.origin, self.lastOrigin);

        if(currentDistance < level.camp_minDistance)
        {            
            while ( self isHardpoint() )
                wait 0.5;

            while ( self isSniper() )
                wait 0.5;

            while( isDefined(self.hidden) && self.hidden )
                wait 0.5;
                
            while( isDefined(self.reaper) && self.reaper )
                wait 0.5;

            self.campTimer += level.camp_checkInterval;
            
            if(self.campTimer >= level.camp_maxTime)
            {
                self iPrintlnBold("^1ANTI-CAMP: You have 5 seconds to move.");

                while ( self isHardpoint() )
                    wait 1;

                while ( self isSniper() )
                    wait 1;

                while( isDefined(self.hidden) && self.hidden )
                    wait 1;
                    
                while( isDefined(self.reaper) && self.reaper )
                    wait 1;

                wait level.camp_gracePeriod;

                while ( self isHardpoint() )
                    wait 1;

                while( isDefined(self.hidden) && self.hidden )
                    wait 1;
                    
                while( isDefined(self.reaper) && self.reaper )
                    wait 1;

                if (!isDefined(self.origin) || !isDefined(self.lastOrigin))
                {
                    self.campTimer = 0;
                    continue;
                }

                if( distance(self.origin, self.lastOrigin) > level.camp_minDistance )
                {
                    self iPrintlnBold("^2ANTI-CAMP: OK!");
                }

                if( distance(self.origin, self.lastOrigin) < level.camp_minDistance )
                {
                    self iPrintlnBold("^1ANTI-CAMP: Not enough movement!");
                    wait 0.5;
                    self suicide();
                }

                self.campTimer = 0;
                self.lastOrigin = self.origin;
            }
        }
        else
        {
            self.campTimer = 0;
            self.lastOrigin = self.origin;
        }
    }
}


isSniper()
{
    currentGun = self getCurrentWeapon();

    if ( isSubStr(currentGun, "m40a3") ) return true;
    if ( isSubStr(currentGun, "barrett") ) return true;
    if ( isSubStr(currentGun, "dragunov") ) return true;
    if ( isSubStr(currentGun, "m21") ) return true;
    if ( isSubStr(currentGun, "remington700") || isSubStr(currentGun, "r700") ) return true;

    return false;
}

isHardpoint()
{
    currentGun = self getCurrentWeapon();

    if ( isSubStr(currentGun, "radar") ) return true;
    if ( isSubStr(currentGun, "airstrike") ) return true;
    if ( isSubStr(currentGun, "helicopter") ) return true;

    return false;
}
