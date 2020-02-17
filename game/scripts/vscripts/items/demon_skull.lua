
function OnEquip()
	--print("OnEquip")

end

function OnUnequip(data)
	--print("OnUnequip")
	data.caster:RemoveModifierByName("modifier_demon_skull")
	
end

function OnToggleOff(data)
	--print("OnUnequip")
	data.caster:RemoveModifierByName("modifier_demon_skull")
	
end


function OnToggle(data)
	--print("OnToggle")
	local caster = data.caster
	local itemName = data.ability:GetAbilityName()
	local modifName = "modifier_cleave_sword"
	local modifTable = caster:FindAllModifiers()
	local deactivate = false

	for i = 1, #modifTable do
		if modifTable[i]:GetName():find("modifier_cleave_sword")  then
			deactivate = true
		end
	end

	if itemName == "item_cleave_sword" then
		modifName = "modifier_cleave_sword"
	end	

	if itemName == "item_cleave_sword_second" then
		modifName = "modifier_cleave_sword_second"
	end	

	if itemName == "item_cleave_sword_third" then
		modifName = "modifier_cleave_sword_third"
	end		

	if deactivate then
		caster:RemoveModifierByName("modifier_cleave_sword")
		caster:RemoveModifierByName("modifier_cleave_sword_second")
		caster:RemoveModifierByName("modifier_cleave_sword_third")
	else
		caster:AddNewModifier(caster, data.ability, modifName, {})
	end

end

--[[Author: Pizzalol/Noya
	Date: 10.01.2015.
	Swaps the ranged attack, projectile and caster model
]]
function ModelSwapStart( keys )
	local caster = keys.caster
	local model = keys.model
	local projectile_model = keys.projectile_model

	-- Saves the original model and attack capability
	if caster.caster_model == nil then 
		caster.caster_model = caster:GetModelName()
	end
	caster.caster_attack = caster:GetAttackCapability()

	-- Sets the new model and projectile
	caster:SetOriginalModel(model)
	caster:SetRangedProjectileName(projectile_model)

	-- Sets the new attack type
	caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
end

--[[Author: Pizzalol/Noya
	Date: 10.01.2015.
	Reverts back to the original model and attack type
]]
function ModelSwapEnd( keys )
	local caster = keys.caster

	caster:SetModel(caster.caster_model)
	caster:SetOriginalModel(caster.caster_model)
	caster:SetAttackCapability(caster.caster_attack)
end


--[[Author: Noya
	Date: 09.08.2015.
	Hides all dem hats
]]
function HideWearables( event )
	local hero = event.caster
	local ability = event.ability

	hero.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() == "dota_item_wearable" then
            model:AddEffects(EF_NODRAW) -- Set model hidden
            table.insert(hero.hiddenWearables, model)
        end
        model = model:NextMovePeer()
    end
end

function ShowWearables( event )
	local hero = event.caster

	for i,v in pairs(hero.hiddenWearables) do
		v:RemoveEffects(EF_NODRAW)
	end
end