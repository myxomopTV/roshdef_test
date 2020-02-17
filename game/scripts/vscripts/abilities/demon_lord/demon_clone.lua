LinkLuaModifier("modifier_demon_lord_demon_clone", "abilities/demon_lord/demon_clone", LUA_MODIFIER_MOTION_NONE)

demon_lord_demon_clone = class({})

function demon_lord_demon_clone:GetIntrinsicModifierName()
	return "modifier_demon_lord_demon_clone"
end

modifier_demon_lord_demon_clone = class({
	IsHidden = function(self) return false end,
	IsPurgable = function(self) return false end,
	RemoveOnDeath = function(self) return true end,
	DeclareFunctions = function(self) return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}end,
})

function modifier_demon_lord_demon_clone:OnCreated()
	local ability = self:GetAbility()

	if ability.unit_count == nil then
		ability.unit_count = 0
	end
end

function modifier_demon_lord_demon_clone:OnDestroy()
	local ability = self:GetAbility()

	ability.unit_count = ability.unit_count - 1
end
function modifier_demon_lord_demon_clone:OnAttackLanded(data)	
	local attacker = data.attacker
	local target = data.target
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local attack_count = ability:GetSpecialValueFor("attack_count")
	local max_unit_count = ability:GetSpecialValueFor("max_unit_count")

	if attacker == parent and target:IsAlive() then
		if not IsValidEntity(caster) or not caster:IsAlive() then
			self:Destroy()
		end
		self:IncrementStackCount()
		if self:GetStackCount() >= attack_count and ability.unit_count < max_unit_count then
			self:SetStackCount(0)
			local team = parent:GetTeam()
			local waypoint = Entities:FindByName( nil, "d_waypoint18")
			local point = parent:GetAbsOrigin()
			local unit = CreateUnitByName( "npc_dota_demon_lord_clone", point + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, team )
			unit:AddNewModifier(caster, ability, "modifier_demon_lord_demon_clone", nil)
			unit:SetHealth(caster:GetHealth())
			unit:SetInitialGoalEntity( waypoint )
			print("casterHealth ="..caster:GetHealth())
			ability.unit_count = ability.unit_count + 1
			print("unit count = "..ability.unit_count)
		end
	end
end

