LinkLuaModifier("modifier_item_icefrog_stand", "items/custom/item_icefrog_stand", LUA_MODIFIER_MOTION_NONE)

item_icefrog_stand = class({})

function item_icefrog_stand:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier( caster, self, "modifier_item_icefrog_stand" , nil)
	caster:RemoveItem(self)
end
--------------------------------------------------------
------------------------------------------------------------
modifier_item_icefrog_stand = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		} end,
})

function modifier_item_icefrog_stand:OnCreated( params )
	if IsServer() then
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		self.damage = ability:GetSpecialValueFor("damage")
		self.radius = ability:GetSpecialValueFor("radius")
		local icefrog = CreateUnitByName("npc_dota_icefrog_stand", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
		
		local effect = "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, icefrog)
		ParticleManager:ReleaseParticleIndex(pfx)

		icefrog:SetRenderColor(0, 0, 150)
	end
end

function modifier_item_icefrog_stand:OnAttackLanded( params )
	if IsServer() then
		local caster = self:GetCaster()
		if params.attacker == caster and ( not caster:IsIllusion() ) then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local target = params.target

			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not target:IsBuilding() and not target:IsMagicImmune() then
				EmitSoundOn("Ability.FrostNova",target)
				
				local effect = "particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova.vpcf"
				local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, target)
				ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin()) -- Origin
				ParticleManager:SetParticleControl(pfx, 1, Vector(self.radius, self.radius, self.radius)) -- Origin
				ParticleManager:ReleaseParticleIndex(pfx)

				local enemies = FindUnitsInRadius(caster:GetTeam(), 
												target:GetAbsOrigin(), 
												nil, 
												self.radius, 
												DOTA_UNIT_TARGET_TEAM_ENEMY, 
												DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
												DOTA_UNIT_TARGET_FLAG_NONE, 
												FIND_ANY_ORDER, false)
				for i=1,#enemies do
					local enemy = enemies[i]
					DealDamage(caster, enemy, self.damage, DAMAGE_TYPE_MAGICAL, nil, ability)
							
				end
			end
		end
	end

	return 0
end