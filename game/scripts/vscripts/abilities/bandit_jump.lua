bandit_jump = class({})
LinkLuaModifier( "modifier_bandit_jump", "abilities/bandit_jump" ,LUA_MODIFIER_MOTION_NONE )

function bandit_jump:GetCastRange(Location, Target)
    return self:GetSpecialValueFor("range")
end

function bandit_jump:OnSpellStart()
    -- Cannot cast multiple stacks
    if self.sleight_of_fist_active ~= nil and self.sleight_of_fist_action == true then
        self:RefundManaCost()
        return nil
    end

    -- Inheritted variables
    local caster = self:GetCaster()
    --local targetPoint = self:GetCursorPosition()
    local ability = self
    local radius = ability:GetSpecialValueFor("width")
	local damage = caster:GetAttackDamage()*(self:GetTalentSpecialValueFor("damage")-100)/100
    local attack_interval = 0.2

    
    -- Start function
    caster:AddNewModifier(caster, self, "modifier_bandit_jump", {duration = attack_interval})
    local startPos = caster:GetAbsOrigin()
    local target = self:GetCursorTarget()

	local blinkIn = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_blink_strike.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(blinkIn, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(blinkIn, 1, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(blinkIn)

	FindClearSpaceForUnit( caster, target:GetAbsOrigin() - target:GetForwardVector() * 50, false )

	caster:PerformAttack(target, true, true, true, true, false, false, true)

	Timers:CreateTimer(attack_interval, function()
        FindClearSpaceForUnit( caster, startPos, false )
        caster:RemoveModifierByName( "modifier_bandit_jump" )
        self.sleight_of_fist_active = false

        local blinkIn = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_blink_strike.vpcf", PATTACH_POINT, caster)
            ParticleManager:SetParticleControl(blinkIn, 0, target:GetAbsOrigin())
            ParticleManager:SetParticleControl(blinkIn, 1, caster:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(blinkIn)
		if caster:HasModifier( "modifier_bandit_jump" ) then
			return 0.1
		else
			return nil
		end
    end) 
end

modifier_bandit_jump = class({})
function modifier_bandit_jump:CheckState()
    local state = { [MODIFIER_STATE_INVULNERABLE] = true,
                    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
                    [MODIFIER_STATE_UNSELECTABLE] = true,
                    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                    [MODIFIER_STATE_COMMAND_RESTRICTED] = true}
    return state
end

function modifier_bandit_jump:IsHidden()
    return true
end