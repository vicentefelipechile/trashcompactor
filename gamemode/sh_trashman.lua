function GM:GetCurrentTrashMan()
    return GetGlobal2Entity("TrashCompactor.CurrentTrashMan")
end

function GM:SetCurrentTrashMan(ply)
    if not IsValid(ply) then
        error("Invalid player passed to GM:SetCurrentTrashMan")
    end

    if not ply:IsPlayer() then
        error("Non-player entity passed to GM:SetCurrentTrashMan")
    end

    SetGlobal2Entity("TrashCompactor.CurrentTrashMan", ply)
end

function GM:GetNextTrashMan()
    -- For third party addons
end