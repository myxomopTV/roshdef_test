item_epic_tower_closed_slot = class({})

function item_epic_tower_closed_slot:OnSpellStart()
	local caster = self:GetCaster()
	caster:RemoveItem(self)
end	

item_epic_tower_closed_slot_1 = class(item_epic_tower_closed_slot)
item_epic_tower_closed_slot_2 = class(item_epic_tower_closed_slot)
item_epic_tower_closed_slot_3 = class(item_epic_tower_closed_slot)
item_epic_tower_closed_slot_4 = class(item_epic_tower_closed_slot)
item_epic_tower_closed_slot_5 = class(item_epic_tower_closed_slot)
item_epic_tower_closed_slot_6 = class(item_epic_tower_closed_slot)
