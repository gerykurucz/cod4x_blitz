/*
 * ============================================================
 *  COD4X - Blitz
 *  Version: 3.2
 *  Developer: Gery Kurucz (github.com/gerykurucz)
 * ============================================================
 */
 
autoTeamBalance()
{
    level endon("game_ended");
    setDvar("scr_teambalance", "0");

    for (;;)
    {
        wait 15;

        if( shouldStopBalance2() ) continue;

        checkHumanBalance();

        wait 1;
        checkBotBalance();
    }
}

checkHumanBalance()
{
    realAllies = [];
    realAxis = [];
    players = getEntArray("player", "classname");

    for (i = 0; i < players.size; i++)
    {
        player = players[i];

        if (!isDefined(player.pers["team"]) || (player.pers["team"] != "allies" && player.pers["team"] != "axis"))
            continue;

        isBot = (isDefined(player.isBot) && player.isBot) || (isDefined(player.pers["isBot"]) && player.pers["isBot"]);
        if (isBot) continue;

        if (player.pers["team"] == "allies")
            realAllies[realAllies.size] = player;
        else
            realAxis[realAxis.size] = player;
    }

    realDiff = realAllies.size - realAxis.size;

    if (realDiff >= 2 || realDiff <= -2)
    {
        if (realDiff > 0)
        {
            overPopulated = realAllies;
            newTeam = "axis";
        }
        else
        {
            overPopulated = realAxis;
            newTeam = "allies";
        }

        candidates = [];
        for (j = 0; j < overPopulated.size; j++)
        {
            p = overPopulated[j];

            if (isDefined(p.balanceThread) && p.balanceThread) continue;
            if (isDefined(p.lastTeamSwap) && (getTime() - p.lastTeamSwap) < 90000) continue;

            candidates[candidates.size] = p;
        }

        if (candidates.size == 0) return;

        lowestScorePlayer = candidates[0];
        lowestScore = getScore(lowestScorePlayer);

        for (j = 1; j < candidates.size; j++)
        {
            pScore = getScore(candidates[j]);
            if (pScore < lowestScore)
            {
                lowestScore = pScore;
                lowestScorePlayer = candidates[j];
            }
        }

        lowestScorePlayer thread movePlayerToTeam(newTeam);
    }
}

checkBotBalance()
{
    alliesCount = 0;
    axisCount = 0;
    botAllies = [];
    botAxis = [];

    players = getEntArray("player", "classname");

    for (i = 0; i < players.size; i++)
    {
        player = players[i];

        if (!isDefined(player.pers["team"]) || (player.pers["team"] != "allies" && player.pers["team"] != "axis"))
            continue;

        if (player.pers["team"] == "allies") alliesCount++;
        else axisCount++;

        isBot = (isDefined(player.isBot) && player.isBot) || (isDefined(player.pers["isBot"]) && player.pers["isBot"]);
        if (isBot)
        {
            if (player.pers["team"] == "allies") botAllies[botAllies.size] = player;
            else botAxis[botAxis.size] = player;
        }
    }

    totalDiff = alliesCount - axisCount;

    if (totalDiff >= 2 || totalDiff <= -2)
    {
        if (totalDiff > 0 && botAllies.size > 0)
        {
            botToMove = botAllies[0];
            botToMove thread moveBotToTeam("axis");
        }
        else if (totalDiff < 0 && botAxis.size > 0)
        {
            botToMove = botAxis[0];
            botToMove thread moveBotToTeam("allies");
        }
    }
}

scoreBalanceLoop()
{
    level endon("game_ended");

    for (;;)
    {
        wait 150;

        if (shouldStopBalance()) continue;

        calculateSwaps();
    }
}

