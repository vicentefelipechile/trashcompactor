--[[------------------------------------------------
                Trash Compactor - Queues
------------------------------------------------]]--

if SERVER then
    util.AddNetworkString("TrashCompactor.AddQueue")
    util.AddNetworkString("TrashCompactor.RemoveQueue")
end

local CurrentQueue = {}

--[[------------------------
        Queue System
------------------------]]--

function TrashCompactor.GetQueue()
    return CurrentQueue
end

function TrashCompactor.ClearQueue()
    CurrentQueue = {}

    for k, v in ipairs(player.GetAll()) do
        v:SetNWInt("TrashCompactor.Queue", 0)
    end
end



--[[------------------------
      Player Functions
------------------------]]--

function TrashCompactor.GetPlayerQueue(ply)
    return ply:GetNWInt("TrashCompactor.Queue", 0)
end

function TrashCompactor.SetPlayerQueue(ply, index)
    local LastPosition = ply:GetNWInt("TrashCompactor.Queue", 0)
    if LastPosition > 0 then
        table.remove(CurrentQueue, LastPosition)
    end

    ply:SetNWInt("TrashCompactor.Queue", index)
    table.insert(CurrentQueue, index, ply)
end

function TrashCompactor.AddPlayerQueue(ply)
    if ply:Team() == TEAM_TRASHMAN then return end

    local PlayerQueue = TrashCompactor.GetPlayerQueue(ply)
    if CLIENT and ( PlayerQueue > 0 ) then
        table.insert(CurrentQueue, PlayerQueue, ply)
    end

    if SERVER then
        local IndexQueue = table.insert(CurrentQueue, ply)
        ply:SetNWInt("TrashCompactor.Queue", IndexQueue)

        net.Start("TrashCompactor.AddQueue")
            net.WriteEntity(ply)
        net.Broadcast()
    end

    return PlayerQueue
end

function TrashCompactor.RemovePlayerQueue(ply)
    local PlayerQueue = TrashCompactor.GetPlayerQueue(ply)
    table.remove(CurrentQueue, PlayerQueue)

    if SERVER then
        net.Start("TrashCompactor.RemoveQueue")
            net.WriteEntity(ply)
        net.Broadcast()
    end
end


function TrashCompactor.GetNextPlayerQueue()
    if #CurrentQueue == 0 then
        return player.GetAll()[ math.random(1, #player.GetAll()) ]
    end

    return table.remove(CurrentQueue, 1)
end


if CLIENT then
    net.Receive("TrashCompactor.AddQueue", function(len, ply)
        if not IsValid(ply) then return end

        TrashCompactor.AddPlayerQueue(ply)
    end)


    net.Receive("TrashCompactor.RemoveQueue", function(len, ply)
        if not IsValid(ply) then return end

        TrashCompactor.RemovePlayerQueue(ply)
    end)
end