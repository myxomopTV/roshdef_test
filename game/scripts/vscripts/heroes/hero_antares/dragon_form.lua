
LinkLuaModifier( "modifier_antares_dragon_form", "heroes/hero_antares/dragon_form", LUA_MODIFIER_MOTION_NONE )

antares_dragon_form = class({})

-- this makes the ability passive when it has scepter
function antares_dragon_form:GetBehavior()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_item_special_antares") or caster:HasModifier("modifier_item_special_antares_upgrade_1") or caster:HasModifier("modifier_item_special_antares_upgrade_2") or caster:HasModifier("modifier_item_special_antares_upgrade_3") or caster:HasModifier("modifier_item_special_antares_upgrade_4")  then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end

	return self.BaseClass.GetBehavior( self )
end

function antares_dragon_form:OnSpellStart()
	local caster = self:GetCaster()
	local form_duration = self:GetSpecialValueFor("form_duration")

	caster:AddNewModifier(caster, self, "modifier_antares_dragon_form", {duration = form_duration})
end

modifier_antares_dragon_form = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self) return 
        {           
            MODIFIER_EVENT_ON_ATTACK_LANDED,
            MODIFIER_PROPERTY_MODEL_SCALE,
            MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
            MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
            MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
        } end,
})

function modifier_antares_dragon_form:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local model =  "models/heroes/dragon_knight/dragon_knight_dragon.vmdl"
		local projectile_model = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf"


		if caster:HasModifier("modifier_item_special_antares") or caster:HasModifier("modifier_item_special_antares_upgrade_1") or caster:HasModifier("modifier_item_special_antares_upgrade_2") or caster:HasModifier("modifier_item_special_antares_upgrade_3") or caster:HasModifier("modifier_item_special_antares_upgrade_4")  then
			caster:SetRenderColor(0, 0 , 0 )
			self:StartIntervalThink(0.1)
		else
			caster:SetRenderColor(255, 0 , 0 )
		end

		caster:EmitSound("Hero_DragonKnight.ElderDragonForm")
	  	local effect = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:ReleaseParticleIndex(pfx)

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

function modifier_antares_dragon_form:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()

		caster:SetRenderColor(255, 255 , 255 )
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

function modifier_antares_dragon_form:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		local team = caster:GetTeam()
		local point = caster:GetAbsOrigin()
		
		AddFOWViewer(team, point, 1300, 0.11, false)
	end
end

function modifier_antares_dragon_form:GetModifierAttackRangeBonus()
    return self:GetAbility():GetSpecialValueFor("attack_range_bonus")
end

function modifier_antares_dragon_form:GetModifierModelScale()
    return self:GetAbility():GetSpecialValueFor("model_scale")
end

function modifier_antares_dragon_form:GetModifierTotalDamageOutgoing_Percentage()
	local parent = self:GetParent()
	if parent:HasModifier("modifier_item_special_antares_upgrade_3") or parent:HasModifier("modifier_item_special_antares_upgrade_4") then
		return 50
	else
		return 0
	end	
end

function modifier_antares_dragon_form:GetModifierBaseAttackTimeConstant()
	local parent = self:GetParent()
	if parent:HasModifier("modifier_item_special_antares_upgrade_3") or parent:HasModifier("modifier_item_special_antares_upgrade_4") then
		return 0.75
	else
		return 0
	end	
end

function modifier_antares_dragon_form:GetEffectName()
	local parent = self:GetParent()
	if parent:HasModifier("modifier_item_special_antares_upgrade_4") then
		return "particles/item/black_queen_cape/black_king_bar_avatar.vpcf"
	else
		return 0
	end	
end

function modifier_antares_dragon_form:OnAttackLanded( params )
    if IsServer() then
        local caster = self:GetCaster()
        local Target = params.target
        local Attacker = params.attacker
        local flDamage = params.original_damage
        

        if Attacker ~= nil and Attacker == caster and Target ~= nil and Ability == nil then
            local position = Target:GetAbsOrigin()
           	local ability = self:GetAbility()
          	local splash_radius = ability:GetSpecialValueFor("splash_radius")
            local splash_pct = ability:GetSpecialValueFor("splash_pct")
            local hData = {}
            hData.flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES

			local enemies = caster:FindEnemyUnitsInRadius(position, splash_radius, hData)
			print(#enemies)

			for _,enemy in ipairs(enemies) do
				if enemy ~= Target then
					local damage =  flDamage * splash_pct / 100 
	                DealDamage(caster, enemy, damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, ability)
            	end
			end               

        end
    end
    return 0
end

function modifier_antares_dragon_form:CheckState()
	local parent = self:GetParent()
	local state = {}

	if parent:HasModifier("modifier_item_special_antares_upgrade_1") or parent:HasModifier("modifier_item_special_antares_upgrade_2") or parent:HasModifier("modifier_item_special_antares_upgrade_3") or parent:HasModifier("modifier_item_special_antares_upgrade_4")  then
		state[MODIFIER_STATE_FLYING] = true
--		state[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
	end

	if parent:HasModifier("modifier_item_special_antares_upgrade_4")  then
		state[MODIFIER_STATE_MAGIC_IMMUNE] = true
		state[MODIFIER_STATE_CANNOT_MISS] = true
	end

	return state
end

