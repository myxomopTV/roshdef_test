LinkLuaModifier("modifier_event_land_mine", "winter_event/event_land_mine", LUA_MODIFIER_MOTION_NONE)

event_land_mine = class({})

function event_land_mine:OnSpellStart()
	local caster = self:GetCaster()
	local point = caster:GetAbsOrigin()
	local team = caster:GetTeam()
	local caster_fw = caster:GetForwardVector()
	local delay = self:GetSpecialValueFor("delay")

	local mine = CreateUnitByName("npc_dota_event_land_mine", point, false, caster, caster, team)
	mine.event = true
	mine:AddNewModifier(caster, self, "modifier_event_land_mine", {duration = delay})
	mine:SetForwardVector(caster_fw)
	caster:EmitSound("Hero_Techies.LandMine.Plant")
end

modifier_event_land_mine = class({
	IsHidden = function(self) return end,
	CheckState = function(self) return {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}end,
	DeclareFunctions = function(self) return {
		MODIFIER_PROPERTY_MODEL_SCALE
	}end,
})

function modifier_event_land_mine:GetModifierModelScale()
	return self:GetAbility():GetSpecialValueFor("model_scale")	
end

function modifier_event_land_mine:OnCreated(data)
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		self.timer = ability:GetSpecialValueFor("delay") + 0.5

		self:StartIntervalThink(0.5)
		self:OnIntervalThink()
	end	
end

function modifier_event_land_mine:OnIntervalThink()
	self.timer = self.timer - 0.5

	local parent = self:GetParent()
	local preSymbol = 0 -- Empty
	local digits = 2 -- "5.0" takes 2 digits

	-- Get the integer. Add a bit because the think interval isn't a perfect 0.5 timer
	local integer = math.floor(math.abs(self.timer))

	-- Round the decimal number to .0 or .5
	local decimal = math.abs(self.timer) % 1

	if decimal < 0.5 then 
		decimal = 1 -- ".0"
	else 
		decimal = 8 -- ".5"
	end
--	print(integer,decimal)

	local effect = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_timer.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_OVERHEAD_FOLLOW, parent)
	ParticleManager:SetParticleControl( pfx, 0, parent:GetAbsOrigin() )
	ParticleManager:SetParticleControl( pfx, 1, Vector( preSymbol, integer, decimal) )
	ParticleManager:SetParticleControl( pfx, 2, Vector( digits, 0, 0) )

end	

function modifier_event_land_mine:OnDestroy()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local point = parent:GetAbsOrigin()
	local damage = ability:GetSpecialValueFor("damage")
	local radius = ability:GetSpecialValueFor("radius")

	local data = { flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES }
	local enemies = parent:FindAllUnitsInRadius( point, radius, data)

	for _,enemy in ipairs(enemies) do
		DealDamage(caster, enemy, damage, DAMAGE_TYPE_MAGICAL, nil, ability)
	end

	parent:EmitSound("Hero_Techies.LandMine.Detonate")
	local effect = "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, parent)
	ParticleManager:SetParticleControl(pfx, 0, point)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius,radius,radius))
	ParticleManager:ReleaseParticleIndex(pfx)
end
