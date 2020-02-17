modifier_present_ability_present = class({
	IsPurgable = function() return false end,
	IsHidden = function() return true end,
})

function modifier_present_ability_present:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end

function modifier_present_ability_present:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_1
end

function modifier_present_ability_present:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

if IsServer() then
	function modifier_present_ability_present:OnCreated()
		local targetPresents = self:GetParent().presentTarget.presents
		local target = targetPresents[self:GetParent().presentsCount-1]
		if not target then target = self:GetParent().presentTarget end
		if target ~= nil then
			self.nFXIndex = ParticleManager:CreateParticle("particles/generic_gameplay/present_web.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			if not self:GetParent():IsPresent() then
				ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_attack1", target:GetOrigin(), true)
			else
				ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true)
			end
			ParticleManager:SetParticleControlEnt(self.nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true)
			self:AddParticle(self.nFXIndex, false, false, -1, false, false)

			self:GetParent():SetTeam(self:GetParent().presentTarget:GetTeam())
			self.newPresentCurrentTime = 0
			self:StartIntervalThink(FrameTime())

			CustomNetTables:SetTableValue("present_targets", tostring(self:GetParent():entindex()), {presentTarget = tostring(self:GetParent().presentTarget:entindex())})
		else
			self:Destroy()
		end
	end
	function modifier_present_ability_present:OnDestroy()
		if not self:GetParent().isInShop then
			self:GetParent():SetTeam(DOTA_TEAM_NEUTRALS)
			local presentIndex = table.findIndex(self:GetParent().presentTarget.presents, self:GetParent())[1]
			if presentIndex == #self:GetParent().presentTarget.presents then
				self:GetParent().presentsCount = self:GetParent().presentsCount - 1
			else
				for i = 1, #self:GetParent().presentTarget.presents do
					local present = self:GetParent().presentTarget.presents[i]
					if present ~= nil and not present:IsNull() and present ~= self:GetParent() then
						if i >= presentIndex then
							present:RemoveModifierByName("modifier_present_ability_present")
							present.presentsCount = present.presentsCount - 1
						end
					end
				end
			end
		end
		table.removeByValue(self:GetParent().presentTarget.presents, self:GetParent())
		self:GetParent().presentsCount = 0
		self:GetParent().presentTarget = nil
		self:GetParent():SetHealth(self:GetParent():GetMaxHealth())
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetOrigin(), false)
		self:StartIntervalThink(-1)
		CustomNetTables:SetTableValue("present_targets", tostring(self:GetParent():entindex()), {presentTarget = nil})
	end
	function modifier_present_ability_present:OnIntervalThink()
		if IsServer() then
			if self:GetParent().presentTarget and not self:GetParent().isInShop then
				local targetPresents = self:GetParent().presentTarget.presents
				local mainTarget = self:GetParent().presentTarget
				local target = targetPresents[self:GetParent().presentsCount-1]
				if not target then target = self:GetParent().presentTarget end
				if target == nil then self:Destroy() return end

				local mainTargetPresentModifier = mainTarget:FindModifierByName("modifier_present_ability_hero")
				local breakDistance = 0
				if mainTargetPresentModifier then
					breakDistance = mainTargetPresentModifier.currentBreakDistance
				end
				local breakDistanceInstant = PRESENT_BREAK_DISTANCE/3
				if self:GetParent().isNewPresent then
					breakDistanceInstant = 600
					self:GetParent().isNewPresent = false
				end
				if not self:GetParent().isNewPresent and ((target:GetOrigin() - self:GetParent():GetOrigin()):Length2D() >= breakDistanceInstant or breakDistance >= PRESENT_BREAK_DISTANCE) then
					EmitSoundOnClient("Frostivus.PresentRopeBreak", mainTarget:GetPlayerOwner())
					self:Destroy()
				else
					if (target:GetOrigin() - self:GetParent():GetOrigin()):Length2D() >= 100 then
						local cx = target:GetOrigin().x
						local cy = target:GetOrigin().y
						local nx = self:GetParent():GetOrigin().x - cx
						local ny = self:GetParent():GetOrigin().y - cy
						local magV = math.sqrt(math.pow(nx,2) + math.pow(ny, 2))
						nx = cx + nx / magV * 100
						ny = cy + ny / magV * 100
						local newPos = Vector(nx,ny,0)
						newPos = Vector(nx,ny,GetGroundHeight(newPos, nil))
						self:GetParent():SetOrigin(newPos)
					end
				end
				if not self:GetParent():IsPresent() then
					ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_attack1", target:GetOrigin(), true)
				else
					ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true)
				end
				ParticleManager:SetParticleControlEnt(self.nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true)
			end
			if not self:GetParent().presentTarget or self:GetParent().presentTarget:IsNull() or not self:GetParent().presentTarget:IsAlive() then
				self:Destroy()
			end
		end
	end
end