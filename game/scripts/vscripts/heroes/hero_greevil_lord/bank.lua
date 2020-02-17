bank_level = 1

function BankCreated( event )
	local caster = event.caster
	local ability = event.ability
	local hero = caster:GetOwner()
	
	if IsValidEntity(hero.bank) and hero.bank then
		hero.bank:ForceKill(false)
	end
	
	hero.bank = caster
	ability:SetLevel(1)
	local upgrade_ability = caster:FindAbilityByName("upgrade_bank")
	upgrade_ability:SetLevel(1)
--	if bank_level == 9 then
--		caster:RemoveAbility("upgrade_bank")
--	else
--		upgrade_ability:SetLevel(bank_level)
--	end
end

function GiveGoldPerTick( event )
	local caster = event.caster
	local ability = event.ability	
	local gold_per_tick = ability:GetSpecialValueFor("gold_per_tick")
	local hero = caster:GetOwner()

	hero:ModifyGold(gold_per_tick, false, 0 )
	
	PopupGoldGainAlt(caster, gold_per_tick, true)
	
end

function UpgradeBank( event )
    local ability = event.ability
    local building = ability:GetCaster()
	local level = ability:GetLevel()
	
	if level == 8 then
		building:RemoveAbility(ability:GetName())
	else
		ability:SetLevel(level+1)
	end
--	bank_level = bank_level + 1
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


