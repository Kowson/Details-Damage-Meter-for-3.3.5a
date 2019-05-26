--> details main objects
local _details = 		_G._details
local gump = 			_details.gump
local _
local _rawset = rawset --> lua locals
local _rawget = rawget --> lua locals
local _setmetatable = setmetatable --> lua locals
local _unpack = unpack --> lua locals
local _type = type --> lua locals
local _math_floor = math.floor --> lua locals

local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")

local cleanfunction = function() end
local BarMetaFunctions = {}
local APIBarFunctions

------------------------------------------------------------------------------------------------------------
--> metatables

	BarMetaFunctions.__call = function(_table, value)
		if (not value) then
			return _table.statusbar:GetValue()
		else
			return _table.statusbar:SetValue(value)
		end
	end

	BarMetaFunctions.__add = function(v1, v2) 
		if (_type(v1) == "table") then
			local v = v1.statusbar:GetValue()
			v = v + v2
			v1.statusbar:SetValue(v)
		else
			local v = v2.statusbar:GetValue()
			v = v + v1
			v2.statusbar:SetValue(v)
		end
	end

	BarMetaFunctions.__sub = function(v1, v2) 
		if (_type(v1) == "table") then
			local v = v1.statusbar:GetValue()
			v = v - v2
			v1.statusbar:SetValue(v)
		else
			local v = v2.statusbar:GetValue()
			v = v - v1
			v2.statusbar:SetValue(v)
		end
	end

