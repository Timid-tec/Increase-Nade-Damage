#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <timid>


Handle g_Cvar_HePower = INVALID_HANDLE;
Handle g_Cvar_HeRadius = INVALID_HANDLE;

public Plugin myinfo = 
{
	name = "Reduce Nade Damage", 
	author = PLUGIN_AUTHOR, 
	description = "Increase HE Nade Damge and radius", 
	version = PLUGIN_VERSION, 
	url = ""
}

public void OnPluginStart()
{
	CreateConVar("ind_version", PLUGIN_VERSION, "Version of increased nade damage", FCVAR_NOTIFY | FCVAR_DONTRECORD);
	
	g_Cvar_HePower = CreateConVar("sm_hePower", "1.0", "Power of HE nades. <Default: 1.3>");
	g_Cvar_HeRadius = CreateConVar("sm_heRadius", "2.3", "Radius of the nade.  <Default: 2.5>");
}

public void OnEntityCreated(int client, const char[] szClassname)
{
	if (StrEqual(szClassname, "hegrenade_projectile"))
	{
		SDKHook(client, SDKHook_SpawnPost, OnGrenadeSpawn);
	}
}

public void OnGrenadeSpawn(int iGrenade)
{
	CreateTimer(0.01, ChangeGrenadeDamage, iGrenade, TIMER_FLAG_NO_MAPCHANGE);
}

public Action ChangeGrenadeDamage(Handle hTimer, int client)
{
	if (!IsValidClient(client))
		return Plugin_Changed;
	float flGrenadePower = GetEntPropFloat(client, Prop_Send, "m_flDamage");
	float flGrenadeRadius = GetEntPropFloat(client, Prop_Send, "m_DmgRadius");
	
	SetEntPropFloat(client, Prop_Send, "m_flDamage", (flGrenadePower * GetConVarFloat(g_Cvar_HePower)));
	SetEntPropFloat(client, Prop_Send, "m_DmgRadius", (flGrenadeRadius * GetConVarFloat(g_Cvar_HeRadius)));
	return Plugin_Handled;
} 