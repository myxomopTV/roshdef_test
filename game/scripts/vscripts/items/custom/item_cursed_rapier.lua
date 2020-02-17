
function CheckForStats (keys)
	local item = keys.ability
	local caster = keys.caster
	local vLocation = caster:GetAbsOrigin()

	if caster:IsRealHero() and caster.activated == nil then
		caster.activated = true
		caster:ForceKill(true)
	end	
	
	local stats_required = item:GetSpecialValueFor( "stats_required" )
--	GameRules:SendCustomMessage("stats_required:"..stats_required,0,0)
	local item_stats_sum = item:GetSpecialValueFor( "rapier_str" ) + item:GetSpecialValueFor( "rapier_agi" ) + item:GetSpecialValueFor( "rapier_int" )
	local stats_sum = caster:GetStrength() + caster:GetAgility() + caster:GetIntellect()
	local hero_stats_sum =  stats_sum - item_stats_sum
	
--	GameRules:SendCustomMessage("stats_sum:"..stats_sum,0,0)	
--	GameRules:SendCustomMessage("item_stats_sum:"..item_stats_sum,0,0)	
--	GameRules:SendCustomMessage("hero_stats_sum:"..hero_stats_sum,0,0)	
if not caster:HasModifier("modifier_arc_warden_tempest_double")and caster:IsRealHero() then
	if stats_required > hero_stats_sum then
		Timers:CreateTimer(0.001, function() caster:DropItemAtPositionImmediate(item, vLocation) end)
		GameRules:SendCustomMessage("#Game_notification_cursed_rapier_request_message",0,0)	
		GameRules:SendCustomMessage("<font color='#FFD700'>NOT ENOUGH </font><font color='#00FF00'>".. stats_required-hero_stats_sum .."</font>",0,0)	
		
	end
end	
	
	
end

function OnOwnerDied( keys )

	local item = keys.ability
	local caster = keys.caster
	local vLocation = caster:GetAbsOrigin()

--	caster:DropItemAtPositionImmediate(item, vLocation)
	
end

function OnUnequip(keys)
	--print("OnUnequip")

	local item = keys.ability
	local caster = keys.caster
	local vLocation = caster:GetAbsOrigin()
	local vRandomVector = RandomVector(50)
	
	if item ~= nil then
		item:GetContainer():SetRenderColor(0,240,0)
		item:LaunchLoot(false, 150, 0.5, vLocation + vRandomVector)
	end	
	
caster:RemoveModifierByName("modifier_cursed_rapier_activated")

end

function OnToggleOff(data)
	--print("OnUnequip")
	data.caster:RemoveModifierByName("modifier_cursed_rapier_activated")
	
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