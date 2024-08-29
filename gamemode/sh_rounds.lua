if SERVER then
    util.AddNetworkString("TrashCompactor.RoundStatus")
    util.AddNetworkString("TrashCompactor.RoundEnd")
    util.AddNetworkString("TrashCompactor.RoundBegin")
end

ROUND_WAITING = 1
ROUND_STARTING = 2
ROUND_RUNNING = 3
ROUND_ENDED = 4

GM.CurrentRoundStatus = ROUND_WAITING
GM.RoundEnded = false

function GM:TrashCompactorRound(status)
    GAMEMODE.CurrentRoundStatus = status

    if CLIENT then return end

    net.Start("TrashCompactor.RoundStatus")
        net.WriteUInt(status, 3)
    net.Broadcast()
end

function GM:EndRound(WinnerTeam)
    GAMEMODE.RoundEnded = true

    if CLIENT then return end

    net.Start("TrashCompactor.RoundEnd")
        net.WriteUInt(WinnerTeam, 2)
    net.Broadcast()
end

function GM:BeginRound()
    GAMEMODE.RoundEnded = false

    if CLIENT then return end

    net.Start("TrashCompactor.RoundBegin")
    net.Broadcast()
end