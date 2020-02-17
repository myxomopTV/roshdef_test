LinkLuaModifier( "ricko_modifier_powerup_passive", "heroes/hero_ricko/powerup", LUA_MODIFIER_MOTION_NONE )	
LinkLuaModifier( "ricko_modifier_powerup", "heroes/hero_ricko/powerup", LUA_MODIFIER_MOTION_NONE )	

ricko_powerup = class({})

function ricko_powerup:GetAbilityTextureName()
	if self:GetToggleState() then
		return "ricko/powerup_physical"
	else
		return "ricko/powerup_magical"
	end
end

function ricko_powerup:OnToggle()
	local caster = self:GetCaster()
    local host = self:GetCaster().host

end

function ricko_powerup:GetIntrinsicModifierName()
	return "ricko_modifier_powerup_passive"
end


ricko_modifier_powerup_passive = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
})

function ricko_modifier_powerup_passive:OnCreated()
    if IsServer() then
    	self:StartIntervalThink(0.1)
    end
end

function ricko_modifier_powerup_passive:OnIntervalThink()
    if IsServer() then
    	local host = self:GetCaster().host

    	if host and IsValidEntity(host) then
    		host:AddNewModifier(self:GetCaster(), self:GetAbility(), "ricko_modifier_powerup", {duration = 0.1})
    	else
      		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "ricko_modifier_powerup", {duration = 0.1})  		
    	end
    end
end

ricko_modifier_powerup = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
            MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
        } end,
})

function ricko_modifier_powerup:GetModifierBaseDamageOutgoing_Percentage()
    if self:GetAbility():GetToggleState() then
    	return self:GetAbility():GetSpecialValueFor("bonus_phys")
    else
    	return 0
    end
end

function ricko_modifier_powerup:GetModifierSpellAmplify_Percentage()
    if not self:GetAbility():GetToggleState() then
    	return self:GetAbility():GetSpecialValueFor("bonus_mag")
    else
    	return 0
    end
end
