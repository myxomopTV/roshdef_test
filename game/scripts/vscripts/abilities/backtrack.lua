--[[Author: Pizzalol
	Date: 14.02.2016.
	Keeps track of the casters health]]
function BacktrackHealth( keys )
	local caster = keys.caster
	local ability = keys.ability

	ability.caster_hp_old = ability.caster_hp_old or caster:GetMaxHealth()
	ability.caster_hp = ability.caster_hp or caster:GetMaxHealth()

	ability.caster_hp_old = ability.caster_hp
	ability.caster_hp = caster:GetHealth()
end

--[[Author: Pizzalol
	Date: 14.02.2016.
	Negates incoming damage]]
function ShieldCreated( keys )
	local caster = keys.caster
	local ability = keys.ability
	local max_layers = ability:GetLevelSpecialValueFor("max_layers", ability:GetLevel() - 1)
	if GetMapName() == "roshdef_turbo" then
		max_layers = max_layers/2
	end

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_sans_shield_counter", nil)
	caster:SetModifierStackCount("modifier_sans_shield_counter", caster, max_layers)
	caster.layers = max_layers
	caster.attack_count = 0
end

function BacktrackShiled( keys )
	local caster = keys.caster
	local ability = keys.ability

--	GameRules:SendCustomMessage("#Game_notification_chaos_mode_message2",0,0)

	caster:SetHealth(1)
end

function BacktrackShiledLayer( keys )
	local caster = keys.caster
	local ability = keys.ability

--	GameRules:SendCustomMessage("that shit works !!!",0,0)


    caster.attack_count = caster.attack_count+1
	if caster.attack_count == 100 then

		if caster:HasModifier("modifier_sans_shield_counter") then
		caster.layers = caster:GetModifierStackCount("modifier_sans_shield_counter", caster)-1
		
		caster:RemoveModifierByName('modifier_sans_shield_counter')
		else caster.layers = 0
		end

		if caster.layers > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_sans_shield_counter", nil)
		caster:SetModifierStackCount("modifier_sans_shield_counter", caster, caster.layers)
		end
		
		caster.attack_count = 0
	end

end

