LinkLuaModifier("modifier_unity_of_evil_custom", "abilities/warrior_curse", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_evil_treant_curse", "abilities/warrior_curse", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_unity_of_evil_mark_custom", "abilities/warrior_curse", LUA_MODIFIER_MOTION_NONE)

warrior_curse = class({})

function warrior_curse:GetIntrinsicModifierName()
	return "modifier_unity_of_evil_custom"
end

evil_treant_curse = class({})

function evil_treant_curse:GetIntrinsicModifierName()
	return "modifier_evil_treant_curse"
end

---------------------------------------------------------------

if modifier_unity_of_evil_custom == nil then
    modifier_unity_of_evil_custom = class({})
end

function modifier_unity_of_evil_custom:IsHidden()
	return true
end

function modifier_unity_of_evil_custom:RemoveOnDeath()
	return true
end

function modifier_unity_of_evil_custom:CanBeAddToMinions()
    return true
end

function modifier_unity_of_evil_custom:GetTexture()
    return "bane_fiends_grip"
end

function modifier_unity_of_evil_custom:GetEffectName()
    return "particles/units/heroes/hero_witchdoctor/witchdoctor_maledict_dot_skulls.vpcf"
end

function modifier_unity_of_evil_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_EVENT_ON_DEATH
    }
    return funcs
end

function modifier_unity_of_evil_custom:OnCreated()

	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		self.damageBonus = self:GetAbility():GetSpecialValueFor( "dmg_bonus" )--(caster:GetBaseDamageMin()+caster:GetBaseDamageMax())/2*ability:GetSpecialValueFor( "dmg_bonus" )/100
		self.attackSpeedBonus = self:GetAbility():GetSpecialValueFor( "as_bonus" )	
		caster.healthBonus = caster:GetMaxHealth()*self:GetAbility():GetSpecialValueFor( "hp_bonus" )/100
		self.healthRegen = 100 --ability:GetSpecialValueFor( "duration" )/100
		self.physArmorBonus = caster:GetPhysicalArmorBaseValue()*self:GetAbility():GetSpecialValueFor( "armor_bonus" )/100
		self.modelScalePers = 10
		self.auraRadius = 10000
		self.auraDuration = 0.3

		self:GetParent():SetRenderColor(199, 21, 133)
	end
end

function modifier_unity_of_evil_custom:GetModifierBaseDamageOutgoing_Percentage()	
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor( "dmg_bonus" ) or 0
end

function modifier_unity_of_evil_custom:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor( "as_bonus" ) or 0
end

function modifier_unity_of_evil_custom:GetModifierConstantHealthRegen()	
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor( "hpreg_bonus" ) or 0
end

function modifier_unity_of_evil_custom:GetModifierPhysicalArmorBonus()	
	return self:GetStackCount()*self:GetParent():GetPhysicalArmorBaseValue()*self:GetAbility():GetSpecialValueFor( "armor_bonus" )/100 or 0
end

function modifier_unity_of_evil_custom:GetModifierModelScale()	
	return self:GetStackCount()*10 or 0
end


function modifier_unity_of_evil_custom:OnDeath(data)
	if IsServer() then
		if data.unit == self:GetParent() then
			EmitSoundOn("Hero_LifeStealer.Infest", self:GetParent())
			ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody_mid.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetParent(), self.auraRadius,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
				
			if units then
				--EmitSoundOn("Hero_Axe.CounterHelix", caster)	
				for i = 1, #units do
--					print("phase #1")
					local ability = self:GetAbility()
					local caster = self:GetCaster()
					local StackModifier = "modifier_unity_of_evil_custom"
					local currentStacks = units[i]:GetModifierStackCount(StackModifier, ability)
	--				local modifier = units[i]:FindModifierByName("modifier_unity_of_evil_custom")	
		
					if units[i]:HasModifier(StackModifier) and currentStacks < 100 then
--						print("phase #2")
	--					modifier:IncrementStackCount()
	--					units[i]:SetBaseMaxHealth(units[i]:GetHealth()+self.healthBonus)
						units[i]:SetModifierStackCount(StackModifier, ability, (currentStacks + 1))		
						units[i]:SetMaxHealth(units[i]:GetMaxHealth()+caster.healthBonus)	
						units[i]:SetBaseMaxHealth(units[i]:GetMaxHealth()+caster.healthBonus)	
						units[i]:SetHealth(units[i]:GetHealth()+caster.healthBonus)
					end		
				end
			end	
		end
	end
end
--------------------------------------------------------------------------------
---------------------------------------------------------------

if modifier_evil_treant_curse == nil then
    modifier_evil_treant_curse = class({})
end

function modifier_evil_treant_curse:IsHidden()
	return true
end

function modifier_evil_treant_curse:RemoveOnDeath()
	return true
end

function modifier_evil_treant_curse:CanBeAddToMinions()
    return true
end

function modifier_evil_treant_curse:GetTexture()
    return "bane_fiends_grip"
end

