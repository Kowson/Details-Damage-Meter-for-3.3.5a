--> details main objects
local _details = 		_G._details
local gump = 			_details.gump
local _
local _rawset = rawset --> lua local
local _rawget = rawget --> lua local
local _setmetatable = setmetatable --> lua local
local _unpack = unpack --> lua local
local _type = type --> lua local
local _math_floor = math.floor --> lua local
local loadstring = loadstring --> lua local
local _string_len = string.len --> lua local

local cleanfunction = function() end
local APITextEntryFunctions = false
local TextEntryMetaFunctions = {}

------------------------------------------------------------------------------------------------------------
--> metatables

	TextEntryMetaFunctions.__call = function(_table, value)
		--> unknow
	end
	
------------------------------------------------------------------------------------------------------------
--> members

	--> tooltip
	local gmember_tooltip = function(_object)
		return _object:GetTooltip()
	end
	--> shown
	local gmember_shown = function(_object)
		return _object:IsShown()
	end
	--> frame width
	local gmember_width = function(_object)
		return _object.editbox:GetWidth()
	end
	--> frame height
	local gmember_height = function(_object)
		return _object.editbox:GetHeight()
	end
	--> get text
	local gmember_text = function(_object)
		return _object.editbox:GetText()
	end

	local get_members_function_index = {
		["tooltip"] = gmember_tooltip,
		["shown"] = gmember_shown,
		["width"] = gmember_width,
		["height"] = gmember_height,
		["text"] = gmember_text,
	}

	TextEntryMetaFunctions.__index = function(_table, _member_requested)

		local func = get_members_function_index[_member_requested]
		if (func) then
			return func(_table, _member_requested)
		end
		
		local fromMe = _rawget(_table, _member_requested)
		if (fromMe) then
			return fromMe
		end
		
		return TextEntryMetaFunctions[_member_requested]
	end
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	--> tooltip
	local smember_tooltip = function(_object, _value)
		return _object:SetTooltip(_value)
	end
	--> show
	local smember_show = function(_object, _value)
		if (_value) then
			return _object:Show()
		else
			return _object:Hide()
		end
	end
	--> hide
	local smember_hide = function(_object, _value)
		if (not _value) then
			return _object:Show()
		else
			return _object:Hide()
		end
	end	
	--> frame width
	local smember_width = function(_object, _value)
		return _object.editbox:SetWidth(_value)
	end
	--> frame height
	local smember_height = function(_object, _value)
		return _object.editbox:SetHeight(_value)
	end
	--> set text
	local smember_text = function(_object, _value)
		return _object.editbox:SetText(_value)
	end
	--> set multiline
	local smember_multiline = function(_object, _value)
		if (_value) then
			return _object.editbox:SetMultiLine(true)
		else
			return _object.editbox:SetMultiLine(false)
		end
	end
	--> text horizontal pos
	local smember_horizontalpos = function(_object, _value)
		return _object.editbox:SetJustifyH(string.lower(_value))
	end
	
	local set_members_function_index = {
		["tooltip"] = smember_tooltip,
		["show"] = smember_show,
		["hide"] = smember_hide,
		["width"] = smember_width,
		["height"] = smember_height,
		["text"] = smember_text,
		["multiline"] = smember_multiline,
		["align"] = smember_horizontalpos,
	}
	
	TextEntryMetaFunctions.__newindex = function(_table, _key, _value)
		local func = set_members_function_index[_key]
		if (func) then
			return func(_table, _value)
		else
			return _rawset(_table, _key, _value)
		end
	end

------------------------------------------------------------------------------------------------------------
--> methods

--> set point
	function TextEntryMetaFunctions:SetPoint(MyAnchor, SnapTo, HisAnchor, x, y, Width)
	
		if (type(MyAnchor) == "boolean" and MyAnchor and self.space) then
			local textWidth = self.label:GetStringWidth()+2
			self.editbox:SetWidth(self.space - textWidth - 15)
			return
			
		elseif (type(MyAnchor) == "boolean" and MyAnchor and not self.space) then
			self.space = self.label:GetStringWidth()+2 + self.editbox:GetWidth()
		end
		
		if (Width) then
			self.space = Width
		end
		
		MyAnchor, SnapTo, HisAnchor, x, y = gump:CheckPoints(MyAnchor, SnapTo, HisAnchor, x, y, self)
		if (not MyAnchor) then
			print("Invalid parameter for SetPoint")
			return
		end
	
		if (self.space) then
			self.label:ClearAllPoints()
			self.editbox:ClearAllPoints()
			
			self.label:SetPoint(MyAnchor, SnapTo, HisAnchor, x, y)
			self.editbox:SetPoint("left", self.label, "right", 2, 0)
			
			local textWidth = self.label:GetStringWidth()+2
			self.editbox:SetWidth(self.space - textWidth - 15)
		else
			self.label:ClearAllPoints()
			self.editbox:ClearAllPoints()
			self.editbox:SetPoint(MyAnchor, SnapTo, HisAnchor, x, y)
		end

	end
	
