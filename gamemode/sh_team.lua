TEAM_VICTIMS = 1
TEAM_TRASHMAN = 2

function GM:CreateTeams()
    team.SetUp( TEAM_VICTIMS, "Victims", GAMEMODE.Config.VictimsColor, true )
    team.SetUp( TEAM_TRASHMAN, "Trashman", GAMEMODE.Config.TrashmanColor, false )

    team.SetSpawnPoint( TEAM_TRASHMAN, "info_player_start" )
    team.SetSpawnPoint( TEAM_VICTIMS, "info_player_start" )
end

function GM:GetVictims()
    return team.GetPlayers(TEAM_VICTIMS)
end

local PlayerMeta = FindMetaTable("Player")

function PlayerMeta:IsTrashman()
    return self:Team() == TEAM_TRASHMAN
end

function PlayerMeta:IsVictim()
    return self:Team() == TEAM_VICTIMS
end

function PlayerMeta:IsSameTeamAs(ply)
    return self:Team() == ply:Team()
end