if customability_technologist_floating_point == nil then
    customability_technologist_floating_point = class({})
end


function customability_technologist_floating_point:OnUpgrade()
	local ability = self:GetCaster():GetAbilityByIndex(4)
	ability:SetLevel(1)
	ability = self:GetCaster():GetAbilityByIndex(5)
	ability:SetLevel(1)
end

function customability_technologist_floating_point:GetManaCost()
	return 0
end

function customability_technologist_floating_point:GetAOERadius()
	return 400
end

function customability_technologist_floating_point:OnSpellStart()
	local Caster = self:GetCaster()
	local Target = false
	if not self:GetCursorTargetingNothing() then
        Target = self:GetCursorTarget()
    end
    self.point = self:GetCursorPosition()

    self:RotateArrays()
end



ArrayTable = {
	--["customability_technologist_return_array"] = "customability_technologist_flame_array",
	["customability_technologist_flame_array"] = "customability_technologist_freeze_array",
	["customability_technologist_freeze_array"] = "customability_technologist_heal_array",
	["customability_technologist_heal_array"] = "customability_technologist_flame_array",
}

function customability_technologist_floating_point:RotateArrays()
	local Caster = self:GetCaster()
	local array = Caster:GetAbilityByIndex(5)
	local arrayName = array:GetName()

	Caster:RemoveAbility(arrayName)
	array = Caster:AddAbility(ArrayTable[arrayName])
	array:SetLevel(1)
end







function SpawnArray(Caster, ability)
	local cost = ability.arrayCost

	if tablelength(Caster.arrayTable) > 2 then
		ReturnArray(Caster, 1)
	end

	local total = 0
	for k,v in pairs(Caster.arrayTable) do
		total = total + v.arrayCost
	end

	local freespace = 100 - total

	while freespace < cost do
		ReturnArray(Caster, 1)

		total = 0
		for k,v in pairs(Caster.arrayTable) do
			total = total + v.arrayCost
		end

		freespace = 100 - total
	end

    --Create array unit, and leap() to target point
	local array = Dummies:ActivateDummy(Caster)
	array:SetAbsOrigin(Caster:GetAbsOrigin())
	--array:SetOriginalModel("models/heroes/techies/fx_techiesfx_stasis.vmdl")
	--array:SetModel("models/heroes/techies/fx_techiesfx_stasis.vmdl")
	Dummies:AddParticleIndex(array, ParticleManager:CreateParticle("particles/technologist/" .. ability.arrayType .. "_array_model.vpcf", PATTACH_ABSORIGIN_FOLLOW, array))
	Dummies:SetKeyValue(array, "arrayType", ability.arrayType)
	Dummies:SetKeyValue(array, "radius", ability:GetAOERadius())
	Dummies:SetKeyValue(array, "arrayCost", cost)

	table.insert(Caster.arrayTable, array)

    --Spawn array
    Leap(array, ability.point, 100, 1000, time, true, function(unit)
		local arrayAbility = unit:AddAbility("customability_technologist_array_passive")
		arrayAbility:SetLevel(1)
    end)
end

function ReturnArray(Caster, index)
	index = index or 1

	if Caster.arrayTable[index] then
		local arrayCost = Caster.arrayTable[index].arrayCost

	    if not Caster.arrayTable[index]:IsNull() then
	    	Dummies:DeactivateDummy(Caster.arrayTable[index])
	    end
	    Caster.arrayTable[index] = nil
	    Caster.arrayTable = SortArrays(Caster.arrayTable)

	    --Refund mana
	    local mod = Caster:FindModifierByName("modifier_technologist_energy")
	    mod:ModifyStacks(arrayCost)
--	    PopupNumbersFilter("energy",  Caster, arrayCost, Caster)
	end
end

function SortArrays(tab)
	local arrayTable = {}

    for k,v in pairs(tab) do
        table.insert(arrayTable, v)
    end

	return arrayTable
end