--> frame levels
	function TextEntryMetaFunctions:GetFrameLevel()
		return self.editbox:GetFrameLevel()
	end
	function TextEntryMetaFunctions:SetFrameLevel(level, frame)
		if (not frame) then
			return self.editbox:SetFrameLevel(level)
		else
			local framelevel = frame:GetFrameLevel(frame) + level
			return self.editbox:SetFrameLevel(framelevel)
		end
	end

--> select all text
	function TextEntryMetaFunctions:SelectAll()
		self.editbox:HighlightText()
	end
	
--> set labal description
	function TextEntryMetaFunctions:SetLabelText(text)
		if (text) then
			self.label:SetText(text)
		else
			self.label:SetText("")
		end
		self:SetPoint(true) --> refresh
	end

--> set tab order
	function TextEntryMetaFunctions:SetNext(nextbox)
		self.next = nextbox
	end
	
--> blink
	function TextEntryMetaFunctions:Blink()
		self.label:SetTextColor(1, .2, .2, 1)
	end	
	
--> show & hide
	function TextEntryMetaFunctions:IsShown()
		return self.editbox:IsShown()
	end
	function TextEntryMetaFunctions:Show()
		return self.editbox:Show()
	end
	function TextEntryMetaFunctions:Hide()
		return self.editbox:Hide()
	end
	
-- tooltip
	function TextEntryMetaFunctions:SetTooltip(tooltip)
		if (tooltip) then
			return _rawset(self, "have_tooltip", tooltip)
		else
			return _rawset(self, "have_tooltip", nil)
		end
	end
	function TextEntryMetaFunctions:GetTooltip()
		return _rawget(self, "have_tooltip")
	end
	
--> hooks
	function TextEntryMetaFunctions:SetHook(hookType, func)
		if (func) then
			_rawset(self, hookType.."Hook", func)
		else
			_rawset(self, hookType.."Hook", nil)
		end
	end
	
	function TextEntryMetaFunctions:Enable()
		--if (not self.editbox:IsEnabled()) then
		--	self.editbox:Enable()
			self.editbox:SetBackdropBorderColor(unpack(self.enabled_border_color))
			self.editbox:SetBackdropColor(unpack(self.enabled_backdrop_color))
			self.editbox:SetTextColor(unpack(self.enabled_text_color))
		--end
	end
	
	function TextEntryMetaFunctions:Disable()
		--if (self.editbox:IsEnabled()) then
			self.enabled_border_color = {self.editbox:GetBackdropBorderColor()}
			self.enabled_backdrop_color = {self.editbox:GetBackdropColor()}
			self.enabled_text_color = {self.editbox:GetTextColor()}

		--	self.editbox:Disable()

			self.editbox:SetBackdropBorderColor(.5, .5, .5, .5)
			self.editbox:SetBackdropColor(.5, .5, .5, .5)
			self.editbox:SetTextColor(.5, .5, .5, .5)
		--end
	end
	