calculateSwaps()
{
    players = getEntArray("player", "classname");
    realAllies = [];
    realAxis = [];
    totalReal = 0;

    for (i = 0; i < players.size; i++)
    {
        player = players[i];
        if (!isDefined(player.team) || (player.team != "allies" && player.team != "axis")) continue;

        isBot = (isDefined(player.isBot) && player.isBot) || (isDefined(player.pers["isBot"]) && player.pers["isBot"]);
        if (isBot) continue;

        totalReal++;
        if (player.team == "allies") realAllies[realAllies.size] = player;
        else realAxis[realAxis.size] = player;
    }

    topN = 0;
    if (totalReal > 24) topN = 24;
    else if (totalReal > 22) topN = 22;
    else if (totalReal > 20) topN = 20;
    else if (totalReal > 18) topN = 18;
    else if (totalReal > 16) topN = 16;
    else if (totalReal > 14) topN = 13;
    else if (totalReal > 12) topN = 12;
    else if (totalReal > 10) topN = 10;
    else if (totalReal >= 8) topN = 8;
    if (topN < 8) return;

    realAllies = sortPlayersByScore(realAllies);
    realAxis = sortPlayersByScore(realAxis);

    topAllies = [];
    topAxis = [];

    if (realAllies.size < topN)
        limitA = realAllies.size;
    else
        limitA = topN;

    if (realAxis.size < topN)
        limitX = realAxis.size;
    else
        limitX = topN;

    for (i = 0; i < limitA; i++) topAllies[i] = realAllies[i];
    for (i = 0; i < limitX; i++) topAxis[i] = realAxis[i];

    sumAllies = 0;
    sumAxis = 0;
    for (i = 0; i < topAllies.size; i++) sumAllies += getScore(topAllies[i]);
    for (i = 0; i < topAxis.size; i++) sumAxis += getScore(topAxis[i]);

    currentDiff = sumAllies - sumAxis;

    if (abs(currentDiff) < 200) return;

    while (abs(currentDiff) >= 200)
    {
        bestSwap = undefined;
        bestNewDiff = abs(currentDiff);

        for (i = 0; i < topAllies.size; i++)
        {
            for (j = 0; j < topAxis.size; j++)
            {
                pA = topAllies[i];
                pX = topAxis[j];

                if ((isDefined(pA.balanceThread) && pA.balanceThread) ||
                    (isDefined(pX.balanceThread) && pX.balanceThread)) continue;

                if (isDefined(pA.lastTeamSwap) && (getTime() - pA.lastTeamSwap) < 450000) continue;
                if (isDefined(pX.lastTeamSwap) && (getTime() - pX.lastTeamSwap) < 450000) continue;

                newSumAllies = sumAllies - getScore(pA) + getScore(pX);
                newSumAxis = sumAxis - getScore(pX) + getScore(pA);
                newDiff = abs(newSumAllies - newSumAxis);

                if (newDiff < bestNewDiff)
                {
                    bestNewDiff = newDiff;
                    bestSwap = [];
                    bestSwap[0] = pA;
                    bestSwap[1] = pX;
                }
            }
        }

        if (isDefined(bestSwap))
        {
            bestSwap[0].balanceThread = true;
            bestSwap[1].balanceThread = true;
            bestSwap[0] thread movePlayerToTeam2("axis");
            bestSwap[1] thread movePlayerToTeam2("allies");
            break;
        }
        else
        {
            break;
        }
    }
}

sortPlayersByScore(arr)
{
    for (i = 0; i < arr.size; i++)
    {
        for (j = i + 1; j < arr.size; j++)
        {
            if (getScore(arr[i]) < getScore(arr[j]))
            {
                temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
            }
        }
    }
    return arr;
}

