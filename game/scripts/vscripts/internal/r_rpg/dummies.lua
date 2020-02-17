Dummies = Dummies or class({}, {
    pool = {}, --indexed as - [handle] = dummyTable
})


function Dummies:Activate()
    
end

function Dummies:ActivateDummy(master)
    local playerID = -1
    if master:IsControllableByAnyPlayer() then
        playerID = master:GetPlayerOwnerID()
    end

    local dummy = self:GetUnusedDummyFromPool()

    if not dummy then
        dummy = self:CreateNewDummy(master)
    end
    self:SetActive(dummy)

    self:SetTeam(dummy, master:GetTeamNumber())
    dummy:SetControllableByPlayer(playerID, true)

    self:SetKeyValue(dummy, "master", master)
    dummy:SetAbsOrigin(master:GetAbsOrigin())

    return dummy
end

function Dummies:GetUnusedDummyFromPool()
    for dummy,dummyTable in pairs(Dummies.pool) do
        if IsValidEntity(dummy) then
            if not dummyTable.bActive then
                return dummy
            end
        else
            Dummies.pool[dummy] = nil
        end
    end
end

function Dummies:CreateNewDummy(master)
    --create unit
    local dummy = CreateUnitByName("dummy_unit_vulnerable", master:GetAbsOrigin(), true, master, master, master:GetTeam())

    self:AddDummyToPool(dummy)
    return dummy
end

function Dummies:SetActive(dummy)
    Dummies.pool[dummy].bActive = true
end

function Dummies:SetInactive(dummy)
    Dummies.pool[dummy].bActive = false
end

function Dummies:AddDummyToPool(dummy)
    Dummies.pool[dummy] = Dummies.pool[dummy] or {}
    self:SetActive(dummy)
end

function Dummies:DeactivateDummy(dummy)
    self:SoftCleanUpDummy(dummy)
    dummy:SetControllableByPlayer(-1, true)
    self:SetInactive(dummy)
end

function Dummies:SoftCleanUpDummy(dummy)
    ProjectileManager:ProjectileDodge(dummy)
    dummy:SetModelScale(1)
    dummy:SetModel("models/development/invisiblebox.vmdl")
    dummy:SetOriginalModel("models/development/invisiblebox.vmdl")
    dummy:SetRenderColor(255, 255, 255)
    dummy:SetAbsOrigin(Vector(0,0,0))

    --remove EF_NODRAW
    --set vision range

    for i=0,15 do
        local ability = dummy:GetAbilityByIndex(i)
        if ability and ability:GetName() ~= "dummy_passive_vulnerable" then
            dummy:RemoveAbility(ability:GetName())
        end
    end

    for k,mod in pairs(dummy:FindAllModifiers()) do
        if mod:GetName() ~= "dummy_modifier" then
            mod:Destroy()
        end
    end

    if IsPhysicsUnit(dummy) then
        dummy:ClearStaticVelocity()
        --reset physics settings
    end

    if Dummies.pool[dummy] then
        for index,value in pairs(Dummies.pool[dummy]) do
            if index == "particles" then
                self:CleanUpParticles(dummy)
            elseif index ~= "bActive" then
                self:SetKeyValue(dummy, index, nil)
            end
        end
    end
end

function Dummies:SetKeyValue(dummy, index, value)
    if not dummy then return end
    if not index then return end
    dummy[index] = value
    Dummies.pool[dummy][index] = value
end

function Dummies:SetTeam(dummy, team)
    dummy:SetTeam(team)
end

function Dummies:AddParticleIndex(dummy, index)
    Dummies.pool[dummy].particles = Dummies.pool[dummy].particles or {}
    Dummies.pool[dummy].particles[index] = true
end

function Dummies:RemoveParticleIndex(dummy, index)
    Dummies.pool[dummy].particles = Dummies.pool[dummy].particles or {}
    Dummies.pool[dummy].particles[index] = nil
end

function Dummies:CleanUpParticles(dummy)
    for index,v in pairs(Dummies.pool[dummy].particles) do
        ParticleManager:DestroyParticle(index, true)
        ParticleManager:ReleaseParticleIndex(index)
    end
    Dummies.pool[dummy].particles = {}
end

--Event:BindActivate(Dummies)