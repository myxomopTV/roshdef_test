LinkLuaModifier("modifier_charges", "modifiers/modifier_charges", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_shapeshift_speed_lua", "/modifiers/modifier_shapeshift_speed_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chen_buff1", "/modifiers/modifier_chen_buff1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demon_lord_buff", "/modifiers/modifier_demon_lord_buff.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lich_lord_debuff", "/modifiers/modifier_lich_lord_debuff.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_necro_lord_debuff", "/modifiers/modifier_necro_lord_debuff.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_bonus_effect_green", "/modifiers/special/modifier_special_effect", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bonus_effect_blue", "/modifiers/special/modifier_special_effect", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bonus_effect_pink", "/modifiers/special/modifier_special_effect", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bonus_tier_divine", "/modifiers/special/modifier_special_effect", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bonus_tier_legendary", "/modifiers/special/modifier_special_effect", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_effect_contest", "/modifiers/special/modifier_special_effect_contest.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_effect_donator", "/modifiers/special/modifier_special_effect_donator.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_effect_legendary", "/modifiers/special/modifier_special_effect_legendary.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_effect_divine", "/modifiers/special/modifier_special_effect_divine.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_effect_mark", "/modifiers/special/modifier_special_effect_mark.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_turbomode_bonus", "/modifiers/special/modifier_turbomode_bonus.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_your_armor", "/modifiers/special/modifier_your_armor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_race_buff", "/modifiers/special/modifier_race_buff.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("tome_strenght_modifier", "/items/item_bonus_stat.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("tome_agility_modifier", "/items/item_bonus_stat.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("tome_intelect_modifier", "/items/item_bonus_stat.lua", LUA_MODIFIER_MOTION_NONE)

for _,file in ipairs({

    'libraries/timers',
    'libraries/utility',
    'libraries/notifications',
    'libraries/popup',
    'libraries/containers',
    'libraries/pathgraph',

    'internal/util',
    'internal/funcs',
	
--    'libraries/chatcommands',

}) do
    --print("Requiring ", file)
    require(file)
end
