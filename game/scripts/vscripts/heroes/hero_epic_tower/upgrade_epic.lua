
epic_tower_upgrade_epic = class({})

function epic_tower_upgrade_epic:OnUpgrade()
	if not self.upgrade then
		self.upgrade = 0
	end
	self:SetActivated(true)
end

function epic_tower_upgrade_epic:OnSpellStart()
	local caster = self:GetCaster()

	self.upgrade = self.upgrade + 1
    local construct_ability = caster:FindAbilityByName("epic_tower_construct_build")
    construct_ability:SetLevel(self.upgrade+1)

	if self.upgrade == self:GetLevel() then
		self:SetActivated(false)
	end
end	




