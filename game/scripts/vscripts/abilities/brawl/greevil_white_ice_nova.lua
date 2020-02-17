greevil_white_ice_nova = class({})

LinkLuaModifier("modifier_greevil_white_ice_nova", "abilities/greevil_white_ice_nova", LUA_MODIFIER_MOTION_NONE)

function greevil_white_ice_nova:GetAbilityTextureName()
	return "greevil_white_ice_nova"
end

function greevil_white_ice_nova:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function greevil_white_ice_nova:OnSpellStart()
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local gameTime = math.min(math.floor(GameRules:GetDOTATime(false, false)/60), GREEVIL_BUFF_TIME_LIMIT)
	damage = damage + self:GetSpecialValueFor("damage_per_minute") * gameTime

	local novaPFX = ParticleManager:CreateParticle("particles/greevils/greevil_white/greevil_white_ice_nova_cast.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(novaPFX, 0, self:GetCaster():GetOrigin())
	ParticleManager:SetParticleControl(novaPFX, 1, Vector(radius, 0.75, radius))
	ParticleManager:SetParticleControl(novaPFX, 2, Vector(0, 0, 0))
	ParticleManager:ReleaseParticleIndex(novaPFX)

	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		ApplyDamage({
			victim = enemy,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
			ability = self
		})
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_greevil_white_ice_nova", {duration = self:GetSpecialValueFor("duration")})
	end
end

modifier_greevil_white_ice_nova = class({
	IsPurgable = function() return false end,
})

if IsServer() then
	function modifier_greevil_white_ice_nova:OnCreated()
		local nFXIndex = ParticleManager:CreateParticle("particles/greevils/greevil_white/greevil_white_ice_novabuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(nFXIndex, 0, self:GetParent():GetOrigin())
		ParticleManager:SetParticleControl(nFXIndex, 1, self:GetParent():GetOrigin())
		ParticleManager:SetParticleControl(nFXIndex, 2, self:GetParent():GetOrigin())
		self:AddParticle(nFXIndex, false, false, -1, false, false)
	end
end

function modifier_greevil_white_ice_nova:CheckState() 
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true
	}
end

function modifier_greevil_white_ice_nova:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL
	}
end

function modifier_greevil_white_ice_nova:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function modifier_greevil_white_ice_nova:GetAbsoluteNoDamagePhysical()
	return 1
end