LinkLuaModifier("modifier_plague_wagon_speed", "abilities/plague_wagon_speed", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_plague_wagon_speed_timer", "abilities/plague_wagon_speed", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_plague_wagon_speed_nitro", "abilities/plague_wagon_speed", LUA_MODIFIER_MOTION_NONE)

plague_wagon_speed = class({})

function plague_wagon_speed:OnSpellStart()
	local caster = self:GetCaster()
	local prepare_time = self:GetSpecialValueFor("prepare_time")
	self.nitro_prepare = true
	caster:AddNewModifier(caster, self, "modifier_plague_wagon_speed_timer", {duration = prepare_time} )

	EmitSoundOn("sonic_race", caster)
end

function plague_wagon_speed:GetIntrinsicModifierName()
	return "modifier_plague_wagon_speed"
end


modifier_plague_wagon_speed = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
			MODIFIER_PROPERTY_MOVESPEED_MAX,
		} end,
})

function modifier_plague_wagon_speed:OnCreated(data)
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local interval = ability:GetSpecialValueFor("interval")
	self.ms_grow = ability:GetSpecialValueFor("ms_grow")
	ability.nitro_prepare = false
	
	caster:AddNewModifier(caster, ability, "modifier_phased", nil)
	caster:AddNewModifier(caster, ability, "modifier_bloodseeker_thirst", nil)
	self:StartIntervalThink(interval)
		
end
function modifier_plague_wagon_speed:OnIntervalThink()
	self:IncrementStackCount()
	EmitSoundOn("sonic_minirace", self:GetCaster())
	
end	
function modifier_plague_wagon_speed:GetModifierMoveSpeedBonus_Percentage()
	local ability = self:GetAbility()
	if ability.nitro_prepare == true then 
	return 0 end
	return self:GetStackCount()*self.ms_grow
end
modifier_plague_wagon_speed_timer = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
			MODIFIER_PROPERTY_MOVESPEED_MAX,
		} end,
})

function modifier_plague_wagon_speed_timer:OnCreated(data)
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local prepare_time = ability:GetSpecialValueFor("prepare_time")
		self.timer = prepare_time + 0.5

		self:StartIntervalThink(0.5)
	end	
end

function modifier_plague_wagon_speed_timer:OnRefresh(data)
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local prepare_time = ability:GetSpecialValueFor("prepare_time")
		self.timer = prepare_time + 0.5

		self:StartIntervalThink(0.5)
	end	
end

function modifier_plague_wagon_speed_timer:OnDestroy(data)
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	StopSoundOn("sonic_race",self:GetCaster())
	caster:AddNewModifier(caster, ability, "modifier_plague_wagon_speed_nitro", nil )	
end

function modifier_plague_wagon_speed_timer:OnIntervalThink()
	self.timer = self.timer - 0.5

	local caster = self:GetCaster()
	local preSymbol = 0 -- Empty
	local digits = 2 -- "5.0" takes 2 digits
--	local number = GameRules:GetGameTime() - ability.brew_start - brew_explosion - 0.1 --the minus .1 is needed because think interval comes a frame earlier

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
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_OVERHEAD_FOLLOW, caster)
	ParticleManager:SetParticleControl( pfx, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( pfx, 1, Vector( preSymbol, integer, decimal) )
	ParticleManager:SetParticleControl( pfx, 2, Vector( digits, 0, 0) )

end	


modifier_plague_wagon_speed_nitro = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,		} end,
})
function modifier_plague_wagon_speed_nitro:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("nitro_speed")
end