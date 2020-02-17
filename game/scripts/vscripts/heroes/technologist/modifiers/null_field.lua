if modifier_technologist_null_field == nil then
    modifier_technologist_null_field = class({})
end

function modifier_technologist_null_field:GetTexture()
    return "abyssal_underlord_dark_rift"
end

function modifier_technologist_null_field:IsDebuff()
    return true
end

function modifier_technologist_null_field:IsHidden()
    return false
end

function modifier_technologist_null_field:DestroyOnExpire()
    return true
end

function modifier_technologist_null_field:OnCreated( event )
    
    if not IsServer() then return end

end

function modifier_technologist_null_field:CheckState()
    local state = {
        [MODIFIER_STATE_SILENCED] = true,
    }
    return state
end
