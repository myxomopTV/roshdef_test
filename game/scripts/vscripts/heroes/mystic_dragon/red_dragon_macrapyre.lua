LinkLuaModifier('red_dragon_macrapyre_thinker','heroes/mystic_dragon/red_dragon_macrapyre.lua',LUA_MODIFIER_MOTION_NONE)

if red_dragon_macrapyre == nil then
    red_dragon_macrapyre = class({})
end

function red_dragon_macrapyre:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local radius = self:GetSpecialValueFor('radius')
    local duration = self:GetDuration()
    local thinker = CreateModifierThinker(caster,self,"red_dragon_macrapyre_thinker",{duration = duration},point,caster:GetTeamNumber(),false)
    local particleName = "particles/units/heroes/hero_jakiro/jakiro_macropyre.vpcf";
    local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, thinker);
    local forward = caster:GetForwardVector();
    ParticleManager:SetParticleControl(particle, 0, point - forward * radius/2);
    ParticleManager:SetParticleControl(particle, 1, point);
    ParticleManager:SetParticleControl(particle, 2, Vector(duration, 0, 0));
    ParticleManager:SetParticleControl(particle, 3, point + forward * radius/2);
end

--THINKER

if red_dragon_macrapyre_thinker == nil then
    red_dragon_macrapyre_thinker = class({})
end

function red_dragon_macrapyre_thinker:OnCreated(table)
    self:StartIntervalThink(0.1)
    self.radius = self:GetAbility():GetSpecialValueFor('radius')
    self.team = self:GetCaster():GetTeam()
    self.dmg = self:GetAbility():GetAbilityDamage()/10
end

function red_dragon_macrapyre_thinker:OnIntervalThink()
    local units = FindUnitsInRadius(self.team,self:GetParent():GetAbsOrigin(),nil,self.radius,DOTA_UNIT_TARGET_TEAM_BOTH,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER,false)
    for _,unit in pairs(units) do
        if unit:GetTeam() ~= self.team then
            local dmg = {
                victim = unit,
                attacker = self:GetCaster(),
                damage = self.dmg,
                damage_type = self:GetAbility():GetAbilityDamageType(),
                damage_flags = DOTA_DAMAGE_FLAG_NONE,
                ability = self:GetAbility(),
            }
            ApplyDamage(dmg)
        elseif unit == self:GetCaster() then
            Heal(self.dmg,self:GetCaster())
        end
    end
end