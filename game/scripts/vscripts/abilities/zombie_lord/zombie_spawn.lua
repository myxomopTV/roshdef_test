LinkLuaModifier("modifier_zombie_lord_zombie_spawn", "abilities/zombie_lord/zombie_spawn", LUA_MODIFIER_MOTION_NONE)

if not zombie_lord_zombie_spawn then zombie_lord_zombie_spawn = class({}) end

function zombie_lord_zombie_spawn:GetCastRange()
	return self:GetSpecialValueFor("radius")
end

function zombie_lord_zombie_spawn:GetIntrinsicModifierName()
	return "modifier_zombie_lord_zombie_spawn"
end

modifier_zombie_lord_zombie_spawn = class({
	IsHidden 		= function(self) return true end,
})

function modifier_zombie_lord_zombie_spawn:OnCreated()
	local interval = self:GetAbility():GetSpecialValueFor("interval")
	self:StartIntervalThink(interval)
end

function modifier_zombie_lord_zombie_spawn:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local caster_point = caster:GetAbsOrigin()
	local team = caster:GetTeamNumber()

	local radius = ability:GetSpecialValueFor("radius")
	local count = ability:GetSpecialValueFor("count")
	local flesh_count = ability:GetSpecialValueFor("flesh_count")
	local unit_name = "npc_dota_zombie_lord_zombie"

	if caster:HasModifier("modifier_zombie_lord_fleshgolem_aura") then
		count = flesh_count
	end

	local enemies = caster:FindEnemyUnitsInRadius(caster_point, radius, nil)

	for _,enemy in pairs (enemies) do
		local point = enemy:GetAbsOrigin()
		for i=1,count do
			local unit = CreateUnitByName(unit_name, point, true, caster, caster, team)
		end
--		unit:SetControllableByPlayer(caster:GetPlayerOwner(), true)	
	end	
end