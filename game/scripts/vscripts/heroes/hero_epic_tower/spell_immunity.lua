LinkLuaModifier("modifier_epic_tower_spell_immunity", "heroes/hero_epic_tower/spell_immunity", LUA_MODIFIER_MOTION_NONE)

epic_tower_spell_immunity = class({})

function epic_tower_spell_immunity:GetIntrinsicModifierName()
	return "modifier_epic_tower_spell_immunity"
end	

modifier_epic_tower_spell_immunity = class ({
	IsHidden = function(self) return true end,	
})
function modifier_epic_tower_spell_immunity:CheckState()
    local state = {}
    state[MODIFIER_STATE_MAGIC_IMMUNE] = true

    if self:GetCaster():HasModifier("modifier_epic_tower_construct") then
        return state
    else
    	return
    end
end



