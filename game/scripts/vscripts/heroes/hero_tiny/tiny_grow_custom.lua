--[[

Real talk, I copy and pasted this while file from
https://raw.githubusercontent.com/darklordabc/Legends-of-Dota-Redux/develop/src/game/scripts/vscripts/abilities/tiny_grow_lod.lua

Darklord is a god of the modding community; even though he doesn't contribute directly to OAA,
his existence alone is an extreme asset to our team. Thanks homie.

Refactored heavily by chrisinajar
Updated to 7.07 by chrisinajar

]]
if tiny_grow_custom == nil then tiny_grow_custom = class({}) end

LinkLuaModifier("modifier_tiny_grow_fastform", "heroes/hero_tiny/tiny_grow_custom.lua", LUA_MODIFIER_MOTION_NONE) --- PATH WERY IMPORTANT
LinkLuaModifier("modifier_tiny_grow_armorform", "heroes/hero_tiny/tiny_grow_custom.lua", LUA_MODIFIER_MOTION_NONE) --- PATH WERY IMPORTANT

function tiny_grow_custom:OnSpellStart()
  if IsServer() then
	if self:GetCaster():GetUnitName() == "npc_dota_hero_tiny" then
	  local caster = self:GetCaster()
	  local ability = self
	  local level_0 = "models/heroes/tiny_01/tiny_01.vmdl"
	  local level_1 = "models/heroes/tiny_02/tiny_02.vmdl"
	  local level_2 = "models/heroes/tiny_03/tiny_03.vmdl"
	  local level_3 = "models/heroes/tiny_04/tiny_04.vmdl"

		if self:GetCaster():HasModifier("modifier_tiny_grow_armorform") then
		  caster:RemoveModifierByName("modifier_tiny_grow_armorform")
		  caster:AddNewModifier(caster, ability, "modifier_tiny_grow_fastform", {})

			self:GetCaster():StartGesture(ACT_TINY_GROWL)
			EmitSoundOn("Tiny.Grow", self:GetCaster())
			
			local grow = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_transform.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster()) 
			ParticleManager:SetParticleControl(grow, 0, self:GetCaster():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(grow)

			  if self:GetLevel() == 1 then
				self:GetCaster():SetOriginalModel(level_1)
				self:GetCaster():SetModel(level_1)
			  elseif self:GetLevel() == 2 then
				self:GetCaster():SetOriginalModel(level_2)
				self:GetCaster():SetModel(level_2)
			  elseif self:GetLevel() >= 3 then
				self:GetCaster():SetOriginalModel(level_3)
				self:GetCaster():SetModel(level_3)
				end
			  UTIL_Remove(self.torso)
			  UTIL_Remove(self.head)		
			  UTIL_Remove(self.left_arm)
			  UTIL_Remove(self.rigt_arm)
		
--		  self:GetCaster():SetOriginalModel(level_0)
			self.torso = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_01/tiny_01_body.vmdl"})
			self.torso:FollowEntity(self:GetCaster(), true)
			self.head = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_01/tiny_01_head.vmdl"})
			self.head:FollowEntity(self:GetCaster(), true)
			self.left_arm = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_01/tiny_01_left_arm.vmdl"})
			self.left_arm:FollowEntity(self:GetCaster(), true)
			self.rigt_arm = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_01/tiny_01_right_arm.vmdl"})
			self.rigt_arm:FollowEntity(self:GetCaster(), true)
		  

		elseif self:GetCaster():HasModifier("modifier_tiny_grow_fastform") then
		  caster:RemoveModifierByName("modifier_tiny_grow_fastform")
		  caster:AddNewModifier(caster, ability, "modifier_tiny_grow_armorform", {})
			
			-- Effects
			self:GetCaster():StartGesture(ACT_TINY_GROWL)
			EmitSoundOn("Tiny.Grow", self:GetCaster())
			
			local grow = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_transform.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster()) 
			ParticleManager:SetParticleControl(grow, 0, self:GetCaster():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(grow)

		 	local level = self:GetLevel()+1
			if level > 4 then level = 4 end
			
				  if self:GetLevel() == 1 then
					self:GetCaster():SetOriginalModel(level_1)
					self:GetCaster():SetModel(level_1)
				  elseif self:GetLevel() == 2 then
					self:GetCaster():SetOriginalModel(level_2)
					self:GetCaster():SetModel(level_2)
				  elseif self:GetLevel() >= 3 then
					self:GetCaster():SetOriginalModel(level_3)
					self:GetCaster():SetModel(level_3)
				  end
				UTIL_Remove(self.torso)
				UTIL_Remove(self.head)
				UTIL_Remove(self.left_arm)
				UTIL_Remove(self.rigt_arm)

				self.head = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_0"..level.."/tiny_0"..level.."_head.vmdl"})
				self.rigt_arm = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_0"..level.."/tiny_0"..level.."_right_arm.vmdl"})
				self.left_arm = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_0"..level.."/tiny_0"..level.."_left_arm.vmdl"})
				self.torso = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_0"..level.."/tiny_0"..level.."_body.vmdl"})

				self.torso:FollowEntity(self:GetCaster(), true)
				self.head:FollowEntity(self:GetCaster(), true)
				self.left_arm:FollowEntity(self:GetCaster(), true)
				self.rigt_arm:FollowEntity(self:GetCaster(), true)
			
		end
	end
  end
end

function tiny_grow_custom:OnUpgrade()
  if IsServer() then
	if self:GetCaster():GetUnitName() == "npc_dota_hero_tiny" then
	  if not self:GetCaster():HasModifier("modifier_tiny_grow_fastform") and not self:GetCaster():HasModifier("modifier_tiny_grow_armorform")
		then self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_tiny_grow_armorform", {})
	  end
	  
	  local level_1 = "models/heroes/tiny_02/tiny_02.vmdl"
	  local level_2 = "models/heroes/tiny_03/tiny_03.vmdl"
	  local level_3 = "models/heroes/tiny_04/tiny_04.vmdl"

		if self:GetLevel() > 3 then
		  if not self.scaleMultiplier then
			self.scaleMultiplier = 1
		  end
		  local desiredScale = 1 + ((self:GetLevel() - 3) * 0.2)
		  if desiredScale ~= self.scaleMultiplier then
			self:GetCaster():SetModelScale(desiredScale * self:GetCaster():GetModelScale() / self.scaleMultiplier)
			self.scaleMultiplier = desiredScale
		  end
		end
		
		if self:GetCaster():HasModifier("modifier_tiny_grow_fastform") then
		  if self:GetLevel() == 1 then
			self:GetCaster():SetOriginalModel(level_1)
		  elseif self:GetLevel() == 2 then
			self:GetCaster():SetOriginalModel(level_2)
		  elseif self:GetLevel() >= 3 then
			self:GetCaster():SetOriginalModel(level_3)
		  end
			self:GetCaster():StartGesture(ACT_TINY_GROWL)
			EmitSoundOn("Tiny.Grow", self:GetCaster())
			
			local grow = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_transform.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster()) 
			ParticleManager:SetParticleControl(grow, 0, self:GetCaster():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(grow)

			--		  self:GetCaster():SetOriginalModel(level_1)
			self.torso = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_01/tiny_01_body.vmdl"})
			self.torso:FollowEntity(self:GetCaster(), true)
			self.head = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_01/tiny_01_head.vmdl"})
			self.head:FollowEntity(self:GetCaster(), true)
			self.left_arm = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_01/tiny_01_left_arm.vmdl"})
			self.left_arm:FollowEntity(self:GetCaster(), true)
			self.rigt_arm = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_01/tiny_01_right_arm.vmdl"})
			self.rigt_arm:FollowEntity(self:GetCaster(), true)
			
		elseif self:GetCaster():HasModifier("modifier_tiny_grow_armorform") then
		 	local level = self:GetLevel()+1
			if level > 4 then level = 4 end
			
			  if self:GetLevel() == 1 then
				self:GetCaster():SetOriginalModel(level_1)
			  elseif self:GetLevel() == 2 then
				self:GetCaster():SetOriginalModel(level_2)
			  elseif self:GetLevel() >= 3 then
				self:GetCaster():SetOriginalModel(level_3)
			  end
			  
			UTIL_Remove(self.torso)
			UTIL_Remove(self.head)
			UTIL_Remove(self.left_arm)
			UTIL_Remove(self.rigt_arm)

			self.head = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_0"..level.."/tiny_0"..level.."_head.vmdl"})
			self.rigt_arm = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_0"..level.."/tiny_0"..level.."_right_arm.vmdl"})
			self.left_arm = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_0"..level.."/tiny_0"..level.."_left_arm.vmdl"})
			self.torso = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_0"..level.."/tiny_0"..level.."_body.vmdl"})

			self.torso:FollowEntity(self:GetCaster(), true)
			self.head:FollowEntity(self:GetCaster(), true)
			self.left_arm:FollowEntity(self:GetCaster(), true)
			self.rigt_arm:FollowEntity(self:GetCaster(), true)

			-- Effects
			self:GetCaster():StartGesture(ACT_TINY_GROWL)
			EmitSoundOn("Tiny.Grow", self:GetCaster())
			
			local grow = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_transform.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster()) 
			ParticleManager:SetParticleControl(grow, 0, self:GetCaster():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(grow)

						
		end
		
	end

  end
end

------------------------------------------------------------------
------------------------------------------------------------------
if modifier_tiny_grow_armorform == nil then modifier_tiny_grow_armorform = class({}) end

function modifier_tiny_grow_armorform:IsHidden()
  return true
end

function modifier_tiny_grow_armorform:IsPurgable()
  return false
end

function modifier_tiny_grow_armorform:RemoveOnDeath()
    return false
end



function modifier_tiny_grow_armorform:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    MODIFIER_PROPERTY_STATUS_RESISTANCE
  }

  return funcs
