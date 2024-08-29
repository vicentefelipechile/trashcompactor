GM.TrashManAFKTimer = 0
GM.TrashManAFK = 20
GM.TrashManIsAFK = true

GM.RoundTimer = 0
function GM.RoundThink()
    if GAMEMODE.CurrentRoundStatus == ROUND_WAITING then
        -- Initial check --
        if #player.GetAll() >= GAMEMODE.Config.MinumumPlayersNeeded then
            GAMEMODE.CurrentRoundStatus = ROUND_STARTING
            GAMEMODE.RoundTimer = CurTime() + GAMEMODE.RoundStarting

            GAMEMODE:TrashCompactorRound(ROUND_STARTING)
            GAMEMODE:BeginRound()
        end


        -- Custom stuff --
        for k, ply in ipairs(player.GetAll()) do

            if ply:Team() == TEAM_VICTIMS and not ply:Alive() then
                ply:Spawn()

            elseif ply:Team() == TEAM_SPECTATOR then
                ply:SetTeam(TEAM_VICTIMS)
                ply:Spawn()
            end

        end


        local ForcePlayer = hook.Call("GetNextTrashMan", GAMEMODE)
        if IsValid(ForcePlayer) then
            ForcePlayer:SetTeam(TEAM_TRASHMAN)
        else
            local ply = NULL
            if GAMEMODE.Config.UseTrashmanQueue:GetBool() then
                ply = GAMEMODE:GetNextPlayerInQueue()
            else
                ply = player.GetAll()[ math.random(1, #player.GetAll()) ]
            end

            ply:SetTeam(TEAM_TRASHMAN)
            GAMEMODE:SetCurrentTrashMan(ply)
        end

    elseif GAMEMODE.CurrentRoundStatus == ROUND_STARTING then
        -- Timer check --
        if GAMEMODE.RoundTimer < CurTime() then
            GAMEMODE.CurrentRoundStatus = ROUND_RUNNING
            GAMEMODE.RoundTimer = CurTime() + GAMEMODE.Config.RoundRunning:GetInt()

            GAMEMODE:TrashCompactorRound(ROUND_RUNNING)
            GAMEMODE.TrashManAFKTimer = CurTime() + GAMEMODE.Config.TrashManAFK:GetInt()
        end

    elseif GAMEMODE.CurrentRoundStatus == ROUND_RUNNING then
        -- Timer check --
        if GAMEMODE.RoundTimer < CurTime() or GAMEMODE.RoundEnded then
            GAMEMODE.CurrentRoundStatus = ROUND_ENDED
            GAMEMODE.RoundTimer = CurTime() + GAMEMODE.Config.RoundEnding:GetInt()

            GAMEMODE:TrashCompactorRound(ROUND_ENDED)
        end


        -- Custom stuff --
        if GAMEMODE.TrashManIsAFK and GAMEMODE.TrashManAFKTimer < CurTime() then
            -- If was afk and timer is up, kill him
            local trashman = GAMEMODE:GetTrashMan()
            if IsValid(trashman) then
                trashman:Kill()
            end
        end

        -- Check if there are any players left
        local victims = team.NumPlayers(TEAM_VICTIMS)
        if victims == 0 then
            GAMEMODE:EndRound(TEAM_TRASHMAN)
        end

    elseif GAMEMODE.CurrentRoundStatus == ROUND_ENDED then
        local victims = team.NumPlayers(TEAM_VICTIMS)
        if victims ~= 0 then
            GAMEMODE:VictimsWin()
        end

        if GAMEMODE.RoundTimer < CurTime() then
            GAMEMODE.CurrentRoundStatus = ROUND_WAITING
            GAMEMODE.RoundTimer = CurTime() + GAMEMODE.Config.RoundWaiting:GetInt()

            GAMEMODE:TrashCompactorRound(ROUND_WAITING)


            -- Custom stuff --
            game.CleanUpMap()

            GAMEMODE:EndRound(TEAM_VICTIMS)
            for k, ply in ipairs(player.GetAll()) do
                ply:SetTeam(TEAM_VICTIMS)
                ply:Spawn()
            end
        end
    end
end
hook.Add("Think", "RoundThink", GM.RoundThink)

function GM:TrashManDied(ply)
    GAMEMODE:EndRound()
    ply:SetTeam(TEAM_SPECTATOR)
end

function GM:KeyPress(ply, key)
    if ply:IsTrashman() then
        GAMEMODE.TrashManIsAFK = false
    end
end