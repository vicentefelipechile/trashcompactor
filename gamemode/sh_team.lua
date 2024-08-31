--[[------------------------------------------------
               Trash Compactor - Teams
------------------------------------------------]]--

TEAM_VICTIMS = 1
TEAM_TRASHMAN = 2

--[[------------------------
        Team Methods
------------------------]]--

function GM:CreateTeams()
    team.SetUp( TEAM_VICTIMS, "Victims", GAMEMODE.Config.VictimsColor, true )
    team.SetUp( TEAM_TRASHMAN, "Trashman", GAMEMODE.Config.TrashmanColor, false )

    team.SetSpawnPoint( TEAM_TRASHMAN, "info_player_terrorist" )
    team.SetSpawnPoint( TEAM_VICTIMS, "info_player_counterterrorist" )
end

function GM:GetVictims()
    return team.GetPlayers(TEAM_VICTIMS)
end

function TrashCompactor.GetVictims()
    return team.GetPlayers(TEAM_VICTIMS)
end



--[[------------------------
       Player Methods
------------------------]]--

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

PlayerMeta.IsSameTeam = PlayerMeta.IsSameTeamAs
PlayerMeta.IsTrashMan = PlayerMeta.IsTrashman



--[[------------------------
      Trash Man Methods
------------------------]]--

function GM:GetNextTrashMan() -- For third party addons
    -- return ply
end

function TrashCompactor.GetTrashman()
    for _, v in ipairs( player.GetAll() ) do
        if v:IsTrashman() then
            return v
        end
    end
end

function TrashCompactor.SetTrashman(ply)
    if not IsValid(ply) then return end

    local CurrentTrashman = TrashCompactor.GetTrashman()
    if IsValid(CurrentTrashman) then
        CurrentTrashman:SetTeam(TEAM_VICTIMS)
    end

    ply:SetTeam(TEAM_TRASHMAN)
    ply:Spawn()
end