function PlaySound( keys )
	local sound = keys.sound
	EmitGlobalSound(sound)
end

function SoundStop( keys )
	SendToConsole("stopsound")
end



