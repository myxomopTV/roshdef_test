
test_modifiers = class({})

function test_modifiers:OnSpellStart()

	local target = self:GetCursorTarget()
	local modifiers = target:FindAllModifiers()
	for _,modifier in pairs(modifiers) do
		print(modifier:GetName())
	end	
--	request:GameEnd(3)
end
