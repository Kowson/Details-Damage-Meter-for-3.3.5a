-- heal ability file

	local _details = 		_G._details
	local _
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local dst_of_ability	=	_details.dst_of_ability
	local ability_heal		=	_details.ability_heal
	local container_combatants =	_details.container_combatants
	local container_heal_target	=	_details.container_type.CONTAINER_HEALTARGET_CLASS
	local container_playernpc	=	_details.container_type.CONTAINER_PLAYERNPC

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internals

	function ability_heal:Newtable(id, link)
		local _newHealSpell = {
			id = id,
			counter = 0,

			--> totals
			total = 0, 
			totalabsorb = 0,
			absorbed = 0,
			overheal = 0,

			--> normal hits		
			n_min = 0,
			n_max = 0,
			n_amt = 0,
			n_healed = 0,
			
			--> critical hits 		
			c_min = 0,
			c_max = 0,
			c_amt = 0,
			c_healed = 0,
			
			--> targets containers
			targets = {},
			targets_overheal = {},
			targets_absorbs = {}
		}
		
		return _newHealSpell
	end

	function ability_heal:Add(serial, name, flag, amount, src_name, absorbed, critical, overhealing, is_shield)

		self.counter = self.counter + 1
		self.targets[name] = (self.targets[name] or 0) + amount

		if (absorbed and absorbed > 0) then
			self.absorbed = self.absorbed + absorbed
		end
		
		if (overhealing and overhealing > 0) then
			self.overheal = self.overheal + overhealing
			self.targets_overheal[name] = (self.targets_overheal[name] or 0) + amount
		end
		
		if (amount and amount > 0) then

			self.total = self.total + amount
			
			if (is_shield) then
				self.totalabsorb = self.totalabsorb + amount
				self.targets_absorbs[name] = (self.targets_absorbs[name] or 0) + amount
			end

			if (critical) then
				self.c_healed = self.c_healed+amount --> amount é o total de damage
				self.c_amt = self.c_amt+1 --> amount é o total de damage
				if (amount > self.c_max) then
					self.c_max = amount
				end
				if (self.c_min > amount or self.c_min == 0) then
					self.c_min = amount
				end
			else
				self.n_healed = self.n_healed+amount
				self.n_amt = self.n_amt+1
				if (amount > self.n_max) then
					self.n_max = amount
				end
				if (self.n_min > amount or self.n_min == 0) then
					self.n_min = amount
				end
			end
		end

	end
