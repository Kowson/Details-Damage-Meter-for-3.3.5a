
--lua locals
local _cstr = string.format
local _math_floor = math.floor
local _table_sort = table.sort
local _table_insert = table.insert
local _setmetatable = setmetatable
local _ipairs = ipairs
local _pairs = pairs
local _rawget= rawget
local _math_min = math.min
local _math_max = math.max
local _bit_band = bit.band
local _unpack = unpack
local _type = type
--api locals
local _GetSpellInfo = _details.getspellinfo
local GameTooltip = GameTooltip
local _IsInRaid = IsInRaid
local _IsInGroup = IsInGroup

local _string_replace = _details.string.replace -- details api

local _details = 		_G._details
local AceLocale = LibStub("AceLocale-3.0")
local Loc = AceLocale:GetLocale( "Details" )
local _

local gump = 			_details.gump

local dst_of_ability = 	_details.dst_of_ability
local container_abilities = 	_details.container_abilities
local container_combatants = _details.container_combatants
local container_pets =		_details.container_pets
local attribute_energy =		_details.attribute_energy
local ability_energy = 	_details.ability_energy

local container_energy = _details.container_type.CONTAINER_ENERGY_CLASS

--local mode_ALONE = _details.modes.alone
local mode_GROUP = _details.modes.group
local mode_ALL = _details.modes.all

local class_type = _details.attributes.e_energy

local DATA_TYPE_START = _details._details_props.DATA_TYPE_START
local DATA_TYPE_END = _details._details_props.DATA_TYPE_END

local ToKFunctions = _details.ToKFunctions
local SelectedToKFunction = ToKFunctions[1]
local UsingCustomLeftText = false
local UsingCustomRightText = false

local FormatTooltipNumber = ToKFunctions[8]
local TooltipMaximizedMethod = 1

local headerColor = "yellow"
local key_overlay = {1, 1, 1, .1 }
local key_overlay_press = {1, 1, 1, .2 }
local actor_class_color_r, actor_class_color_g, actor_class_color_b

local info = _details.window_info
local keyName


function attribute_energy:Newtable(serial, name, link)

	--> constructor
	
	local alphabetical = _details:GetOrderNumber(name)
	
	local _new_energyActor = {
		last_event = 0,
		type = class_type,

		total = alphabetical,
		received = alphabetical,
		resource = alphabetical,

		last_value = nil,

		pets = {},

		targets = {},

		spells = container_abilities:NewContainer(container_energy),
	}
	
	_setmetatable(_new_energyActor, attribute_energy)
	
	return _new_energyActor
end

--> resources sort
function _details.SortGroupResource(container, keyName2)
	keyName = keyName2
	return _table_sort(container, _details.SortKeyGroupResources)
end

function _details.SortKeyGroupResources(table1, table2)
	if (table1.group and table2.group) then
		return table1[keyName] > table2[keyName]
	elseif (table1.group and not table2.group) then
		return true
	elseif (not table1.group and table2.group) then
		return false
	else
		return table1[keyName] > table2[keyName]
	end
end

function _details.SortKeySimpleResources(table1, table2)
	return table1[keyName] > table2[keyName]
end

function _details:ContainerSortResources(container, amount, keyName2)
	keyName = keyName2
	_table_sort(container,  _details.SortKeySimpleResources)
	
	if (amount) then 
		for i = amount, 1, -1 do --> de tr�s pra frente
			if (container[i][keyName] < 1) then
				amount = amount-1
			else
				break
			end
		end
		
		return amount
	end
end

--> power types sort

local power_table = {0, 1, 3, 6}
local power_type

local sort_energy = function(t1, t2)
	if (t1.powertype == power_type and t2.powertype == power_type) then
		return t1.received > t2.received
	elseif (t1.powertype == power_type) then
		return true
	elseif (t2.powertype == power_type) then
		return false
	else
		return t1.received > t2.received
	end
end

local sort_energy_group = function(t1, t2)
	if (t1.group and t2.group) then
		if (t1.powertype == power_type and t2.powertype == power_type) then
			return t1.received > t2.received
		elseif (t1.powertype == power_type) then
			return true
		elseif (t2.powertype == power_type) then
			return false
		else
			return t1.received > t2.received
		end
	else
		if (t1.group) then
			return true
		elseif (t2.group) then
			return false
		else
			return t1.received > t2.received
		end
	end
end

--> resource refresh

local function RefreshBarResources(tab, bar, instance)
	tab:UpdateResources(tab.my_bar, bar.placing, instance)
end