------------------------------------------------------------------------------------------------------------
--> scripts
	local OnEnter = function(textentry)

		if (textentry.MyObject.OnEnterHook) then
			local interrupt = textentry.MyObject.OnEnterHook(textentry)
			if (interrupt) then
				return
			end
		end
	
		if (textentry.MyObject.have_tooltip) then 
			_details:CooltipPreset(2)
			GameCooltip:AddLine(textentry.MyObject.have_tooltip)
			GameCooltip:ShowCooltip(textentry, "tooltip")
		end
		
		textentry.mouse_over = true 

		--if (textentry:IsEnabled()) then 
			textentry.current_bordercolor = textentry.current_bordercolor or {textentry:GetBackdropBorderColor()}
			textentry:SetBackdropBorderColor(1, 1, 1, 1)
		--end
		
		local parent = textentry:GetParent().MyObject
		if (parent and parent.type == "panel") then
			if (parent.GradientEnabled) then
				parent:RunGradient()
			end
		end
		
	end
	
	local OnLeave = function(textentry)
		if (textentry.MyObject.OnLeaveHook) then
			local interrupt = textentry.MyObject.OnLeaveHook(textentry)
			if (interrupt) then
				return
			end
		end
	
		if (textentry.MyObject.have_tooltip) then 
			_details.popup:ShowMe(false)
		end
		
		textentry.mouse_over = false 
		
		--if (textentry:IsEnabled()) then 
			textentry:SetBackdropBorderColor(unpack(textentry.current_bordercolor))
		--end
		
		local parent = textentry:GetParent().MyObject
		if (parent and parent.type == "panel") then
			if (parent.GradientEnabled) then
				parent:RunGradient(false)
			end
		end
	end
	
	local OnHide = function(textentry)
		if (textentry.MyObject.OnHideHook) then
			local interrupt = textentry.MyObject.OnHideHook(textentry)
			if (interrupt) then
				return
			end
		end
	end
	
	local OnShow = function(textentry)
		if (textentry.MyObject.OnShowHook) then
			local interrupt = textentry.MyObject.OnShowHook(textentry)
			if (interrupt) then
				return
			end
		end
	end

	local OnEnterPressed = function(textentry, byScript) 
	
		if (textentry.MyObject.OnEnterPressedHook) then
			local interrupt = textentry.MyObject.OnEnterPressedHook(textentry)
			if (interrupt) then
				return
			end
		end
	
		local text = _details:trim(textentry:GetText())
		if (_string_len(text) > 0) then 
			textentry.text = text
			if (textentry.MyObject.func) then 
				textentry.MyObject.func(textentry.MyObject.param1, textentry.MyObject.param2, text, textentry, byScript or textentry)
			end
		else
			textentry:SetText("")
			textentry.MyObject.currenttext = ""
		end
		textentry.focuslost = true --> lost_focus isso aqui pra quando estiver editando e clicar em outra caixa
		textentry:ClearFocus()
		
		if (textentry.MyObject.tab_on_enter and textentry.MyObject.next) then
			textentry.MyObject.next:SetFocus()
		end
	end
	
	local OnEscapePressed = function(textentry)
	
		if (textentry.MyObject.OnEscapePressedHook) then
			local interrupt = textentry.MyObject.OnEscapePressedHook(textentry)
			if (interrupt) then
				return
			end
		end
	
		--textentry:SetText("") 
		--textentry.MyObject.currenttext = ""
		textentry.focuslost = true
		textentry:ClearFocus() 
	end
	
	local OnEditFocusLost = function(textentry)

		if (textentry:IsShown()) then
		
			if (textentry.MyObject.OnEditFocusLostHook) then
				local interrupt = textentry.MyObject.OnEditFocusLostHook(textentry)
				if (interrupt) then
					return
				end
			end
		
			if (not textentry.focuslost) then
				local text = _details:trim(textentry:GetText())
				if (_string_len(text) > 0) then 
					textentry.MyObject.currenttext = text
					if (textentry.MyObject.func) then 
						textentry.MyObject.func(textentry.MyObject.param1, textentry.MyObject.param2, text, textentry, nil)
					end
				else 
					textentry:SetText("") 
					textentry.MyObject.currenttext = ""
				end 
			else
				textentry.focuslost = false
			end
			
			textentry.MyObject.label:SetTextColor(.8, .8, .8, 1)

		end
	end
	
	local OnEditFocusGained = function(textentry)
		if (textentry.MyObject.OnEditFocusGainedHook) then
			local interrupt = textentry.MyObject.OnEditFocusGainedHook(textentry)
			if (interrupt) then
				return
			end
		end
		textentry.MyObject.label:SetTextColor(1, 1, 1, 1)
	end
	
	local OnChar = function(textentry, text) 
		if (textentry.MyObject.OnCharHook) then
			local interrupt = textentry.MyObject.OnCharHook(textentry, text)
			if (interrupt) then
				return
			end
		end
	end
	
	local OnTextChanged = function(textentry, byUser) 
		if (textentry.MyObject.OnTextChangedHook) then
			local interrupt = textentry.MyObject.OnTextChangedHook(textentry, byUser)
			if (interrupt) then
				return
			end
		end
	end
	
	local OnTabPressed = function(textentry) 
		if (textentry.MyObject.OnTabPressedHook) then
			local interrupt = textentry.MyObject.OnTabPressedHook(textentry, byUser)
			if (interrupt) then
				return
			end
		end
		
		if (textentry.MyObject.next) then 
			OnEnterPressed(textentry, false)
			textentry.MyObject.next:SetFocus()
		end
	end
	
	function TextEntryMetaFunctions:PressEnter(byScript)
		OnEnterPressed(self.editbox, byScript)
	end
	
------------------------------------------------------------------------------------------------------------
--> object constructor

