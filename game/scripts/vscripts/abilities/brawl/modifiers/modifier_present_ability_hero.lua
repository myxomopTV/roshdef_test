modifier_present_ability_hero = class({
	IsPurgable = function() return false end,
	IsPurgeException = function() return false end,
	IsHidden = function() return true end,
})

function modifier_present_ability_hero:CheckState() 
	return {
		[MODIFIER_STATE_INVISIBLE] = false
	}
end

function modifier_present_ability_hero:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

if IsServer() then
	function modifier_present_ability_hero:OnCreated()
		self:StartIntervalThink(0.1)
		self.currentBreakDistance = 0
		self.breakDistanceResetTime = 0
		self.oldPosition = self:GetParent():GetOrigin()
	end
	function modifier_present_ability_hero:OnDestroy()
		local playerID = self:GetParent():GetPlayerOwnerID()
		PLAYERS_DATA[playerID].presentBreakDistance = 0
		CustomNetTables:SetTableValue("player_data", tostring(playerID), PLAYERS_DATA[playerID])
	end
	function modifier_present_ability_hero:OnIntervalThink()
		local presentsCount = #self:GetParent().presents
		if presentsCount <= 0 then
			self:Destroy()
		else
			self:SetStackCount(presentsCount)

			local redPresents = 0
			local greenPresents = 0
			local bluePresents = 0
			for _,present in pairs(self:GetParent().presents) do
				if present.isRed then
					redPresents = redPresents + 1
				end
				if present.isGreen then
					greenPresents = greenPresents + 1
				end
				if present.isBlue then
					bluePresents = bluePresents + 1
				end
			end

			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_present_ability_red", {duration = 0.15})
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_present_ability_green", {duration = 0.15})
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_present_ability_blue", {duration = 0.15})
			local redModifier = self:GetParent():FindModifierByName("modifier_present_ability_red")
			local greenModifier = self:GetParent():FindModifierByName("modifier_present_ability_green")
			local blueModifier = self:GetParent():FindModifierByName("modifier_present_ability_blue")
			redModifier:SetStackCount(redPresents)
			greenModifier:SetStackCount(greenPresents)
			blueModifier:SetStackCount(bluePresents)

			local breakLength = (self.oldPosition - self:GetParent():GetOrigin()):Length2D()

			self.currentBreakDistance = math.floor(self.currentBreakDistance + breakLength)

			self.oldPosition = self:GetParent():GetOrigin()

			self.currentBreakDistance = self.currentBreakDistance - 30

			if self.currentBreakDistance < 0 then
				self.currentBreakDistance = 0
			elseif self.currentBreakDistance > PRESENT_BREAK_DISTANCE then
				self.currentBreakDistance = 1000
			end

			-- if self.breakDistanceResetTime >= 1 then
			-- 	self.currentBreakDistance = 0
			-- 	self.breakDistanceResetTime = 0
			-- else
			-- 	self.breakDistanceResetTime = self.breakDistanceResetTime + 0.1
			-- end

			local playerID = self:GetParent():GetPlayerOwnerID()

			PLAYERS_DATA[playerID].presentBreakDistance = self.currentBreakDistance

			CustomNetTables:SetTableValue("player_data", tostring(playerID), PLAYERS_DATA[playerID])
		end

		-- Give all presents to shopkeeper
		local isInMainDeliveryTrigger = false
		local isInSecretDeliveryTrigger = false
		local DeliveryTrigger_Main = Entities:FindByName(nil, "DeliveryTrigger_Main")
		local DeliveryTrigger_Secret = Entities:FindAllByName("DeliveryTrigger_Secret")
		if DeliveryTrigger_Main:IsTouching(self:GetParent()) then
			isInMainDeliveryTrigger = true
		end
		for _,deliveryTrigger in pairs(DeliveryTrigger_Secret) do
			if deliveryTrigger ~= nil and deliveryTrigger:IsTouching(self:GetParent()) then
				isInSecretDeliveryTrigger = true
			end
		end

		if isInMainDeliveryTrigger then
			for i = 1, #self:GetParent().presents do
				local present = self:GetParent().presents[#self:GetParent().presents]
				Timers:CreateTimer(0.1*(i-1), function()
					if present ~= nil and not present:IsNull() and self and not self:IsNull() and self:GetParent() ~= nil and not self:GetParent():IsNull() then
						local presentOrigin = present:GetOrigin()

						local fireworkFX = ParticleManager:CreateParticle("particles/generic_gameplay/present_firework.vpcf", PATTACH_WORLDORIGIN, nil)
						ParticleManager:SetParticleControl(fireworkFX, 0, presentOrigin)
						ParticleManager:SetParticleControl(fireworkFX, 1, presentOrigin)
						ParticleManager:SetParticleControl(fireworkFX, 3, presentOrigin)
						ParticleManager:ReleaseParticleIndex(fireworkFX)

						EmitSoundOnLocationWithCaster(presentOrigin, "ParticleDriven.Rocket.Launch", nil)
						Timers:CreateTimer(2.25, function() EmitSoundOnLocationWithCaster(presentOrigin, "ParticleDriven.Rocket.Explode", nil) end)

						local particle = "particles/generic_gameplay/red_present_proj.vpcf"
						if present.isRed then particle = "particles/generic_gameplay/red_present_proj.vpcf" end
						if present.isGreen then particle = "particles/generic_gameplay/green_present_proj.vpcf" end
						if present.isBlue then particle = "particles/generic_gameplay/blue_present_proj.vpcf" end
						
						for i = 1, 30 do
							local presentProp = Entities:FindByName(nil, "Present_"..i)
							if presentProp.Showed == false then
								presentProp:SetModel(present:GetModelName())
								presentProp.Showed = true
								break
							end
						end

						ProjectileManager:CreateTrackingProjectile({
							Target = MAP_BORDER_DUMMY,
							Source = present,
							Ability = self:GetAbility(),
							EffectName = particle,
							bDodgeable = false,
							bProvidesVision = false,
							iMoveSpeed = 600,
							iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
						})

						local presentType = "none"
						if present.isRed then presentType = "red" end
						if present.isGreen then presentType = "green" end
						if present.isBlue then presentType = "blue" end

						present.isInShop = true
						present:RemoveModifierByName("modifier_present_ability_present")
						UTIL_Remove(present)

						local bonusGold = 500
						local bonusXP = 500
						self:GetParent():ModifyGold(bonusGold, true, DOTA_ModifyGold_Unspecified)
						self:GetParent():AddExperience(bonusXP, DOTA_ModifyXP_Unspecified, false, true)
						SendOverheadEventMessage(self:GetParent():GetPlayerOwner(), OVERHEAD_ALERT_GOLD, self:GetParent(), bonusGold, nil)
						EmitSoundOnClient("General.Coins", self:GetParent():GetPlayerOwner())

						if self:GetParent():HasAbility("alchemist_goblins_greed_frostivus") then
							local goblins_greed = self:GetParent():FindAbilityByName("alchemist_goblins_greed_frostivus")
							if goblins_greed then
								goblins_greed:OnPresentDelivered()
							end
						end

						TEAM_POINTS[self:GetParent():GetTeamNumber()].count = TEAM_POINTS[self:GetParent():GetTeamNumber()].count + 1
						TEAM_POINTS[self:GetParent():GetTeamNumber()].present = presentType

						CustomNetTables:SetTableValue("main", "points", TEAM_POINTS)

						if TEAM_POINTS[self:GetParent():GetTeamNumber()].count >= POINTS_TO_WIN then
							GameRules:SetSafeToLeave(true)
							GameRules:SetGameWinner(self:GetParent():GetTeamNumber())
						end

						if TEAM_POINTS[self:GetParent():GetTeamNumber()].soundCooldown + 5.0 <= GameRules:GetGameTime() then
							EmitGlobalSound("Frostivus.PresentReceive")
							TEAM_POINTS[self:GetParent():GetTeamNumber()].soundCooldown = GameRules:GetGameTime()
						end
					end
				end)
			end
		elseif isInSecretDeliveryTrigger then
			for i = 1, #self:GetParent().presents do
				local present = self:GetParent().presents[#self:GetParent().presents]
				Timers:CreateTimer(0.1*i, function()
					if present ~= nil and not present:IsNull() and self and not self:IsNull() and self:GetParent() ~= nil and not self:GetParent():IsNull() then
						local presentOrigin = present:GetOrigin()

						local fireworkFX = ParticleManager:CreateParticle("particles/generic_gameplay/present_firework.vpcf", PATTACH_WORLDORIGIN, nil)
						ParticleManager:SetParticleControl(fireworkFX, 0, presentOrigin)
						ParticleManager:SetParticleControl(fireworkFX, 1, presentOrigin)
						ParticleManager:SetParticleControl(fireworkFX, 3, presentOrigin)
						ParticleManager:ReleaseParticleIndex(fireworkFX)

						EmitSoundOnLocationWithCaster(presentOrigin, "ParticleDriven.Rocket.Launch", nil)
						Timers:CreateTimer(2.25, function() EmitSoundOnLocationWithCaster(presentOrigin, "ParticleDriven.Rocket.Explode", nil) end)

						local presentType = "none"
						if present.isRed then presentType = "red" end
						if present.isGreen then presentType = "green" end
						if present.isBlue then presentType = "blue" end

						present.isInShop = true
						present:RemoveModifierByName("modifier_present_ability_present")
						UTIL_Remove(present)

						local bonusGold = 200 -- 40%
						local bonusXP = 200 -- 40%
						self:GetParent():ModifyGold(bonusGold, true, DOTA_ModifyGold_Unspecified)
						self:GetParent():AddExperience(bonusXP, DOTA_ModifyXP_Unspecified, false, true)
						SendOverheadEventMessage(self:GetParent():GetPlayerOwner(), OVERHEAD_ALERT_GOLD, self:GetParent(), bonusGold, nil)
						EmitSoundOnClient("General.Coins", self:GetParent():GetPlayerOwner())

						if self:GetParent():HasAbility("alchemist_goblins_greed_frostivus") then
							local goblins_greed = self:GetParent():FindAbilityByName("alchemist_goblins_greed_frostivus")
							if goblins_greed then
								goblins_greed:OnPresentDelivered()
							end
						end

						TEAM_POINTS[self:GetParent():GetTeamNumber()].count = TEAM_POINTS[self:GetParent():GetTeamNumber()].count + 1
						TEAM_POINTS[self:GetParent():GetTeamNumber()].present = presentType

						CustomNetTables:SetTableValue("main", "points", TEAM_POINTS)

						if TEAM_POINTS[self:GetParent():GetTeamNumber()].count >= POINTS_TO_WIN then
							GameRules:SetSafeToLeave(true)
							GameRules:SetGameWinner(self:GetParent():GetTeamNumber())
						end

						if TEAM_POINTS[self:GetParent():GetTeamNumber()].soundCooldown + 5.0 <= GameRules:GetGameTime() then
							EmitSoundOnLocationForAllies(self:GetParent():GetOrigin(), "Frostivus.PresentReceive", self:GetParent())
							TEAM_POINTS[self:GetParent():GetTeamNumber()].soundCooldown = GameRules:GetGameTime()
						end
					end
				end)
			end
		end
	end
end