function modifier_evil_treant_curse:GetEffectName()
    return "particles/units/heroes/hero_witchdoctor/witchdoctor_maledict_dot_skulls.vpcf"
end

function modifier_evil_treant_curse:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_EVENT_ON_DEATH
    }
    return funcs
end

function modifier_evil_treant_curse:OnCreated()

	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		self.damageBonus = self:GetAbility():GetSpecialValueFor( "dmg_bonus" )--(caster:GetBaseDamageMin()+caster:GetBaseDamageMax())/2*ability:GetSpecialValueFor( "dmg_bonus" )/100
		self.attackSpeedBonus = self:GetAbility():GetSpecialValueFor( "as_bonus" )	
		caster.healthBonus = caster:GetMaxHealth()*self:GetAbility():GetSpecialValueFor( "hp_bonus" )/100
		self.healthRegen = 100 --ability:GetSpecialValueFor( "duration" )/100
		self.physArmorBonus = caster:GetPhysicalArmorBaseValue()*self:GetAbility():GetSpecialValueFor( "armor_bonus" )/100
		self.modelScalePers = 10
		self.auraRadius = 10000
		self.auraDuration = 0.3

		self:GetParent():SetRenderColor(199, 21, 133)
	end
end

function modifier_evil_treant_curse:GetModifierBaseDamageOutgoing_Percentage()	
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor( "dmg_bonus" ) or 0
end

function modifier_evil_treant_curse:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor( "as_bonus" ) or 0
end

function modifier_evil_treant_curse:GetModifierConstantHealthRegen()	
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor( "hpreg_bonus" ) or 0
end

function modifier_evil_treant_curse:GetModifierPhysicalArmorBonus()	
	return self:GetStackCount()*self:GetParent():GetPhysicalArmorBaseValue()*self:GetAbility():GetSpecialValueFor( "armor_bonus" )/100 or 0
end

function modifier_evil_treant_curse:GetModifierModelScale()	
	return self:GetStackCount()*5 or 0
end


function modifier_evil_treant_curse:OnDeath(data)
	if IsServer() then
		if data.unit == self:GetParent() then
			EmitSoundOn("Hero_LifeStealer.Infest", self:GetParent())
			ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody_mid.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetParent(), self.auraRadius,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
				
			if units then
				--EmitSoundOn("Hero_Axe.CounterHelix", caster)	
				for i = 1, #units do
--					print("phase #1")
					local ability = self:GetAbility()
					local caster = self:GetCaster()
					local StackModifier = "modifier_evil_treant_curse"
					local currentStacks = units[i]:GetModifierStackCount(StackModifier, ability)
	--				local modifier = units[i]:FindModifierByName("modifier_unity_of_evil_custom")	
		
					if units[i]:HasModifier(StackModifier) and currentStacks < 100 then
--						print("phase #2")
	--					modifier:IncrementStackCount()
	--					units[i]:SetBaseMaxHealth(units[i]:GetHealth()+self.healthBonus)
						units[i]:SetModifierStackCount(StackModifier, ability, (currentStacks + 1))		
						units[i]:SetMaxHealth(units[i]:GetMaxHealth()+caster.healthBonus)	
						units[i]:SetBaseMaxHealth(units[i]:GetMaxHealth()+caster.healthBonus)	
						units[i]:SetHealth(units[i]:GetHealth()+caster.healthBonus)
					end		
				end
			end	
		end
	end
end
--------------------------------------------------------------
modifier_unity_of_evil_mark_custom = class({})

function modifier_unity_of_evil_mark_custom:IsHidden()
    return true
end

function modifier_unity_of_evil_mark_custom:DeclareFunctions()
    local funcs = {
 --       MODIFIER_EVENT_ON_DEATH
    }
    return funcs
end

function modifier_unity_of_evil_mark_custom:RemoveOnDeath()
    return true
end

function modifier_unity_of_evil_mark_custom:OnCreated()
	self.auraRadius = 10000
end

function modifier_unity_of_evil_mark_custom:OnDeath(data)
	if IsServer() then
		local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetParent(), self.auraRadius,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
			
		if units then
			--EmitSoundOn("Hero_Axe.CounterHelix", caster)	
			for i = 1, #units do
				print("phase #1")
				local ability = self:GetAbility()
				local caster = self:GetCaster()
				local StackModifier = "modifier_evil_treant_curse"
				local currentStacks = units[i]:GetModifierStackCount(StackModifier, ability)
				local modifier = units[i]:FindModifierByName("modifier_unity_of_evil_custom")	
				local modifier1 = ""
	
				if units[i]:HasModifier(StackModifier) and currentStacks < 100 then
					print("phase #2")
--					modifier:IncrementStackCount()
--					units[i]:SetBaseMaxHealth(units[i]:GetHealth()+self.healthBonus)
					units[i]:SetModifierStackCount(StackModifier, ability, (currentStacks + 1))		
					units[i]:SetMaxHealth(units[i]:GetHealth()+caster.healthBonus)	
					units[i]:SetHealth(units[i]:GetHealth()+caster.healthBonus)
				end		
			end
		end		
	end
end