function gump:NewTextEntry(parent, container, name, member, w, h, func, param1, param2, space)
	
	if (not name) then
		return nil
	elseif (not parent) then
		return nil
	end
	if (not container) then
		container = parent
	end
	
	if (name:find("$parent")) then
		name = name:gsub("$parent", parent:GetName())
	end
	
	local TextEntryObject = {type = "textentry", dframework = true}
	
	if (member) then
		parent[member] = TextEntryObject
	end

	if (parent.dframework) then
		parent = parent.widget
	end
	if (container.dframework) then
		container = container.widget
	end
	
	--> default members:
		--> hooks
		TextEntryObject.OnEnterHook = nil
		TextEntryObject.OnLeaveHook = nil
		TextEntryObject.OnHideHook = nil
		TextEntryObject.OnShowHook = nil
		TextEntryObject.OnEnterPressedHook = nil
		TextEntryObject.OnEscapePressedHook = nil
		TextEntryObject.OnEditFocusGainedHook = nil
		TextEntryObject.OnEditFocusLostHook = nil
		TextEntryObject.OnCharHook = nil
		TextEntryObject.OnTextChangedHook = nil
		TextEntryObject.OnTabPressedHook = nil

		--> misc
		TextEntryObject.container = container
		TextEntryObject.have_tooltip = nil

	TextEntryObject.editbox = CreateFrame("EditBox", name, parent, "DetailsEditBoxTemplate2")
	TextEntryObject.widget = TextEntryObject.editbox
	
	TextEntryObject.editbox:SetTextInsets(3, 0, 0, -3)

	if (not APITextEntryFunctions) then
		APITextEntryFunctions = true
		local idx = getmetatable(TextEntryObject.editbox).__index
		for funcName, funcAddress in pairs(idx) do 
			if (not TextEntryMetaFunctions[funcName]) then
				TextEntryMetaFunctions[funcName] = function(object, ...)
					local x = loadstring( "return _G."..object.editbox:GetName()..":"..funcName.."(...)")
					return x(...)
				end
			end
		end
	end
	
	TextEntryObject.editbox.MyObject = TextEntryObject
	
	if (not w and space) then
		w = space
	elseif (w and space) then
		if (gump.debug) then
			print("warning: you are using width and space, try use only space for better results.")
		end
	end
	
	TextEntryObject.editbox:SetWidth(w)
	TextEntryObject.editbox:SetHeight(h)

	TextEntryObject.editbox:SetJustifyH("center")
	TextEntryObject.editbox:EnableMouse(true)
	TextEntryObject.editbox:SetText("")

	TextEntryObject.editbox:SetAutoFocus(false)
	TextEntryObject.editbox:SetFontObject("GameFontNormalSmall")

	TextEntryObject.editbox.current_bordercolor = {1, 1, 1, 0.7}
	TextEntryObject.editbox:SetBackdropBorderColor(1, 1, 1, 0.7)
	TextEntryObject.enabled_border_color = {TextEntryObject.editbox:GetBackdropBorderColor()}
	TextEntryObject.enabled_backdrop_color = {TextEntryObject.editbox:GetBackdropColor()}
	TextEntryObject.enabled_text_color = {TextEntryObject.editbox:GetTextColor()}
	
	TextEntryObject.func = func
	TextEntryObject.param1 = param1
	TextEntryObject.param2 = param2
	TextEntryObject.next = nil
	TextEntryObject.space = space
	TextEntryObject.tab_on_enter = false
	
	TextEntryObject.label = _G[name .. "_Desc"]
	
	--> hooks
		TextEntryObject.editbox:SetScript("OnEnter", OnEnter)
		TextEntryObject.editbox:SetScript("OnLeave", OnLeave)
		TextEntryObject.editbox:SetScript("OnHide", OnHide)
		TextEntryObject.editbox:SetScript("OnShow", OnShow)
		
		TextEntryObject.editbox:SetScript("OnEnterPressed", OnEnterPressed)
		TextEntryObject.editbox:SetScript("OnEscapePressed", OnEscapePressed)
		TextEntryObject.editbox:SetScript("OnEditFocusLost", OnEditFocusLost)
		TextEntryObject.editbox:SetScript("OnEditFocusGained", OnEditFocusGained)
		TextEntryObject.editbox:SetScript("OnChar", OnChar)
		TextEntryObject.editbox:SetScript("OnTextChanged", OnTextChanged)
		TextEntryObject.editbox:SetScript("OnTabPressed", OnTabPressed)
		
	_setmetatable(TextEntryObject, TextEntryMetaFunctions)
	
	return TextEntryObject	
	
