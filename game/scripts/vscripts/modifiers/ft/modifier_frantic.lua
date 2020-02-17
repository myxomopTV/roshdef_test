LinkLuaModifier("modifier_frantic", "modifiers/ft/modifier_frantic.lua", LUA_MODIFIER_MOTION_NONE )

function ApplyModifierToUnit(data)
	--print("ApplyModifierToUnit")
	data.caster:AddNewModifier(data.caster, data.ability, data.ModifName, {})
end

-- Modifier Frantic !!!

if modifier_frantic == nil then
    modifier_frantic = class({})
end

function modifier_frantic:IsHidden()
	return false
end

function modifier_frantic:GetTexture()
    return "nevermore_dark_lord"
end

function modifier_frantic:RemoveOnDeath()
	return true
end

function modifier_frantic:CanBeAddToMinions()
    return true
end

function modifier_frantic:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
    return funcs
end

function modifier_frantic:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()*self.attackSpeedBonus or 0
end

function modifier_frantic:GetModifierMagicalResistanceBonus()	
	return self:GetStackCount()*self.magicResistBonus or 0
end

function modifier_frantic:GetModifierPhysicalArmorBonus()	
	return self:GetStackCount()*self.physArmorBonus or 0
end

function modifier_frantic:OnCreated()
	self.attackSpeedBonus = 30
	self.magicResistBonus = 10
	self.physArmorBonus = 15
	self.thresholdPerc = 10 

	if IsServer() then
		self:GetParent():SetRenderColor(75, 0, 130)
		self:StartIntervalThink(0.3) 
	end
end

function modifier_frantic:OnIntervalThink()
	local stack = self:GetParent():GetMaxHealth() - self:GetParent():GetHealth()
	stack = (stack*self.thresholdPerc)/self:GetParent():GetMaxHealth()
	self:SetStackCount(stack)
end