------------------------------------------------------------------------------------------------------------
--> members

	--> tooltip
	local function gmember_tooltip(_object)
		return _object:GetTooltip()
	end
	--> shown
	local gmember_shown = function(_object)
		return _object.statusbar:IsShown()
	end
	--> frame width
	local gmember_width = function(_object)
		return _object.statusbar:GetWidth()
	end
	--> frame height
	local gmember_height = function(_object)
		return _object.statusbar:GetHeight()
	end
	--> value
	local gmember_value = function(_object)
		return _object.statusbar:GetValue()
	end
	--> right text
	local gmember_rtext = function(_object)
		return _object.textright:GetText()
	end
	--> left text
	local gmember_ltext = function(_object)
		return _object.textleft:GetText()
	end
	--> left color
	local gmember_color = function(_object)
		return _object._texture.original_colors
	end
	--> icon
	local gmember_icon = function(_object)
		return _object._icon:GetTexture()
	end
	--> texture
	local gmember_texture = function(_object)
		return _object._texture:GetTexture()
	end	
	--> font size
	local gmember_textsize = function(_object)
		local _, fontsize = _object.textleft:GetFont()
		return fontsize
	end
	--> font face
	local gmember_textfont = function(_object)
		local fontface = _object.textleft:GetFont()
		return fontface
	end
	--> font color
	local gmember_textcolor = function(_object)
		return _object.textleft:GetTextColor()
	end

	local get_members_function_index = {
		["tooltip"] = gmember_tooltip,
		["shown"] = gmember_shown,
		["width"] = gmember_width,
		["height"] = gmember_height,
		["value"] = gmember_value,
		["lefttext"] = gmember_ltext,
		["righttext"] = gmember_rtext,
		["color"] = gmember_color,
		["icon"] = gmember_icon,
		["texture"] = gmember_texture,
		["fontsize"] = gmember_textsize,
		["fontface"] = gmember_textfont,
		["fontcolor"] = gmember_textcolor,
		["textsize"] = gmember_textsize, --alias
		["textfont"] = gmember_textfont, --alias
		["textcolor"] = gmember_textcolor --alias
	}
	
	BarMetaFunctions.__index = function(_table, _member_requested)

		local func = get_members_function_index[_member_requested]
		if (func) then
			return func(_table, _member_requested)
		end
		
		local fromMe = _rawget(_table, _member_requested)
		if (fromMe) then
			return fromMe
		end
		
		return BarMetaFunctions[_member_requested]
	end
	
	
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


	--> tooltip
	local smember_tooltip = function(_object, _value)
		return _object:SetTooltip(_value)
	end
	--> show
	local smember_shown = function(_object, _value)
		if (_value) then
			return _object:Show()
		else
			return _object:Hide()
		end
	end
	--> hide
	local smember_hide = function(_object, _value)
		if (_value) then
			return _object:Hide()
		else
			return _object:Show()
		end
	end
	--> width
	local smember_width = function(_object, _value)
		return _object.statusbar:SetWidth(_value)
	end
	--> height
	local smember_height = function(_object, _value)
		return _object.statusbar:SetHeight(_value)
	end
	--> statusbar value
	local smember_value = function(_object, _value)
		_object.statusbar:SetValue(_value)
		return _object.div:SetPoint("left", _object.statusbar, "left", _value *(_object.statusbar:GetWidth()/100) - 16, 0)
	end
	--> right text
	local smember_rtext = function(_object, _value)
		return _object.textright:SetText(_value)
	end
	--> left text
	local smember_ltext = function(_object, _value)
		return _object.textleft:SetText(_value)
	end
	--> color
	local smember_color = function(_object, _value)
		local _value1, _value2, _value3, _value4 = gump:ParseColors(_value)
		
		_object.statusbar:SetStatusBarColor(_value1, _value2, _value3, _value4)
		_object._texture.original_colors = {_value1, _value2, _value3, _value4}
		return _object._texture:SetVertexColor(_value1, _value2, _value3, _value4)
	end
	--> icon
	local smember_icon = function(_object, _value)
		if (type(_value) == "table") then
			local _value1, _value2 = _unpack(_value)
			_object._icon:SetTexture(_value1)
			if (_value2) then
				_object._icon:SetTexCoord(_unpack(_value2))
			end
		else
			_object._icon:SetTexture(_value)
		end
		return
	end
	--> texture
	local smember_texture = function(_object, _value)
		if (type(_value) == "table") then
			local _value1, _value2 = _unpack(_value)
			_object._texture:SetTexture(_value1)
			if (_value2) then
				_object._texture:SetTexCoord(_unpack(_value2))
			end
		else
			if (_value:find("\\")) then
				_object._texture:SetTexture(_value)
			else
				local file = SharedMedia:Fetch("statusbar", _value)
				if (file) then
					_object._texture:SetTexture(file)
				else
					_object._texture:SetTexture(_value)
				end
			end
		end
		return
	end
	--> font face
	local smember_textfont = function(_object, _value)
		_details:SetFontFace(_object.textleft, _value)
		return _details:SetFontFace(_object.textright, _value)
	end
	--> font size
	local smember_textsize = function(_object, _value)
		_details:SetFontSize(_object.textleft, _value)
		return _details:SetFontSize(_object.textright, _value)
	end
	--> font color
	local smember_textcolor = function(_object, _value)
		local _value1, _value2, _value3, _value4 = gump:ParseColors(_value)
		_object.textleft:SetTextColor(_value1, _value2, _value3, _value4)
		return _object.textright:SetTextColor(_value1, _value2, _value3, _value4)
	end
	--> outline(shadow)
	local smember_outline = function(_object, _value)
		_details:SetFontOutline(_object.textleft, _value)
		return _details:SetFontOutline(_object.textright, _value)
	end

	local set_members_function_index = {
		["tooltip"] = smember_tooltip,
		["shown"] = smember_shown,
		["width"] = smember_width,
		["height"] = smember_height,
		["value"] = smember_value,
		["righttext"] = smember_rtext,
		["lefttext"] = smember_ltext,
		["color"] = smember_color,
		["icon"] = smember_icon,
		["texture"] = smember_texture,
		["fontsize"] = smember_textsize,
		["fontface"] = smember_textfont,
		["fontcolor"] = smember_textcolor,
		["textsize"] = smember_textsize, --alias
		["textfont"] = smember_textfont, --alias
		["textcolor"] = smember_textcolor, --alias
		["shadow"] = smember_outline,
		["outline"] = smember_outline, --alias
	}
	
	BarMetaFunctions.__newindex = function(_table, _key, _value)
	
		local func = set_members_function_index[_key]
		if (func) then
			return func(_table, _value)
		else
			return _rawset(_table, _key, _value)
		end
	end

------------------------------------------------------------------------------------------------------------
--> methods

--> show & hide
	function BarMetaFunctions:Show()
		self.statusbar:Show()
	end
	function BarMetaFunctions:Hide()
		self.statusbar:Hide()
	end

