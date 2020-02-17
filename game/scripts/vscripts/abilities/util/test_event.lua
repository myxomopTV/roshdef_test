
test_event = class({})

function test_event:OnSpellStart()
	FrostEvent:EndRound()
	FrostEvent.event_level = FrostEvent.event_level + 1
end
