LinkLuaModifier("modifier_disruptor_glimpself", "heroes/hero_disruptor/glimpself", LUA_MODIFIER_MOTION_NONE)

disruptor_glimpself = class({})

function disruptor_glimpself:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

function disruptor_glimpself:GetIntrinsicModifierName()
	return "modifier_disruptor_glimpself"
end

function disruptor_glimpself:OnSpellStart()
	if IsServer() then
		local caster	=	self:GetCaster()
		local ability	=	self
		local target	=	caster
		print(target:GetUnitName())		
		local new_position	=	self:GetCursorPosition()	
		local cast_sound = "Hero_Disruptor.Glimpse.Target"
		local delay = ability:GetSpecialValueFor("move_delay")
		local cast_response = "disruptor_dis_glimpse_0"..math.random(1,5)

		-- Roll cast response
		if RollPercentage(75) then
			EmitSoundOn(cast_response, caster)
		end
		
--		local thinker = CreateModifierThinker(caster, ability, "modifier_disruptor_glimpse_custom_thinker", {}, target:GetAbsOrigin(), caster:GetTeamNumber(), false)	
		local thinker = target:AddNewModifier(caster, self, "modifier_disruptor_glimpse_custom_thinker", {})

			EmitSoundOn(cast_sound, target)	
			thinker:BeginGlimpse(target, new_position)

	end
end

modifier_disruptor_glimpself = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		} end,
})

function modifier_disruptor_glimpself:GetModifierPercentageCooldown()
	return self:GetAbility():GetSpecialValueFor("reduce_cd")
end