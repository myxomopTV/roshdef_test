LinkLuaModifier( "modifier_witch_doctor_music", "abilities/wd_music.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable

music_enum = {
--	{ name = "wrath_music", duration = 27},
	{ name = "fly_mach", duration = 41},
	{ name = "jojo_op_1", duration = 58},
	{ name = "jojo_op_2", duration = 54},
	{ name = "igor_doroga1", duration = 26},
	{ name = "igor_doroga2", duration = 25},
	{ name = "igor_doroga3", duration = 30},
	{ name = "igor_doroga4", duration = 26},	
	{ name = "gluttony_music", duration = 32},
	{ name = "envy_music", duration = 25},
	{ name = "pride_music", duration = 43},
	{ name = "greed_music", duration = 32},
	{ name = "lust_music", duration = 25},
	{ name = "sloth_music", duration = 41},
	{ name = "Roshan_def.wd_dance", duration = 8},
	{ name = "dyadya_vova1", duration = 51},
	{ name = "dyadya_vova2", duration = 38},
	{ name = "dyadya_vova3", duration = 43},
	{ name = "stalker_bandit", duration = 43},
	{ name = "spulae_mulae", duration = 36},
	{ name = "glad_valakas", duration = 28},
	{ name = "undertale", duration = 19},
	{ name = "pivko", duration = 24},
	{ name = "totoro_theme", duration = 31},
}

function WDMusicStart1(keys)
	local caster = keys.caster
	caster.sound = true
	caster.sound_num = 0
	caster.sound_on = true
	
	Timers:CreateTimer(0.1,function()
		if caster.sound == false then
			return
		elseif caster.sound_on == false then
			return 1
		end
--		caster.sound_num = caster.sound_num + 1
--		caster.music = caster.sound_num%3+1
		caster.music = RandomInt(1,#music_enum)
		print(caster.music)
		print("music_name = "..music_enum[caster.music].name.." music_duraton = "..music_enum[caster.music].duration)
		EmitSoundOn(music_enum[caster.music].name,caster)
		
		 
		return music_enum[caster.music].duration

	end)
	caster.timer = timer
end

function WDMusicStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	caster.sound = true
	caster.sound_on = true
	
	local music_number = RandomInt(1,#music_enum)
	local music_duration = music_enum[music_number].duration
	local music_name = music_enum[music_number].name
	caster:AddNewModifier(caster, ability, "modifier_witch_doctor_music", {duration = music_duration, music_name = music_name})
	print("music name = "..music_name)
end
function WDMusicStop(keys)
	local caster = keys.caster
	caster.sound = false
	StopSoundOn(music_enum[caster.music].name, caster)
	for i=1,#music_enum do
		StopSoundOn(music_enum[i].name, caster)
	end	
end


function WDSoundOn(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	if caster.sound_on == true then
		caster.sound_on = false
		caster:RemoveModifierByName("modifier_witch_doctor_music")
		caster:RemoveModifierByName("modifier_wd_music")
	else
		caster.sound_on = true
		local music_number = RandomInt(1,#music_enum)
		local music_duration = music_enum[music_number].duration
		local music_name = music_enum[music_number].name
		caster:AddNewModifier(caster, ability, "modifier_witch_doctor_music", {duration = music_duration, music_name = music_name})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_wd_music", nil)
 	end
end

modifier_witch_doctor_music = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
})
function modifier_witch_doctor_music:OnCreated(keys)
	local caster = self:GetCaster()
	self.music_name = keys.music_name

	EmitSoundOn(self.music_name, caster)
end

function modifier_witch_doctor_music:OnDestroy()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local music_name = self.music_name
	StopSoundOn(music_name, caster)
	
	if caster.sound_on == true then		
		local music_number = RandomInt(1,#music_enum)
		local music_duration = music_enum[music_number].duration
		local music_name = music_enum[music_number].name
		caster:AddNewModifier(caster, ability, "modifier_witch_doctor_music", {duration = music_duration, music_name = music_name})
	end
end