--> set value(status bar)
	function BarMetaFunctions:SetValue(value)
		if (not value) then
			value = 0
		end
		self.statusbar:SetValue(value)
		self.div:SetPoint("left", self.statusbar, "left", value *(self.statusbar:GetWidth()/100) - 16, 0)
	end
	
--> set point
	function BarMetaFunctions:SetPoint(v1, v2, v3, v4, v5)
		v1, v2, v3, v4, v5 = gump:CheckPoints(v1, v2, v3, v4, v5, self)
		if (not v1) then
			print("Invalid parameter for SetPoint")
			return
		end
		return self.widget:SetPoint(v1, v2, v3, v4, v5)
	end
	
--> set sizes
	function BarMetaFunctions:SetSize(w, h)
		if (w) then
			self.statusbar:SetWidth(w)
		end
		if (h) then
			self.statusbar:SetHeight(h)
		end
	end

--> set texture
	function BarMetaFunctions:SetTexture(texture)
		self._texture:SetTexture(texture)
	end
	
--> set texts
	function BarMetaFunctions:SetLeftText(text)
		self.textleft:SetText(text)
	end
	function BarMetaFunctions:SetRightText(text)
		self.textright:SetText(text)
	end
	
--> set color
	function BarMetaFunctions:SetColor(r, g, b, a)
		r, g, b, a = gump:ParseColors(r, g, b, a)
		
		self._texture:SetVertexColor(r, g, b, a)
		self.statusbar:SetStatusBarColor(r, g, b, a)
		self._texture.original_colors = {r, g, b, a}
	end
	
--> set icons
	function BarMetaFunctions:SetIcon(texture, ...)
		self._icon:SetTexture(texture)
		if (...) then
			local L, R, U, D = _unpack(...)
			self._icon:SetTexCoord(L, R, U, D)
		end
	end

--> show div
	function BarMetaFunctions:ShowDiv(bool)
		if (bool) then
			self.div:Show()
		else
			self.div:Hide()
		end
	end

-- tooltip
	function BarMetaFunctions:SetTooltip(tooltip)
		if (tooltip) then
			return _rawset(self, "have_tooltip", tooltip)
		else
			return _rawset(self, "have_tooltip", nil)
		end
	end
	function BarMetaFunctions:GetTooltip()
		return _rawget(self, "have_tooltip")
	end
	
-- frame levels
	function BarMetaFunctions:GetFrameLevel()
		return self.statusbar:GetFrameLevel()
	end
	function BarMetaFunctions:SetFrameLevel(level, frame)
		if (not frame) then
			return self.statusbar:SetFrameLevel(level)
		else
			local framelevel = frame:GetFrameLevel(frame) + level
			return self.statusbar:SetFrameLevel(framelevel)
		end
	end

-- frame stratas
	function BarMetaFunctions:SetFrameStrata()
		return self.statusbar:GetFrameStrata()
	end
	function BarMetaFunctions:SetFrameStrata(strata)
		if (_type(strata) == "table") then
			self.statusbar:SetFrameStrata(strata:GetFrameStrata())
		else
			self.statusbar:SetFrameStrata(strata)
		end
	end
	
--> container
	function BarMetaFunctions:SetContainer(container)
		self.container = container
	end
	
--> hooks
	function BarMetaFunctions:SetHook(hookType, func)
		if (func) then
			_rawset(self, hookType.."Hook", func)
		else
			_rawset(self, hookType.."Hook", nil)
		end
	end
	
