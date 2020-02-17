LinkLuaModifier("modifier_monkey_king_power_jump", "heroes/hero_monkey_king/power_jump", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_power_jump_buff", "heroes/hero_monkey_king/power_jump", LUA_MODIFIER_MOTION_NONE)



monkey_king_power_jump = class({})

function monkey_king_power_jump:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function monkey_king_power_jump:GetCastRange()
    return self:GetSpecialValueFor("jump_range")
end

function monkey_king_power_jump:GetCastAnimation()
     return ACT_DOTA_MK_SPRING_END
end

function monkey_king_power_jump:OnSpellStart()
    local caster = self:GetCaster()

    EmitSoundOn("Hero_MonkeyKing.Spring.Channel", caster)
--[[
    if caster  then--:HasTalent("special_bonus_unique_mk_spring_1") then
        local point = self:GetCursorPosition()

        local nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/mk_spring_blone.vpcf", PATTACH_POINT, caster)
                    ParticleManager:SetParticleControl(nfx, 0, point)

        Timers:CreateTimer(0.4, function()
            GridNav:DestroyTreesAroundPoint(point, self:GetSpecialValueFor("radius"), false)
            self:DoSpring(point)
            ParticleManager:ClearParticle(nfx)
        end)
    else
 ]]       
        if caster then--:HasModifier("modifier_mk_tree_perch") then
            caster:AddNewModifier(caster, self, "modifier_monkey_king_power_jump", {Duration = 2})
        else
            local point = caster:GetAbsOrigin()
            self:DoSpring(point)
        end
 --   end
end

function monkey_king_power_jump:DoSpring(vLocation)
    local caster = self:GetCaster()
    local point = vLocation

    local buff_duration = self:GetSpecialValueFor("buff_duration")
    local radius = self:GetSpecialValueFor("radius")
    local damage = self:GetSpecialValueFor("damage")

    EmitSoundOnLocationWithCaster(vLocation, "Hero_MonkeyKing.Spring.Impact", caster)

    local nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_spring.vpcf", PATTACH_POINT, caster)
                ParticleManager:SetParticleControl(nfx, 0, point)
                ParticleManager:SetParticleControl(nfx, 1, Vector(radius, radius, radius))
                ParticleManager:ReleaseParticleIndex(nfx)

    EmitSoundOn("Hero_MonkeyKing.Spring.Target", enemy)
    caster:AddNewModifier(caster, self, "modifier_monkey_king_power_jump_buff", {Duration = buff_duration})
    caster:AddNewModifier(caster, self, "modifier_phased", {Duration = 0.1})
end

modifier_monkey_king_power_jump = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
            MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        } end,
    CheckState      = function(self) return 
        {
            [MODIFIER_STATE_STUNNED] = true,          
            [MODIFIER_STATE_INVULNERABLE] = true, 
      } end,
})

function modifier_monkey_king_power_jump:OnCreated(table)
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()

        local nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
                    ParticleManager:SetParticleControlEnt(nfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
        self:AttachEffect(nfx)

        self.speed = self:GetSpecialValueFor("leap_speed") * FrameTime()

        self.distance = CalculateDistance(ability:GetCursorPosition(), caster:GetAbsOrigin())
        self.direction = CalculateDirection(ability:GetCursorPosition(), caster:GetAbsOrigin())
        self.maxHeight = 250

        self.distanceTraveled = 0

        self:StartMotionController()
    end
end

function modifier_monkey_king_power_jump:GetOverrideAnimation()
    return ACT_DOTA_MK_SPRING_SOAR
end

function modifier_monkey_king_power_jump:DoControlledMotion()
    if IsServer() then
        local parent = self:GetParent()
        local ability = self:GetAbility()

        if self.distanceTraveled < (self.distance - self.speed) then
            local newPos = GetGroundPosition(parent:GetAbsOrigin(), parent) + self.direction * self.speed
            local height = GetGroundHeight(parent:GetAbsOrigin(), parent)
            newPos.z = height + self.maxHeight * math.sin( (self.distanceTraveled/self.distance) * math.pi )
            parent:SetAbsOrigin( newPos )
            
            self.distanceTraveled = self.distanceTraveled + self.speed
        else
            self:GetAbility():DoSpring(parent:GetAbsOrigin())

            self:Destroy()
            self:StopMotionController()
        end  
    end
end

modifier_monkey_king_power_jump_buff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {
             MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        } end,
})
function modifier_monkey_king_power_jump_buff:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("bonus_as")
end
