LinkLuaModifier( "modifier_mark_developer_present", "heroes/hero_mark/developer_present.lua", LUA_MODIFIER_MOTION_NONE )

mark_developer_present = class({})

function mark_developer_present:GetIntrinsicModifierName()
	return "modifier_mark_developer_present"
end
--------------------------------------------------------------------------------

modifier_mark_developer_present = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
})

function modifier_mark_developer_present:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.25)
		self.state = 1
		
		local caster = self:GetCaster()
		local point = caster:GetAbsOrigin()
		local team = caster:GetTeam()
		local unit = CreateUnitByName( "npc_dota_companion", point, true, caster, caster, team )
		unit:SetModel("models/props_gameplay/pig.vmdl")
		unit:SetOriginalModel("models/props_gameplay/pig.vmdl")
		unit:SetModelScale(0.75)
		local unit = CreateUnitByName( "npc_dota_companion", point, true, caster, caster, team )
		unit:SetModel("models/props_gameplay/chicken.vmdl")
		unit:SetOriginalModel("models/props_gameplay/chicken.vmdl")
		unit:SetModelScale(0.75)
		
	end
end

function modifier_mark_developer_present:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local strength = caster:GetStrength()
	local agility = caster:GetAgility()
	local intellect = caster:GetIntellect()
	local stats_sum = strength + agility + intellect

	if caster:HasScepter() then
--		self.state = 0
		local model = "models/items/courier/devourling/devourling.vmdl"
		caster:SetOriginalModel(model)
		caster:SetModel(model)
	elseif self.state == 1 and stats_sum > 500 then
		self.state = self.state + 1
		local model = "models/courier/donkey_unicorn/donkey_unicorn.vmdl"
		caster:SetOriginalModel(model)
		caster:SetModel(model)
	elseif self.state == 2 and stats_sum > 1500 then
		self.state = self.state + 1
		local model = "models/courier/donkey_crummy_wizard_2014/donkey_crummy_wizard_2014.vmdl"
		caster:SetOriginalModel(model)
		caster:SetModel(model)
	elseif self.state == 3 and stats_sum > 5000 then
		self.state = self.state + 1
		local model = "models/courier/donkey_ti7/donkey_ti7.vmdl"
		caster:SetOriginalModel(model)
		caster:SetModel(model)
	end
	if ability:IsCooldownReady() then
		ability:UseResources(false, false, true)
		if caster:HasModifier("tome_strenght_modifier") == false then
			caster:AddNewModifier(caster,ability,"tome_strenght_modifier",nil)
			caster:SetModifierStackCount("tome_strenght_modifier", caster, 1)
		else
			caster:SetModifierStackCount("tome_strenght_modifier", caster, (caster:GetModifierStackCount("tome_strenght_modifier", caster) + 1))
		end
		 if caster:HasModifier("tome_agility_modifier") == false then
			caster:AddNewModifier(caster,ability,"tome_agility_modifier",nil)
			caster:SetModifierStackCount("tome_agility_modifier", caster, 1)
		else
			caster:SetModifierStackCount("tome_agility_modifier", caster, (caster:GetModifierStackCount("tome_agility_modifier", caster) + 1))
		end
	   if caster:HasModifier("tome_intelect_modifier") == false then
			caster:AddNewModifier(caster,ability,"tome_intelect_modifier",nil)
			caster:SetModifierStackCount("tome_intelect_modifier", caster, 1)
		else
			caster:SetModifierStackCount("tome_intelect_modifier", caster, (caster:GetModifierStackCount("tome_intelect_modifier", caster) + 1))
		end
	end
end
