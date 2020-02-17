
function StrengthTomeUsed( event )
    local picker = event.caster
    local tome = event.ability
    local statBonus = event.bonus_stat

    if picker:IsRealHero() == false then
    	picker = picker:GetPlayerOwner():GetAssignedHero()
    end
  	local effect = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, picker)
	ParticleManager:ReleaseParticleIndex(pfx)
	EmitSoundOn("DOTA_Item.Refresher.Activate",picker)

	if picker:HasModifier("tome_strenght_modifier") == false then
		picker:AddNewModifier(picker,tome,"tome_strenght_modifier",nil)
        picker:SetModifierStackCount("tome_strenght_modifier", picker, statBonus)
    else
        picker:SetModifierStackCount("tome_strenght_modifier", picker, (picker:GetModifierStackCount("tome_strenght_modifier", picker) + statBonus))
    end
	picker:CalculateStatBonus()
end

function AgilityTomeUsed( event )   
    local picker = event.caster
    local tome = event.ability
    local statBonus = event.bonus_stat
	

	if picker:IsRealHero() == false then
    	picker = picker:GetPlayerOwner():GetAssignedHero()
    end
 	local effect = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, picker)
	ParticleManager:ReleaseParticleIndex(pfx)
	EmitSoundOn("DOTA_Item.Refresher.Activate",picker)

	if picker:HasModifier("tome_agility_modifier") == false then
		picker:AddNewModifier(picker,tome,"tome_agility_modifier",nil)
        picker:SetModifierStackCount("tome_agility_modifier", picker, statBonus)
    else
        picker:SetModifierStackCount("tome_agility_modifier", picker, (picker:GetModifierStackCount("tome_agility_modifier", picker) + statBonus))
    end
	picker:CalculateStatBonus()
end

function IntellectTomeUsed( event )
    local picker = event.caster
    local tome = event.ability
    local statBonus = event.bonus_stat
 
	if picker:IsRealHero() == false then
    	picker = picker:GetPlayerOwner():GetAssignedHero()
    end
  	local effect = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, picker)
	ParticleManager:ReleaseParticleIndex(pfx)
	EmitSoundOn("DOTA_Item.Refresher.Activate",picker)

   if picker:HasModifier("tome_intelect_modifier") == false then
		picker:AddNewModifier(picker,tome,"tome_intelect_modifier",nil)
        picker:SetModifierStackCount("tome_intelect_modifier", picker, statBonus)
    else
        picker:SetModifierStackCount("tome_intelect_modifier", picker, (picker:GetModifierStackCount("tome_intelect_modifier", picker) + statBonus))
    end
	picker:CalculateStatBonus()
end
---------------------------------------------------------------
---------------------------------------------------------------

tome_strenght_modifier = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_STATS_STRENGTH_BONUS} end,
})

function tome_strenght_modifier:GetModifierBonusStats_Strength()
	return self:GetStackCount() or 0
end

function tome_strenght_modifier:GetTexture()
	return "item_str_bonus"
end
---------------------------------------------------------------
---------------------------------------------------------------
tome_agility_modifier = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_STATS_AGILITY_BONUS} end,
})

function tome_agility_modifier:GetModifierBonusStats_Agility()
	return self:GetStackCount() or 0
end

function tome_agility_modifier:GetTexture()
	return "item_agi_bonus"
end
---------------------------------------------------------------
---------------------------------------------------------------

tome_intelect_modifier = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_STATS_INTELLECT_BONUS} end,
})

function tome_intelect_modifier:GetModifierBonusStats_Intellect()
	return self:GetStackCount() or 0
end

function tome_intelect_modifier:GetTexture()
	return "item_int_bonus"
end
---------------------------------------------------------------
---------------------------------------------------------------
