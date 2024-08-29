function GM:PlayerLoadout( ply )
    if ply:IsTrashMan() then
        if GAMEMODE.Config.SpawnWithPhysGun:GetBool() then
            ply:Give( "weapon_physgun" )
        end

        ply:Give("weapon_physcannon")
        ply:Give("weapon_fists")
        ply:Give("weapon_frag")
        ply:GiveAmmo(2, "Grenade", true)

    elseif ply:IsVictim() then
        for k, v in pairs(GAMEMODE.Config.VictimWeapons) do
            ply:Give(v)
        end
    end

    return true
end


function GM:PlayerSelectSpawn( ply )
    local TrashManSpawns = ents.FindByClass("info_player_terrorist")
    local VictimSpawns = ents.FindByClass("info_player_counterterrorist")
    local SpectatorSpawns = ents.FindByClass("info_player_start")

    if ply:IsTrashMan() then
        for k, spawn in pairs( TrashManSpawns ) do
            if ( IsValid(spawn) and GAMEMODE:IsSpawnpointSuitable(ply, spawn, false)) then
                return spawn
            end
        end
        return TrashManSpawns[1]

    elseif ply:IsVictim() then
        for k, spawn in pairs( VictimSpawns ) do
            if ( IsValid(spawn) and GAMEMODE:IsSpawnpointSuitable(ply, spawn, false)) then
                return spawn
            end
        end
        return VictimSpawns[1]

    elseif ( ply:Team() == TEAM_SPECTATOR or ply:Team() == TEAM_UNASSIGNED ) then
        for k, spawn in pairs( SpectatorSpawns ) do
            if ( IsValid(spawn) and GAMEMODE:IsSpawnpointSuitable(ply, spawn, false)) then
                return spawn
            end
        end
        return SpectatorSpawns[1]
    end

end


function GM:PlayerSpawn( ply )
    if (ply:Team() == TEAM_SPECTATOR) then
        GAMEMODE:PlayerSpawnAsSpectator( ply )
        return
    end

    ply:UnSpectate()
    ply:SetupHands()

    ply:SetGestureCam(false)
    ply:RemoveFlags(FL_ATCONTROLS)
end


function GM:PlayerInitialSpawn( ply )
    if ( #PROP_LIST == 0 ) then
        SaveAllPropLocations()
        SpawnAllProps()
    end

    ply:SetCustomCollisionCheck( true )
    ply:AllowFlashlight( true )

    if GAMEMODE:CanJoin(ply) then
        ply:SetTeam( TEAM_VICTIMS )
    else
        ply:SetTeam( TEAM_SPECTATOR )
    end
end


function GM:PostPlayerDeath( ply )
    ply:CreateRagdoll()

    if ply:IsTrashMan() then
        GAMEMODE:TrashManDied(ply)
    elseif ply:IsVictim() then
        ply:SetTeam( TEAM_SPECTATOR )
    end
end


function GM:PlayerShouldTakeDamage( Victim, Attacker )
    if not Attacker:IsPlayer() then return true end
    if ( Victim == Attacker ) then return true end

    local DMOnRoundEnd = GAMEMODE.Config.DMOnRoundEnd:GetBool()
    if ( GAMEMODE.CurrentRoundStatus == ROUND_ENDED ) and DMOnRoundEnd then
        return Victim:Team() == Attacker:Team()
    end

    if ( Victim:IsTrashMan() and Attacker:IsVictim() ) then
        return true
    elseif ( Victim:IsVictim() and Attacker:IsTrashMan() ) then
        return true
    end
end