------------------------------------------------------------------------------------------------------------
--> scripts

	local OnEnter = function(frame)
		if (frame.MyObject.OnEnterHook) then
			local interrupt = frame.MyObject.OnEnterHook(frame, frame.MyObject)
			if (interrupt) then
				return
			end
		end
		
		if (not frame.MyObject.timer) then
			local oc = frame.MyObject._texture.original_colors --original colors
			gump:GradientEffect( frame.MyObject._texture, "texture", oc[1], oc[2], oc[3], oc[4], oc[1]+0.2, oc[2]+0.2, oc[3]+0.2, oc[4], .2)
			frame.MyObject.div:Show()
			frame.MyObject.div:SetPoint("left", frame, "left", frame:GetValue() *(frame:GetWidth()/100) - 16, 0)
		else
			local oc = frame.MyObject._texture.original_colors --original colors
			gump:GradientEffect( frame.MyObject._texture, "texture", oc[1], oc[2], oc[3], oc[4], oc[1]-0.2, oc[2]-0.2, oc[3]-0.2, oc[4]+.2, .2)
		end
		
		frame.MyObject.background:Show()
		
		if (frame.MyObject.have_tooltip) then 
			GameCooltip:Reset()
			GameCooltip:AddLine(frame.MyObject.have_tooltip)
			GameCooltip:ShowCooltip(frame, "tooltip")
		end
		
		local parent = frame:GetParent().MyObject
		if (parent and parent.type == "panel") then
			if (parent.GradientEnabled) then
				parent:RunGradient()
			end
		end
		
	end
	
	local OnLeave = function(frame)
		if (frame.MyObject.OnLeaveHook) then
			local interrupt = frame.MyObject.OnLeaveHook(frame)
			if (interrupt) then
				return
			end
		end
		
		if (not frame.MyObject.timer) then
			local oc = frame.MyObject._texture.original_colors --original colors
			local r, g, b, a = frame.MyObject._texture:GetVertexColor()
			gump:GradientEffect( frame.MyObject._texture, "texture", r, g, b, a, oc[1], oc[2], oc[3], oc[4], .2)
			frame.MyObject.div:Hide()
			
			--frame.MyObject.background:Hide()
		else
			local oc = frame.MyObject.background.original_colors --original colors
			local r, g, b, a = frame.MyObject.background:GetVertexColor()
			gump:GradientEffect( frame.MyObject.background, "texture", r, g, b, a, oc[1], oc[2], oc[3], oc[4], .2)
		end
		
		if (frame.MyObject.have_tooltip) then 
			_details.popup:ShowMe(false)
		end
		
		local parent = frame:GetParent().MyObject
		if (parent and parent.type == "panel") then
			if (parent.GradientEnabled) then
				parent:RunGradient(false)
			end
		end
	end
	
	local OnHide = function(frame)
		if (frame.MyObject.OnHideHook) then
			local interrupt = frame.MyObject.OnHideHook(frame)
			if (interrupt) then
				return
			end
		end
	end
	
	local OnShow = function(frame)
		if (frame.MyObject.OnShowHook) then
			local interrupt = frame.MyObject.OnShowHook(frame)
			if (interrupt) then
				return
			end
		end
	end
	
	local OnMouseDown = function(frame, button)
		if (frame.MyObject.OnMouseDownHook) then
			local interrupt = frame.MyObject.OnMouseDownHook(frame, button)
			if (interrupt) then
				return
			end
		end
		
		if (not frame.MyObject.container.isLocked and frame.MyObject.container:IsMovable()) then
			if (not frame.isLocked and frame:IsMovable()) then
				frame.MyObject.container.isMoving = true
				frame.MyObject.container:StartMoving()
			end
		end
	end
	
	local OnMouseUp = function(frame, button)
		if (frame.MyObject.OnMouseUpHook) then
			local interrupt = frame.MyObject.OnMouseUpHook(frame, button)
			if (interrupt) then
				return
			end
		end
		
		if (frame.MyObject.container.isMoving) then
			frame.MyObject.container:StopMovingOrSizing()
			frame.MyObject.container.isMoving = false
		end
	end
	
------------------------------------------------------------------------------------------------------------
--> timer
	
	function BarMetaFunctions:OnTimerEnd()
		if (self.OnTimerEndHook) then
			local interrupt = self.OnTimerEndHook()
			if (interrupt) then
				return
			end
		end
		self.timer_texture:Hide()
		self.div_timer:Hide()
		self:Hide()
		self.timer = false
	end

	local OnUpdate = function(self, elapsed)
		local timepct =(elapsed / self.time) * 100
		self.c = self.c -(timepct*self.width/100)
		self.remaining = self.remaining - elapsed
		self.righttext:SetText(_math_floor(self.remaining))
		self.timertexture:SetWidth(self.c)
		if (self.c < 1) then
			self:SetScript("OnUpdate", nil)
			self.MyObject:OnTimerEnd()
		end
	end
	
	function BarMetaFunctions:SetTimer(time)

		self.statusbar.width = self.statusbar:GetWidth()
		self.statusbar.time = time
		self.statusbar.remaining = time
		self.statusbar.c = self.statusbar.width
		
		self.timer_texture:Show()
		self.timer_texture:SetWidth(self.statusbar.width)
		self.statusbar.t = self.timer_texture
		self(1)
		
		self.div_timer:Show()
		self.background:Show()
		
		self.timer = true
		
		self.statusbar:SetScript("OnUpdate", OnUpdate)
	end
	
