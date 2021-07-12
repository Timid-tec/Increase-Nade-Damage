/*  [CS:GO] InceaseNadeDamage: Change the nade damage.
 *
 *  Copyright (C) 2021 Mr.Timid // timidexempt@gmail.com
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with 
 * this program. If not, see http://www.gnu.org/licenses/.
 */

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
	
	g_Cvar_HePower = CreateConVar("sm_hePower", "1.0", "Power of HE nades. (Default: 1.3)");
	g_Cvar_HeRadius = CreateConVar("sm_heRadius", "2.3", "Radius of the nade.  (Default: 2.5");
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