end

local SpellEntryOnEditFocusGained = 	function(self)
	local start_build_cache = _details:BuildSpellListSlow()
	if (start_build_cache) then
		DetailsLoadSpellCacheProgress:SetPoint("left", self, "right", 2, 0)
	end
end

local SpellEntryOnClickMenu = function(_, _, SpellID, editbox)
	editbox:SetText(SpellID)
	editbox:PressEnter()
	editbox.HaveMenu = false
	GameCooltip:ShowMe(false)
end

local SpellEntryOnTextChanged = function(editbox, userChanged)

	if (not userChanged) then
		return
	elseif (not _details.spellcachefull) then
		return
	end
	
	editbox = editbox.MyObject
	
	local text = editbox:GetText()
	text = _details:trim(text)
	text = string.lower(text)
	
	local LetterIndex = string.sub(text, 1, 1)
	local LetterIndex_CacheContainer = _details.spellcachefull[LetterIndex]
	
	if (LetterIndex_CacheContainer) then
	
		local GameCooltip = _G.GameCooltip
	
		_details:CooltipPreset(1)
		GameCooltip:SetType("menu")
		GameCooltip:SetOwner(editbox.widget)
		GameCooltip:SetOption("NoLastSelectedBar", true)
		GameCooltip:SetOption("TextSize", 9)
		
		local i = 1

		for SpellID, SpellTable in pairs(LetterIndex_CacheContainer) do 
			if (string.lower(SpellTable[1]):find(text)) then 
			
				GameCooltip:AddMenu(1, SpellEntryOnClickMenu, SpellID, editbox, nil, SpellID..": "..SpellTable[1], SpellTable[2], true)
				
				if (i > 20) then
					break
				else
					i = i + 1
				end
			end
		end
		
		editbox.HaveMenu = true
		GameCooltip.buttonOver = true
		GameCooltip:ShowCooltip()
	end
	
end

function gump:NewSpellEntry(parent, func, w, h, param1, param2, member, name)
	local editbox = gump:NewTextEntry(parent, parent, name, member, w, h, func, param1, param2)
	
	editbox:SetHook("OnEditFocusGained", SpellEntryOnEditFocusGained)
	editbox:SetHook("OnTextChanged", SpellEntryOnTextChanged)
	
	return editbox	
end


local function_gettext = function(self)
	return self.editbox:GetText()
end
local function_settext = function(self, text)
	return self.editbox:SetText(text)
end
local function_clearfocus = function(self)
	return self.editbox:ClearFocus()
end
local function_setfocus = function(self)
	return self.editbox:SetFocus(true)
end

function gump:NewSpecialLuaEditorEntry(parent, w, h, member, name, nointent)
	
	if (name:find("$parent")) then
		name = name:gsub("$parent", parent:GetName())
	end
	
	local borderframe = CreateFrame("Frame", name, parent)
	borderframe:SetSize(w, h)

	if (member) then
		parent[member] = borderframe
	end
	
	local scrollframe = CreateFrame("ScrollFrame", name, borderframe, "DetailsEditBoxMultiLineTemplate")

	scrollframe:SetScript("OnSizeChanged", function(self)
		scrollframe.editbox:SetSize(self:GetSize())
	end)
	
	scrollframe:SetPoint("topleft", borderframe, "topleft", 10, -10)
	scrollframe:SetPoint("bottomright", borderframe, "bottomright", -30, 10)
	
	scrollframe.editbox:SetMultiLine(true)
	scrollframe.editbox:SetJustifyH("left")
	scrollframe.editbox:SetJustifyV("top")
	scrollframe.editbox:SetMaxBytes(1024000)
	scrollframe.editbox:SetMaxLetters(128000)
	
	borderframe.GetText = function_gettext
	borderframe.SetText = function_settext
	borderframe.ClearFocus = function_clearfocus
	borderframe.SetFocus = function_setfocus
	
	if (not nointent) then
		IndentationLib.enable(scrollframe.editbox, nil, 4)
	end
	
	borderframe:SetBackdrop({bgFile =[[Interface\Tooltips\UI-Tooltip-Background]], edgeFile =[[Interface\Tooltips\UI-Tooltip-Border]], 
		tile = 1, tileSize = 16, edgeSize = 16, insets = {left = 5, right = 5, top = 5, bottom = 5}})
	borderframe:SetBackdropColor(0.090195, 0.090195, 0.188234, 1)
	borderframe:SetBackdropBorderColor(1, 1, 1, 1)
	
	borderframe.scroll = scrollframe
	borderframe.editbox = scrollframe.editbox
	
	return borderframe
end