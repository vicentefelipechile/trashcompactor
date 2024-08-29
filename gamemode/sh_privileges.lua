if not CAMI then return end

CAMI.RegisterPrivilege({
    Name = "tc_config",
    MinAccess = "superadmin",
    Description = "Allows the player to change the gamemode config."
})

CAMI.RegisterPrivilege({
    Name = "tc_admin",
    MinAccess = "admin",
    Description = "Allows the player to use admin commands."
})

CAMI.RegisterPrivilege({
    Name = "tc_spawnmenu",
    MinAccess = "admin",
    Description = "Allows the player to use the spawnmenu."
})