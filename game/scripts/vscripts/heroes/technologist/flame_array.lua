if customability_technologist_flame_array == nil then
    customability_technologist_flame_array = class({})
end


function customability_technologist_flame_array:OnUpgrade()
	self.arrayType = "flame"
	self.arrayCost = 15
end

function customability_technologist_flame_array:GetAOERadius()
	return 275
end

function customability_technologist_flame_array:OnSpellStart()
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