function attribute_energy:UpdateResources(bar_index, placing, instance)

	local this_bar = instance.bars[bar_index]

	if (not this_bar) then
		print("DEBUG: problem with <instance.this_bar> " .. bar_index .. " " .. placing)
		return
	end

	self._refresh_window = RefreshBarResources

	this_bar.my_table = self
	self.my_bar = bar_index
	this_bar.placing = placing

	local total = instance.showing.totals.resources

	local combat_time = instance.showing:GetCombatTime()
	local rps = _math_floor(self.resource / combat_time)

	local formated_resource = SelectedToKFunction(_, self.resource)
	--local formated_rps = SelectedToKFunction (_, rps)
	local formated_rps = _cstr("%.2f", self.resource / combat_time)

	local percentage

	if (instance.row_info.percent_type == 1) then
		percentage = _cstr("%.1f", self.resource / total * 100)
	elseif (instance.row_info.percent_type == 2) then
		percentage = _cstr("%.1f", self.resource / instance.top * 100)
	end

	if (UsingCustomRightText) then
		this_bar.text_right:SetText(_string_replace(instance.row_info.textR_custom_text, formated_resource, formated_rps, percentage, self))
	else
		this_bar.text_right:SetText(formated_resource .. " (" .. formated_rps .. ", " .. percentage .. "%)")
	end

	this_bar.text_left:SetText(placing .. ". " .. self.name)
	this_bar.text_left:SetSize(this_bar:GetWidth() - this_bar.text_right:GetStringWidth() - 20, 15)

	this_bar.statusbar:SetValue(100)

	if (this_bar.hidden or this_bar.fading_in or this_bar.faded) then
		gump:Fade(this_bar, "out")
	end

	actor_class_color_r, actor_class_color_g, actor_class_color_b = self:GetBarColor()
	this_bar.texture:SetVertexColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)

	if (self.class == "UNKNOW") then
		this_bar.icon_class:SetTexture([[Interface\AddOns\Details\images\classes_plus]])
		this_bar.icon_class:SetTexCoord(0.50390625, 0.62890625, 0, 0.125)
		this_bar.icon_class:SetVertexColor(1, 1, 1)

	elseif (self.class == "UNGROUPPLAYER") then
		if (self.enemy) then
			if (_details.faction_against == "Horde") then
				this_bar.icon_class:SetTexture([[Interface\AddOns\Details\images\Achievement_Character_Orc_Male]])
				this_bar.icon_class:SetTexCoord(0, 1, 0, 1)
			else
				this_bar.icon_class:SetTexture([[Interface\AddOns\Details\images\Achievement_Character_Human_Male]])
				this_bar.icon_class:SetTexCoord(0, 1, 0, 1)
			end
		else
			if (_details.faction_against == "Horde") then
				this_bar.icon_class:SetTexture([[Interface\AddOns\Details\images\Achievement_Character_Human_Male]])
				this_bar.icon_class:SetTexCoord(0, 1, 0, 1)
			else
				this_bar.icon_class:SetTexture([[Interface\AddOns\Details\images\Achievement_Character_Orc_Male]])
				this_bar.icon_class:SetTexCoord(0, 1, 0, 1)
			end
		end
		this_bar.icon_class:SetVertexColor(1, 1, 1)

	elseif (self.class == "PET") then
		this_bar.icon_class:SetTexture(instance.row_info.icon_file)
		this_bar.icon_class:SetTexCoord(0.25, 0.49609375, 0.75, 1)
		this_bar.icon_class:SetVertexColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)

	else
		this_bar.icon_class:SetTexture(instance.row_info.icon_file)
		this_bar.icon_class:SetTexCoord(_unpack(CLASS_ICON_TCOORDS[self.class])) --very slow method
		this_bar.icon_class:SetVertexColor(1, 1, 1)
	end

	if (instance.row_info.textL_class_colors) then
		this_bar.text_left:SetTextColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)
	end
	if (instance.row_info.textR_class_colors) then
		this_bar.text_right:SetTextColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)
	end
end

--> refresh function


