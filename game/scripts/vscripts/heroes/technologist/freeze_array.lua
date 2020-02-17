if customability_technologist_freeze_array == nil then
    customability_technologist_freeze_array = class({})
end


function customability_technologist_freeze_array:OnUpgrade()
	self.arrayType = "freeze"
	self.arrayCost = 15
end

function customability_technologist_freeze_array:GetAOERadius()
	return 300
end

function customability_technologist_freeze_array:OnSpellStart()
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