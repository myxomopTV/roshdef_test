LinkLuaModifier("modifier_rasta_death_ward", "heroes/hero_rasta/death_ward", LUA_MODIFIER_MOTION_NONE)

rasta_death_ward = class({})


function rasta_death_ward:OnSpellStart( )
	local caster = self:GetCaster()
	local ability = self

	local ward_duration = self:GetSpecialValueFor("ward_duration")
	local ward_count = self:GetSpecialValueFor("ward_count")
	local ward_damage = self:GetSpecialValueFor("ward_damage")
	local ward_health = self:GetSpecialValueFor("ward_health")
	local int_dmg = self:GetSpecialValueFor("int_dmg")*caster:GetIntellect()/100
	local point = self:GetCursorPosition()
	local fv = caster:GetForwardVector()
	local team = caster:GetTeam()
	local player = caster:GetPlayerID()

	for i=1, ward_count do
		local unit = CreateUnitByName( "npc_dota_rasta_death_ward", point, true, caster, caster, team )

		unit:SetControllableByPlayer(player, false)
		unit:SetOwner(caster)
		unit:SetForwardVector(fv)	
		unit:SetBaseDamageMin(ward_damage + int_dmg)
		unit:SetBaseDamageMax(ward_damage + int_dmg)
		
		unit:SetBaseMaxHealth(ward_health)
		unit:SetMaxHealth(ward_health)
		unit:SetHealth(ward_health)				
	--	unit:SetBaseAttackTime(bat)
		unit:AddNewModifier(caster, ability, "modifier_rasta_death_ward", nil)
		unit:AddNewModifier(caster, ability, "modifier_kill", {duration = ward_duration})
	end
	--	unit:SetHealth(unit:GetMaxHealth())
--	unit:SetHealth(unit:GetMaxHealth())
end

modifier_rasta_death_ward = class({
	IsHidden = function(self) return true end,
	CheckState = function(self) return {
--		[MODIFIER_STATE_INVULNERABLE] = true,
--		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
--		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
--		[MODIFIER_STATE_DISARMED] = true,
	}end,
	DeclareFunctions = function(self) return {
		MODIFIER_EVENT_ON_ATTACK
	}end,
    GetEffectName = function(self) return "particles/units/heroes/hero_witchdoctor/witchdoctor_ward_skull.vpcf" end,    
    GetEffectAttachType = function(self) return PATTACH_OVERHEAD_FOLLOW end,    
})

function modifier_rasta_death_ward:OnAttack(params)
    if not IsServer() then return end
    local attacker = params.attacker
    local parent = self:GetParent()
    local ability = self:GetAbility()
    
    if parent.split == nil then
        parent.split = true
    end

    if attacker == parent and parent.split == true  then
        local attack_range = parent:Script_GetAttackRange() + 50
        local arrow_count = ability:GetSpecialValueFor("arrow_count")-1
--        local trigger_chance = ability:GetSpecialValueFor("trigger_chance")        
--        if RollPercentage(trigger_chance)  then
        local units = FindUnitsInRadius(parent:GetTeamNumber(), 
                                        parent:GetAbsOrigin(),
                                        nil,
                                        attack_range,
                                        DOTA_UNIT_TARGET_TEAM_ENEMY,
                                        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, 
                                        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
                                        FIND_ANY_ORDER, 
                                        false) 


        parent.split = false 
        if arrow_count > #units  then 
                arrow_count = #units
        end

        local index = 1
        local arrow_deal = 0

        while arrow_deal < arrow_count   do
            if units[index] == params.target then
            --                     print("bingo!!!")
            else
                parent:PerformAttack(units[ index ], false, true, true, false, true, false, false)
                arrow_deal = arrow_deal + 1
            end 
            index = index + 1
        end

        parent.split = true
        --   		 end
    end    
end