
aniki_absorption_shield_mass = class({})

function aniki_absorption_shield_mass:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function aniki_absorption_shield_mass:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local shield_ability = caster:FindAbilityByName("aniki_absorption_shield")
	local allies = caster:FindFriendlyUnitsInRadius(point, radius, nil)

	for _, ally in ipairs(allies) do
		caster:SetCursorCastTarget(ally)
		shield_ability:OnSpellStart()
	end
end
