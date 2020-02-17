LinkLuaModifier("modifier_ice_frog_effect", "abilities/ice_frog_effect", LUA_MODIFIER_MOTION_NONE)
letter_index = 1

ice_frog_effect = class({})

function ice_frog_effect:GetIntrinsicModifierName()
	return "modifier_ice_frog_effect"
end

modifier_ice_frog_effect = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
			MODIFIER_EVENT_ON_ATTACK_LANDED,
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		} end,
	CheckState		= function(self) return 
		{
			[MODIFIER_STATE_MAGIC_IMMUNE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_INVISIBLE] = true,
			[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		} end,
})
function modifier_ice_frog_effect:OnCreated()
	if IsServer() then
--		Timers:CreateTimer(0.1, function()
--			local ability = self:GetAbility()
			self.caster = self:GetCaster()
			
			local a = 0
			local b = 50
			local c = 255
			self.caster:SetRenderColor(a, b, c)
						
--		end)
	end
end

function modifier_ice_frog_effect:GetEffectName()
--	return "particles/econ/items/drow/drow_ti9_immortal/drow_ti9_frost_arrow_debuff.vpcf"
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

function modifier_ice_frog_effect:OnAttackLanded(params)
	if params.target == self.caster and self.caster:HasModifier("modifier_truesight") then
		local caster = self:GetCaster()
		if not caster:IsAlive() then
			return
		end

		caster:ForceKill(false)
		
		if letter_index <= 9 then
			local item_name = "item_icefrog_letter_"..letter_index
			local point = self.caster:GetAbsOrigin()
			local newItem = CreateItem( item_name, nil, nil )
			local drop = CreateItemOnPositionSync( point, newItem )
			letter_index = letter_index + 1	
		end
	end
end

function modifier_ice_frog_effect:GetModifierIncomingDamage_Percentage(params)
	return -100
end

