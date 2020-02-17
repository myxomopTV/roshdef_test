function Death( event )
    local target = event.target
    local caster = event.caster
	Timers:CreateTimer(10, function() caster:RespawnHero(false,false) end )	
	caster:RemoveModifierByName("modifier_aphotic_shield")
	caster:ForceKill(true)

end

function SetBuffStack( event )
    local target = event.target
    local caster = event.caster
    local ability = event.ability
    local statBonus = event.bonus_stat
    --casterUnit:SetBaseStrength( casterUnit:GetBaseStrenght() + 1 )
    --casterUnit:ModifyStrength(statBonus)


    if target:HasModifier("modifier_true_promise_permament") == false then
        ability:ApplyDataDrivenModifier( caster, target, "modifier_true_promise_permament", nil)
        target:SetModifierStackCount("modifier_true_promise_permament", caster, statBonus)
    else
        target:SetModifierStackCount("modifier_true_promise_permament", caster, (target:GetModifierStackCount("modifier_true_promise_permament", caster) + statBonus))
    end

end