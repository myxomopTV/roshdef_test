local count = 0
function TEST( keys )	
	count = count + 1
	print("count= "..count)
	
	local caster = keys.caster
	local ability = keys.ability
	local maxhp = 100 * count
	
	caster:SetBaseDamageMin(10*count)
	caster:SetBaseDamageMax(20*count)				
	caster:SetPhysicalArmorBaseValue((-1)*caster:GetAgility()*0.16)
	caster:SetBaseMagicalResistanceValue(-200)--(-1)*caster:GetStrength()*0.1)
	caster:SetBaseMaxHealth(maxhp)
	caster:SetMaxHealth(maxhp)	
	caster:SetHealth(maxhp)

end