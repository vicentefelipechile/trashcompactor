if SERVER then
    util.AddNetworkString("TrashCompactor.AddQueue")
    util.AddNetworkString("TrashCompactor.RemoveQueue")
end

GM.TrashMan = GM.TrashMan or {}
GM.TrashMan.Queue = GM.TrashMan.Queue or {}

function GM:GetQueue()
    return GM.TrashMan.Queue
end


function GM:AddPlayerToQeue(ply)
    if ply:Team() == TEAM_TRASHMAN then return end
    if table.HasValue(GM.TrashMan.Queue, ply) then return end -- don't add the same player twice

    table.insert(GM.TrashMan.Queue, ply)

    if CLIENT then return end

    net.Start("TrashCompactor.AddQueue")
        net.WriteEntity(ply)
    net.Broadcast()
end


function GM:RemovePlayerFromQueue(ply)
    for k, v in pairs(GM.TrashMan.Queue) do
        if v == ply then
            table.remove(GM.TrashMan.Queue, k) -- i know, this isn't the best way to do this, but it works
        end
    end

    if CLIENT then return end

    net.Start("TrashCompactor.RemoveQueue")
        net.WriteEntity(ply)
    net.Broadcast()
end


function GM:GetNextPlayerInQueue()
    if #self.TrashMan.Queue == 0 then
        return player.GetAll()[ math.random(1, #player.GetAll()) ]
    end

    return table.remove(self.TrashMan.Queue, 1)
end


if CLIENT then
    net.Receive("TrashCompactor.AddQueue", function(len, ply)
        if not IsValid(ply) then return end

        GAMEMODE:AddPlayerToQeue(ply)
    end)


    net.Receive("TrashCompactor.RemoveQueue", function(len, ply)
        if not IsValid(ply) then return end

        GAMEMODE:RemovePlayerFromQueue(ply)
    end)
end