function attribute_energy:RefreshWindow(instance, combat_table, force, export)

	local showing = combat_table[class_type]

	if (#showing._ActorTable < 1) then
		return _details:HideBarsNotUsed(instance, showing) 
	end
	
	local total = 0
	instance.top = 0
	
	local sub_attribute = instance.sub_attribute
	local content = showing._ActorTable
	local amount = #content
	local mode = instance.mode

	if (sub_attribute == 5) then
		--> showing resources
		keyName = "resource"

		if (mode == mode_ALL) then
			amount = _details:ContainerSortResources(content, amount, "resource")
			instance.top = content[1].resource

			for index, player in _ipairs(content) do
				if (player.resource >= 1) then
					total = total + player.resource
				else
					break
				end
			end

		elseif (mode == mode_GROUP) then
			_table_sort(content, _details.SortKeyGroupResources)

			for index, player in _ipairs(content) do
				if (player.group) then --> if is player and is in a group
					if (player.resource < 1) then
						amount = index - 1
						break
					end

					total = total + player.resource
				else
					amount = index - 1
					break
				end
			end

			instance.top = content[1].resource
		end

		showing:remapear()

		if (export) then
			return total, keyName, instance.top, amount
		end

		if (total < 1) then
			instance:HideScrollBar()
			return _details:EndRefresh(instance, total, combat_table, showing)
		end

		combat_table.totals.resources = total

		instance:ActualizeScrollBar(amount)

		local bar_index = 1
		local bars_container = instance.bars

		for i = instance.barS[1], instance.barS[2], 1 do
			content[i]:UpdateResources(bar_index, i, instance)
			bar_index = bar_index+1
		end

		--> beta, hide bars not used during a forced refresh
		if (force) then
			if (instance.mode == 2) then --> group
				for i = bar_index, instance.rows_fit_in_window do
					gump:Fade(instance.bars[i], "in", 0.3)
				end
			end
		end

		return _details:EndRefresh(instance, total, combat_table, showing)

	end

	power_type = power_table[sub_attribute]

	keyName = "received"

	if (export) then
		if (_type(export) == "boolean") then 		
			keyName = "received"
		else
			keyName = export.key
			mode = export.mode		
		end
	else
		keyName = "received"
	end
	
	if (mode == mode_ALL) then --> showing ALL

		_table_sort(content, sort_energy)
		
		--> do not show results with zero
		for i = amount, 1, -1 do
			if (content[i].received < 1) then
				amount = amount - 1
			elseif (content[i].powertype ~= power_type) then -- TODO: change to or
				amount = amount - 1
			else
				break
			end
		end
		
		total = combat_table.totals[class_type][power_type] --> pega o total de damage j� aplicado
		
		instance.top = content[1].received
		
	elseif (mode == mode_GROUP) then --> showing GROUP
		
		_table_sort(content, sort_energy_group)
		
		for index, player in _ipairs(content) do
			if (player.group) then
				if (player.received < 1) then
					amount = index - 1
					break
				elseif (player.powertype ~= power_type) then
					amount = index - 1
					break
				end
				
				total = total + player.received
			else
				amount = index-1
				break
			end
		end
		instance.top = content[1].received
	end

	showing:remapear()

	if (export) then 
		return total, keyName, instance.top, amount
	end
	
	if (amount < 1) then --> n�o h� bars para mostrar
		instance:HideScrollBar()
		return _details:EndRefresh(instance, total, combat_table, showing) --> retorna a table que precisa ganhar o refresh
	end

	instance:ActualizeScrollBar(amount)

	local which_bar = 1
	local bars_container = instance.bars
	local percentage_type = instance.row_info.percent_type
	local baseframe = instance.baseframe
	
	local use_animations = _details.is_using_row_animations and(not baseframe.isStretching and not force and not baseframe.isResizing)
	
	if (total == 0) then
		total = 0.00000001
	end
	
	local myPos
	local following = instance.following.enabled
	
	if (following) then
		if (using_cache) then
			local pname = _details.playername
			for i, actor in _ipairs(content) do
				if (actor.name == pname) then
					myPos = i
					break
				end
			end
		else
			myPos = showing._NameIndexTable[_details.playername]
		end
	end
	
	local combat_time = instance.showing:GetCombatTime()
	UsingCustomLeftText = instance.row_info.textL_enable_custom_text
	UsingCustomRightText = instance.row_info.textR_enable_custom_text
	
	local use_total_bar = false
	if (instance.total_bar.enabled) then
		use_total_bar = true
		
		if (instance.total_bar.only_in_group and(GetNumPartyMembers() == 0 and GetNumRaidMembers() == 0)) then
			use_total_bar = false
		end
	end
	
	if (instance.bars_sort_direction == 1) then --top to bottom
		
		if (use_total_bar and instance.barS[1] == 1) then
		
			which_bar = 2
			local iter_last = instance.barS[2]
			if (iter_last == instance.rows_fit_in_window) then
				iter_last = iter_last - 1
			end
			
			local row1 = bars_container[1]
			row1.my_table = nil
			row1.text_left:SetText(Loc["STRING_TOTAL"])
			row1.text_right:SetText(_details:ToK2(total) .. "(" .. _details:ToK(total / combat_time) .. ")")
			
			row1.statusbar:SetValue(100)
			local r, b, g = unpack(instance.total_bar.color)
			row1.texture:SetVertexColor(r, b, g)
			
			row1.icon_class:SetTexture(instance.total_bar.icon)
			row1.icon_class:SetTexCoord(0.0625, 0.9375, 0.0625, 0.9375)
			
			gump:Fade(row1, "out")
			
			if (following and myPos and myPos > instance.rows_fit_in_window and instance.barS[2] < myPos) then
				for i = instance.barS[1], iter_last-1, 1 do --> vai atualizar s� o range que this sendo mostrado
					content[i]:UpdateBar(instance, bars_container, which_bar, i, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> inst�ncia, index, total, valor da 1� bar
					which_bar = which_bar+1
				end
				
				content[myPos]:UpdateBar(instance, bars_container, which_bar, myPos, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> inst�ncia, index, total, valor da 1� bar
				which_bar = which_bar+1
			else
				for i = instance.barS[1], iter_last, 1 do --> vai atualizar s� o range que this sendo mostrado
					content[i]:UpdateBar(instance, bars_container, which_bar, i, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> inst�ncia, index, total, valor da 1� bar
					which_bar = which_bar+1
				end
			end

		else
			if (following and myPos and myPos > instance.rows_fit_in_window and instance.barS[2] < myPos) then
				for i = instance.barS[1], instance.barS[2]-1, 1 do --> vai atualizar s� o range que this sendo mostrado
					content[i]:UpdateBar(instance, bars_container, which_bar, i, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> inst�ncia, index, total, valor da 1� bar
					which_bar = which_bar+1
				end
				
				content[myPos]:UpdateBar(instance, bars_container, which_bar, myPos, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> inst�ncia, index, total, valor da 1� bar
				which_bar = which_bar+1
			else
				for i = instance.barS[1], instance.barS[2], 1 do --> vai atualizar s� o range que this sendo mostrado
					content[i]:UpdateBar(instance, bars_container, which_bar, i, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> inst�ncia, index, total, valor da 1� bar
					which_bar = which_bar+1
				end
			end
		end
		
	elseif (instance.bars_sort_direction == 2) then --bottom to top
	
		if (use_total_bar and instance.barS[1] == 1) then
		
			which_bar = 2
			local iter_last = instance.barS[2]
			if (iter_last == instance.rows_fit_in_window) then
				iter_last = iter_last - 1
			end
			
			local row1 = bars_container[1]
			row1.my_table = nil
			row1.text_left:SetText(Loc["STRING_TOTAL"])
			row1.text_right:SetText(_details:ToK2(total) .. "(" .. _details:ToK(total / combat_time) .. ")")
			
			row1.statusbar:SetValue(100)
			local r, b, g = unpack(instance.total_bar.color)
			row1.texture:SetVertexColor(r, b, g)
			
			row1.icon_class:SetTexture(instance.total_bar.icon)
			row1.icon_class:SetTexCoord(0.0625, 0.9375, 0.0625, 0.9375)
			
			gump:Fade(row1, "out")
			
			if (following and myPos and myPos > instance.rows_fit_in_window and instance.barS[2] < myPos) then
				for i = iter_last-1, instance.barS[1], -1 do --> vai atualizar s� o range que this sendo mostrado
					content[i]:UpdateBar(instance, bars_container, which_bar, i, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> inst�ncia, index, total, valor da 1� bar
					which_bar = which_bar+1
				end
				
				content[myPos]:UpdateBar(instance, bars_container, which_bar, myPos, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> inst�ncia, index, total, valor da 1� bar
				which_bar = which_bar+1
			else
				for i = iter_last, instance.barS[1], -1 do --> vai atualizar s� o range que this sendo mostrado
					content[i]:UpdateBar(instance, bars_container, which_bar, i, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> inst�ncia, index, total, valor da 1� bar
					which_bar = which_bar+1
				end
			end
		else
			if (following and myPos and myPos > instance.rows_fit_in_window and instance.barS[2] < myPos) then
				for i = instance.barS[2]-1, instance.barS[1], -1 do --> vai atualizar s� o range que this sendo mostrado
					content[i]:UpdateBar(instance, bars_container, which_bar, i, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> inst�ncia, index, total, valor da 1� bar
					which_bar = which_bar+1
				end
				
				content[myPos]:UpdateBar(instance, bars_container, which_bar, myPos, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> inst�ncia, index, total, valor da 1� bar
				which_bar = which_bar+1
			else
				for i = instance.barS[2], instance.barS[1], -1 do --> vai atualizar s� o range que this sendo mostrado
					content[i]:UpdateBar(instance, bars_container, which_bar, i, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> inst�ncia, index, total, valor da 1� bar
					which_bar = which_bar+1
				end
			end
		end
		
	end
	
	if (use_animations) then
		instance:do_animations()
	end

	if (force) then
		if (instance.mode == 2) then --> group
			for i = which_bar, instance.rows_fit_in_window  do
				gump:Fade(instance.bars[i], "in", 0.3)
			end
		end
	end

	return _details:EndRefresh(instance, total, combat_table, showing) --> retorna a table que precisa ganhar o refresh

end

function attribute_energy:UpdateBar(instance, bars_container, which_bar, place, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations)

	local this_bar = instance.bars[which_bar] --> pega a refer�ncia da bar na window
	
	if (not this_bar) then
		print("DEBUG: problema com <instance.this_bar> "..which_bar.." "..place)
		return
	end
	
	local table_previous = this_bar.my_table
	
	this_bar.my_table = self
	this_bar.placing = place
	
	self.my_bar = this_bar
	self.placing = place

	local this_e_energy_total = self[keyName] --> total de damage que this player deu
	
--	local percentage = this_e_energy_total / total * 100
	local percentage
	if (percentage_type == 1) then
		percentage = _cstr("%.1f", this_e_energy_total / total * 100)
	elseif (percentage_type == 2) then
		percentage = _cstr("%.1f", this_e_energy_total / instance.top * 100)
	end

	local this_percentage = _math_floor((this_e_energy_total/instance.top) * 100)

	local formated_energy = SelectedToKFunction(_, this_e_energy_total)
	
	if (UsingCustomRightText) then
		this_bar.text_right:SetText(_string_replace(instance.row_info.textR_custom_text, formated_energy, "", percentage, self))
	else
		this_bar.text_right:SetText(formated_energy .. "(" .. percentage .. "%)") --seta o text da right
	end
	
	if (this_bar.mouse_over and not instance.baseframe.isMoving) then --> precisa atualizar o tooltip
		gump:UpdateTooltip(which_bar, this_bar, instance)
	end

	actor_class_color_r, actor_class_color_g, actor_class_color_b = self:GetBarColor()
	
	return self:RefreshBar2(this_bar, instance, table_previous, force, this_percentage, which_bar, bars_container, use_animations)
end

function attribute_energy:RefreshBar2(this_bar, instance, table_previous, force, this_percentage, which_bar, bars_container, use_animations)
	
	--> primeiro colocado
	if (this_bar.placing == 1) then
		if (not table_previous or table_previous ~= this_bar.my_table or force) then
			this_bar.statusbar:SetValue(100)
			
			if (this_bar.hidden or this_bar.fading_in or this_bar.faded) then
				gump:Fade(this_bar, "out")
			end
			
			return self:RefreshBar(this_bar, instance)
		else
			return
		end
	else

		if (this_bar.hidden or this_bar.fading_in or this_bar.faded) then
		
			--this_bar.statusbar:SetValue(this_percentage)
			
			if (use_animations) then
				this_bar.animation_end = this_percentage
			else
				this_bar.statusbar:SetValue(this_percentage)
				this_bar.animation_ignore = true
			end
			
			gump:Fade(this_bar, "out")
			
			if (instance.row_info.texture_class_colors) then
				this_bar.texture:SetVertexColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)
			end
			if (instance.row_info.texture_background_class_color) then
				this_bar.background:SetVertexColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)
			end
			
			return self:RefreshBar(this_bar, instance)
			
		else
			--> agora this comparando se a table da bar � diferente da table na atualiza��o previous
			if (not table_previous or table_previous ~= this_bar.my_table or force) then --> aqui diz se a bar do player mudou de posi��o ou se ela apenas ser� atualizada
			
				if (use_animations) then
					this_bar.animation_end = this_percentage
				else
					this_bar.statusbar:SetValue(this_percentage)
					this_bar.animation_ignore = true
				end
			
				this_bar.last_value = this_percentage --> reseta o ultimo valor da bar
			
				return self:RefreshBar(this_bar, instance)
				
			elseif (this_percentage ~= this_bar.last_value) then --> continua showing a mesma table ent�o compara a percentage
				--> apenas atualizar
				if (use_animations) then
					this_bar.animation_end = this_percentage
				else
					this_bar.statusbar:SetValue(this_percentage)
				end
				this_bar.last_value = this_percentage
				
				return self:RefreshBar(this_bar, instance)
			end
		end

	end
	
end

function attribute_energy:RefreshBar(this_bar, instance, from_resize)
	
	if (from_resize) then
		actor_class_color_r, actor_class_color_g, actor_class_color_b = self:GetBarColor()
	end
	
	if (instance.row_info.texture_class_colors) then
		this_bar.texture:SetVertexColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)
	end
	if (instance.row_info.texture_background_class_color) then
		this_bar.background:SetVertexColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)
	end
	
	if (self.class == "UNKNOW") then
		this_bar.icon_class:SetTexture("Interface\\LFGFRAME\\LFGROLE_BW")
		this_bar.icon_class:SetTexCoord(.25, .5, 0, 1)
		this_bar.icon_class:SetVertexColor(1, 1, 1)
	
	elseif (self.class == "UNGROUPPLAYER") then
		if (self.enemy) then
			if (_details.faction_against == "Horde") then
				this_bar.icon_class:SetTexture("Interface\\AddOns\\Details\\images\\Achievement_Character_Orc_Male")
				this_bar.icon_class:SetTexCoord(0, 1, 0, 1)
			else
				this_bar.icon_class:SetTexture("Interface\\AddOns\\Details\\images\\Achievement_Character_Human_Male")
				this_bar.icon_class:SetTexCoord(0, 1, 0, 1)
			end
		else
			if (_details.faction_against == "Horde") then
				this_bar.icon_class:SetTexture("Interface\\AddOns\\Details\\images\\Achievement_Character_Human_Male")
				this_bar.icon_class:SetTexCoord(0, 1, 0, 1)
			else
				this_bar.icon_class:SetTexture("Interface\\AddOns\\Details\\images\\Achievement_Character_Orc_Male")
				this_bar.icon_class:SetTexCoord(0, 1, 0, 1)
			end
		end
		this_bar.icon_class:SetVertexColor(1, 1, 1)
	
	elseif (self.class == "PET") then
		this_bar.icon_class:SetTexture(instance.row_info.icon_file)
		this_bar.icon_class:SetTexCoord(0.25, 0.49609375, 0.75, 1)
		this_bar.icon_class:SetVertexColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)

	else
		this_bar.icon_class:SetTexture(instance.row_info.icon_file)
		this_bar.icon_class:SetTexCoord(_unpack(CLASS_ICON_TCOORDS[self.class])) --very slow method
		this_bar.icon_class:SetVertexColor(1, 1, 1)
	end
	
	--texture and text
	
	local bar_number = ""
	if (instance.row_info.textL_show_number) then
		bar_number = this_bar.placing .. ". "
	end
	
	if (self.enemy) then
		if (self.arena_enemy) then
			if (UsingCustomLeftText) then
				this_bar.text_left:SetText(_string_replace(instance.row_info.textL_custom_text, this_bar.placing, self.displayName, "|TInterface\\LFGFRAME\\UI-LFG-ICON-ROLES:" .. instance.row_info.height .. ":" .. instance.row_info.height .. ":0:0:256:256:" .. _details.role_texcoord[self.role or "NONE"] .. "|t"))
			else
				this_bar.text_left:SetText(bar_number .. "|TInterface\\LFGFRAME\\UI-LFG-ICON-ROLES:" .. instance.row_info.height .. ":" .. instance.row_info.height .. ":0:0:256:256:" .. _details.role_texcoord[self.role or "NONE"] .. "|t" .. self.displayName)
			end
			this_bar.texture:SetVertexColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)
		else
			if (_details.faction_against == "Horde") then
				if (UsingCustomLeftText) then
					this_bar.text_left:SetText(_string_replace(instance.row_info.textL_custom_text, this_bar.placing, self.displayName, "|TInterface\\AddOns\\Details\\images\\icons_bar:"..instance.row_info.height..":"..instance.row_info.height..":0:0:256:32:0:32:0:32|t"))
				else
					this_bar.text_left:SetText(bar_number .. "|TInterface\\AddOns\\Details\\images\\icons_bar:"..instance.row_info.height..":"..instance.row_info.height..":0:0:256:32:0:32:0:32|t"..self.displayName) --seta o text da esqueda -- HORDA
				end
			else
				if (UsingCustomLeftText) then
					this_bar.text_left:SetText(_string_replace(instance.row_info.textL_custom_text, this_bar.placing, self.displayName, "|TInterface\\AddOns\\Details\\images\\icons_bar:"..instance.row_info.height..":"..instance.row_info.height..":0:0:256:32:32:64:0:32|t"))
				else
					this_bar.text_left:SetText(bar_number .. "|TInterface\\AddOns\\Details\\images\\icons_bar:"..instance.row_info.height..":"..instance.row_info.height..":0:0:256:32:32:64:0:32|t"..self.displayName) --seta o text da esqueda -- ALLY
				end
			end
			
			if (instance.row_info.texture_class_colors) then
				this_bar.texture:SetVertexColor(0.94117, 0, 0.01960, 1)
			end
		end
	else
		if (self.arena_ally) then
			if (UsingCustomLeftText) then
				this_bar.text_left:SetText(_string_replace(instance.row_info.textL_custom_text, this_bar.placing, self.displayName, "|TInterface\\LFGFRAME\\UI-LFG-ICON-ROLES:" .. instance.row_info.height .. ":" .. instance.row_info.height .. ":0:0:256:256:" .. _details.role_texcoord[self.role or "NONE"] .. "|t"))
			else
				this_bar.text_left:SetText(bar_number .. "|TInterface\\LFGFRAME\\UI-LFG-ICON-ROLES:" .. instance.row_info.height .. ":" .. instance.row_info.height .. ":0:0:256:256:" .. _details.role_texcoord[self.role or "NONE"] .. "|t" .. self.displayName)
			end
		else
			if (UsingCustomLeftText) then
				this_bar.text_left:SetText(_string_replace(instance.row_info.textL_custom_text, this_bar.placing, self.displayName, ""))
			else
				this_bar.text_left:SetText(bar_number .. self.displayName) --seta o text da esqueda
			end
		end
	end
	
	if (instance.row_info.textL_class_colors) then
		this_bar.text_left:SetTextColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)
	end
	if (instance.row_info.textR_class_colors) then
		this_bar.text_right:SetTextColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)
	end
	
	this_bar.text_left:SetSize(this_bar:GetWidth() - this_bar.text_right:GetStringWidth() - 20, 15)
	
end

--------------------------------------------- // TOOLTIPS // ---------------------------------------------
function attribute_energy:KeyNames(sub_attribute)
	return "total"
end

---------> TOOLTIPS BIFURCA��O
function attribute_energy:ToolTip(instance, number, bar, keydown)
	if (instance.sub_attribute <= 4) then
		return self:ToolTipRegenReceived(instance, number, bar, keydown)
	end
end

--> tooltip locals
local r, g, b
local barAlpha = .6

local energy_tooltips_table = {}
local energy_tooltips_hash = {}

local reset_tooltips_table = function()
	for i = 1, #energy_tooltips_table do
		local t = energy_tooltips_table[i]
		t[1], t[2], t[3] = "", 0, ""
	end

	for k, v in _pairs(energy_tooltips_hash) do
		energy_tooltips_hash[k] = nil
	end
end

function attribute_energy:ToolTipRegenReceived(instance, number, bar, keydown)

	reset_tooltips_table()

	local owner = self.owner
	if (owner and owner.class) then
		r, g, b = unpack(_details.class_colors[owner.class])
	else
		r, g, b = unpack(_details.class_colors[self.class])
	end

	local powertype = self.powertype
	local combat_table = instance.showing
	local container = combat_table[class_type]
	local total_regenerated = self.received
	local name = self.name

	--> spells
	local i = 1

	for index, actor in _ipairs(container._ActorTable) do
		if (actor.powertype == powertype) then

			for spellid, spell in _pairs(actor.spells._ActorTable) do
				local on_self = spell.targets[name]
				if (on_self) then
					local already_tracked = energy_tooltips_hash[spellid]
					if (already_tracked) then
						local t = energy_tooltips_table[already_tracked]
						t[2] = t[2] + on_self
					else
						local t = energy_tooltips_table[i]
						if (not t) then
							energy_tooltips_table[i] = {}
							t = energy_tooltips_table[i]
						end
						t[1], t[2], t[3] = spellid, on_self, ""
						energy_tooltips_hash[spellid] = i
						i = i + 1
					end
				end
			end

		end
	end

	i = i - 1
	_table_sort(energy_tooltips_table, _details.Sort2)
	
	_details:AddTooltipSpellHeaderText(Loc["STRING_SPELLS"], headerColor, r, g, b, i)
	GameCooltip:AddIcon([[Interface\AddOns\Details\images\ReportLagIcon-Spells]], 1, 1, 14, 14, 0.21875, 0.78125, 0.21875, 0.78125)
	
	local ismaximized = false
	if (keydown == "shift" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 3) then
		GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_shift]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay_press)
		GameCooltip:AddStatusBar(100, 1, r, g, b, 1)
		ismaximized = true
	else
		GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_shift]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay)
		GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
	end
	
	local max = i
	if (max > 3) then
		max = 3
	end
	
	if (ismaximized) then
		max = 99
	end

	for j = 1, math.min(i, max) do
		local spell = energy_tooltips_table[j]
		if (spell[2] < 1) then
			break
		end
		local name_spell, _, icon_spell = _GetSpellInfo(spell[1])
		GameCooltip:AddLine(name_spell..": ", FormatTooltipNumber(_,  spell[2]) .. "(" .. _cstr("%.1f",(spell[2] / total_regenerated) * 100) .. "%)")
		GameCooltip:AddIcon(icon_spell)
		_details:AddTooltipBackgroundStatusbar()
	end
	
	--> players

	reset_tooltips_table()
	i = 1

	for index, actor in _ipairs(container._ActorTable) do
		if (actor.powertype == powertype) then
			local on_self = actor.targets[name]
			if (on_self) then
				local t = energy_tooltips_table[i]
				if (not t) then
					energy_tooltips_table[i] = {}
					t = energy_tooltips_table[i]
				end
				t[1], t[2], t[3] = actor.name, on_self, actor.class
				i = i + 1
			end
		end
	end

	i = i - 1
	_table_sort(energy_tooltips_table, _details.Sort2)

	_details:AddTooltipSpellHeaderText(Loc["STRING_PLAYERS"], headerColor, r, g, b, i)
	GameCooltip:AddIcon([[Interface\AddOns\Details\images\HelpIcon-HotIssues]], 1, 1, 14, 14, 0.21875, 0.78125, 0.21875, 0.78125)
	
	local ismaximized = false
	if (keydown == "ctrl" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 4) then
		GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_ctrl]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay_press)
		GameCooltip:AddStatusBar(100, 1, r, g, b, 1)
		ismaximized = true
	else
		GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_ctrl]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay)
		GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
	end
	
	max = i
	if (max > 3) then
		max = 3
	end
	
	if (ismaximized) then
		max = 99
	end
	
	for j = 1, math.min(i, max) do
		local source = energy_tooltips_table[j]

		if (source[2] < 1) then
			break
		end

		GameCooltip:AddLine(source[1] .. ": ", FormatTooltipNumber(_,  source[2]) .. "(" .. _cstr("%.1f",(source[2] / total_regenerated) * 100) .. "%)")
		_details:AddTooltipBackgroundStatusbar()
		
		local class = source[3]
		if (not class) then
			class = "UNKNOW"
		end
		if (class == "UNKNOW") then
			GameCooltip:AddIcon("Interface\\LFGFRAME\\LFGROLE_BW", nil, nil, 14, 14, .25, .5, 0, 1)
		else
			GameCooltip:AddIcon("Interface\\AddOns\\Details\\images\\classes_small", nil, nil, 14, 14, _unpack(_details.class_coords[class]))
		end
		
	end
	
	return true
