
greevil_building_destruction = class({})

function greevil_building_destruction:OnSpellStart()
	local caster = self:GetCaster()

	caster:ForceKill(false)
end
