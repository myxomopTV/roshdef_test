riki_dance = class({})
LinkLuaModifier( "modifier_dance", "heroes/hero_riki/riki_dance" ,LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_dance_enemy", "heroes/hero_riki/riki_dance.lua" ,LUA_MODIFIER_MOTION_NONE )

function riki_dance:GetCastRange(Location, Target)
    return self:GetSpecialValueFor("range")
end

function riki_dance:OnSpellStart()
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
    local attack_interval = 0.1

	local backstab_ability = caster:FindAbilityByName("cloak_and_dagger_datadriven")

    -- Necessary varaibles
    local counter = 0
    self.sleight_of_fist_active = true
    
    -- Start function
    caster:AddNewModifier(caster, self, "modifier_dance", nil)
    local startPos = caster:GetAbsOrigin()
    local endPos = self:GetCursorPosition()
    local enemies = caster:FindEnemyUnitsInLine(startPos, endPos, radius, {})
    for _, target in pairs( enemies ) do
        Timers:CreateTimer(attack_interval*(counter+1), function()
            local blinkIn = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_blink_strike.vpcf", PATTACH_POINT, caster)
            ParticleManager:SetParticleControl(blinkIn, 0, caster:GetAbsOrigin())
            ParticleManager:SetParticleControl(blinkIn, 1, target:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(blinkIn)

            FindClearSpaceForUnit( caster, target:GetAbsOrigin() - target:GetForwardVector() * 50, false )

            caster:PerformAttack(target, true, true, true, true, false, false, true)
            self:DealDamage(caster, target, caster:GetAttackDamage()*(self:GetTalentSpecialValueFor("damage")-100)/100, {}, 0)

			if backstab_ability and backstab_ability:GetLevel() > 0 and not self:GetParent():PassivesDisabled() then
				local agility_damage_multiplier = backstab_ability:GetSpecialValueFor("agility_damage")/100
				
                local previous_stack_count = 0
                local damage = caster:GetAgility() * agility_damage_multiplier

                if caster:HasModifier("modifier_slark_essence_shift_datadriven_buff_counter") then
                    previous_stack_count = caster:GetModifierStackCount("modifier_slark_essence_shift_datadriven_buff_counter", caster)
                    
                    --We have to remove and replace the modifier so the duration will refresh (so it will show the duration of the latest Essence Shift).
                    caster:RemoveModifierByNameAndCaster("modifier_slark_essence_shift_datadriven_buff_counter", caster)
                end
                ability:ApplyDataDrivenModifier(caster, caster, "modifier_slark_essence_shift_datadriven_buff_counter", nil)
                caster:SetModifierStackCount("modifier_slark_essence_shift_datadriven_buff_counter", caster, previous_stack_count + 1)
                
                --Apply an Agility buff for Slark.
                ability:ApplyDataDrivenModifier(caster, caster, "modifier_slark_essence_shift_datadriven_buff", nil)
                -- Create the back particle effect.
                local particle = ParticleManager:CreateParticle(params.particle, PATTACH_ABSORIGIN_FOLLOW, target) 
                -- Set Control Point 1 for the backstab particle; this controls where it's positioned in the world. In this case, it should be positioned on the victim.
                ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true) 
                -- Apply extra backstab damage based on Riki's agility
                ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = ability:GetAbilityDamageType(),damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION })
			end
			
		--Apply an Agility buff for Slark.
		backstab_ability:ApplyDataDrivenModifier(caster, caster, "modifier_slark_essence_shift_datadriven_buff", nil)

            if caster:HasTalent("special_bonus_unique_riki_dance_2") and RollPercentage(25) then
                self:Stun(target, 0.5, false)
            end
            
            Timers:CreateTimer(0.3, function()  
                EmitSoundOn("Hero_Riki.Blink_Strike", target)
            end)
        end)
        counter = counter + 1
        --break
    end
    
    -- Return caster to end position
    Timers:CreateTimer(attack_interval*(counter+1), function()
        FindClearSpaceForUnit( caster, startPos, false )
        caster:RemoveModifierByName( "modifier_dance" )
        self.sleight_of_fist_active = false

        StopSoundOn("Hero_Riki.Blink_Strike", caster)

        local blinkIn = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_blink_strike.vpcf", PATTACH_POINT, caster)
            ParticleManager:SetParticleControl(blinkIn, 0, caster:GetAbsOrigin())
            ParticleManager:SetParticleControl(blinkIn, 1, endPos)
            ParticleManager:ReleaseParticleIndex(blinkIn)
		if caster:HasModifier( "modifier_dance" ) then
			return 0.1
		else
			return nil
		end
    end) 
end

modifier_dance = class({})
function modifier_dance:CheckState()
    local state = { [MODIFIER_STATE_INVULNERABLE] = true,
                    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
                    [MODIFIER_STATE_UNSELECTABLE] = true,
                    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                    [MODIFIER_STATE_COMMAND_RESTRICTED] = true}
    return state
end

function modifier_dance:IsHidden()
    return true
end