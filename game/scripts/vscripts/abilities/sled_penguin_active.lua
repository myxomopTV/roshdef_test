
LinkLuaModifier( "modifier_sled_penguin_passive", "modifiers/modifier_sled_penguin_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sled_penguin_movement_self", "modifiers/modifier_sled_penguin_movement_self", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_sled_penguin_crash", "modifiers/modifier_sled_penguin_crash", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_sled_penguin_impairment", "modifiers/modifier_sled_penguin_impairment", LUA_MODIFIER_MOTION_NONE )


sled_penguin_active = class({})

function sled_penguin_active:OnSpellStart()
	local caster = self:GetCaster()

	if caster:HasModifier("modifier_sled_penguin_movement_self") then
		caster:RemoveModifierByName("modifier_sled_penguin_movement_self")
	else
		EmitSoundOn( "SledPenguin.PlayerHopOn", caster )
		caster:AddNewModifier( caster, self, "modifier_sled_penguin_movement_self", {} )
	end
end