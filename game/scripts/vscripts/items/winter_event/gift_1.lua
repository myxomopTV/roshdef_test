item_event_gift_1 = class({})

function item_event_gift_1:OnSpellStart()
	GiveGoldPlayers(2500)
	local caster = self:GetCaster()
	EmitGlobalSound("event_gift")
end