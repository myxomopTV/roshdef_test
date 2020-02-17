LinkLuaModifier("modifier_rasta_serpent_ward", "heroes/hero_rasta/serpent_ward", LUA_MODIFIER_MOTION_NONE)

rasta_serpent_ward = class({})


function rasta_serpent_ward:OnSpellStart( )
	local caster = self:GetCaster()
	local ability = self

	local ward_duration = self:GetSpecialValueFor("ward_duration")
	local ward_count = self:GetSpecialValueFor("ward_count")
	local ward_damage = self:GetSpecialValueFor("ward_damage")
	local int_dmg = self:GetSpecialValueFor("int_dmg")*caster:GetIntellect()/100
	local point = self:GetCursorPosition()
	local fv = caster:GetForwardVector()
	local team = caster:GetTeam()
	local player = caster:GetPlayerID()

	for i=1, ward_count do
		local unit = CreateUnitByName( "npc_dota_rasta_serpent_ward", point, true, caster, caster, team )

		unit:SetControllableByPlayer(player, false)
		unit:SetOwner(caster)
		unit:SetForwardVector(fv)	
		unit:SetBaseDamageMin(ward_damage + int_dmg)
		unit:SetBaseDamageMax(ward_damage + int_dmg)				
	--	unit:SetBaseAttackTime(bat)
		unit:AddNewModifier(caster, ability, "modifier_rasta_serpent_ward", nil)
		unit:AddNewModifier(caster, ability, "modifier_kill", {duration = ward_duration})
	end
	--	unit:SetHealth(unit:GetMaxHealth())
--	unit:SetHealth(unit:GetMaxHealth())
end

modifier_rasta_serpent_ward = class({
	IsHidden = function(self) return true end,
	CheckState = function(self) return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
--		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
--		[MODIFIER_STATE_DISARMED] = true,
	}end,
	DeclareFunctions = function(self) return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}end,	
})

function modifier_rasta_serpent_ward:OnAttackLanded( params )
    if IsServer() then
        local parent = self:GetParent()
        local Target = params.target
        local Attacker = params.attacker
        local flDamage = params.original_damage
        

        if Attacker ~= nil and Attacker == parent and Target ~= nil and Ability == nil then
            local position = Target:GetAbsOrigin()
           	local ability = self:GetAbility()
          	local splash_radius = ability:GetSpecialValueFor("splash_radius")
            local splash_pct = ability:GetSpecialValueFor("splash_pct")
            local hData = {}
            hData.flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES

			local enemies = parent:FindEnemyUnitsInRadius(position, splash_radius, hData)
			print(#enemies)

			for _,enemy in ipairs(enemies) do
				if enemy ~= Target then
					local damage =  flDamage * splash_pct / 100 
	                DealDamage(parent, enemy, damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, ability)
            	end
			end               

        end
    end
    return 0
end
