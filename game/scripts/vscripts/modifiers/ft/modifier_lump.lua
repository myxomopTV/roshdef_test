
if modifier_lump == nil then
    modifier_lump = class({})
end

function modifier_lump:IsHidden()
	return false
end

function modifier_lump:GetTexture()
    return "tiny_grow"
end

function modifier_lump:RemoveOnDeath()
	return true
end

function modifier_lump:CanBeAddToMinions()
    return true
end

function modifier_lump:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
    return funcs
end

function modifier_lump:GetModifierMagicalResistanceBonus()	
	return self.magicResBonus or 0
end

function modifier_lump:GetModifierPhysicalArmorBonus()	
	return self.physArmorBonus or 0
end

function modifier_lump:OnCreated()
	self.magicResBonus = 80
	self.physArmorBonus = 150

	if IsServer() then
		self:GetParent():SetRenderColor(105, 105, 105)
	end
end