end

--------------------------------------------- // JANELA DETALHES // ---------------------------------------------

---------> DETALHES BIFURCA��O
function attribute_energy:SetInfo()
	if (info.sub_attribute <= 4) then
		return self:SetInfoRegenReceived()
	end
end

---------> DETALHES bloco da right BIFURCA��O
function attribute_energy:SetDetails(spellid, bar)
	if (info.sub_attribute <= 4) then
		return self:SetDetailsRegenReceived(spellid, bar)
	end
end

function attribute_energy:SetInfoRegenReceived()

	reset_tooltips_table()

	local bars = info.bars1
	local bars2 = info.bars2
	local bars3 = info.bars3
	
	local instance = info.instance
	
	local combat_table = instance.showing
	local container = combat_table[class_type]
	
	local total_regenerated = self.received
	local my_name = self.name
	local powertype = self.powertype

	--> spells:
	local i = 1

	for index, actor in _ipairs(container._ActorTable) do
		if (actor.powertype == powertype) then
			for spellid, spell in _pairs(actor.spells._ActorTable) do
				local on_self = spell.targets[my_name]
				if (on_self) then
					local already_tracked = energy_tooltips_hash[spellid]
					if (already_tracked) then
						local t = energy_tooltips_table[already_tracked]
						t[2] = t[2] + on_self
					else
						local t = energy_tooltips_table[i]
						if (not t) then
							energy_tooltips_table[i] = {}
							t = energy_tooltips_table[i]
						end
						t[1], t[2], t[3] = spellid, on_self, ""
						energy_tooltips_hash[spellid] = i
						i = i + 1
					end
				end
			end
		end
	end

	i = i - 1
	_table_sort(energy_tooltips_table, _details.Sort2)

	local amt = i
	
	if (amt < 1) then
		return true
	end
	
	gump:JI_UpdateContainerBars(amt)
	local max_ = energy_tooltips_table[1][2]
	
	for index, table in _ipairs(energy_tooltips_table) do
		if (table[2] < 1) then
			break
		end

		local bar = bars[index]

		if (not bar) then
			bar = gump:CreateNewBarInfo1(instance, index)
			bar.texture:SetStatusBarColor(1, 1, 1, 1)
			bar.on_focus = false
		end

		self:FocusLock(bar, table[1])

		local spellname, _, spellicon = _GetSpellInfo(table[1])
		local percent = table[2] / total_regenerated * 100

		self:UpdadeInfoBar(bar, index, table[1], spellname, table[2], _details:comma_value(table[2]), max_, percent, spellicon, true)

		bar.my_table = self
		bar.show = table[1]
		bar:Show()

		if (self.details and self.details == bar.show) then
			self:SetDetails(self.details, bar)
		end
		
	end
	
	--> players:
	reset_tooltips_table()
	i = 1


	for index, actor in _ipairs (container._ActorTable) do
		if (actor.powertype == powertype) then
			local on_self = actor.targets[my_name]
			if (on_self) then
				local t = energy_tooltips_table[i]
				if (not t) then
					energy_tooltips_table[i] = {}
					t = energy_tooltips_table[i]
				end
				t[1], t[2], t[3] = actor.name, on_self, actor.class
				i = i + 1
			end
		end
	end

	i = i - 1
	_table_sort(energy_tooltips_table, _details.Sort2)

	local amt_sources = i
	gump:JI_UpdateContainerTargets(amt_sources)
	
	local max_sources = energy_tooltips_table[1][2]
	
	local bar
	for index, table in _ipairs(energy_tooltips_table) do

		if (table[2] < 1) then
			break
		end

		bar = info.bars2[index]
		
		if (not bar) then
			bar = gump:CreateNewBarInfo2(instance, index)
			bar.texture:SetStatusBarColor(1, 1, 1, 1)
		end
		
		if (index == 1) then
			bar.texture:SetValue(100)
		else
			bar.texture:SetValue(table[2]/max_sources*100)
		end
		
		bar.text_left:SetText(index..instance.dividers.placing..table[1])
		bar.text_right:SetText(_details:comma_value(table[2]) .. _cstr("%.1f", table[2] / total_regenerated * 100))
		
		if (bar.mouse_over) then --> atualizar o tooltip
			if (bar.isTarget) then
				GameTooltip:Hide() 
				GameTooltip:SetOwner(bar, "ANCHOR_TOPRIGHT")
				if (not bar.my_table:SetTooltipTargets(bar, index)) then
					return
				end
				GameTooltip:Show()
			end
		end	

		bar.my_table = self
		bar.name_enemy = table[1]

		bar:Show()
	end	