------------------------------------------------------------------------------------------------------------
--> object constructor

function DetailsNormalBar_OnCreate(self)
	self.texture.original_colors = {1, 1, 1, 1}
	self.background.original_colors = {.3, .3, .3, .3}
	self.timertexture.original_colors = {.3, .3, .3, .3}
	return true
end

function gump:CreateBar(parent, texture, w, h, value, member, name)
	return gump:NewBar(parent, parent, name, member, w, h, value, texture)
end

function gump:NewBar(parent, container, name, member, w, h, value, texture_name)

	if (not name) then
		name = "DetailsBarNumber" .. gump.BarNameCounter
		gump.BarNameCounter = gump.BarNameCounter + 1

	elseif (not parent) then
		return nil
	elseif (not container) then
		container = parent
	end
	
	if (name:find("$parent")) then
		name = name:gsub("$parent", parent:GetName())
	end
	
	local BarObject = {type = "bar", dframework = true}
	
	if (member) then
		parent[member] = BarObject
	end
	
	if (parent.dframework) then
		parent = parent.widget
	end
	if (container.dframework) then
		container = container.widget
	end	
	
	value = value or 0
	w = w or 150
	h = h or 14

	--> default members:
		--> hooks
		BarObject.OnEnterHook = nil
		BarObject.OnLeaveHook = nil
		BarObject.OnHideHook = nil
		BarObject.OnShowHook = nil
		BarObject.OnMouseDownHook = nil
		BarObject.OnMouseUpHook = nil
		BarObject.OnTimerEndHook = nil
		--> misc
		BarObject.tooltip = nil
		BarObject.locked = false
		BarObject.have_tooltip = nil

	BarObject.container = container
	
	--> create widgets
		BarObject.statusbar = CreateFrame("statusbar", name, parent, "DetailsNormalBarTemplate")
		BarObject.widget = BarObject.statusbar
		
		if (not APIBarFunctions) then
			APIBarFunctions = true
			local idx = getmetatable(BarObject.statusbar).__index
			for funcName, funcAddress in pairs(idx) do 
				if (not BarMetaFunctions[funcName]) then
					BarMetaFunctions[funcName] = function(object, ...)
						local x = loadstring( "return _G."..object.statusbar:GetName()..":"..funcName.."(...)")
						return x(...)
					end
				end
			end
		end
		
		BarObject.statusbar:SetHeight(h)
		BarObject.statusbar:SetWidth(w)
		BarObject.statusbar:SetFrameLevel(parent:GetFrameLevel()+1)
		BarObject.statusbar:SetMinMaxValues(0, 100)
		BarObject.statusbar:SetValue(value or 50)
		BarObject.statusbar.MyObject = BarObject

		BarObject.timer_texture = _G[name .. "_timerTexture"]
		BarObject.timer_texture:SetWidth(w)
		BarObject.timer_texture:SetHeight(h)
		
		BarObject._texture = _G[name .. "_statusbarTexture"]
		BarObject.background = _G[name .. "_background"]
		BarObject._icon = _G[name .. "_icon"]
		BarObject.textleft = _G[name .. "_TextLeft"]
		BarObject.textright = _G[name .. "_TextRight"]
		BarObject.div = _G[name .. "_sparkMouseover"]
		BarObject.div_timer = _G[name .. "_sparkTimer"]
	
	--> hooks
		BarObject.statusbar:SetScript("OnEnter", OnEnter)
		BarObject.statusbar:SetScript("OnLeave", OnLeave)
		BarObject.statusbar:SetScript("OnHide", OnHide)
		BarObject.statusbar:SetScript("OnShow", OnShow)
		BarObject.statusbar:SetScript("OnMouseDown", OnMouseDown)
		BarObject.statusbar:SetScript("OnMouseUp", OnMouseUp)
		
	--> set class
		_setmetatable(BarObject, BarMetaFunctions)

	--> set texture
		if (texture_name) then
			smember_texture(BarObject, texture_name)
		end
		
	return BarObject
end
