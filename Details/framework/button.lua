--> details main objects
local _details = 		_G._details
local gump = 			_details.gump

local _rawset = rawset --> lua local
local _rawget = rawget --> lua local
local _setmetatable = setmetatable --> lua local
local _unpack = unpack --> lua local
local _type = type --> lua local
local _math_floor = math.floor --> lua local
local loadstring = loadstring --> lua local
local _
local cleanfunction = function() end
local APIButtonFunctions = false
local ButtonMetaFunctions = {}

------------------------------------------------------------------------------------------------------------
--> metatables

	ButtonMetaFunctions.__call = function(_table, value, ...)
		return self.func(_table.param1, _table.param2, value, ...)
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
		return _object.button:GetWidth()
	end
	--> frame height
	local gmember_height = function(_object)
		return _object.button:GetHeight()
	end
	--> text
	local gmember_text = function(_object)
		return _object.button.text:GetText()
	end
	--> function
	local gmember_function = function(_object)
		return _rawget(_object, "func")
	end
	--> text color
	local gmember_textcolor = function(_object)
		return _object.button.text:GetTextColor()
	end
	--> text font
	local gmember_textfont = function(_object)
		local fontface = _object.button.text:GetFont()
		return fontface
	end
	--> text size
	local gmember_textsize = function(_object)
		local _, fontsize = _object.button.text:GetFont()
		return fontsize
	end
	--> texture
	local gmember_texture = function(_object)
		return {_object.button:GetNormalTexture(), _object.button:GetHighlightTexture(), _object.button:GetPushedTexture(), _object.button:GetDisabledTexture()}
	end
	--> locked
	local gmember_locked = function(_object)
		return _rawget(_object, "is_locked")
	end

	local get_members_function_index = {
		["tooltip"] = gmember_tooltip,
		["shown"] = gmember_shown,
		["width"] = gmember_width,
		["height"] = gmember_height,
		["text"] = gmember_text,
		["clickfunction"] = gmember_function,
		["texture"] = gmember_texture,
		["locked"] = gmember_locked,
		["fontcolor"] = gmember_textcolor,
		["fontface"] = gmember_textfont,
		["fontsize"] = gmember_textsize,
		["textcolor"] = gmember_textcolor, --alias
		["textfont"] = gmember_textfont, --alias
		["textsize"] = gmember_textsize --alias
	}

	ButtonMetaFunctions.__index = function(_table, _member_requested)

		local func = get_members_function_index[_member_requested]
		if (func) then
			return func(_table, _member_requested)
		end
		
		local fromMe = _rawget(_table, _member_requested)
		if (fromMe) then
			return fromMe
		end
		
		return ButtonMetaFunctions[_member_requested]
	end
	
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
		return _object.button:SetWidth(_value)
	end
	--> frame height
	local smember_height = function(_object, _value)
		return _object.button:SetHeight(_value)
	end
	--> text
	local smember_text = function(_object, _value)
		return _object.button.text:SetText(_value)
	end
	--> function
	local smember_function = function(_object, _value)
		return _rawset(_object, "func", _value)
	end
	--> text color
	local smember_textcolor = function(_object, _value)
		local _value1, _value2, _value3, _value4 = gump:ParseColors(_value)
		return _object.button.text:SetTextColor(_value1, _value2, _value3, _value4)	
	end
	--> text font
	local smember_textfont = function(_object, _value)
		return _details:SetFontFace(_object.button.text, _value)
	end
	--> text size
	local smember_textsize = function(_object, _value)
		return _details:SetFontSize(_object.button.text, _value)
	end
	--> texture
	local smember_texture = function(_object, _value)
		if (_type(_value) == "table") then
			local _value1, _value2, _value3, _value4 = unpack(_value)
			if (_value1) then
				_object.button:SetNormalTexture(_value1)
			end
			if (_value2) then
				_object.button:SetHighlightTexture(_value2, "ADD")
			end
			if (_value3) then
				_object.button:SetPushedTexture(_value3)
			end
			if (_value4) then
				_object.button:SetDisabledTexture(_value4)
			end
		else
			_object.button:SetNormalTexture(_value)
			_object.button:SetHighlightTexture(_value, "ADD")
			_object.button:SetPushedTexture(_value)
			_object.button:SetDisabledTexture(_value)
		end
		return
	end
	--> locked
	local smember_locked = function(_object, _value)
		if (_value) then
			_object.button:SetMovable(false)
			return _rawset(_object, "is_locked", true)
		else
			_object.button:SetMovable(true)
			_rawset(_object, "is_locked", false)
			return
		end
	end	
	--> text align
	local smember_textalign = function(_object, _value)
		if (_value == "left" or _value == "<") then
			_object.button.text:SetPoint("left", _object.button, "left", 2, 0)
			_object.capsule_textalign = "left"
		elseif (_value == "center" or _value == "|") then
			_object.button.text:SetPoint("center", _object.button, "center", 0, 0)
			_object.capsule_textalign = "center"
		elseif (_value == "right" or _value == ">") then
			_object.button.text:SetPoint("right", _object.button, "right", -2, 0)
			_object.capsule_textalign = "right"
		end
	end

	local set_members_function_index = {
		["tooltip"] = smember_tooltip,
		["show"] = smember_show,
		["hide"] = smember_hide,
		["width"] = smember_width,
		["height"] = smember_height,
		["text"] = smember_text,
		["clickfunction"] = smember_function,
		["textcolor"] = smember_textcolor,
		["textfont"] = smember_textfont,
		["textsize"] = smember_textsize,
		["texture"] = smember_texture,
		["locked"] = smember_locked,
		["textalign"] = smember_textalign,
	}
	
	ButtonMetaFunctions.__newindex = function(_table, _key, _value)
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
	function ButtonMetaFunctions:IsShown()
		return self.button:IsShown()
	end
	function ButtonMetaFunctions:Show()
		return self.button:Show()
	end
	function ButtonMetaFunctions:Hide()
		return self.button:Hide()
	end
	
