
LinkLuaModifier( "modifier_item_arrow", "items/custom/item_arrow.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_arrow_fire", "items/custom/item_arrow.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_campfire_quest", "items/custom/item_arrow.lua", LUA_MODIFIER_MOTION_NONE )

item_arrow_pike = class({})

function item_arrow_pike:GetIntrinsicModifierName()
	return "modifier_item_arrow"
end
item_arrow_full = class({})

function item_arrow_full:GetIntrinsicModifierName()
	return "modifier_item_arrow"
end

item_arrow_fire = class({})

function item_arrow_fire:GetIntrinsicModifierName()
	return "modifier_item_arrow"
end

function item_arrow_fire:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function item_arrow_fire:OnSpellStart()
	local point = self:GetCursorPosition()
--[[
	local dummy = CreateUnitByName("npc_dota_thinker", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
	dummy:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = 3})

	local info = {
		EffectName = "particles/units/heroes/hero_huskar/huskar_burning_spear.vpcf",
		Ability = self,
		iMoveSpeed = 800,
		Source = self:GetCaster(),
		Target = dummy,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
	}

	ProjectileManager:CreateTrackingProjectile( info )
]]
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")

	local enemies = FindUnitsInRadius(caster:GetTeam(), 
									point, 
									caster, 
									radius, 
									DOTA_UNIT_TARGET_TEAM_BOTH, 
									DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
									DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
									FIND_ANY_ORDER, false)
	
	for i=1,#enemies do
		EmitSoundOn( "Hero_Huskar.Burning_Spear", enemy )
		local enemy = enemies[i]
		DealDamage(caster, enemy, damage, DAMAGE_TYPE_MAGICAL, nil, ability)
		enemy:AddNewModifier(caster, self, "modifier_item_arrow_fire", {duration = duration})
			
	end
end

function item_arrow_fire:OnProjectileHit(hTarget, vLocation)
	if hTarget ~= nil and ( not hTarget:TriggerSpellAbsorb( self ) )  then
		local caster = self:GetCaster()
		local radius = self:GetSpecialValueFor("radius")
		local duration = self:GetSpecialValueFor("duration")

		EmitSoundOn( "Hero_Huskar.Burning_Spear", hTarget )
		local enemies = FindUnitsInRadius(caster:GetTeam(), 
										hTarget:GetAbsOrigin(), 
										nil, 
										radius, 
										DOTA_UNIT_TARGET_TEAM_BOTH, 
										DOTA_UNIT_TARGET_BASIC, 
										DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
										FIND_ANY_ORDER, false)
		
		for i=1,#enemies do
			local enemy = enemies[i]
			DealDamage(caster, enemy, damage, DAMAGE_TYPE_MAGICAL, nil, ability)
			enemy:AddNewModifier(caster, self, "modifier_item_arrow_fire", {duration = duration})
				
		end
	end
 end 
--------------------------------------------------------------------------------

modifier_item_arrow = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		} end,
})

function modifier_item_arrow:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

modifier_item_arrow_fire = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
})

function modifier_item_arrow_fire:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		self.value_need = 1/ability:GetSpecialValueFor("str_mult")
		self.crit_chance = ability:GetSpecialValueFor("crit_chance")
		self:StartIntervalThink(1)
	end
end

function modifier_item_arrow_fire:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if parent:GetUnitName() == "npc_dota_creature_friendly_ogre_tank_webtrapped" then
			parent:AddNoDraw()
			parent:ForceKill(false)

			local point = parent:GetAbsOrigin()
			local unit = CreateUnitByName("npc_dota_friendly_ogre_cook", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
			EmitGlobalSound("gachi_welcome_club")
			
			local newItem = CreateItem( "item_pie", nil, nil )
			CreateItemOnPositionSync( point, newItem )					

			Timers:CreateTimer(0.1,function ()
				local home_point = Entities:FindByName( nil, "point_home_cook") 				
				if home_point then	
					unit:MoveToPositionAggressive(home_point:GetAbsOrigin())
				end	
			end)
		end
	end
end

function modifier_item_arrow_fire:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local dps =  ability:GetSpecialValueFor("dps")

	DealDamage(caster, parent, dps, DAMAGE_TYPE_MAGICAL, nil, ability)
end

function modifier_item_arrow_fire:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end



campfire_quest = class({})

function campfire_quest:GetIntrinsicModifierName()
	return "modifier_campfire_quest"
end

modifier_campfire_quest = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
})

function modifier_campfire_quest:GetEffectName()
	return "particles/vr_env/vr_camp_fire.vpcf"
--	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_campfire_quest:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end
function modifier_campfire_quest:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local radius = ability:GetSpecialValueFor("radius")
	local duration = ability:GetSpecialValueFor("duration")
	
	local units = FindUnitsInRadius(caster:GetTeam(), 
									caster:GetAbsOrigin(), 
									nil, 
									radius, 
									DOTA_UNIT_TARGET_TEAM_BOTH, 
									DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
--									DOTA_UNIT_TARGET_FLAG_INVULNERABLE +  
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
									FIND_ANY_ORDER, false)
	
	for i=1,#units do
		local unit = units[i]
		unit:AddNewModifier(caster, ability, "modifier_item_arrow_fire", {duration = duration})
		local item1 = nil
		local item2 = nil
		local item3 = nil
		local item4 = nil
		local index = 1

		if unit:IsRealHero() then
			for k=0,9 do
				local item = unit:GetItemInSlot(k)


				if item then
					local item_name = item:GetName()
					if item_name == "item_arrow_full" then
	--					EmitSoundOn("Hero_Broodmother.SpawnSpiderlings",caster)
						local newItem = CreateItem( "item_arrow_fire", nil, nil )
						CreateItemOnPositionSync( caster:GetAbsOrigin(), newItem )					
						unit:RemoveItem(item)	
					end	

					if item_name == "item_reward_banana" or item_name == "item_reward_fish" or item_name == "item_reward_meat" or item_name == "item_reward_soup" then
--						print("find item = "..item_name)
						if index == 1 then
							item1 = item
							index = index + 1
						elseif index == 2 then
							item2 = item
							index = index + 1
						elseif index == 3 then
							item3 = item
							index = index + 1
						elseif index == 4 then
							item4 = item
							index = index + 1
						end
						if index == 5 then
							local newItem = CreateItem( "item_soup", nil, nil )
							CreateItemOnPositionSync( caster:GetAbsOrigin(), newItem )				
							unit:RemoveItem(item1)	
							unit:RemoveItem(item2)	
							unit:RemoveItem(item3)	
							unit:RemoveItem(item4)	
						end
					end
				end
				
			end	
		end				
	end	
end


