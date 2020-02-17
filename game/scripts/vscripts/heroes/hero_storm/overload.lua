
LinkLuaModifier( "modifier_storm_overload", "heroes/hero_storm/overload", LUA_MODIFIER_MOTION_NONE )

storm_overload = class({})

function storm_overload:OnToggle()
	local caster = self:GetCaster()
	if self:GetToggleState() then
		caster:AddNewModifier( caster, self, "modifier_storm_overload", nil )
	else
		caster:RemoveModifierByName("modifier_storm_overload")
	end
end

modifier_storm_overload = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
})

function modifier_storm_overload:OnCreated()
	if IsServer() then
		-- Attach the particle to Storm
		local parent	=	self:GetParent()
		local particle	=	"particles/units/heroes/hero_stormspirit/stormspirit_overload_ambient.vpcf"
		self.particle_fx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, parent)
		ParticleManager:SetParticleControlEnt(self.particle_fx, 0, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true)
--		self:SetStackCount(1)
	end
end

function modifier_storm_overload:DeclareFunctions()
	local funcs ={
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
	return funcs
end

function modifier_storm_overload:OnAttackLanded(keys)
	if IsServer() then
		-- When someone affected by overload buff has attacked
		if keys.attacker == self:GetParent() then
			-- Does not proc when attacking buildings or allies
			if not keys.target:IsBuilding() and keys.target:GetTeamNumber() ~= keys.attacker:GetTeamNumber() then

				-- Ability properties
				local parent	=	self:GetParent()
				local ability	=	self:GetAbility()
				local particle	=	"particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf"
				-- Ability paramaters
				local radius 		=	ability:GetSpecialValueFor("radius") 
				local base_damage = self:GetSpecialValueFor("base_damage")
				local int_damage = self:GetSpecialValueFor("int_damage")*parent:GetIntellect()
				local damage = base_damage + int_damage
--				local slow_duration	=	ability:GetSpecialValueFor("slow_duration")
				local current_mana  = parent:GetMana()
				local mana_required = ability:GetManaCost(-1)
				
				if current_mana > mana_required then
					parent:SetMana(parent:GetMana() - mana_required)
				else
					ability:ToggleAbility()
				end

				local target_flag = ability:GetAbilityTargetFlags()

				if parent:HasModifier("modifier_item_special_storm_upgrade") then
					parent:SetCursorCastTarget(keys.target)
					local thunder_strike = parent:FindAbilityByName("storm_thunder_strike")
					thunder_strike:OnSpellStart()
				end

				-- Find enemies around the target
				local enemies	=	FindUnitsInRadius(	parent:GetTeamNumber(),
					keys.target:GetAbsOrigin(),
					nil,
					radius,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
					target_flag,
					FIND_ANY_ORDER,
					false)
				
				keys.target:EmitSound("Hero_StormSpirit.Overload")
				local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, parent)
				ParticleManager:SetParticleControl(particle_fx, 0, keys.target:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle_fx)

				-- Damage and apply slow to enemies near target
				for _,enemy in pairs(enemies) do

					DealDamage(parent, enemy, damage, DAMAGE_TYPE_MAGICAL, nil, ability)

					-- Apply debuff
--					enemy:AddNewModifier(parent, ability, "modifier_imba_overload_debuff",	{duration = slow_duration} )

					-- Emit particle
					-- Remove overload buff
--					self:Destroy()
				end
			end
		end
	end
end

function modifier_storm_overload:GetActivityTranslationModifiers()
	if self:GetParent():GetName() == "npc_dota_hero_storm_spirit" then
		--return ACT_STORM_SPIRIT_OVERLOAD_RUN_OVERRIDE
		return "overload"
	end
	return 0
end

function modifier_storm_overload:GetModifierAttackRangeBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_range")
end

function modifier_storm_overload:GetOverrideAnimation()
	return ACT_STORM_SPIRIT_OVERLOAD_RUN_OVERRIDE
end

function modifier_storm_overload:CheckState()
	local parent = self:GetParent()
	local state ={
		[MODIFIER_STATE_FLYING] = true,
	}
	if parent:HasModifier("modifier_item_special_storm") or parent:HasModifier("modifier_item_special_storm_upgrade") then
		return state
	else
		return 
	end
end

function modifier_storm_overload:OnDestroy()
	if IsServer() then
		-- Remove the particle
		ParticleManager:DestroyParticle(self.particle_fx, false)
		ParticleManager:ReleaseParticleIndex(self.particle_fx)
	end
end