end

function attribute_energy:SetDetailsRegenReceived(name, bar)
	for _, bar in _ipairs(info.bars3) do 
		bar:Hide()
	end

	reset_tooltips_table()
	
	local bars = info.bars3
	local instance = info.instance

	local combat_table = info.instance.showing
	local container = combat_table[class_type]

	local total_regenerated = self.received
	
	local spellid = name
	local who_name = self.name
	local powertype = self.powertype

	--> who is regenerating with the spell -> name

	--> spells:
	local i = 1

	for index, actor in _ipairs(container._ActorTable) do
		if (actor.powertype == powertype) then
			local spell = actor.spells._ActorTable[spellid]
			if (spell) then
				local on_self = spell.targets[who_name]
				if (on_self) then
					local t = energy_tooltips_table[i]
					if (not t) then
						energy_tooltips_table[i] = {}
						t = energy_tooltips_table[i]
					end
					t[1], t[2], t[3] = actor.name, on_self, actor.class
					i = i + 1
				end
			end
		end
	end

	i = i - 1

	if (i < 1) then
		return
	end

	_table_sort(energy_tooltips_table, _details.Sort2)

	local max_ = energy_tooltips_table[1][2]
	
	local bar
	for index, table in _ipairs(energy_tooltips_table) do
		if (table[2] < 1) then
			break
		end

		bar = bars[index]

		if (not bar) then --> se a bar n�o existir, create ela ent�o
			bar = gump:CreateNewBarInfo3(instance, index)
			bar.texture:SetStatusBarColor(1, 1, 1, 1)
		end
		
		if (index == 1) then
			bar.texture:SetValue(100)
		else
			bar.texture:SetValue(table[2] / max_ * 100)
		end

		bar.text_left:SetText(index .. "." .. table[1])
		bar.text_right:SetText(_details:comma_value(table[2]) .. " (" .. _cstr("%.1f", table[2] / total_regenerated * 100) .. "%)")
		
		bar.texture:SetStatusBarColor(_unpack(_details.class_colors[table[3]]))
		bar.icon:SetTexture("Interface\\AddOns\\Details\\images\\classes_small")
		
		bar.icon:SetTexCoord(_unpack(_details.class_coords[table[3]]))

		bar:Show() --> mostra a bar
		
		if (index == 15) then 
			break
		end
	end
