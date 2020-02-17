if customability_technologist_heal_array == nil then
    customability_technologist_heal_array = class({})
end


function customability_technologist_heal_array:OnUpgrade()
	self.arrayType = "heal"
	self.arrayCost = 35
end

function customability_technologist_heal_array:GetAOERadius()
	return 325
end

function customability_technologist_heal_array:OnSpellStart()
	local Caster = self:GetCaster()
	local Target = false
	if not self:GetCursorTargetingNothing() then
        Target = self:GetCursorTarget()
    end
    self.point = self:GetCursorPosition()

    local mod = Caster:FindModifierByName("modifier_technologist_energy")
    mod:ModifyStacks(-self.arrayCost)

    if not Caster.arrayTable then
		Caster.arrayTable = {}
	end

	require('heroes/technologist/floating_point')

	SpawnArray(Caster, self)
end