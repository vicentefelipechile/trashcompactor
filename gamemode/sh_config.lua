GM.Config = GM.Config or {}

--CONFIG SETTINGS

--Use thr Trashman Queue? (Use tc_queue 1  console command now)
--GM.Config.UseTrashmanQueue = true
GM.Config.UseTrashmanQueue = CreateConVar("tc_usequeue", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Use Trashman Queue")

--Round length in minutes (Use tc_roundtime instead)
--GM.Config.RoundTime = 5
GM.Config.RoundTime = CreateConVar("tc_roundtime", 5, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Round Time")

--Amount of players needed before the round will start.
--GM.Config.MinumumPlayersNeeded = 2
GM.Config.MinumumPlayersNeeded = CreateConVar("tc_minplayers", 2, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Minimum Players Needed")

--Trashmen can double tap reload to drop all at once
--GM.Config.DropAllEnabled = true
GM.Config.DropAllEnabled = CreateConVar("tc_dropall", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Drop All Enabled")

--Trashmen can freeze objects
--GM.Config.FreezePropsEnabled = true
GM.Config.FreezePropsEnabled = CreateConVar("tc_freezeprops", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Freeze Props Enabled")

--Maximum amount of props the Trashman can freeze (Use tc_maxfreeze ## console command now)
--GM.Config.MaxFreezeAmount = 10
GM.Config.MaxFreezeAmount = CreateConVar("tc_maxfreeze", 10, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Max Freeze Amount")

--Props will collide with each other
--GM.Config.PropCollision = false
GM.Config.PropCollision = CreateConVar("tc_propcollision", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Prop Collision")

--Trashmen spawn with the Physgun
--GM.Config.SpawnWithPhysGun = true
GM.Config.SpawnWithPhysGun = CreateConVar("tc_spawnwithphysgun", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Spawn With Physgun")

--Strip Trashman of Physgun when he jumps down?
--GM.Config.StripPhysgun = true
GM.Config.StripPhysgun = CreateConVar("tc_stripphysgun", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Strip Physgun")



--Max grab distance for props (Use tc_maxpropdistance ### console command now)
--GM.Config.MaxPropDistance = 800
GM.Config.MaxPropDistance = CreateConVar("tc_maxpropdistance", 800, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Max Prop Distance")

--Can Victims fight it out if they survive the round?
--GM.Config.DMOnRoundEnd = true
GM.Config.DMOnRoundEnd = CreateConVar("tc_dmonroundend", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Deathmatch On Round End")

--Trashman AFK Timer. Set 0 to disable (Use tc_afktimer ## console command now)
--GM.Config.TrashmanAfkTimer = 20
GM.Config.TrashmanAfkTimer = CreateConVar("tc_afktimer", 20, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Trashman AFK Timer")

--Colors--

--Default color for the Trashman team. For GUI only. (Red Green Blue Alpha format. Leave Alpha at 255) Default is 120,152,27,255
--GM.Config.TrashmanColor = Color(120,152,27,255)
GM.Config.TrashmanColor = CreateConVar("tc_trashmancolor", "120 152 27 255", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Trashman Color")

--Default color for the Victims team. For GUI only. Default is 46,92,165,255
--GM.Config.VictimsColor = Color(46,92,165,255)
GM.Config.VictimsColor = CreateConVar("tc_victimscolor", "46 92 165 255", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Victims Color")

--Default color for the Trashman weapon and skin (Red Green Blue format. Value between 1 & 0 work best. ex 0.58)
--GM.Config.TrashmanWeaponColor = Vector(0,1,0)
GM.Config.TrashmanWeaponColor = CreateConVar("tc_trashmanweaponcolor", "0 1 0", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Trashman Weapon Color")

--Default color for the Victims weapon and skin
--GM.Config.VictimsWeaponColor = Vector(0,0,1)
GM.Config.VictimsWeaponColor = CreateConVar("tc_victimsweaponcolor", "0 0 1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Victims Weapon Color")


--Weapons the victims will spawn with
GM.Config.VictimWeapons = {
	"weapon_357",
	"weapon_fists"
}

--When You Press F1 this is the link that will open
GM.Config.HelpButtonLink = "http://steamcommunity.com/sharedfiles/filedetails/?id=495998201"