end

function attribute_energy:SetTooltipTargets(this_bar, index)
	local instance = info.instance
	local combat_table = instance.showing
	local container = combat_table[class_type]
	
	local total_regenerated = self.received
	local my_name = self.name

	reset_tooltips_table()
	
	-- actor name
	local actor = container._ActorTable[container._NameIndexTable[this_bar.name_enemy]]

	if (actor) then
		--> spells:
		local i = 1

		for spellid, spell in _pairs(actor.spells._ActorTable) do
			local on_self = spell.targets[my_name]
			if (on_self) then
				local t = energy_tooltips_table[i]
				if (not t) then
					energy_tooltips_table[i] = {}
					t = energy_tooltips_table[i]
				end
				t[1], t[2], t[3] = spellid, on_self, ""
				i = i + 1
			end
		end

		i = i - 1
		_table_sort(energy_tooltips_table, _details.Sort2)

		for index, spell in _ipairs(energy_tooltips_table) do
			if (spell[2] < 1) then
				break
			end

			local spellname, _, spellicon = _GetSpellInfo(spell[1])
			GameTooltip:AddDoubleLine(spellname .. ": ", _details:comma_value(spell[2]) .. " (" .. _cstr("%.1f", (spell[2] / total_regenerated) * 100) .. "%)", 1, 1, 1, 1, 1, 1)
			GameTooltip:AddTexture(spellicon)
		end
	end
	return true
