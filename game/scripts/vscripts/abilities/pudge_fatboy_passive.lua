LinkLuaModifier("modifier_pudge_fatboy_passive", "abilities/pudge_fatboy_passive", LUA_MODIFIER_MOTION_NONE)

pudge_fatboy_passive = class({})

function pudge_fatboy_passive:GetIntrinsicModifierName()
	return "modifier_pudge_fatboy_passive"
end

modifier_pudge_fatboy_passive = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	CheckState		= function(self) return 
		{
--			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
--			[MODIFIER_STATE_BLIND] = true,
			[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
--			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_DISARMED] = true,
		} end,
})
--[[
function modifier_acult_mark:OnCreated()
	if IsServer() then
		Timers:CreateTimer(0.1, function()
			local ability = self:GetAbility()
			local caster = self:GetCaster()
			local point = caster:GetAbsOrigin()
			print(point)
						
			EmitSoundOn("Hero_Necrolyte.ReapersScythe.Cast.ti7", caster)
			
			ability.trigger = false
			self:StartIntervalThink(1)
		end)
	end
end

function modifier_acult_mark:GetEffectName()
	return "particles/units/heroes/hero_rubick/rubick_doom.vpcf"
end
function modifier_acult_mark:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local death_duration = ability:GetSpecialValueFor("death_duration")
	
	local units = FindUnitsInRadius(caster:GetTeamNumber(), 
									caster:GetAbsOrigin(),
									nil,
									150,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
									FIND_CLOSEST, 
									false)

	for i=1,#units do
		local unit = units[i]
		local name = unit:GetUnitName()
--		print(name)
		
		if 		name == "npc_dota_troll_myth" 	
		or 		name == "npc_dota_ogre_myth" 	
		or 		name == "npc_dota_dragon_myth" 
		or 		name == "npc_dota_kobold_myth" 
		or 		name == "npc_dota_wolf_myth" 	
		or 		name == "npc_dota_centaur_myth"
		or 		name == "npc_dota_golem_myth" 	
		or 		name == "npc_dota_ursa_myth" 	 
		or 		name == "npc_dota_satyr_myth"
		or 		name == "npc_dota_lizard_myth"
		or 		name == "npc_dota_hero_pangolier"
		and 	ability.trigger == false
		then 	
			ability.trigger = true
			unit:AddNewModifier(caster, ability, "modifier_acult_mark_death", {duration = death_duration})
		end		
	end
end

modifier_acult_mark_death = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	CheckState		= function(self) return 
		{
			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_BLIND] = true,
			[MODIFIER_STATE_STUNNED] = true,
		} end,
})

function modifier_acult_mark_death:GetEffectName()
	--return "particles/econ/items/necrolyte/necro_sullen_harvest/necro_ti7_immortal_scythe.vpcf"
	return "particles/units/heroes/hero_dark_willow/dark_willow_bramble.vpcf"
end
function modifier_acult_mark_death:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		local parent = self:GetParent()
		local point = parent:GetAbsOrigin()
	
		local death_duration = ability:GetSpecialValueFor("death_duration")
		EmitGlobalSound("tanos_death")
		
		Timers:CreateTimer(death_duration-1.5, function()
			local effect = "particles/econ/items/necrolyte/necro_sullen_harvest/necro_ti7_immortal_scythe_start.vpcf"
			local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, parent)
			ParticleManager:SetParticleControl(pfx, 0, point) -- Origin
			ParticleManager:SetParticleControl(pfx, 1, point) -- Origin
			ParticleManager:ReleaseParticleIndex(pfx)
			
			EmitSoundOn("Hero_Necrolyte.ReapersScythe.Cast.ti7", parent)
			EmitSoundOn("Hero_Necrolyte.ReapersScythe.Target", parent)
			
		end)
	end
end
function modifier_acult_mark_death:OnDestroy()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	caster:ForceKill(false)
	parent:ForceKill(false)
	
	local point = caster:GetAbsOrigin()
	local newItem = CreateItem( "item_soul_gem", nil, nil )
--	local newItem = CreateItem( "item_icefrog_stand", nil, nil )
	local drop = CreateItemOnPositionSync( point, newItem )

	if parent:GetUnitName() == "npc_dota_hero_pangolier" then
		require("abilities/hero_change")
		local demigod_enum ={
			"npc_dota_hero_terrorblade","npc_dota_hero_templar_assassin",
			"npc_dota_hero_sven","npc_dota_hero_undying",
			"npc_dota_hero_dark_seer","npc_dota_hero_dark_willow",
		}
		local data = {}
		data.hero_name = demigod_enum[RandomInt(1,#demigod_enum)]
		data.caster = parent
		GiveNewHero(data)
	end
	
end
]]