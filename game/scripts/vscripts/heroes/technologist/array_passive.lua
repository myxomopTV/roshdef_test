if customability_technologist_array_passive == nil then
    customability_technologist_array_passive = class({})
end


LinkLuaModifier( "modifier_technologist_array", "heroes/technologist/modifiers/array.lua", LUA_MODIFIER_MOTION_NONE )

function customability_technologist_array_passive:GetIntrinsicModifierName()
    return "modifier_technologist_array"
end