-- setpoint
	function ButtonMetaFunctions:SetPoint(v1, v2, v3, v4, v5)
		v1, v2, v3, v4, v5 = gump:CheckPoints(v1, v2, v3, v4, v5, self)
		if (not v1) then
			print("Invalid parameter for SetPoint")
			return
		end
		return self.widget:SetPoint(v1, v2, v3, v4, v5)
	end

-- sizes
	function ButtonMetaFunctions:SetSize(w, h)
		if (w) then
			self.button:SetWidth(w)
		end
		if (h) then
			return self.button:SetHeight(h)
		end
	end
	
-- tooltip
	function ButtonMetaFunctions:SetTooltip(tooltip)
		if (tooltip) then
			return _rawset(self, "have_tooltip", tooltip)
		else
			return _rawset(self, "have_tooltip", nil)
		end
	end
	function ButtonMetaFunctions:GetTooltip()
		return _rawget(self, "have_tooltip")
	end
	
-- functions
	function ButtonMetaFunctions:SetClickFunction(func, param1, param2, clicktype)
		if (not clicktype or string.find(string.lower(clicktype), "left")) then
			if (func) then
				_rawset(self, "func", func)
			else
				_rawset(self, "func", cleanfunction)
			end
			
			if (param1 ~= nil) then
				_rawset(self, "param1", param1)
			end
			if (param2 ~= nil) then
				_rawset(self, "param2", param2)
			end
			
		elseif (clicktype or string.find(string.lower(clicktype), "right")) then
			if (func) then
				_rawset(self, "funcright", func)
			else
				_rawset(self, "funcright", cleanfunction)
			end
		end
	end
	
-- text
	function ButtonMetaFunctions:SetText(text)
		if (text) then
			self.button.text:SetText(text)
		else
			self.button.text:SetText(nil)
		end
	end
	
-- textcolor
	function ButtonMetaFunctions:SetTextColor(color, arg2, arg3, arg4)
		if (arg2) then
			return self.button.text:SetTextColor(color, arg2, arg3, arg4 or 1)
		end
		local _value1, _value2, _value3, _value4 = gump:ParseColors(color)
		return self.button.text:SetTextColor(_value1, _value2, _value3, _value4)
	end
	
-- textsize
	function ButtonMetaFunctions:SetTextSize(size)
		return _details:SetFontSize(self.button.text, _value)
	end
	
-- textfont
	function ButtonMetaFunctions:SetTextFont(font)
		return _details:SetFontFace(_object.button.text, _value)
	end
	
