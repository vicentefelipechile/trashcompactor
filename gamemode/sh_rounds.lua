--[[------------------------------------------------
                Trash Compactor - Rounds
------------------------------------------------]]--

if SERVER then
    util.AddNetworkString("TrashCompactor.RoundEnd")
    util.AddNetworkString("TrashCompactor.RoundBegin")
end

--[[------------------------
        Round States
------------------------]]--

ROUND_WAITING = 1
ROUND_STARTING = 2
ROUND_RUNNING = 3
ROUND_ENDED = 4

SetGlobalInt("RoundStatus", ROUND_WAITING)
SetGlobalBool("RoundEnded", false)



--[[------------------------
        Round Methods
------------------------]]--

function GM:SetRoundStatus(status)
    SetGlobalInt("RoundStatus", status)
end

function GM:GetRoundStatus()
    return GetGlobalInt("RoundStatus")
end

function GM:EndRound(WinnerTeam)
    SetGlobalBool("RoundEnded", true)

    if CLIENT then return end

    net.Start("TrashCompactor.RoundEnd")
        net.WriteUInt(WinnerTeam, TrashCompactor.DefaultUInt)
    net.Broadcast()
end

function GM:BeginRound()
    SetGlobalBool("RoundEnded", false)

    if CLIENT then return end

    net.Start("TrashCompactor.RoundBegin")
    net.Broadcast()
end


function TrashCompactor.SetRoundStatus(status)
    GAMEMODE:SetRoundStatus(status)
end

function TrashCompactor.GetRoundStatus()
    return GAMEMODE:GetRoundStatus()
end

function TrashCompactor.GetRoundEnded()
    return GetGlobalBool("RoundEnded")
end



--[[------------------------
         Replication
------------------------]]--

if CLIENT then
    net.Receive("TrashCompactor.RoundEnd", function()
        GAMEMODE:EndRound( net.ReadUInt(TrashCompactor.DefaultUInt) )
    end)

    net.Receive("TrashCompactor.RoundBegin", function()
        GAMEMODE:BeginRound()
    end)
end