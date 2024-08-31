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

function GM:PlayerSelectTeamSpawn( TeamID, ply )
    local SpawnPoints = team.GetSpawnPoints( TeamID )
    if ( #SpawnPoints == 0 ) then return end

    local ChosenSpawnPoint = nil
    local SuitableSpawnPoints = {}

    for _, SpawnPoint in ipairs( SpawnPoints ) do
        if GAMEMODE:IsSpawnpointSuitable( ply, SpawnPoint, true ) then
            table.insert( SuitableSpawnPoints, SpawnPoint )
        end
    end

    return ChosenSpawnPoint[ math.random(1, #SuitableSpawnPoints) ]
end


function GM:PlayerSpawn( ply )
    if (ply:Team() == TEAM_SPECTATOR) then
        self:PlayerSpawnAsSpectator( ply )
        return
    end

    ply:UnSpectate()
    ply:SetupHands()

    ply:SetGestureCam(false)
    ply:RemoveFlags(FL_ATCONTROLS)
end


function GM:PlayerInitialSpawn( ply )
    ply:SetCustomCollisionCheck( true )
    ply:AllowFlashlight( true )

    local CanJoin = hook.Call("PlayerCanJoin", GAMEMODE, ply)
    if ( CanJoin == true ) then
        ply:SetTeam( TEAM_VICTIMS )
    else
        ply:SetTeam( TEAM_SPECTATOR )
    end
end


function GM:PostPlayerDeath( ply )
    ply:CreateRagdoll()

    if ply:IsTrashMan() then
        hook.Call("TrashManDied", GAMEMODE, ply)
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