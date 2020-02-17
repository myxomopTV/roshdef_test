-- Copyright (C) 2018  The Dota IMBA Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- Editors:
--

--[[	Author: d2imba
		Date:	13.08.2015	]]

function Cheese( keys )
	local caster = keys.caster
	local ability = keys.ability
	local sound_cast = keys.sound_cast
	local heal_pct = ability:GetSpecialValueFor("heal_pct")/100
	local mana_pct = ability:GetSpecialValueFor("mana_pct")/100
	local heal = ability:GetSpecialValueFor("heal")
	local mana = ability:GetSpecialValueFor("mana")

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Fully heal the caster
	caster:Heal(caster:GetMaxHealth()*heal_pct+heal, caster)
	caster:GiveMana(caster:GetMaxMana()*mana_pct+mana)

	-- Spend a charge
	ability:SetCurrentCharges( ability:GetCurrentCharges() - 1 )

	-- If this was the last charge, remove the item
	if ability:GetCurrentCharges() == 0 then
		caster:RemoveItem(ability)
	end
end
