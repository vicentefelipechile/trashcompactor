if SERVER then
    util.AddNetworkString("TrashCompactor.AddQueue")
    util.AddNetworkString("TrashCompactor.RemoveQueue")
end

local CurrentQueue = {}

function TrashCompactor.GetQueue()
    return CurrentQueue
end


function TrashCompactor.AddPlayerToQeue(ply)
    if ply:Team() == TEAM_TRASHMAN then return end
    if table.HasValue(CurrentQueue, ply) then return end -- don't add the same player twice

    table.insert(CurrentQueue, ply)

    if CLIENT then return end

    net.Start("TrashCompactor.AddQueue")
        net.WriteEntity(ply)
    net.Broadcast()
end


function TrashCompactor.RemovePlayerFromQueue(ply)
    for k, v in pairs(CurrentQueue) do
        if v == ply then
            table.remove(CurrentQueue, k) -- i know, this isn't the best way to do this, but it works
        end
    end

    if CLIENT then return end

    net.Start("TrashCompactor.RemoveQueue")
        net.WriteEntity(ply)
    net.Broadcast()
end


function TrashCompactor.GetNextPlayerInQueue()
    if #CurrentQueue == 0 then
        return player.GetAll()[ math.random(1, #player.GetAll()) ]
    end

    return table.remove(CurrentQueue, 1)
end


if CLIENT then
    net.Receive("TrashCompactor.AddQueue", function(len, ply)
        if not IsValid(ply) then return end

        TrashCompactor.AddPlayerToQeue(ply)
    end)


    net.Receive("TrashCompactor.RemoveQueue", function(len, ply)
        if not IsValid(ply) then return end

        TrashCompactor.RemovePlayerFromQueue(ply)
    end)
end