end


--controla se o dps do player this travado ou destravado
function attribute_energy:Initialize(initialize)
	return false --retorna se o dps this aberto ou closedo para this player
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core functions

	--> atualize a func de opsendcao
		function attribute_energy:UpdateSelectedToKFunction()
			SelectedToKFunction = ToKFunctions[_details.ps_abbreviation]
			FormatTooltipNumber = ToKFunctions[_details.tooltip.abbreviation]
			TooltipMaximizedMethod = _details.tooltip.maximize_method
			headerColor = _details.tooltip.header_text_color
		end

	--> subtract total from a combat table
		function attribute_energy:subtract_total(combat_table)
			--print ("reduce total:", combat_table.totals [class_type] [self.powertype], self.total, self.powertype, self.nome)
			if (self.powertype and combat_table.totals[class_type][self.powertype]) then
				combat_table.totals[class_type][self.powertype] = combat_table.totals[class_type][self.powertype] - self.total
				if (self.group) then
					combat_table.totals_group[class_type][self.powertype] = combat_table.totals_group[class_type][self.powertype] - self.total
				end
			end
		end

		function attribute_energy:add_total(combat_table)
			--print ("add total:", combat_table.totals [class_type] [self.powertype], self.total)
			if (self.powertype and combat_table.totals[class_type][self.powertype]) then
				combat_table.totals[class_type][self.powertype] = combat_table.totals[class_type][self.powertype] + self.total

				if (self.group) then
					combat_table.totals_group[class_type][self.powertype] = combat_table.totals_group[class_type][self.powertype] + self.total
				end
			end
		end
		
	--> restore e liga o ator com a sua shadow durante a inicializa��o
	
		function attribute_energy:r_onlyrefresh_shadow(actor)
		
			--> create uma shadow desse ator se ainda n�o tiver uma
				local overall_energy = _details.table_overall[3]
				local shadow = overall_energy._ActorTable[overall_energy._NameIndexTable[actor.name]]

				if (not shadow) then 
					shadow = overall_energy:CatchCombatant(actor.serial, actor.name, actor.flag_original, true)
					shadow.class = actor.class
					shadow.group = actor.group
				end
			
			--> restore a meta e indexes ao ator
				_details.refresh:r_attribute_energy(actor, shadow)
				shadow.powertype = actor.powertype
			
			--> targets
				for target_name, amount in _pairs(actor.targets) do
					shadow.targets[target_name] = 0
				end
			
			--> spells
				for spellid, ability in _pairs(actor.spells._ActorTable) do
					local ability_shadow = shadow.spells:CatchSpell(spellid, true, "SPELL_ENERGY", false)
					--> spell targets
					for target_name, amount in _pairs(ability.targets) do
						ability_shadow.targets[target_name] = 0
					end
				end

			return shadow
		end
	
		function attribute_energy:r_connect_shadow(actor, no_refresh)
		
			--> create uma shadow desse ator se ainda n�o tiver uma
				local overall_energy = _details.table_overall[3]
				local shadow = overall_energy._ActorTable[overall_energy._NameIndexTable[actor.name]]

				if (not shadow) then 
					shadow = overall_energy:CatchCombatant(actor.serial, actor.name, actor.flag_original, true)
					shadow.class = actor.class
					shadow.group = actor.group
				end
			
			--> restore a meta e indexes ao ator
				if (not no_refresh) then
					_details.refresh:r_attribute_energy(actor, shadow)
				end
			
			--> total das energias(captura de dados)
				shadow.total = shadow.total + actor.total
				shadow.received = shadow.received + actor.received

				if (not actor.powertype) then
					print("actor without powertype", actor.name, actor.powertype)
				end

				shadow.powertype = actor.powertype
				
			--> total no combat overall(captura de dados)
				_details.table_overall.totals[3][actor.powertype] = _details.table_overall.totals[3][actor.powertype] + actor.total

				if (actor.group) then
					_details.table_overall.totals_group[3][actor.powertype] = _details.table_overall.totals_group[3][actor.powertype] + actor.total
				end

			--> targets
				for target_name, amount in _pairs(actor.targets) do
					shadow.targets[target_name] = (shadow.targets[target_name] or 0) + amount
				end
			
			--> spells
				for spellid, ability in _pairs(actor.spells._ActorTable) do

					local ability_shadow = shadow.spells:CatchSpell(spellid, true, "SPELL_ENERGY", false)

					ability_shadow.total = ability_shadow.total + ability.total
					ability_shadow.counter = ability_shadow.counter + ability.counter

					--> spell targets
					for target_name, amount in _pairs(ability.targets) do
						ability_shadow.targets[target_name] = (ability_shadow.targets[target_name] or 0) + amount
					end
				end

			return shadow
		end