-- textures
	function ButtonMetaFunctions:SetTexture(normal, highlight, pressed, disabled)
		if (normal) then
			self.button:SetNormalTexture(normal)
		elseif (_type(normal) ~= "boolean") then
			self.button:SetNormalTexture(nil)
		end
		
		if (_type(highlight) == "boolean") then
			if (highlight and normal and _type(normal) ~= "boolean") then
				self.button:SetHighlightTexture(normal, "ADD")
			end
		elseif (highlight == nil) then
			self.button:SetHighlightTexture(nil)
		else
			self.button:SetHighlightTexture(highlight, "ADD")
		end
		
		if (_type(pressed) == "boolean") then
			if (pressed and normal and _type(normal) ~= "boolean") then
				self.button:SetPushedTexture(normal)
			end
		elseif (pressed == nil) then
			self.button:SetPushedTexture(nil)
		else
			self.button:SetPushedTexture(pressed, "ADD")
		end
		
		if (_type(disabled) == "boolean") then
			if (disabled and normal and _type(normal) ~= "boolean") then
				self.button:SetDisabledTexture(normal)
			end
		elseif (disabled == nil) then
			self.button:SetDisabledTexture(nil)
		else
			self.button:SetDisabledTexture(disabled, "ADD")
		end
		
	end
	
-- frame levels
	function ButtonMetaFunctions:GetFrameLevel()
		return self.button:GetFrameLevel()
	end
	function ButtonMetaFunctions:SetFrameLevel(level, frame)
		if (not frame) then
			return self.button:SetFrameLevel(level)
		else
			local framelevel = frame:GetFrameLevel(frame) + level
			return self.button:SetFrameLevel(framelevel)
		end
	end

-- icon
	function ButtonMetaFunctions:SetIcon(texture, width, height, layout, texcoord, overlay, textdistance)
		if (not self.icon) then
			self.icon = self:CreateTexture(nil, "artwork")
			self.icon:SetSize(self.height*0.8, self.height*0.8)
			self.icon:SetPoint("left", self.widget, "left", 4, 0)
			
			self.widget.text:ClearAllPoints()
			self.widget.text:SetPoint("left", self.icon, "right", textdistance or 2, 0)
		end
		
		self.icon:SetTexture(texture)
		self.icon:SetSize(width or self.height*0.8, height or self.height*0.8)
		self.icon:SetDrawLayer(layout or "artwork")
		if (texcoord) then
			self.icon:SetTexCoord(unpack(texcoord))
		else
			self.icon:SetTexCoord(0, 1, 0, 1)
		end
		if (overlay) then
			if (type(overlay) == "string") then
				local r, g, b, a = gump:ParseColors(overlay)
				self.icon:SetVertexColor(r, g, b, a)
			else
				self.icon:SetVertexColor(unpack(overlay))
			end
		else
			self.icon:SetVertexColor(1, 1, 1, 1)
		end
		
		local w = self.button:GetWidth()
		local iconw = self.icon:GetWidth()
		local text_width = self.button.text:GetStringWidth()
		if (text_width > w-15-iconw) then
			if (not short_method) then
				local new_width = text_width+15+iconw
				self.button:SetWidth(new_width)
			elseif (short_method == 1) then
				local loop = true
				local textsize = 11
				while(loop) do
					if (text_width+15+iconw < w or textsize < 8) then
						loop = false
						break
					else
						_details:SetFontSize(self.button.text, textsize)
						text_width = self.button.text:GetStringWidth()
						textsize = textsize - 1
					end
				end
			end
		end
		
	end
	
-- frame stratas
	function ButtonMetaFunctions:SetFrameStrata()
		return self.button:GetFrameStrata()
	end
	function ButtonMetaFunctions:SetFrameStrata(strata)
		if (_type(strata) == "table") then
			self.button:SetFrameStrata(strata:GetFrameStrata())
		else
			self.button:SetFrameStrata(strata)
		end
	end
	
-- enabled
	function ButtonMetaFunctions:IsEnabled()
		return self.button:IsEnabled()
	end
	function ButtonMetaFunctions:Enable()
		return self.button:Enable()
	end
	function ButtonMetaFunctions:Disable()
		return self.button:Disable()
	end
	
-- exec
	function ButtonMetaFunctions:Exec()
		return self.func(self.param1, self.param2)
	end
	function ButtonMetaFunctions:Click()
		return self.func(self.param1, self.param2)
	end
	function ButtonMetaFunctions:RightClick()
		return self.funcright()
	end

--> hooks
	function ButtonMetaFunctions:SetHook(hookType, func)
		if (func) then
			_rawset(self, hookType.."Hook", func)
		else
			_rawset(self, hookType.."Hook", nil)
		end
	end

