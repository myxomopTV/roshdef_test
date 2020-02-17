modifier_shapeshift_speed_lua = class({})

--[[Author: Perry,Noya
	Date: 26.09.2015.
	Creates a modifier that allows to go beyond the 522 movement speed limit]]
function modifier_shapeshift_speed_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
	}

	return funcs
end

function modifier_shapeshift_speed_lua:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_shapeshift_speed_lua:IsHidden()
	return true
end

--[[Adds the shapeshift haste particle to the unit when the modifier gets created]]
function modifier_shapeshift_speed_lua:OnCreated()
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_shapeshift_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(self.nFXIndex, false, false, -1, false, false)
		self:StartIntervalThink( 0.5 )
	end
end

----------------------------------------

function modifier_shapeshift_speed_lua:OnIntervalThink()
	self.flMoveSpeed = 0
	self.flMoveSpeed = self:GetCaster():GetIdealSpeedNoSlows()
end

function modifier_shapeshift_speed_lua:GetModifierMoveSpeed_AbsoluteMin( params )
	return self.flMoveSpeed
end