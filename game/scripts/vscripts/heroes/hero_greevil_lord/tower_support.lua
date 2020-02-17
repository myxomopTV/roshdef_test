

function UpgradeAbility( event )
    local ability = event.ability
    local building = ability:GetCaster()
	local level = ability:GetLevel()
	
	if level == 3 then
		building:RemoveAbility(ability:GetName())
	else
		ability:SetLevel(level+1)
	end
	building:GetAbilityByIndex(0):SetLevel(level+1)
	
end

function CancelUpgrade( event )
    local building = event.caster
    local ability = event.ability
    local playerID = building:GetPlayerOwnerID()
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    local gold_cost = ability:GetGoldCost(-1)

    hero:ModifyGold(gold_cost, false, 0)

end
