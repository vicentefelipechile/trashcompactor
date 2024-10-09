--[[------------------------------------------------
              Trash Compactor - Rounds
------------------------------------------------]]--

local RoundTimer = 0
local FirstTime = true

--[[------------------------
        Trash Man AFK
------------------------]]--

local TrashManAFKTimer = 0
local TrashManAFK = 20
local TrashManIsAFK = true



--[[------------------------
         Round Hooks
------------------------]]--

-- Phase 1: Waiting
function GM:RoundWaiting() end
function GM:PostRoundWaiting()
    for k, ply in ipairs(player.GetAll()) do

        if ply:Team() == TEAM_VICTIMS and not ply:Alive() then
            ply:Spawn()

        elseif ply:Team() == TEAM_SPECTATOR then
            ply:SetTeam(TEAM_VICTIMS)
            ply:Spawn()
        end
    end
end



-- Phase 2: Starting
function GM:RoundStarting()
    local ply = NULL

    if self.Config.UseTrashmanQueue then
        ply = TrashCompactor.GetNextPlayerQueue()
    else
        ply = player.GetAll()[ math.random(1, #player.GetAll()) ]
    end

    TrashCompactor.SetTrashman(ply)
end

function GM:PostRoundStarting() end



-- Phase 3: Running
function GM:RoundRunning() end
function GM:PostRoundRunning() end



-- Phase 4: Ended
function GM:RoundEnded() end
function GM:PostRoundEnded()
    game.CleanUpMap()

    for k, ply in ipairs(player.GetAll()) do
        ply:KillSilent()
        ply:SetTeam(TEAM_VICTIMS)
    end
end



--[[------------------------
         Round Logic
------------------------]]--

hook.Add("Think", "RoundLogic", function()
    if ( GAMEMODE.CurrentRoundStatus == ROUND_WAITING ) then

        if FirstTime then
            GAMEMODE:RoundWaiting()
            FirstTime = false
        end

        if #player.GetAll() >= 2 then
            GAMEMODE:PostRoundWaiting()
            GAMEMODE:BeginRound()

            FirstTime = true
            TrashCompactor.SetRoundStatus(ROUND_STARTING)
            RoundTimer = CurTime() + 10
        end

    elseif ( GAMEMODE.CurrentRoundStatus == ROUND_STARTING ) then

        if FirstTime then
            GAMEMODE:RoundStarting()
            FirstTime = false
        end

        if RoundTimer < CurTime() then
            GAMEMODE:PostRoundStarting()

            FirstTime = true
            TrashCompactor.SetRoundStatus(ROUND_RUNNING)
            RoundTimer = CurTime() + 120
        end

    elseif ( GAMEMODE.CurrentRoundStatus == ROUND_RUNNING ) then

        if FirstTime then
            GAMEMODE:RoundRunning()
            FirstTime = false
        end

        if RoundTimer < CurTime() or GAMEMODE.RoundEnded then
            GAMEMODE:PostRoundRunning()

            FirstTime = true
            TrashCompactor.SetRoundStatus(ROUND_ENDED)
            RoundTimer = CurTime() + 10

            return
        end

        if TrashManIsAFK then
            TrashManAFKTimer = TrashManAFKTimer + 1

            if TrashManAFKTimer >= TrashManAFK then
                FirstTime = true
                TrashCompactor.SetRoundStatus(ROUND_ENDED)
                RoundTimer = CurTime() + 10

                GAMEMODE:EndRound(TEAM_VICTIMS)

                return
            end
        end

        if #TrashCompactor.GetVictims() == 0 then
            FirstTime = true
            TrashCompactor.SetRoundStatus(ROUND_ENDED)
            RoundTimer = CurTime() + 10

            GAMEMODE:EndRound(TEAM_TRASHMAN)
        end

    elseif ( GAMEMODE.CurrentRoundStatus == ROUND_ENDED ) then

        if FirstTime then
            GAMEMODE:RoundEnded()
            FirstTime = false
        end

        if RoundTimer < CurTime() then
            GAMEMODE:PostRoundEnded()

            FirstTime = true
            TrashCompactor.SetRoundStatus(ROUND_WAITING)
            RoundTimer = CurTime() + 10
        end
    end
end)



--[[------------------------
         Extra Hooks
------------------------]]--

hook.Add("PlayerCanJoin", "TrashCompactor.PlayerCanJoin", function(ply)
    if GAMEMODE.CurrentRoundStatus == ROUND_WAITING then
        return true
    end
end)

function GM:TrashManDied(ply)
    GAMEMODE:EndRound(TEAM_VICTIMS)
    ply:SetTeam(TEAM_SPECTATOR)
end

function GM:KeyPress(ply, key)
    if ply:IsTrashman() then
        GAMEMODE.TrashManIsAFK = false
    end
end