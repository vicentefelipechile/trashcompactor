GM.FrozenPhysicsObjects = 0

function GM:OnPhysgunFreeze( weap, phys, ent, ply )
    if ply:IsTrashMan() then
        if GAMEMODE.Config.MaxFreezeAmount:GetInt() <= GAMEMODE.FrozenPhysicsObjects then
            return false
        end

        GAMEMODE.FrozenPhysicsObjects = GAMEMODE.FrozenPhysicsObjects + 1
    end
end

hook.Add("EndRound", "ResetFrozenPhysicsObjects", function()
    GAMEMODE.FrozenPhysicsObjects = 0
end)


function GM:OnPhysgunReload( _, ply )
    if GAMEMODE.Config.DropAllEnabled:GetBool() then
        ply:PhysgunUnfreeze()
        GAMEMODE.FrozenPhysicsObjects = 0
    end
end


function GM:PhysgunPickup(ply, ent)
    if ( ent:IsPlayer() or not IsValid(ent) ) then return false end
    if ( ent:GetClass() ~= "prop_physics_multiplayer" and ent:GetClass() ~= "prop_trash") then return false end


    -- check if the prop is to away from the player
    if ( ent:GetPos():Distance( ply:GetPos() ) > GAMEMODE.Config.MaxPropDistance:GetInt() ) then return false end
end


local InstaKillWeapon = {
    [DMG_ALWAYSGIB + DMG_BULLET] = true,
    [DMG_BULLET] = true,
}
local InstaKillVector = Vector(0, 0, 30000)

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
    if InstaKillWeapon[ dmginfo:GetDamageType() ] then
        dmginfo:ScaleDamage( 20 )
        dmginfo:SetDamageForce( dmginfo:GetAttacker():GetForward() * 50000 + InstaKillVector)
    end
end


function GM:GetFallDamage( ply, speed )
    return 0
end