movePlayerToTeam(team)
{
    self endon("disconnect");
    self endon("joined_spectators");
    level endon("game_ended");

    self.balanceThread = true;
    self thread clearBalanceFlagOn("joined_spectators");

    if (self.sessionstate == "playing")
    {
        self waittill("death");
    }

    realAllies = [];
    realAxis = [];
    players = getEntArray("player", "classname");

    for (i = 0; i < players.size; i++)
    {
        player = players[i];

        if (!isDefined(player.pers["team"]) || (player.pers["team"] != "allies" && player.pers["team"] != "axis"))
            continue;

        isBot = (isDefined(player.isBot) && player.isBot) || (isDefined(player.pers["isBot"]) && player.pers["isBot"]);
        if (isBot) continue;

        if (player.pers["team"] == "allies")
            realAllies[realAllies.size] = player;
        else
            realAxis[realAxis.size] = player;
    }

    realDiff = realAllies.size - realAxis.size;
    if (realDiff > -2 && realDiff < 2)
    {
        self.balanceThread = false;
        return;
    }

    if (team == "allies")
    {
        self thread [[level.allies]]();
    }
    else if (team == "axis")
    {
        self thread [[level.axis]]();
    }

    if (self.sessionstate == "playing")
    {
        wait 0.5;
        self suicide();
    }
    self.lastTeamSwap = getTime();

    self iprintlnbold("You've been moved to balance teams!");
    self.balanceThread = false;
    self notify("balance_move_done");

    wait 0.5;
    thread checkBotBalance();
}

movePlayerToTeam2(team)
{
    self endon("disconnect");
    self endon("joined_spectators");
    level endon("game_ended");

    self.balanceThread = true;
    self thread clearBalanceFlagOn("joined_spectators");

    if (self.sessionstate == "playing")
    {
        self waittill("death");
    }

    if (team == "allies")
    {
        self thread [[level.allies]]();
    }
    else if (team == "axis")
    {
        self thread [[level.axis]]();
    }

    if (self.sessionstate == "playing")
    {
        wait 0.5;
        self suicide();
    }
    self.lastTeamSwap = getTime();

    self iprintlnbold("You've been moved to balance teams!");
    self.balanceThread = false;
    self notify("balance_move_done");
    
    wait 0.5;
    thread checkBotBalance();
}

clearBalanceFlagOn(eventName)
{
    self endon("disconnect");
    self endon("balance_move_done");
    self waittill(eventName);
    self.balanceThread = false;
}

moveBotToTeam(team)
{
    self endon("disconnect");
    level endon("game_ended");

    if (team == "allies")
    {
        self thread [[level.allies]]();
    }
    else if (team == "axis")
    {
        self thread [[level.axis]]();
    }
    
    if (self.sessionstate == "playing")
    {
        wait 0.5;
        self suicide();
    }
}

getScore(player)
{
    if (isDefined(player.score)) return player.score;
    if (isDefined(player.pers["score"])) return player.pers["score"];
    return 0;
}

shouldStopBalance()
{
    if (isDefined(level.timeLimit) && level.timeLimit > 0)
    {
        timeRemaining = getTimeRemaining();
        if (timeRemaining <= 200000)
            return true;
    }
/*
    if (isDefined(game["teamScores"]))
    {
        alliesScore = 0;
        axisScore = 0;

        if (isDefined(game["teamScores"]["allies"]))
            alliesScore = game["teamScores"]["allies"];
        if (isDefined(game["teamScores"]["axis"]))
            axisScore = game["teamScores"]["axis"];

        if (alliesScore >= 6000 || axisScore >= 6000)
            return true;
    }
*/

    return false;
}

shouldStopBalance2()
{
    if (isDefined(level.timeLimit) && level.timeLimit > 0)
    {
        timeRemaining = getTimeRemaining();
        if (timeRemaining <= 70000)
            return true;
    }

    return false;
}


getTimeRemaining()
{
	return level.timeLimit * 60 * 1000 - getTimePassed();
}

getTimePassed()
{
	if ( !isDefined( level.startTime ) )
		return 0;

	if ( level.timerStopped )
		return (level.timerPauseTime - level.startTime) - level.discardTime;
	else
		return (gettime()            - level.startTime) - level.discardTime;

}

isHardpoint()
{
    currentGun = self getCurrentWeapon();

    if ( isSubStr(currentGun, "radar") ) return true;
    if ( isSubStr(currentGun, "airstrike") ) return true;
    if ( isSubStr(currentGun, "helicopter") ) return true;

    return false;
}