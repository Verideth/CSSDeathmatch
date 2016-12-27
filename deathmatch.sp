#include <sourcemod>
#include <cstrike>
#include <sdktools>
 
public Plugin myinfo =
{
    name = "Deathmatch",
    author = "Verideth",
    description = "Deathmatch gamemode for CSS",
    version = "1.0",
    url = ""
};
 
public Action PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
    //Get ids
    int client = GetClientOfUserId(event.GetInt("userid"));
    int attacker = GetClientOfUserId(event.GetInt("attacker"));
 
    //SendDeathMessage
    PrintToChatAll("\x03Player %N was killed by: %N", client, attacker);
   
    //kill count
    if (attacker > 0 && IsClientInGame(attacker) && GetClientFrags(attacker) >= 9) // if having 10 kills then continue.
    {
        PrintToChatAll("\x03%N \x05is the winner!", attacker);
        CreateTimer(5.0, ForceLevel);
    }
   
    //respawn
    CreateTimer(0.1, Respawn, GetClientSerial(client));
   
    return Plugin_Continue;
}
 
public Action ForceLevel(Handle timer)
{
	decl String:maps[][] = 
	{
		"cs_italy",
		"de_dust",
		"de_dust2",
		"de_nuke",
		"cs_militia",
		"de_train",
		"de_prodigy"
	}

    	ForceChangeLevel(maps[GetRandomInt(0, 6)], "Changing because the winner has won the game!");
}
 
public Action GiveWeapon(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	
	decl String:weapons[][] = 
	{
		"weapon_ak47",
		"weapon_famas",
		"weapon_awp",
		"weapon_g3sg1",
		"weapon_galil",
		"weapon_m429",
		"weapon_m3",
		"weapon_m4a1",
		"weapon_mac10",
		"weapon_mp5navy",
		"weapon_p228",
		"weapon_p90",
		"weapon_scout",
		"weapon_sg550",
		"weapon_sg552",
		"weapon_ump45",
		"weapon_xm1014"
	}
	
	// Secondary array
	// decl String:weapons2[][] =
	// {
		// "weapon_usp",
		// "weapon_p228",
		// "weapon_deagle",
		// "weapon_elite",
		// "weapon_fiveseven",
		// "weapon_glock",
		// "weapon_tmp"
	// }

	GivePlayerItem(client, weapons[GetRandomInt(0, 16)]);
	// GivePlayerItem(client, weapons2[GetRandomInt(0, 6)]); uncomment this if you want to have secondaries
}
 
public Action Respawn(Handle timer, any serial)
{
   	int client = GetClientFromSerial(serial); // Validate client serial
   
	if (client == 0) 
	{
        	return Plugin_Stop;
    	}
 
    	if (GetClientTeam(client) != 1) //if not spectate continue
    	{
    	    CS_RespawnPlayer(client);
    	}
	
	return Plugin_Continue;
}
 
public Action CS_OnBuyCommand(int client, const char[] weapon)
{
    return Plugin_Handled;
}

public void OnPluginStart()
{
   	 PrintToChatAll("\x03Welcome to deathmath! A gamemode made by verideth!");
	
    	HookEvent("player_death", PlayerDeath);
	  HookEvent("player_spawn", GiveWeapon);
}