--> custom textures
	function ButtonMetaFunctions:InstallCustomTexture(texture, rect, coords, use_split, side_textures)
	
		self.button:SetNormalTexture(nil)
		self.button:SetPushedTexture(nil)
		self.button:SetDisabledTexture(nil)
		self.button:SetHighlightTexture(nil)

		local button = self.button
		
		if (use_split) then
		
			--> 4 corners
			button.textureTopLeft = button:CreateTexture(nil, "artwork"); button.textureTopLeft:SetSize(8, 8); button.textureTopLeft:SetPoint("topleft", button)
			button.textureTopRight = button:CreateTexture(nil, "artwork"); button.textureTopRight:SetSize(8, 8); button.textureTopRight:SetPoint("topright", button)
			button.textureBottomLeft = button:CreateTexture(nil, "artwork"); button.textureBottomLeft:SetSize(8, 8); button.textureBottomLeft:SetPoint("bottomleft", button)
			button.textureBottomRight = button:CreateTexture(nil, "artwork"); button.textureBottomRight:SetSize(8, 8); button.textureBottomRight:SetPoint("bottomright", button)

			button.textureLeft = button:CreateTexture(nil, "artwork"); button.textureLeft:SetWidth(4); button.textureLeft:SetPoint("topleft", button.textureTopLeft, "bottomleft"); button.textureLeft:SetPoint("bottomleft", button.textureBottomLeft, "topleft")
			button.textureRight = button:CreateTexture(nil, "artwork"); button.textureRight:SetWidth(4); button.textureRight:SetPoint("topright", button.textureTopRight, "bottomright"); button.textureRight:SetPoint("bottomright", button.textureBottomRight, "topright")
			button.textureTop = button:CreateTexture(nil, "artwork"); button.textureTop:SetHeight(4); button.textureTop:SetPoint("topleft", button.textureTopLeft, "topright"); button.textureTop:SetPoint("topright", button.textureTopRight, "topleft");
			button.textureBottom = button:CreateTexture(nil, "artwork"); button.textureBottom:SetHeight(4); button.textureBottom:SetPoint("bottomleft", button.textureBottomLeft, "bottomright"); button.textureBottom:SetPoint("bottomright", button.textureBottomRight, "bottomleft");
			
			button.textureLeft:SetTexCoord(0, 4/128, 9/128, 24/128)
			button.textureRight:SetTexCoord(124/128, 1, 9/128, 24/128)
			button.textureTop:SetTexCoord(9/128, 120/128, 0, 4/128)
			button.textureBottom:SetTexCoord(9/128, 119/128, 28/128, 32/128)
			
			button.textureTopLeft:SetTexCoord(0, 8/128, 0, 8/128)
			button.textureTopRight:SetTexCoord(121/128, 1, 0, 8/128)
			button.textureBottomLeft:SetTexCoord(0, 8/128, 24/128, 32/128)
			button.textureBottomRight:SetTexCoord(120/128, 1, 24/128, 32/128)
			
			button.textureTopLeft:SetTexture([[Interface\AddOns\Details\images\default_button]])
			button.textureTopRight:SetTexture([[Interface\AddOns\Details\images\default_button]])
			button.textureBottomLeft:SetTexture([[Interface\AddOns\Details\images\default_button]])
			button.textureBottomRight:SetTexture([[Interface\AddOns\Details\images\default_button]])
			button.textureLeft:SetTexture([[Interface\AddOns\Details\images\default_button]])
			button.textureRight:SetTexture([[Interface\AddOns\Details\images\default_button]])
			button.textureTop:SetTexture([[Interface\AddOns\Details\images\default_button]])
			button.textureBottom:SetTexture([[Interface\AddOns\Details\images\default_button]])
		
		else
			texture = texture or "Interface\\AddOns\\Details\\images\\default_button"
			self.button.texture = self.button:CreateTexture(nil, "artwork")
			
			if (not rect) then 
				self.button.texture:SetAllPoints(self.button)
			else
				self.button.texture:SetPoint("topleft", self.button, "topleft", rect.x1, rect.y1)
				self.button.texture:SetPoint("bottomright", self.button, "bottomright", rect.x2, rect.y2)
			end
			
			if (coords) then
				self.button.texture.coords = coords
				self.button.texture:SetTexCoord(_unpack(coords.Normal))
			else
				self.button.texture:SetTexCoord(0, 1, 0, 0.24609375)
			end
			
			self.button.texture:SetTexture(texture)
		end
		
		if (side_textures) then
			local left = self.button:CreateTexture(nil, "overlay")
			left:SetTexture([[Interface\AddOns\Details\images\talent-main]])
			left:SetTexCoord(0.13671875, 0.25, 0.486328125, 0.576171875)
			left:SetPoint("left", self.button, 0, 0)
			left:SetWidth(10)
			left:SetHeight(self.button:GetHeight()+2)
			
			local right = self.button:CreateTexture(nil, "overlay")
			right:SetTexture([[Interface\AddOns\Details\images\talent-main]])
			right:SetTexCoord(0.01953125, 0.13671875, 0.486328125, 0.576171875)
			right:SetPoint("right", self.button, 0, 0)	
			right:SetWidth(10)
			right:SetHeight(self.button:GetHeight()+2)
		end
	end

