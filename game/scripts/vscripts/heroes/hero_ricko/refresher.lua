
LinkLuaModifier( "modifier_ricko_refresher", "heroes/hero_ricko/refresher", LUA_MODIFIER_MOTION_NONE )

ricko_refresher = class({})

function ricko_refresher:OnSpellStart()
	local buff_duration= self:GetSpecialValueFor("buff_duration")
	local caster = self:GetCaster()
	local host = self:GetCaster().host
	if host and IsValidEntity(host) then
		host:AddNewModifier( caster, self, "modifier_ricko_refresher", {duration = buff_duration} )
		host:EmitSound("DOTA_Item.Refresher.Activate")

--		local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, host )
--		ParticleManager:ReleaseParticleIndex( nFXIndex )
		host:SetHealth(host:GetMaxHealth())
		host:SetMana(host:GetMaxMana())

		for index=0,16 do
			local ability = host:GetAbilityByIndex(index)
			if ability then
				ability:EndCooldown()
			end
		end
		for index=0,8 do
			local item = host:GetItemInSlot(index)
			if item then
				item:EndCooldown()
			end
		end

	end
end

modifier_ricko_refresher = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
	CheckState				= function(self) return 
		{
			[MODIFIER_STATE_MAGIC_IMMUNE] = true
		} end,
})

function modifier_ricko_refresher:GetEffectName()
	return "particles/econ/items/lifestealer/lifestealer_immortal_backbone_gold/lifestealer_immortal_backbone_gold_rage.vpcf"
end
