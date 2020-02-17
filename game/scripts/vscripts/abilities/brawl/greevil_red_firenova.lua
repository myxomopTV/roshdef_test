greevil_red_firenova = class({})

function greevil_red_firenova:GetAbilityTextureName()
	return "greevil_red_firenova"
end

function greevil_red_firenova:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_1
end

function greevil_red_firenova:OnSpellStart()
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local gameTime = math.min(math.floor(GameRules:GetDOTATime(false, false)/60), GREEVIL_BUFF_TIME_LIMIT)
	damage = damage + self:GetSpecialValueFor("damage_per_minute") * gameTime
	
	local novaCastPFX = ParticleManager:CreateParticle("particles/greevils/greevil_red/greevil_red_firenova_cast.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(novaCastPFX, 0, self:GetCaster():GetOrigin())
	ParticleManager:ReleaseParticleIndex(novaCastPFX)

	local novaPFX = ParticleManager:CreateParticle("particles/greevils/greevil_red/greevil_red_firenova.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
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
	end
end