item_medusa_head = class({})
LinkLuaModifier( "modifier_item_watchers_gaze", "modifiers/modifier_item_watchers_gaze", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_stone_gaze_debuff", "modifiers/modifier_stone_gaze_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_medusa_head:OnSpellStart()
	if IsServer() then
--		local vision_cone = self:GetSpecialValueFor( "vision_cone" )
		local duration = self:GetSpecialValueFor( "stone_duration" )
		local target = self:GetCursorTarget()
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_medusa/medusa_stone_gaze_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		target:AddNewModifier( self:GetCaster(), self, "modifier_stone_gaze_debuff", {duration = 1000000})
		EmitSoundOn( "Hero_Medusa.StoneGaze.target" ,target )
		Timers:CreateTimer(duration, function()
			target:RemoveModifierByName("modifier_stone_gaze_debuff")
		end)
	end
end

--------------------------------------------------------------------------------

function item_medusa_head:GetIntrinsicModifierName()
	return "modifier_item_watchers_gaze"
end

--------------------------------------------------------------------------------
item_watchers_gaze = class(item_medusa_head)
--------------------------------------------------------------------------------