------------------------------------------------------------------------------------------------------------
--> scripts

	local OnEnter = function(button)

		if (button.textureTopLeft) then
			button.textureLeft:SetTexCoord(0, 4/128, 40/128, 56/128)
			button.textureRight:SetTexCoord(124/128, 1, 40/128, 56/128)
			button.textureTop:SetTexCoord(9/128, 120/128, 33/128, 37/128)
			button.textureBottom:SetTexCoord(9/128, 119/128, 60/128, 64/128)
			
			button.textureTopLeft:SetTexCoord(0, 8/128, 33/128, 40/128)
			button.textureTopRight:SetTexCoord(121/128, 1, 33/128, 40/128)
			button.textureBottomLeft:SetTexCoord(0, 8/128, 56/128, 64/128)
			button.textureBottomRight:SetTexCoord(120/128, 1, 56/128, 64/128)
		end
	
		if (button.MyObject.OnEnterHook) then
			local interrupt = button.MyObject.OnEnterHook(button, button.MyObject)
			if (interrupt) then
				return
			end
		end

		button.MyObject.is_mouse_over = true
		
		if (button.texture) then
			if (button.texture.coords) then
				button.texture:SetTexCoord(_unpack(button.texture.coords.Highlight))
			else
				button.texture:SetTexCoord(0, 1, 0.24609375, 0.49609375)
			end
		end

		if (button.MyObject.have_tooltip) then 
			_details:CooltipPreset(2)
			GameCooltip:AddLine(button.MyObject.have_tooltip)
			GameCooltip:ShowCooltip(button, "tooltip")
		end
		
		local parent = button:GetParent().MyObject
		if (parent and parent.type == "panel") then
			if (parent.GradientEnabled) then
				parent:RunGradient()
			end
		end
	end
	
	local OnLeave = function(button)
	
		if (button.textureLeft and not button.MyObject.is_mouse_down) then
			button.textureLeft:SetTexCoord(0, 4/128, 9/128, 24/128)
			button.textureRight:SetTexCoord(124/128, 1, 9/128, 24/128)
			button.textureTop:SetTexCoord(9/128, 120/128, 0, 4/128)
			button.textureBottom:SetTexCoord(9/128, 119/128, 28/128, 32/128)
			
			button.textureTopLeft:SetTexCoord(0, 8/128, 0, 8/128)
			button.textureTopRight:SetTexCoord(121/128, 1, 0, 8/128)
			button.textureBottomLeft:SetTexCoord(0, 8/128, 24/128, 32/128)
			button.textureBottomRight:SetTexCoord(120/128, 1, 24/128, 32/128)
		end
	
		if (button.MyObject.OnLeaveHook) then
			local interrupt = button.MyObject.OnLeaveHook(button, button.MyObject)
			if (interrupt) then
				return
			end
		end
		
		button.MyObject.is_mouse_over = false
		
		if (button.texture and not button.MyObject.is_mouse_down) then
			if (button.texture.coords) then
				button.texture:SetTexCoord(_unpack(button.texture.coords.Normal))
			else		
				button.texture:SetTexCoord(0, 1, 0, 0.24609375)
			end
		end

		if (button.MyObject.have_tooltip) then
			if (GameCooltip:GetText(1) == button.MyObject.have_tooltip) then
				GameCooltip:Hide()
			end
		end
		
		local parent = button:GetParent().MyObject
		if (parent and parent.type == "panel") then
			if (parent.GradientEnabled) then
				parent:RunGradient(false)
			end
		end
	end
	
	local OnHide = function(button)
		if (button.MyObject.OnHideHook) then
			local interrupt = button.MyObject.OnHideHook(button, button.MyObject)
			if (interrupt) then
				return
			end
		end
	end
	
	local OnShow = function(button)
		if (button.MyObject.OnShowHook) then
			local interrupt = button.MyObject.OnShowHook(button, button.MyObject)
			if (interrupt) then
				return
			end
		end
	end
	
	local OnMouseDown = function(button, buttontype)
		if (not button:IsEnabled()) then
			return
		end
		
		if (button.textureTopLeft) then
			button.textureLeft:SetTexCoord(0, 4/128, 72/128, 88/128)
			button.textureRight:SetTexCoord(124/128, 1, 72/128, 88/128)
			button.textureTop:SetTexCoord(9/128, 120/128, 65/128, 68/128)
			button.textureBottom:SetTexCoord(9/128, 119/128, 92/128, 96/128)
			
			button.textureTopLeft:SetTexCoord(0, 8/128, 65/128, 71/128)
			button.textureTopRight:SetTexCoord(121/128, 1, 65/128, 71/128)
			button.textureBottomLeft:SetTexCoord(0, 8/128, 88/128, 96/128)
			button.textureBottomRight:SetTexCoord(120/128, 1, 88/128, 96/128)
		end
		
		if (button.MyObject.OnMouseDownHook) then
			local interrupt = button.MyObject.OnMouseDownHook(button, buttontype, button.MyObject)
			if (interrupt) then
				return
			end
		end
		
		button.MyObject.is_mouse_down = true
		
		if (button.texture) then
			if (button.texture.coords) then
				button.texture:SetTexCoord(_unpack(button.texture.coords.Pushed))
			else		
				button.texture:SetTexCoord(0, 1, 0.5078125, 0.75)
			end
		end
		
		if (button.MyObject.capsule_textalign) then
			if (button.MyObject.icon) then
				button.MyObject.icon:SetPoint("left", button, "left", 5, -1)
			elseif (button.MyObject.capsule_textalign == "left") then
				button.text:SetPoint("left", button, "left", 3, -1)
			elseif (button.MyObject.capsule_textalign == "center") then
				button.text:SetPoint("center", button, "center", 1, -1)
			elseif (button.MyObject.capsule_textalign == "right") then
				button.text:SetPoint("right", button, "right", -1, -1)
			end
		else
			if (button.MyObject.icon) then
				button.MyObject.icon:SetPoint("left", button, "left", 7, -2)
			else
				button.text:SetPoint("center", button,"center", 1, -1)
			end
		end

		button.mouse_down = GetTime()
		local x, y = GetCursorPosition()
		button.x = _math_floor(x)
		button.y = _math_floor(y)
	
		if (not button.MyObject.container.isLocked and button.MyObject.container:IsMovable()) then
			if (not button.isLocked and button:IsMovable()) then
				button.MyObject.container.isMoving = true
				button.MyObject.container:StartMoving()
			end
		end
		
		if (button.MyObject.options.OnGrab) then
			if (_type(button.MyObject.options.OnGrab) == "string" and button.MyObject.options.OnGrab == "PassClick") then
				if (buttontype == "LeftButton") then
					button.MyObject.func(button.MyObject.param1, button.MyObject.param2)
				else
					button.MyObject.funcright(button.MyObject.param1, button.MyObject.param2)
				end
			end
		end
	end

	local OnMouseUp = function(button, buttontype)
		if (not button:IsEnabled()) then
			return
		end
		
		if (button.textureLeft) then
			if (button.MyObject.is_mouse_over) then
				button.textureLeft:SetTexCoord(0, 4/128, 40/128, 56/128)
				button.textureRight:SetTexCoord(124/128, 1, 40/128, 56/128)
				button.textureTop:SetTexCoord(9/128, 120/128, 33/128, 37/128)
				button.textureBottom:SetTexCoord(9/128, 119/128, 60/128, 64/128)
				
				button.textureTopLeft:SetTexCoord(0, 8/128, 33/128, 40/128)
				button.textureTopRight:SetTexCoord(121/128, 1, 33/128, 40/128)
				button.textureBottomLeft:SetTexCoord(0, 8/128, 56/128, 64/128)
				button.textureBottomRight:SetTexCoord(120/128, 1, 56/128, 64/128)
			else
				button.textureLeft:SetTexCoord(0, 4/128, 9/128, 24/128)
				button.textureRight:SetTexCoord(124/128, 1, 9/128, 24/128)
				button.textureTop:SetTexCoord(9/128, 120/128, 0, 4/128)
				button.textureBottom:SetTexCoord(9/128, 119/128, 28/128, 32/128)
				
				button.textureTopLeft:SetTexCoord(0, 8/128, 0, 8/128)
				button.textureTopRight:SetTexCoord(121/128, 1, 0, 8/128)
				button.textureBottomLeft:SetTexCoord(0, 8/128, 24/128, 32/128)
				button.textureBottomRight:SetTexCoord(120/128, 1, 24/128, 32/128)
			end
		end
		
		if (button.MyObject.OnMouseUpHook) then
			local interrupt = button.MyObject.OnMouseUpHook(button, buttontype, button.MyObject)
			if (interrupt) then
				return
			end
		end
		
		button.MyObject.is_mouse_down = false
		
		if (button.texture) then
			if (button.texture.coords) then
				if (button.MyObject.is_mouse_over) then
					button.texture:SetTexCoord(_unpack(button.texture.coords.Highlight))
				else
					button.texture:SetTexCoord(_unpack(coords.Normal))
				end
			else	
				if (button.MyObject.is_mouse_over) then
					button.texture:SetTexCoord(0, 1, 0.24609375, 0.49609375)
				else
					button.texture:SetTexCoord(0, 1, 0, 0.24609375)
				end
			end
		end

		if (button.MyObject.capsule_textalign) then
			if (button.MyObject.icon) then
				button.MyObject.icon:SetPoint("left", button, "left", 4, 0)
			elseif (button.MyObject.capsule_textalign == "left") then
				button.text:SetPoint("left", button, "left", 2, 0)
			elseif (button.MyObject.capsule_textalign == "center") then
				button.text:SetPoint("center", button, "center", 0, 0)
			elseif (button.MyObject.capsule_textalign == "right") then
				button.text:SetPoint("right", button, "right", -2, 0)
			end
		else
			if (button.MyObject.icon) then
				button.MyObject.icon:SetPoint("left", button, "left", 4, 0)
			else
				button.text:SetPoint("center", button,"center", 0, 0)
			end
		end
		
		if (button.MyObject.container.isMoving) then
			button.MyObject.container:StopMovingOrSizing()
			button.MyObject.container.isMoving = false
		end

		local x, y = GetCursorPosition()
		x = _math_floor(x)
		y = _math_floor(y)
		if ((button.mouse_down+0.4 > GetTime() and(x == button.x and y == button.y)) or(x == button.x and y == button.y)) then
			if (buttontype == "LeftButton") then
				button.MyObject.func(button.MyObject.param1, button.MyObject.param2, button, buttontype)
			else
				button.MyObject.funcright(button.MyObject.param1, button.MyObject.param2, button, buttontype)
			end
		end
	end

