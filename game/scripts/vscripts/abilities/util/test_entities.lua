
test_entities = class({})

function test_entities:OnSpellStart()

	local savedEntities = {}--savedEntities or {}
	local current = Entities:First()
	local newEntities = {}
	local index = 0
	while current do
		local classname = current:GetClassname()

		savedEntities[classname] = savedEntities[classname] and savedEntities[classname] + 1 or 1
		savedEntities["total_enities"] = savedEntities["total_enities"] and savedEntities["total_enities"] + 1 or 1
		current = Entities:Next(current)
	end
	DeepPrintTable( savedEntities )
	print("total entities = "..savedEntities["total_enities"])

end
