greevil_naked_magic_shield = class({})

LinkLuaModifier("modifier_greevil_naked_magic_shield", "abilities/greevil_naked_magic_shield", LUA_MODIFIER_MOTION_NONE)

function greevil_naked_magic_shield:GetAbilityTextureName()
	return "greevil_naked_magic_shield"
end

function greevil_naked_magic_shield:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_3
end

function greevil_naked_magic_shield:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_greevil_naked_magic_shield", {duration = self:GetSpecialValueFor("duration")})

	local castPFX = ParticleManager:CreateParticle("particles/greevils/greevil_naked/greevil_naked_magic_shield_cast.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControlEnt(castPFX, 0, self:GetCaster(), PATTACH_POINT, "attach_mouth", self:GetCaster():GetOrigin(), true)
	ParticleManager:SetParticleControl(castPFX, 1, self:GetCaster():GetOrigin())
	ParticleManager:SetParticleControl(castPFX, 2, Vector(400, 0, 0))
	ParticleManager:ReleaseParticleIndex(castPFX)

	EmitSoundOn("Greevil.Shield.Cast", self:GetCaster())
end

modifier_greevil_naked_magic_shield = class({
	IsPurgable = function() return false end,
})

if IsServer() then
	function modifier_greevil_naked_magic_shield:OnCreated()
		self:GetParent().greevil_naked_magic_shield_damage = 0
		self:GetParent().greevil_naked_magic_shield_damage_absorb = self:GetAbility():GetSpecialValueFor("damage_absorb")

		local nFXIndex = ParticleManager:CreateParticle("particles/greevils/greevil_naked/greevil_naked_magic_shield.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(nFXIndex, 0, self:GetParent():GetOrigin())
		ParticleManager:SetParticleControlEnt(nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true)
		self:AddParticle(nFXIndex, false, false, -1, false, false)
	end
	function modifier_greevil_naked_magic_shield:OnDestroy()
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local damage = self:GetAbility():GetSpecialValueFor("damage")
		local gameTime = math.min(math.floor(GameRules:GetDOTATime(false, false)/60), GREEVIL_BUFF_TIME_LIMIT)
		damage = damage + self:GetAbility():GetSpecialValueFor("damage_per_minute") * gameTime
		
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			ApplyDamage({
				victim = enemy,
				attacker = self:GetCaster(),
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			})
		end

		local explodePFX = ParticleManager:CreateParticle("particles/greevils/greevil_naked/greevil_naked_magic_shield_explosion.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(explodePFX, 0, self:GetParent():GetOrigin())
		ParticleManager:SetParticleControl(explodePFX, 5, self:GetParent():GetOrigin())
		ParticleManager:ReleaseParticleIndex(explodePFX)

		EmitSoundOn("Greevil.Shield.Explode", self:GetCaster())
	end
end