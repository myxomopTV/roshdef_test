modifier_present_ability_present_greevil = class({
	IsPurgable = function() return false end,
	IsHidden = function() return true end,
})

function modifier_present_ability_present_greevil:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
	}
end

function modifier_present_ability_present_greevil:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_1
end

function modifier_present_ability_present_greevil:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_present_ability_present_greevil:CheckState()
	return {
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		[MODIFIER_STATE_INVULNERABLE] = true
	}
end

if IsServer() then
	function modifier_present_ability_present_greevil:OnCreated()
		local targetPresents = self:GetParent().presentTarget.presents
		local target = targetPresents[self:GetParent().presentsCount-1]
		if not target then target = self:GetParent().presentTarget end
		if target ~= nil then
			self.nFXIndex = ParticleManager:CreateParticle("particles/generic_gameplay/present_web.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			if not self:GetParent():IsPresent() then
				ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_attack2", target:GetOrigin(), true)
			else
				ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true)
			end
			ParticleManager:SetParticleControlEnt(self.nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true)
			self:AddParticle(self.nFXIndex, false, false, -1, false, false)

			self:GetParent():SetTeam(self:GetParent().presentTarget:GetTeam())
			self.newPresentCurrentTime = 0
			self:StartIntervalThink(FrameTime())
		else
			self:Destroy()
		end
	end
	function modifier_present_ability_present_greevil:OnDestroy()
		local presentIndex = table.findIndex(self:GetParent().presentTarget.presents, self:GetParent())[1]
		if presentIndex == #self:GetParent().presentTarget.presents then
			self:GetParent().presentsCount = self:GetParent().presentsCount - 1
		else
			for i = 1, #self:GetParent().presentTarget.presents do
				local present = self:GetParent().presentTarget.presents[i]
				if present ~= nil and not present:IsNull() and present ~= self:GetParent() then
					if i >= presentIndex then
						present:RemoveModifierByName("modifier_present_ability_present_greevil")
						present.presentsCount = present.presentsCount - 1
					end
				end
			end
		end
		table.removeByValue(self:GetParent().presentTarget.presents, self:GetParent())
		self:GetParent().presentsCount = 0
		self:GetParent().presentTarget = nil
		self:GetParent():SetHealth(self:GetParent():GetMaxHealth())
		self:StartIntervalThink(-1)
	end
	function modifier_present_ability_present_greevil:OnIntervalThink()
		if IsServer() then
			if self:GetParent().presentTarget then
				local targetPresents = self:GetParent().presentTarget.presents
				local target = targetPresents[self:GetParent().presentsCount-1]
				if not target then target = self:GetParent().presentTarget end
				if target == nil then self:Destroy() return end

				if (target:GetOrigin() - self:GetParent():GetOrigin()):Length2D() >= 150 then
					local cx = target:GetOrigin().x
					local cy = target:GetOrigin().y
					local cz = target:GetOrigin().z
					local nx = self:GetParent():GetOrigin().x - cx
					local ny = self:GetParent():GetOrigin().y - cy
					local nz = self:GetParent():GetOrigin().z - cz
					local magV = math.sqrt(math.pow(nx,2) + math.pow(ny, 2) + math.pow(nz, 2))
					nx = cx + nx / magV * 150
					ny = cy + ny / magV * 150
					nz = cz + nz / magV * 150
					local newPos = Vector(nx,ny,nz)
					newPos = Vector(nx,ny,0)
					FindClearSpaceForUnit(self:GetParent(), newPos, false)
					if GetGroundHeight(target:GetOrigin(), nil) == target:GetOrigin().z then
						nz = 0
					end
					self:GetParent():SetOrigin(self:GetParent():GetOrigin() + Vector(0,0,nz))
				end

				if not self:GetParent():IsPresent() then
					ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_attack2", target:GetOrigin(), true)
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
	function modifier_present_ability_present_greevil:GetModifierProvidesFOWVision()
		if ROSHAN_SPAWNED then
			return 0
		end 
		return 1
	end
end