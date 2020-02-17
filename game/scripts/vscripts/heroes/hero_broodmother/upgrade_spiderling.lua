LinkLuaModifier("modifier_broodmother_upgrade_spiderling", "heroes/hero_broodmother/upgrade_spiderling", LUA_MODIFIER_MOTION_NONE)


broodmother_upgrade_spiderling = class({})

function broodmother_upgrade_spiderling:GetIntrinsicModifierName()
	return "modifier_broodmother_upgrade_spiderling"
end


modifier_broodmother_upgrade_spiderling = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
})

function modifier_broodmother_upgrade_spiderling:OnCreated()
	self:StartIntervalThink(0.25)
end

function modifier_broodmother_upgrade_spiderling:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	
	if ability:IsCooldownReady() and caster:IsAlive() then
		ability:UseResources(false, false, true)
		self:IncrementStackCount()
--		EmitSoundOn("broodmother_broo_ability_spawn_11",caster)
		EmitSoundOn("broodmother_broo_ability_spawn_07",caster)
	end
end