end

function modifier_tiny_grow_armorform:GetModifierPhysicalArmorBonus (params)
  local hAbility = self:GetAbility ()
  return hAbility:GetSpecialValueFor ("bonus_armor")
end

function modifier_tiny_grow_armorform:GetModifierBaseAttack_BonusDamage (params)
  local hAbility = self:GetAbility ()
  return hAbility:GetSpecialValueFor ("bonus_damage")
end

function modifier_tiny_grow_armorform:GetModifierStatusResistance (params)
  local hAbility = self:GetAbility ()
  return hAbility:GetSpecialValueFor ("status_resistance")
end
------------------------------------------------------------------
------------------------------------------------------------------
if modifier_tiny_grow_fastform == nil then modifier_tiny_grow_fastform = class({}) end

function modifier_tiny_grow_fastform:IsHidden()
  return true
end

function modifier_tiny_grow_fastform:IsPurgable()
  return false
end

function modifier_tiny_grow_fastform:RemoveOnDeath()
    return false
end



function modifier_tiny_grow_fastform:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,

  }

  return funcs
end

function modifier_tiny_grow_fastform:GetModifierMoveSpeedBonus_Constant (params)
  local hAbility = self:GetAbility ()
  return hAbility:GetSpecialValueFor ("bonus_ms")
end

function modifier_tiny_grow_fastform:GetModifierBaseAttack_BonusDamage (params)
  local hAbility = self:GetAbility ()
  return hAbility:GetSpecialValueFor ("bonus_damage")
end

function modifier_tiny_grow_fastform:GetModifierBaseAttackTimeConstant (params)
  local hAbility = self:GetAbility ()
  return hAbility:GetSpecialValueFor ("attack_const")
end