function attribute_energy:CollectGarbage(lastevent)
	return _details:CollectGarbage(class_type, lastevent)
end

function _details.refresh:r_attribute_energy(this_player, shadow)
	_setmetatable(this_player, _details.attribute_energy)
	this_player.__index = _details.attribute_energy

	this_player.shadow = shadow
	_details.refresh:r_container_abilities(this_player.spells, shadow.spells)

	if (not shadow.powertype) then
		shadow.powertype = this_player.powertype
	end
end

function _details.clear:c_attribute_energy(this_player)
	this_player.__index = nil
	this_player.shadow = nil
	this_player.links = nil
	this_player.my_bar = nil

	_details.clear:c_container_abilities(this_player.spells)
end

attribute_energy.__add = function(table1, table2)

	if (not table1.powertype) then
		table1.powertype = table2.powertype
	end

	--> total and received
		table1.total = table1.total + table2.total
		table1.received = table1.received + table2.received

	--> targets
		for target_name, amount in _pairs (table2.targets) do
			table1.targets[target_name] = (table1.targets[target_name] or 0) + amount
		end
	
	--> spells
		for spellid, ability in _pairs (table2.spells._ActorTable) do 

			local ability_table1 = table1.spells:CatchSpell(spellid, true, "SPELL_ENERGY", false)

			ability_table1.total = ability_table1.total + ability.total
			ability_table1.counter = ability_table1.counter + ability.counter

			--> spell targets
			for target_name, amount in _pairs(ability.targets) do
				ability_table1.targets[target_name] = (ability_table1.targets[target_name] or 0) + amount
			end
		end
	
	return table1
end

attribute_energy.__sub = function(table1, table2)

	if (not table1.powertype) then
		table1.powertype = table2.powertype
	end

	--> total and received
		table1.total = table1.total - table2.total
		table1.received = table1.received - table2.received

	--> targets
		for target_name, amount in _pairs(table2.targets) do
			if (table1.targets[target_name]) then
				table1.targets[target_name] = table1.targets[target_name] - amount
			end
		end
	
	--> spells
		for spellid, ability in _pairs(table2.spells._ActorTable) do
			local ability_table1 = table1.spells:CatchSpell(spellid, true, "SPELL_ENERGY", false)

			ability_table1.total = ability_table1.total - ability.total
			ability_table1.counter = ability_table1.counter - ability.counter

			--> spell targets
			for target_name, amount in _pairs(ability.targets) do
				if (ability_table1.targets[target_name]) then
					ability_table1.targets[target_name] = ability_table1.targets[target_name] - amount
				end
			end
		end

	return table1
end
