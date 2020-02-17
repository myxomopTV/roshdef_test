if customability_energy_system == nil then
    customability_energy_system = class({})
end


LinkLuaModifier( "modifier_technologist_energy", "heroes/technologist/modifiers/energy_system.lua", LUA_MODIFIER_MOTION_NONE )

function customability_energy_system:GetIntrinsicModifierName()
    return "modifier_technologist_energy"
end