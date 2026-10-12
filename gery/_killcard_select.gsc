/*-------------------------------------------------------------------------------------*/
/* This menu is based on Braxi's original deathrun source + script by Zoro-6191 promod */
/*-----------------------------By JEENNN:]---------------------------------------------*/
/*-------------------------------------------------------------------------------------*/
init()
{
	preCacheMenu("killcard");
	for(i=0;i<60;i++)
	{
		precacheshader("killcard"+i+"_menu");
	} 
	thread OnPlayerConnect();
}
onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting",player);
		player thread onPlayerMenuResponse();
	}
}
onPlayerMenuResponse()
{
	level endon("restarting");
	level endon("game_ended");
	self endon( "disconnect" );
	while(1)
	{
		self waittill( "menuresponse", menu, response );
		processMenuResponse( menu, response );
	}
}
processMenuResponse( menu, response )
{
	switch( response )
	{
		case "killcard0_menu":
			self.pers["killcard"] = int(0);
			self setStat(71,0);
			break;
		case "killcard1_menu":
			self.pers["killcard"] = int(1);
			self setStat(71,1);
			break;
		case "killcard2_menu":
			self.pers["killcard"] = int(2);
			self setStat(71,2);
			break;
		case "killcard3_menu":
			self.pers["killcard"] = int(3);
			self setStat(71,3);
			break;
		case "killcard4_menu":
			self.pers["killcard"] = int(4);
			self setStat(71,4);
			break;
		case "killcard5_menu":
			self.pers["killcard"] = int(5);
			self setStat(71,5);
			break;
		case "killcard6_menu":
			self.pers["killcard"] = int(6);
			self setStat(71,6);
			break;
		case "killcard7_menu":
			self.pers["killcard"] = int(7);
			self setStat(71,7);
			break;
		case "killcard8_menu":
			self.pers["killcard"] = int(8);
			self setStat(71,8);
			break;
		case "killcard9_menu":
			self.pers["killcard"] = int(9);
			self setStat(71,9);
			break;
		case "killcard10_menu":
			self.pers["killcard"] = int(10);
			self setStat(71,10);
			break;
		case "killcard11_menu":
			self.pers["killcard"] = int(11);
			self setStat(71,11);
			break;
		case "killcard12_menu":
			self.pers["killcard"] = int(12);
			self setStat(71,12);
			break;
		case "killcard13_menu":
			self.pers["killcard"] = int(13);
			self setStat(71,13);
			break;
		case "killcard14_menu":
			self.pers["killcard"] = int(14);
			self setStat(71,14);
			break;
		case "killcard15_menu":
			self.pers["killcard"] = int(15);
			self setStat(71,15);
			break;
		case "killcard16_menu":
			self.pers["killcard"] = int(16);
			self setStat(71,16);
			break;
		case "killcard17_menu":
			self.pers["killcard"] = int(17);
			self setStat(71,17);
			break;
		case "killcard18_menu":
			self.pers["killcard"] = int(18);
			self setStat(71,18);
			break;
		case "killcard19_menu":
			self.pers["killcard"] = int(19);
			self setStat(71,19);
			break;
		case "killcard20_menu":
			self.pers["killcard"] = int(20);
			self setStat(71,20);
			break;
		case "killcard21_menu":
			self.pers["killcard"] = int(21);
			self setStat(71,21);
			break;
		case "killcard22_menu":
			self.pers["killcard"] = int(22);
			self setStat(71,22);
			break;
		case "killcard23_menu":
			self.pers["killcard"] = int(23);
			self setStat(71,23);
			break;
		case "killcard24_menu":
			self.pers["killcard"] = int(24);
			self setStat(71,24);
			break;
		case "killcard25_menu":
			self.pers["killcard"] = int(25);
			self setStat(71,25);
			break;
		case "killcard26_menu":
			self.pers["killcard"] = int(26);
			self setStat(71,26);
			break;
		case "killcard27_menu":
			self.pers["killcard"] = int(27);
			self setStat(71,27);
			break;
		case "killcard28_menu":
			self.pers["killcard"] = int(28);
			self setStat(71,28);
			break;
		case "killcard29_menu":
			self.pers["killcard"] = int(29);
			self setStat(71,29);
			break;
		case "killcard30_menu":
			self.pers["killcard"] = int(30);
			self setStat(71,30);
			break;
		case "killcard31_menu":
			self.pers["killcard"] = int(31);
			self setStat(71,31);
			break;
		case "killcard32_menu":
			self.pers["killcard"] = int(32);
			self setStat(71,32);
			break;
		case "killcard33_menu":
			self.pers["killcard"] = int(33);
			self setStat(71,33);
			break;
		case "killcard34_menu":
			self.pers["killcard"] = int(34);
			self setStat(71,34);
			break;
		case "killcard35_menu":
			self.pers["killcard"] = int(35);
			self setStat(71,35);
			break;
		case "killcard36_menu":
			self.pers["killcard"] = int(36);
			self setStat(71,36);
			break;
		case "killcard37_menu":
			self.pers["killcard"] = int(37);
			self setStat(71,37);
			break;
		case "killcard38_menu":
			self.pers["killcard"] = int(38);
			self setStat(71,38);
			break;
		case "killcard39_menu":
			self.pers["killcard"] = int(39);
			self setStat(71,39);
			break;
		case "killcard40_menu":
			self.pers["killcard"] = int(40);
			self setStat(71,40);
			break;
		case "killcard41_menu":
			self.pers["killcard"] = int(41);
			self setStat(71,41);
			break;
		case "killcard42_menu":
			self.pers["killcard"] = int(42);
			self setStat(71,42);
			break;
		case "killcard43_menu":
			self.pers["killcard"] = int(43);
			self setStat(71,43);
			break;
		case "killcard44_menu":
			self.pers["killcard"] = int(44);
			self setStat(71,44);
			break;
		case "killcard45_menu":
			self.pers["killcard"] = int(45);
			self setStat(71,45);
			break;
		case "killcard46_menu":
			self.pers["killcard"] = int(46);
			self setStat(71,46);
			break;
		case "killcard47_menu":
			self.pers["killcard"] = int(47);
			self setStat(71,47);
			break;
		case "killcard48_menu":
			self.pers["killcard"] = int(48);
			self setStat(71,48);
			break;
		case "killcard49_menu":
			self.pers["killcard"] = int(49);
			self setStat(71,49);
			break;
		case "killcard50_menu":
			self.pers["killcard"] = int(50);
			self setStat(71,50);
			break;
		case "killcard51_menu":
			self.pers["killcard"] = int(51);
			self setStat(71,51);
			break;
		case "killcard52_menu":
			self.pers["killcard"] = int(52);
			self setStat(71,52);
			break;
		case "killcard53_menu":
			self.pers["killcard"] = int(53);
			self setStat(71,53);
			break;
		case "killcard54_menu":
			self.pers["killcard"] = int(54);
			self setStat(71,54);
			break;
		case "killcard55_menu":
			self.pers["killcard"] = int(55);
			self setStat(71,55);
			break;
		case "killcard56_menu":
			self.pers["killcard"] = int(56);
			self setStat(71,56);
			break;
		case "killcard57_menu":
			self.pers["killcard"] = int(57);
			self setStat(71,57);
			break;
		case "killcard58_menu":
			self.pers["killcard"] = int(58);
			self setStat(71,58);
			break;
		case "killcard59_menu":
			self.pers["killcard"] = int(59);
			self setStat(71,59);
			break;
		case "killcard60_menu":
			self.pers["killcard"] = int(60);
			self setStat(71,60);
			break;
		case "killcard61_menu":
			num = strTok(response, "_")[1];
			self.pers["killcard"] = int(num);
			self setStat(70,int(num));
			break;
			
	}
}