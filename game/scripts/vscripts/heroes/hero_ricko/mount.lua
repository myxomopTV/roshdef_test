
LinkLuaModifier( "modifier_ricko_mount_passive", "heroes/hero_ricko/mount", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ricko_mount_hidden", "heroes/hero_ricko/mount", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ricko_mount_host", "heroes/hero_ricko/mount", LUA_MODIFIER_MOTION_NONE )

ricko_unmount = class({})

function ricko_unmount:OnSpellStart()
	local caster = self:GetCaster()
--	caster.host:ForceKill(false)
	
	EmitSoundOn("Hero_LifeStealer.unmount",caster)

--	caster:SetAbsOrigin(caster.host:GetAbsOrigin())
	caster:RemoveNoDraw()
	caster:RemoveModifierByName("modifier_ricko_mount_hidden")
	caster:SwapAbilities("ricko_unmount", "ricko_mount", false, true) 
	caster:Hold()

	local mount_ability = caster:FindAbilityByName("ricko_mount")
	local ability_cooldown = mount_ability:GetSpecialValueFor("ability_cooldown")
	mount_ability:StartCooldown(ability_cooldown)

	if caster.host and IsValidEntity(caster.host) then
		caster.host:RemoveModifierByName("modifier_ricko_mount_host")
    	caster.host:RemoveModifierByName("modifier_ricko_rage_buff")
		caster.host = nil
	end
end

ricko_mount = class({})

function ricko_mount:OnAbilityPhaseStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
	local ability = self
	
	if caster == target then
		Containers:DisplayError(caster:GetPlayerID(), "wisp_infest_error_need_lvl")
		return false
	else
		return true
	end	
end

function ricko_mount:OnSpellStart( keys )
    local target = self:GetCursorTarget()
    local caster = self:GetCaster()
    local ability = self

	caster:AddNewModifier(caster, ability, "modifier_ricko_mount_hidden", nil)
	target:AddNewModifier(caster, ability, "modifier_ricko_mount_host", nil)
    caster.host = target

	caster:AddNoDraw()
	EmitSoundOn("Hero_LifeStealer.mount",unit)
--	local effect = "particles/units/heroes/hero_life_stealer/life_stealer_mount_emerge_clean_mid.vpcf"
--	local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, unit)
--	ParticleManager:ReleaseParticleIndex(pfx)

	caster:SwapAbilities("ricko_mount", "ricko_unmount", false, true) 

end

modifier_ricko_mount_hidden = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_EXP_RATE_BOOST,
		} end,
	CheckState		= function(self) return 
		{
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_OUT_OF_GAME] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		} end,
})

function modifier_ricko_mount_hidden:OnCreated()
	self:StartIntervalThink(0.03)
end

function modifier_ricko_mount_hidden:OnIntervalThink()
	local caster = self:GetCaster()

	if IsValidEntity(caster.host) and caster.host:IsAlive() then
		caster:SetAbsOrigin(caster.host:GetAbsOrigin())
	end
end

function modifier_ricko_mount_hidden:GetModifierPercentageExpRateBoost()
	return self:GetAbility():GetSpecialValueFor("bonus_exp")
end

modifier_ricko_mount_host = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_EVENT_ON_DEATH,
			MODIFIER_PROPERTY_EXP_RATE_BOOST,
		} end,
})

function modifier_ricko_mount_host:GetEffectName()
	return "particles/creeps/infest/infested_unit.vpcf"
end

function modifier_ricko_mount_host:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_ricko_mount_host:OnDeath(data)
    local caster = self:GetCaster()
	local parent = self:GetParent()
	local attacker = data.attacker
	local unit = data.unit
    local ability = self:GetAbility()
	local ability_cooldown = ability:GetSpecialValueFor("ability_cooldown")
	local share_gold = ability:GetSpecialValueFor("share_gold")/100

    if parent == unit or caster == unit  then 
		caster:SetAbsOrigin(parent:GetAbsOrigin())
		caster:RemoveNoDraw()
		caster:RemoveModifierByName("modifier_ricko_mount_hidden")
		parent:RemoveModifierByName("modifier_ricko_mount_host")
		caster:SwapAbilities("ricko_unmount", "ricko_mount", false, true) 
		caster:Hold()
    	caster.host:RemoveModifierByName("modifier_ricko_rage_buff")
		caster.host = nil

		ability:StartCooldown(ability_cooldown)
	elseif parent == attacker then
		local gold = unit:GetGoldBounty()*share_gold
		local player = PlayerResource:GetPlayer(caster:GetPlayerID())
		SendOverheadEventMessage( player, OVERHEAD_ALERT_GOLD, caster, gold, nil )
		caster:ModifyGold(gold, false, 0)
   end
end

function modifier_ricko_mount_host:GetModifierPercentageExpRateBoost()
	return self:GetAbility():GetSpecialValueFor("bonus_exp")
end

