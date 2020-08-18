-- energy ability file

	local _details = 		_G._details
	local _

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _setmetatable = setmetatable --lua local
	local _ipairs = ipairs --lua local
	local _UnitAura = UnitAura --api local

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local dst_of_ability	=	_details.dst_of_ability
	local ability_energy	=	_details.ability_e_energy
	local container_combatants	= _details.container_combatants
	local container_energy_target	= _details.container_type.CONTAINER_ENERGYTARGET_CLASS
	local container_playernpc		= _details.container_type.CONTAINER_PLAYERNPC

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internals

	function ability_energy:Newtable(id, link, token)
		local _newEnergySpell = {
			id = id,
			counter = 0,
			total = 0,
			targets = {}
		}

		return _newEnergySpell
	end

	function ability_energy:Add(serial, name, flag, amount, src_name, powertype)
		self.counter = self.counter + 1
		self.total = self.total + amount
		self.targets[name] = (self.targets[name] or 0) + amount
	end