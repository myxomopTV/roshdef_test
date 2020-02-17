
event_exit = class({})

function event_exit:OnSpellStart()
	local caster = self:GetCaster()

	caster:ForceKill(false)
end