------------------------------------------------------------------------------------------------------------
--> object constructor

function gump:CreateButton(parent, func, w, h, text, param1, param2, texture, member, name, short_method)
	return gump:NewButton(parent, parent, name, member, w, h, func, param1, param2, texture, text, short_method)
end

function gump:NewButton(parent, container, name, member, w, h, func, param1, param2, texture, text, short_method)
	
	if (not name) then
		name = "DetailsButtonNumber" .. gump.ButtonCounter
		gump.ButtonCounter = gump.ButtonCounter + 1
		
	elseif (not parent) then
		return nil
	end
	if (not container) then
		container = parent
	end
	
	if (name:find("$parent")) then
		name = name:gsub("$parent", parent:GetName())
	end
	
	
	local ButtonObject = {type = "button", dframework = true}
	
	if (member) then
		parent[member] = ButtonObject
	end	
	
	if (parent.dframework) then
		parent = parent.widget
	end
	if (container.dframework) then
		container = container.widget
	end
	
	--> default members:
		--> hooks
		ButtonObject.OnEnterHook = nil
		ButtonObject.OnLeaveHook = nil
		ButtonObject.OnHideHook = nil
		ButtonObject.OnShowHook = nil
		ButtonObject.OnMouseDownHook = nil
		ButtonObject.OnMouseUpHook = nil
		--> misc
		ButtonObject.is_locked = true
		ButtonObject.container = container
		ButtonObject.have_tooltip = nil
		ButtonObject.options = {OnGrab = false}


	ButtonObject.button = CreateFrame("button", name, parent, "DetailsButtonTemplate")
	ButtonObject.widget = ButtonObject.button

	if (not APIButtonFunctions) then
		APIButtonFunctions = true
		local idx = getmetatable(ButtonObject.button).__index
		for funcName, funcAddress in pairs(idx) do 
			if (not ButtonMetaFunctions[funcName]) then
				ButtonMetaFunctions[funcName] = function(object, ...)
					local x = loadstring( "return _G."..object.button:GetName()..":"..funcName.."(...)")
					return x(...)
				end
			end
		end
	end

	ButtonObject.button:SetWidth(w or 100)
	ButtonObject.button:SetHeight(h or 20)
	ButtonObject.button.MyObject = ButtonObject
	
	ButtonObject.text_overlay = _G[name .. "_Text"]
	ButtonObject.disabled_overlay = _G[name .. "_TextureDisabled"]
	
	ButtonObject.button:SetNormalTexture(texture)
	ButtonObject.button:SetPushedTexture(texture)
	ButtonObject.button:SetDisabledTexture(texture)
	ButtonObject.button:SetHighlightTexture(texture, "ADD")
	
	ButtonObject.button.text:SetText(text)
	ButtonObject.button.text:SetPoint("center", ButtonObject.button, "center")
	
	local text_width = ButtonObject.button.text:GetStringWidth()
	if (text_width > w-15) then
		if (not short_method) then
			local new_width = text_width+15
			ButtonObject.button:SetWidth(new_width)
		elseif (short_method == 1) then
			local loop = true
			local textsize = 11
			while(loop) do
				if (text_width+15 < w or textsize < 8) then
					loop = false
					break
				else
					_details:SetFontSize(ButtonObject.button.text, textsize)
					text_width = ButtonObject.button.text:GetStringWidth()
					textsize = textsize - 1
				end
			end
		end
	end
	
	ButtonObject.func = func or cleanfunction
	ButtonObject.funcright = cleanfunction
	ButtonObject.param1 = param1
	ButtonObject.param2 = param2
	
	ButtonObject.short_method = short_method
	
	--> hooks
		ButtonObject.button:SetScript("OnEnter", OnEnter)
		ButtonObject.button:SetScript("OnLeave", OnLeave)
		ButtonObject.button:SetScript("OnHide", OnHide)
		ButtonObject.button:SetScript("OnShow", OnShow)
		ButtonObject.button:SetScript("OnMouseDown", OnMouseDown)
		ButtonObject.button:SetScript("OnMouseUp", OnMouseUp)
		
	_setmetatable(ButtonObject, ButtonMetaFunctions)
	
	return ButtonObject
	
