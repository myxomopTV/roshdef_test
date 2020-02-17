local RandomOrder = {1,2,3,4,5,6,7,8,9}
local Chickens = {}
current_state = 0
number_of_games = 0

for i=1,9 do
	print("RandomOrder["..i.."] = ".. RandomOrder[i])
end

print("Shuffle RandomOrder")
for i=1,9 do
	local temp = RandomOrder[i]
	local random_int = math.random(1,9)
	RandomOrder[i] = RandomOrder[random_int]
	RandomOrder[random_int] = temp
	print("RandomOrder["..i.."] = ".. random_int)
end

for i=1,9 do
	print("RandomOrder["..i.."] = ".. RandomOrder[i])
end

function StartGame( keys )	
	if current_state > 0 then
		return
	end
	local caster = keys.caster	
	local target = keys.target
	local player = target:GetPlayerOwnerID()
	local ability = keys.ability
	local gold_cost = ability:GetSpecialValueFor("gold_cost")
	local gold_cost_max = ability:GetSpecialValueFor("gold_cost_max")
	local current_gold_cost = number_of_games * gold_cost < gold_cost_max and number_of_games * gold_cost or gold_cost_max
	local player_gold = PlayerResource:GetGold(player)
	local player_reliable_gold = PlayerResource:GetReliableGold(player)

--	caster:StartGesture( ACT_DOTA_TAUNT)
	caster:StartGestureWithPlaybackRate( ACT_DOTA_TAUNT, 0.5 )
	EmitSoundOn("ChickenTaunt",caster)
--	EmitSoundOn("Hero_SkywrathMage.ChickenTaunt",caster)
			
	if player_gold < current_gold_cost then
		return
	end
	
	if player_reliable_gold < current_gold_cost then
		PlayerResource:ModifyGold(player, -player_reliable_gold, true, 0)
		PlayerResource:ModifyGold(player, player_reliable_gold - current_gold_cost, false, 0)
	else
		PlayerResource:ModifyGold(player, -current_gold_cost, true, 0)
	end	
	SendOverheadEventMessage( target, OVERHEAD_ALERT_GOLD, target, current_gold_cost, nil )

	for i=1,9 do
		local unit_name = "npc_dota_secret_chicken"--..RandomOrder[i]
		local point = Entities:FindByName( nil, "chicken_point"..i):GetAbsOrigin()
		local chicken = CreateUnitByName(unit_name, point, true, nil, nil, DOTA_TEAM_NEUTRALS)
		Chickens[RandomOrder[i]] = chicken
	end
	
	number_of_games = number_of_games + 1
	current_state = 1
end

function test( keys )
	
	local caster = keys.caster	
	caster:StartGesture( ACT_DOTA_TAUNT )
	EmitGlobalSound("ChickenTaunt")

end

function ChickenKill( keys )
	local caster = keys.caster
	local unit_name = caster:GetUnitName()
	
	if caster == Chickens[current_state] then
		local particle = "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"
		local particleIndex = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, Chickens[current_state])
		EmitSoundOnLocationWithCaster(Chickens[current_state]:GetAbsOrigin(), "Hero_Omniknight.Purification" ,Chickens[j])

		Chickens[current_state]:RemoveSelf()
		current_state = current_state + 1
		if current_state == 10 then
			for k=1,9 do
				EmitGlobalSound("Item.PickUpGemWorld")
				local point = Entities:FindByName( nil, "chicken_point"..k):GetAbsOrigin()
				local item_name = "item_chicken_coin"
				if k == 5 then
					item_name = "item_chicken_king_staff"
				end
				
				local newItem = CreateItem( item_name, nil, nil )
				CreateItemOnPositionSync( point, newItem )
			end
		end
	else 
		for j=1,9 do
			if Chickens[j] and IsValidEntity(Chickens[j]) and Chickens[j]:IsAlive() then
				local particle = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf"
				local particleIndex = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, Chickens[j])
				EmitSoundOnLocationWithCaster(Chickens[j]:GetAbsOrigin(), "Hero_Nevermore.Shadowraze" ,Chickens[j])
				Chickens[j]:RemoveSelf()
			end			
		end
		Chickens = {}
		current_state = 0
	end
	
end

if modifier_chicken_taunt == nil then modifier_chicken_taunt = class({}) end
function modifier_chicken_taunt:IsHidden() return true end
function modifier_chicken_taunt:IsDebuff() return false end
function modifier_chicken_taunt:IsPurgable() return false end

function modifier_chicken_taunt:DeclareFunctions()
    local funcs =
    {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
    return funcs
end
 
 
function modifier_chicken_taunt:GetOverrideAnimationRate( params )
    return 1.00
end
 
function modifier_chicken_taunt:GetActivityTranslationModifiers( params )
        return "chicken_gesture"
end
 
function modifier_chicken_taunt:GetOverrideAnimation( params )
        return ACT_DOTA_TAUNT_STATUE
end