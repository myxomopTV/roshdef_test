
function SpiritLink( event )
	local caster = event.caster
	local ability = event.ability
	local buff_duration = ability:GetSpecialValueFor("buff_duration")

	EmitSoundOn("Hero_LoneDruid.Rabid", caster)
	if caster.bear and caster.bear:IsAlive() then
		
		local effect = "particles/units/heroes/hero_lone_druid/lone_druid_spiritlink_cast.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(pfx, 1, caster.bear, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster.bear:GetAbsOrigin(), true)

		ability:ApplyDataDrivenModifier(caster, caster, "modifier_lone_druid_spirit_link_buff", {duration = buff_duration})
		ability:ApplyDataDrivenModifier(caster, caster.bear, "modifier_lone_druid_spirit_link_buff", {duration = buff_duration})
	end
end