end

local pickcolor_callback = function(self, r, g, b, a, button)
	button.MyObject.color_texture:SetVertexColor(r, g, b, a)
	button.MyObject:color_callback(r, g, b, a)
end
local pickcolor = function(alpha, param2, self)
	local r, g, b, a = self.MyObject.color_texture:GetVertexColor()
	gump:ColorPick(self, r, g, b, a, pickcolor_callback)
end

local color_button_height = 16
local color_button_width = 16

local set_colorpick_color = function(button, r, g, b, a)
	button.color_texture:SetVertexColor(r, g, b, a)
end

local colorpick_cancel = function(self)
	ColorPickerFrame:Hide()
end

function gump:NewColorPickButton(parent, name, member, callback, alpha)

	--button
	local button = gump:NewButton(parent, _, name, member, color_button_width, color_button_height, pickcolor, alpha, "param2")
	button:InstallCustomTexture()
	button.color_callback = callback
	button.Cancel = colorpick_cancel
	button.SetColor = set_colorpick_color
	
	button:SetBackdrop({edgeFile =[[Interface\Tooltips\UI-Tooltip-Border]], edgeSize = 6,
	bgFile =[[Interface\AddOns\Details\images\background]], insets = {left = 0, right = 0, top = 0, bottom = 0}})
	
	--texture do fundo
	local background = gump:NewImage(button, nil, color_button_width, color_button_height, nil, nil, nil, "$parentBck")
	background:SetTexture([[Interface\AddOns\Details\images\icons]])
	background:SetPoint("topleft", button.widget, "topleft", 1, -2)
	background:SetPoint("bottomright", button.widget, "bottomright", -1, 1)
	--background:SetTexCoord(0.337890625, 0.5859375, 0.625, 0.685546875) --173 320 300 351
	background:SetTexCoord(0.337890625, 0.390625, 0.625, 0.658203125) --173 320 200 337
	background:SetDrawLayer("background", 1)
	
	--texture da cor
	local img = gump:NewImage(button, nil, color_button_width, color_button_height, nil, nil, "color_texture", "$parentTex")
	img:SetTexture(1, 1, 1)
	img:SetPoint("topleft", button.widget, "topleft", 1, -2)
	img:SetPoint("bottomright", button.widget, "bottomright", -1, 1)
	img:SetDrawLayer("background", 2)
	
	--icon do color pick
	--[[
	local icon = gump:NewImage(button, nil, "$parentIcon", nil, 16, color_button_height)
	icon:SetTexture("Interface\\AddOns\\Details\\images\\icons")
	icon:SetPoint("topleft", button, "topleft", -1, 0)
	icon:SetDrawLayer("border", 3)
	icon:SetTexCoord(0.640625, 0.6875, 0.630859375, 0.677734375) --328 323 352 347

	text
	local color_label = gump:NewLabel(button, nil, nil, nil, "color", "GameFontNormal")
	color_label:SetDrawLayer("border", 4)
	color_label:SetPoint("left", icon, "right", 2, 1)
	--]]
	
	return button
	
end