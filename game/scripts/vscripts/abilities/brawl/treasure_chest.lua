treasure_chest = class({})
LinkLuaModifier("modifier_treasure_chest", "abilities/treasure_chest", LUA_MODIFIER_MOTION_NONE)

function treasure_chest:GetIntrinsicModifierName()
	return "modifier_treasure_chest"
end

modifier_treasure_chest = class({
	IsPurgable = function() return false end,
	IsHidden = function() return true end,
})

function modifier_treasure_chest:CheckState()
	local state = {
		-- [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		[MODIFIER_STATE_PROVIDES_VISION] = true,
	}
	if self:GetParent().WasOpened then
		state[MODIFIER_STATE_OUT_OF_GAME] = true
	end
	return state
end

function modifier_treasure_chest:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
	}
end

function modifier_treasure_chest:GetModifierProvidesFOWVision()
	return 1
end

function modifier_treasure_chest:GetAbsoluteNoDamagePhysical()
	return self:GetParent().presentTarget == nil and 1 or 0
end

function modifier_treasure_chest:GetAbsoluteNoDamageMagical()
	return self:GetParent().presentTarget == nil and 1 or 0
end

function modifier_treasure_chest:GetAbsoluteNoDamagePure()
	return self:GetParent().presentTarget == nil and 1 or 0
end

if IsServer() then
	function modifier_treasure_chest:OnCreated()
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_disable_aggro", {})
		self:StartIntervalThink(0.5)
		self:OnIntervalThink()

		local nFXIndex = ParticleManager:CreateParticle("particles/generic_gameplay/treasure_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(nFXIndex, 0, self:GetParent():GetOrigin())
		ParticleManager:SetParticleControl(nFXIndex, 1, self:GetParent():GetOrigin())
		self:AddParticle(nFXIndex, false, false, -1, false, false)
	end
	function modifier_treasure_chest:OnRefresh()
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_disable_aggro", {})
	end
	function modifier_treasure_chest:OnIntervalThink()
		for i = 2, 3 do
			self:GetParent():MakeVisibleToTeam(i, 0.5)
		end
		for i = 6, 13 do
			self:GetParent():MakeVisibleToTeam(i, 0.5)
		end
	end
end