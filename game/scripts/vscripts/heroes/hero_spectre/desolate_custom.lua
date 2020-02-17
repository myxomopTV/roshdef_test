LinkLuaModifier("modifier_spectre_desolate_custom", "heroes/hero_spectre/desolate_custom", LUA_MODIFIER_MOTION_NONE)

spectre_desolate_custom = class({})

function spectre_desolate_custom:OnSpellStart()
	self.target = self:GetCursorTarget()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_spectre_desolate_custom", nil)
end

modifier_spectre_desolate_custom = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	CheckState		= function(self) return 
		{
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,          
			[MODIFIER_STATE_FLYING] = true,
			[MODIFIER_STATE_INVULNERABLE] = true, 
			[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_SILENCED] = true,
		} end,
})

function modifier_spectre_desolate_custom:OnCreated()
    if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local target = ability.target
		local pos = target:GetAbsOrigin()
		local bounce_tick = ability:GetSpecialValueFor("bounce_tick")
		local target_pos = target:GetAbsOrigin()
 		
		ability.origin= caster:GetAbsOrigin()
		caster:AddNoDraw()
		PlayerResource:SetCameraTarget(caster:GetPlayerID(), nil)
		ability.max_count = ability:GetLevelSpecialValueFor("count", (ability:GetLevel() - 1))
		ability.count = 0
		local random_pos = pos + Vector(RandomInt(-100,100),RandomInt(-100,100),0)
		caster:SetAbsOrigin(random_pos)
		caster:PerformAttack(target, true, true, true, true, true, false, false)
		caster:EmitSound("Hero_Spectre.Desolate")
        local particle_name = "particles/units/heroes/hero_spectre/spectre_desolate.vpcf"
        local particle_1 = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControl(particle_1, 0, target_pos)
        Timers:CreateTimer(0.5, function()
            ParticleManager:DestroyParticle(particle_1, false)
        end)
		ability.count = ability.count + 1
		self:StartIntervalThink(bounce_tick)
	end
end


function modifier_spectre_desolate_custom:OnIntervalThink()
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local pos = caster:GetAbsOrigin()
    local radius = ability:GetLevelSpecialValueFor("bounce_distance", (ability:GetLevel() - 1))
    local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    local enemy_count = 0
    for _,unit in ipairs(units) do
        enemy_count = enemy_count + 1
    end
    if enemy_count == 0 or ability.count >= ability.max_count then
        self:Destroy()
        caster:Stop()
        caster:RemoveNoDraw()
        caster:SetAbsOrigin(ability.origin)
		caster:AddNewModifier(caster, ability, "modifier_phased", {duration = 0.1})
    else
        local random = RandomInt(1, enemy_count)
        local target = units[random]
        local target_pos = target:GetAbsOrigin()
        local random_pos = target_pos + Vector(RandomInt(-100,100),RandomInt(-100,100),0)
        caster:SetAbsOrigin(random_pos)
        caster:PerformAttack(target, true, true, true, true, true, false, false)
		caster:EmitSound("Hero_Spectre.Desolate")
  --      local particle_name = "particles/units/heroes/hero_spectre/spectre_desolate.vpcf"
        local particle_name = "particles/econ/items/spectre/spectre_transversant_soul/spectre_transversant_spectral_dagger_path_owner_glow.vpcf"
        local particle_1 = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControl(particle_1, 0, target_pos)
        Timers:CreateTimer(0.5, function()
            ParticleManager:DestroyParticle(particle_1, false)
        end)

        ability.count = ability.count + 1
    end  
end