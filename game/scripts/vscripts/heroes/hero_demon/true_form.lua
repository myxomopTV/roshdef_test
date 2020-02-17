LinkLuaModifier("modifier_demon_true_form", "heroes/hero_demon/true_form", LUA_MODIFIER_MOTION_NONE)

demon_true_form = class({})

function demon_true_form:OnSpellStart()
	local caster = self:GetCaster()
	local form_duration = self:GetSpecialValueFor("form_duration")

	caster:AddNewModifier(caster, self, "modifier_demon_true_form", {duration = form_duration})
end

--------------------------------------------------------
------------------------------------------------------------
modifier_demon_true_form = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{	MODIFIER_EVENT_ON_ATTACK_LANDED,
			MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		} end,
})

function modifier_demon_true_form:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local model =  "models/heroes/terrorblade/demon.vmdl"
		local projectile_model = "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf"

		-- Saves the original model and attack capability
		if caster.caster_model == nil then 
			caster.caster_model = caster:GetModelName()
		end
		caster.caster_attack = caster:GetAttackCapability()

		-- Sets the new model and projectile
		caster:SetOriginalModel(model)
		caster:SetRangedProjectileName(projectile_model)

		-- Sets the new attack type
		caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)

		caster.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
	    local model = caster:FirstMoveChild()
	    while model ~= nil do
	        if model:GetClassname() == "dota_item_wearable" then
	            model:AddEffects(EF_NODRAW) -- Set model hidden
	            table.insert(caster.hiddenWearables, model)
	        end
	        model = model:NextMovePeer()
	    end		
	end
end
function modifier_demon_true_form:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()

		caster:SetModel(caster.caster_model)
		caster:SetOriginalModel(caster.caster_model)
		caster:SetAttackCapability(caster.caster_attack)

		-- Sets the new attack type
		caster:SetAttackCapability(caster.caster_attack)

		for i,v in pairs(caster.hiddenWearables) do
			v:RemoveEffects(EF_NODRAW)
		end
	end
end

function modifier_demon_true_form:GetModifierAttackRangeBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_range")
end

function modifier_demon_true_form:OnAttackLanded( params )
    if IsServer() then
        local parent = self:GetParent()
        local Target = params.target
        local Attacker = params.attacker
        local Ability = params.inflictor
        local flDamage = params.original_damage
        

        if Attacker ~= nil and Attacker == parent and Target ~= nil and not Target:IsBuilding() and Ability == nil then
            local ability = self:GetAbility()
            local pure_dmg_pct = ability:GetSpecialValueFor("pure_dmg_pct")
            local damage =  flDamage * pure_dmg_pct / 100 
            DealDamage(Attacker, Target, damage, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATIONA, ability)                    
        

        end
    end
    return 0
end

