-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> attributes functions for customs
--> DAMAGE DONE

--> customized display script

	local _details = 		_G._details
	local _
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _cstr = string.format --lua local
	local _math_floor = math.floor --lua local
	local _table_sort = table.sort --lua local
	local _table_insert = table.insert --lua local
	local _table_size = table.getn --lua local
	local _setmetatable = setmetatable --lua local
	local _ipairs = ipairs --lua local
	local _pairs = pairs --lua local
	local _rawget= rawget --lua local
	local _math_min = math.min --lua local
	local _math_max = math.max --lua local
	local _bit_band = bit.band --lua local
	local _unpack = unpack --lua local
	local _type = type --lua local
	
	local _GetSpellInfo = _details.getspellinfo -- api local
	local _IsInRaid = IsInRaid -- api local
	local _IsInGroup = IsInGroup -- api local
	local _GetNumGroupMembers = GetNumGroupMembers -- api local
	local _GetNumPartyMembers = GetNumPartyMembers or GetNumSubgroupMembers -- api local
	local _GetNumRaidMembers = GetNumRaidMembers or GetNumGroupMembers -- api local
	local _GetUnitName = GetUnitName -- api local

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local attribute_custom = _details.attribute_custom
	
	local ToKFunctions = _details.ToKFunctions
	local SelectedToKFunction = ToKFunctions[1]
	local FormatTooltipNumber = ToKFunctions[8]
	local TooltipMaximizedMethod = 1

	function attribute_custom:UpdateDamageDoneBracket()
		SelectedToKFunction = ToKFunctions[_details.ps_abbreviation]
		FormatTooltipNumber = ToKFunctions[_details.tooltip.abbreviation]
		TooltipMaximizedMethod = _details.tooltip.maximize_method
	end

	local temp_table = {}

	local target_func = function(main_table)
		local i = 1
		for name, amount in _pairs(main_table) do
			local t = temp_table[i]
			if (not t) then
				t = {"", 0}
				temp_table[i] = t
			end
			t[1] = name
			t[2] = amount
			i = i + 1
		end
	end

	local spells_used_func = function(main_table, target)
		local i = 1
		for spellid, spell_table in _pairs(main_table) do
			local target_amount = spell_table.targets[target]
			if (target_amount) then
				local t = temp_table[i]
				if (not t) then
					t = {"", 0}
					temp_table[i] = t
				end
				t[1] = spellid
				t[2] = target_amount
				i = i + 1
			end
		end
	end

	local function SortOrder(main_table, func, ...)
		for i = 1, #temp_table do
			temp_table[i][1] = ""
			temp_table[i][2] = 0
		end
		func(main_table, ...)
		_table_sort(temp_table, _details.Sort2)

		return temp_table
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> damage done tooltip
	
	function attribute_custom:damagedoneTooltip(actor, target, spellid, combat, instance)
	
		if (spellid) then

			if (instance:GetCustomObject():IsSpellTarget()) then
				local targetname = actor.name
				local this_actor = combat(1, targetname)
				
				if (this_actor) then
					for name, _ in _pairs(this_actor.damage_from) do 
						local aggressor = combat(1, name)
						if (aggressor) then
							local spell = aggressor.spells._ActorTable[spellid]
							if (spell) then
								local on_me = spell.targets[targetname]
								if (on_me) then
									GameCooltip:AddLine(aggressor.name, FormatTooltipNumber(_, on_me))
								end
							end
						end
					end
				end
				
				return
			else
				local name, _, icon = _GetSpellInfo(spellid)
				GameCooltip:AddLine(name)
				GameCooltip:AddIcon(icon, 1, 1, 14, 14)
				
				GameCooltip:AddLine(Loc["STRING_DAMAGE"] .. ": ", spell.total)
				GameCooltip:AddLine(Loc["STRING_HITS"] .. ": ", spell.counter)
				GameCooltip:AddLine(Loc["STRING_CRITICAL_HITS"] .. ": ", spell.c_amt)
			end
		
		elseif (target) then
			
			if (target == "[all]") then
				SortOrder(actor.targets, target_func)
				for i = 1, #temp_table do
					local t = temp_table[i]
					if (t[2] < 1) then
						break
					end

					GameCooltip:AddLine(t[1], FormatTooltipNumber(_, t[2]))
					_details:AddTooltipBackgroundStatusbar()
					GameCooltip:AddIcon([[Interface\FriendsFrame\StatusIcon-Offline]], 1, 1, 14, 14)
				end
				
			elseif (target == "[raid]") then
				local roster = combat.raid_roster
				SortOrder(actor.targets, target_func)
				for i = 1, #temp_table do
					local t = temp_table[i]
					if (t[2] < 1) then
						break
					end
					if (roster[t[1]]) then
						GameCooltip:AddLine(t[1], FormatTooltipNumber(_, t[2]))
					end
				end
				
			elseif (target == "[player]") then
				local target_amount = actor.targets[_details.playername]
				if (target_amount) then
					GameCooltip:AddLine(_details.playername, FormatTooltipNumber(_, target_amount))
				end
			else
				SortOrder(actor.spells._ActorTable, spells_used_func, target)
				for i = 1, #temp_table do
					local t = temp_table[i]
					if (t[2] < 1) then
						break
					end
					local name, _, icon = _GetSpellInfo(t[1])
					GameCooltip:AddLine(name, FormatTooltipNumber(_, t[2]))
					GameCooltip:AddIcon(icon, 1, 1, 14, 14)
				end
			end
		
		else
			actor:ToolTip_DamageDone(instance)
		end
	end
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> damage done search
	
	function attribute_custom:damagedone(actor, source, target, spellid, combat, instance_container)

		if (spellid) then --> spell is always damage done
			local spell = actor.spells._ActorTable[spellid]
			if (spell) then
				if (target) then
					if (target == "[all]") then
						for target_name, amount in _pairs(spell.targets) do
							--> add amount
							--> we need to pass a object here in order to get name and class, so we just get the main damage actor from the combat
							instance_container:AddValue(combat(1, target_name), amount, true)
							--
							attribute_custom._TargetActorsProcessedTotal = attribute_custom._TargetActorsProcessedTotal + amount
							--> add to processed container
							if (not attribute_custom._TargetActorsProcessed[target_name.name]) then
								attribute_custom._TargetActorsProcessed[target_name.name] = true
								attribute_custom._TargetActorsProcessedAmt = attribute_custom._TargetActorsProcessedAmt + 1
							end
						end
						return 0, true
						
					elseif (target == "[raid]") then
						local roster = combat.raid_roster
						for target_name, amount in _pairs(spell.targets) do
							if (roster[target_name]) then
								--> add amount
								instance_container:AddValue(combat(1, target_name), amount, true)
								attribute_custom._TargetActorsProcessedTotal = attribute_custom._TargetActorsProcessedTotal + amount
								--> add to processed container
								if (not attribute_custom._TargetActorsProcessed[target_name]) then
									attribute_custom._TargetActorsProcessed[target_name] = true
									attribute_custom._TargetActorsProcessedAmt = attribute_custom._TargetActorsProcessedAmt + 1
								end
							end
						end
						return 0, true
						
					elseif (target == "[player]") then
						local target_amount = spell.targets [_details.playername]
						if (target_amount) then
							--> add amount
							instance_container:AddValue(combat(1, _details.playername), target_amount, true)
							attribute_custom._TargetActorsProcessedTotal = attribute_custom._TargetActorsProcessedTotal + target_amount
							--> add to processed container
							if (not attribute_custom._TargetActorsProcessed[_details.playername]) then
								attribute_custom._TargetActorsProcessed[_details.playername] = true
								attribute_custom._TargetActorsProcessedAmt = attribute_custom._TargetActorsProcessedAmt + 1
							end
						end
						return 0, true
					
					else
						local target_amount = actor.targets[target]
						if (target_amount) then
							--> add amount
							instance_container:AddValue(combat(1, target), target_amount, true)
							attribute_custom._TargetActorsProcessedTotal = attribute_custom._TargetActorsProcessedTotal + target_amount
							--> add to processed container
							if (not attribute_custom._TargetActorsProcessed[target]) then
								attribute_custom._TargetActorsProcessed[target] = true
								attribute_custom._TargetActorsProcessedAmt = attribute_custom._TargetActorsProcessedAmt + 1
							end
						end
						return 0, true
					end
				else
					return spell.total
				end
			else
				return 0
			end

		elseif (target) then

			if (target == "[all]") then
				local total = 0
				for _, amount in _pairs(actor.targets) do
					total = total + amount
				end
				return total
				
			elseif (target == "[raid]") then
				local total = 0
				for target_name, amount in _pairs(actor.targets) do
					if (combat.raid_roster[target_name]) then
						total = total + amount
					end
				end
				return total
			
			elseif (target == "[player]") then
				return actor.targets[_details.playername] or 0

			else
				return actor.targets[target] or 0
			end
		else
			return actor.total or 0
			
		end
		
	end