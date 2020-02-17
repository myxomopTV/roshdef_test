
LinkLuaModifier( "modifier_bristleback_mega_quill_spray", "heroes/hero_bristleback/mega_quill_spray", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bristleback_mega_quill_spray_buff", "heroes/hero_bristleback/mega_quill_spray", LUA_MODIFIER_MOTION_NONE )

bristleback_mega_quill_spray = class({})

function bristleback_mega_quill_spray:GetIntrinsicModifierName()
	return "modifier_bristleback_mega_quill_spray"
end

function bristleback_mega_quill_spray:OnSpellStart()
	local caster = self:GetCaster()
	local interval = self:GetSpecialValueFor("interval")
	local modifier = caster:FindModifierByName("modifier_bristleback_mega_quill_spray")
	local stack_count = modifier:GetStackCount()
	modifier:SetStackCount(0)
	local buff_duration = interval*(stack_count+1)

	caster:AddNewModifier( caster, self, "modifier_bristleback_mega_quill_spray_buff", {duration = buff_duration} )

end

modifier_bristleback_mega_quill_spray = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
})

modifier_bristleback_mega_quill_spray_buff = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		} end,
})

function modifier_bristleback_mega_quill_spray_buff:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		local interval = ability:GetSpecialValueFor("interval")
		
		self:StartIntervalThink(interval)
	end
end

function modifier_bristleback_mega_quill_spray_buff:OnIntervalThink()
	local caster = self:GetCaster()

	local ability_spray = caster:FindAbilityByName("bristleback_quill_spray_custom")
	if ability_spray and ability_spray:GetLevel() > 0 then
		ability_spray:DoSpray()
	end
	
end

