if customability_technologist_return_array == nil then
    customability_technologist_return_array = class({})
end


function customability_technologist_return_array:OnSpellStart()
	local Caster = self:GetCaster()
	local Target = false
	if not self:GetCursorTargetingNothing() then
        Target = self:GetCursorTarget()
    end
    self.point = self:GetCursorPosition()

    if not Caster.arrayTable then
		Caster.arrayTable = {}
	end

	require('heroes/technologist/floating_point')

	ReturnArray(Caster, 1)
end