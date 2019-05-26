local _details = _G._details
local g = _details.gump
local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
local _

	local window = g:NewPanel(UIParent, nil, "DetailsImageEdit", nil, 100, 100, false)
	window:SetPoint("center", UIParent, "center")
	window:SetResizable(true)
	window:SetMovable(true)
	tinsert(UISpecialFrames, "DetailsImageEdit")
	window:SetFrameStrata("TOOLTIP")
	
	window:SetMaxResize(266, 226)
	
	window.hooks = {}
	
	local background = g:NewImage(window, nil, nil, nil, "background", nil, nil, "$parentBackground")
	background:SetAllPoints()
	background:SetTexture(0, 0, 0, .8)
	
	local edit_texture = g:NewImage(window, nil, 300, 250, "artwork", nil, nil, "$parentImage")
	edit_texture:SetAllPoints()
	
	local background_frame = CreateFrame("frame", "DetailsImageEditBackground", DetailsImageEdit)
	background_frame:SetPoint("topleft", DetailsImageEdit, "topleft", -10, 12)
	background_frame:SetFrameStrata("DIALOG")
	background_frame:SetSize(400, 252)
	
	background_frame:SetResizable(true)
	background_frame:SetMovable(true)
	
	background_frame:SetScript("OnMouseDown", function()
		window:StartMoving()
	end)
	background_frame:SetScript("OnMouseUp", function()
		window:StopMovingOrSizing()
	end)
	
	local background_frame_image = background_frame:CreateTexture(nil, "background")
	background_frame_image:SetAllPoints(background_frame)
	background_frame_image:SetTexture([[Interface\AddOns\Details\images\welcome]])
	
	local haveHFlip = false
	local haveVFlip = false
	
--> Top Slider
	
		local topCoordTexture = g:NewImage(window, nil, nil, nil, "overlay", nil, nil, "$parentImageTopCoord")
		topCoordTexture:SetPoint("topleft", window, "topleft")
		topCoordTexture:SetPoint("topright", window, "topright")
		topCoordTexture.color = "red"
		topCoordTexture.height = 1
		topCoordTexture.alpha = .2
		
		local topSlider = g:NewSlider(window, nil, "$parentTopSlider", "topSlider", 100, 100, 0.1, 100, 0.1, 0)
		topSlider:SetAllPoints(window.widget)
		topSlider:SetOrientation("VERTICAL")
		topSlider.backdrop = nil
		topSlider.fractional = true
		topSlider:SetHook("OnEnter", function() return true end)
		topSlider:SetHook("OnLeave", function() return true end)

		local topSliderThumpTexture = topSlider:CreateTexture(nil, "overlay")
		topSliderThumpTexture:SetTexture(1, 1, 1)
		topSliderThumpTexture:SetWidth(512)
		topSliderThumpTexture:SetHeight(3)
		topSlider:SetThumbTexture(topSliderThumpTexture)

		topSlider:SetHook("OnValueChange", function(_, _, value)
			topCoordTexture.image:SetHeight(window.frame:GetHeight()/100*value)
			if (window.callback_func) then
				window.accept(true)
			end
		end)
		
		topSlider:Hide()

--> Bottom Slider

		local bottomCoordTexture = g:NewImage(window, nil, nil, nil, "overlay", nil, nil, "$parentImageBottomCoord")
		bottomCoordTexture:SetPoint("bottomleft", window, "bottomleft", 0, 0)
		bottomCoordTexture:SetPoint("bottomright", window, "bottomright", 0, 0)
		bottomCoordTexture.color = "red"
		bottomCoordTexture.height = 1
		bottomCoordTexture.alpha = .2

		local bottomSlider= g:NewSlider(window, nil, "$parentBottomSlider", "bottomSlider", 100, 100, 0.1, 100, 0.1, 100)
		bottomSlider:SetAllPoints(window.widget)
		bottomSlider:SetOrientation("VERTICAL")
		bottomSlider.backdrop = nil
		bottomSlider.fractional = true
		bottomSlider:SetHook("OnEnter", function() return true end)
		bottomSlider:SetHook("OnLeave", function() return true end)

		local bottomSliderThumpTexture = bottomSlider:CreateTexture(nil, "overlay")
		bottomSliderThumpTexture:SetTexture(1, 1, 1)
		bottomSliderThumpTexture:SetWidth(512)
		bottomSliderThumpTexture:SetHeight(3)
		bottomSlider:SetThumbTexture(bottomSliderThumpTexture)

		bottomSlider:SetHook("OnValueChange", function(_, _, value)
			value = math.abs(value-100)
			bottomCoordTexture.image:SetHeight(math.max(window.frame:GetHeight()/100*value, 1))
			if (window.callback_func) then
				window.accept(true)
			end
		end)
		
		bottomSlider:Hide()
		
--> Left Slider
		
		local leftCoordTexture = g:NewImage(window, nil, nil, nil, "overlay", nil, nil, "$parentImageLeftCoord")
		leftCoordTexture:SetPoint("topleft", window, "topleft", 0, 0)
		leftCoordTexture:SetPoint("bottomleft", window, "bottomleft", 0, 0)
		leftCoordTexture.color = "red"
		leftCoordTexture.width = 1
		leftCoordTexture.alpha = .2
		
		local leftSlider = g:NewSlider(window, nil, "$parentLeftSlider", "leftSlider", 100, 100, 0.1, 100, 0.1, 0.1)
		leftSlider:SetAllPoints(window.widget)
		leftSlider.backdrop = nil
		leftSlider.fractional = true
		leftSlider:SetHook("OnEnter", function() return true end)
		leftSlider:SetHook("OnLeave", function() return true end)
		
		local leftSliderThumpTexture = leftSlider:CreateTexture(nil, "overlay")
		leftSliderThumpTexture:SetTexture(1, 1, 1)
		leftSliderThumpTexture:SetWidth(3)
		leftSliderThumpTexture:SetHeight(512)
		leftSlider:SetThumbTexture(leftSliderThumpTexture)
		
		leftSlider:SetHook("OnValueChange", function(_, _, value)
			leftCoordTexture.image:SetWidth(window.frame:GetWidth()/100*value)
			if (window.callback_func) then
				window.accept(true)
			end
		end)
		
		leftSlider:Hide()
		
--> Right Slider
		
		local rightCoordTexture = g:NewImage(window, nil, nil, nil, "overlay", nil, nil, "$parentImageRightCoord")
		rightCoordTexture:SetPoint("topright", window, "topright", 0, 0)
		rightCoordTexture:SetPoint("bottomright", window, "bottomright", 0, 0)
		rightCoordTexture.color = "red"
		rightCoordTexture.width = 1
		rightCoordTexture.alpha = .2
		
		local rightSlider = g:NewSlider(window, nil, "$parentRightSlider", "rightSlider", 100, 100, 0.1, 100, 0.1, 100)
		rightSlider:SetAllPoints(window.widget)
		rightSlider.backdrop = nil
		rightSlider.fractional = true
		rightSlider:SetHook("OnEnter", function() return true end)
		rightSlider:SetHook("OnLeave", function() return true end)
		--[
		local rightSliderThumpTexture = rightSlider:CreateTexture(nil, "overlay")
		rightSliderThumpTexture:SetTexture(1, 1, 1)
		rightSliderThumpTexture:SetWidth(3)
		rightSliderThumpTexture:SetHeight(512)
		rightSlider:SetThumbTexture(rightSliderThumpTexture)
		--]]
		rightSlider:SetHook("OnValueChange", function(_, _, value)
			value = math.abs(value-100)
			rightCoordTexture.image:SetWidth(math.max(window.frame:GetWidth()/100*value, 1))
			if (window.callback_func) then
				window.accept(true)
			end
		end)
		
		rightSlider:Hide()
		
--> Edit Buttons

	local buttonsBackground = g:NewPanel(UIParent, nil, "DetailsImageEditButtonsBg", nil, 115, 230)
	--buttonsBackground:SetPoint("topleft", window, "topright", 2, 0)
	buttonsBackground:SetPoint("topright", background_frame, "topright", -8, -10)
	buttonsBackground:Hide()
	--buttonsBackground:SetMovable(true)
	tinsert(UISpecialFrames, "DetailsImageEditButtonsBg")
	buttonsBackground:SetFrameStrata("TOOLTIP")
	
		local alphaFrameShown = false
	
		local editingSide = nil
		local lastButton = nil
		local alphaFrame
		local originalColor = {0.9999, 0.8196, 0}
		
		local enableTexEdit = function(side, _, button)
			
			if (alphaFrameShown) then
				alphaFrame:Hide()
				alphaFrameShown = false
				button.text:SetTextColor(unpack(originalColor))
			end
			
			if (ColorPickerFrame:IsShown()) then
				ColorPickerFrame:Hide()
			end
			
			if (lastButton) then
				lastButton.text:SetTextColor(unpack(originalColor))
			end
			
			if (editingSide == side) then
				window[editingSide.."Slider"]:Hide()
				editingSide = nil
				return
				
			elseif (editingSide) then
				window[editingSide.."Slider"]:Hide()
			end

			editingSide = side
			button.text:SetTextColor(1, 1, 1)
			lastButton = button
			
			window[side.."Slider"]:Show()
		end
		
		local leftTexCoordButton = g:NewButton(buttonsBackground, nil, "$parentLeftTexButton", nil, 100, 20, enableTexEdit, "left", nil, nil, Loc["STRING_IMAGEEDIT_CROPLEFT"], 1)
		leftTexCoordButton:SetPoint("topright", buttonsBackground, "topright", -8, -10)
		local rightTexCoordButton = g:NewButton(buttonsBackground, nil, "$parentRightTexButton", nil, 100, 20, enableTexEdit, "right", nil, nil, Loc["STRING_IMAGEEDIT_CROPRIGHT"], 1)
		rightTexCoordButton:SetPoint("topright", buttonsBackground, "topright", -8, -30)
		local topTexCoordButton = g:NewButton(buttonsBackground, nil, "$parentTopTexButton", nil, 100, 20, enableTexEdit, "top", nil, nil, Loc["STRING_IMAGEEDIT_CROPTOP"], 1)
		topTexCoordButton:SetPoint("topright", buttonsBackground, "topright", -8, -50)
		local bottomTexCoordButton = g:NewButton(buttonsBackground, nil, "$parentBottomTexButton", nil, 100, 20, enableTexEdit, "bottom", nil, nil, Loc["STRING_IMAGEEDIT_CROPBOTTOM"], 1)
		bottomTexCoordButton:SetPoint("topright", buttonsBackground, "topright", -8, -70)
		leftTexCoordButton:InstallCustomTexture()
		rightTexCoordButton:InstallCustomTexture()
		topTexCoordButton:InstallCustomTexture()
		bottomTexCoordButton:InstallCustomTexture()
		
		local Alpha = g:NewButton(buttonsBackground, nil, "$parentBottomAlphaButton", nil, 100, 20, alpha, nil, nil, nil, Loc["STRING_IMAGEEDIT_ALPHA"], 1)
		Alpha:SetPoint("topright", buttonsBackground, "topright", -8, -115)
		Alpha:InstallCustomTexture()
		
	--> overlay color
		local selectedColor = function(default)
			if (default) then
				edit_texture:SetVertexColor(unpack(default))
				if (window.callback_func) then
					window.accept(true)
				end
			else
				edit_texture:SetVertexColor(ColorPickerFrame:GetColorRGB())
				if (window.callback_func) then
					window.accept(true)
				end
			end
		end
		
		local changeColor = function()
		
			ColorPickerFrame.func = nil
			ColorPickerFrame.opacityFunc = nil
			ColorPickerFrame.cancelFunc = nil
			ColorPickerFrame.previousValues = nil
			
			local r, g, b = edit_texture:GetVertexColor()
			ColorPickerFrame:SetColorRGB(r, g, b)
			ColorPickerFrame:SetParent(buttonsBackground.widget)
			ColorPickerFrame.hasOpacity = false
			ColorPickerFrame.previousValues = {r, g, b}
			ColorPickerFrame.func = selectedColor
			ColorPickerFrame.cancelFunc = selectedColor
			ColorPickerFrame:ClearAllPoints()
			ColorPickerFrame:SetPoint("left", buttonsBackground.widget, "right")
			ColorPickerFrame:Show()
			
			if (alphaFrameShown) then
				alphaFrame:Hide()
				alphaFrameShown = false
				Alpha.button.text:SetTextColor(unpack(originalColor))
			end	
			
			if (lastButton) then
				lastButton.text:SetTextColor(unpack(originalColor))
				if (editingSide) then
					window[editingSide.."Slider"]:Hide()
				end
			end
		end
		
		local changeColorButton = g:NewButton(buttonsBackground, nil, "$parentOverlayColorButton", nil, 100, 20, changeColor, nil, nil, nil, Loc["STRING_IMAGEEDIT_COLOR"], 1)
		changeColorButton:SetPoint("topright", buttonsBackground, "topright", -8, -95)
		changeColorButton:InstallCustomTexture()
		
		alphaFrame = g:NewPanel(buttonsBackground, nil, "DetailsImageEditAlphaBg", nil, 40, 225)
		alphaFrame:SetPoint("topleft", buttonsBackground, "topright", 2, 0)
		alphaFrame:Hide() 
		local alphaSlider = g:NewSlider(alphaFrame, nil, "$parentAlphaSlider", "alphaSlider", 30, 220, 1, 100, 1, edit_texture:GetAlpha()*100)
		alphaSlider:SetPoint("top", alphaFrame, "top", 0, -5)
		alphaSlider:SetOrientation("VERTICAL")
		alphaSlider.thumb:SetSize(40, 30)
		--leftSlider.backdrop = nil
		--leftSlider.fractional = true
		
		local alpha = function(_, _, button)
		
			if (ColorPickerFrame:IsShown()) then
				ColorPickerFrame:Hide()
			end
		
			if (lastButton) then
				lastButton.text:SetTextColor(unpack(originalColor))
				if (editingSide) then
					window[editingSide.."Slider"]:Hide()
				end
			end
		
			if (not alphaFrameShown) then
				alphaFrame:Show()
				alphaSlider:SetValue(edit_texture:GetAlpha()*100)
				alphaFrameShown = true
				button.text:SetTextColor(1, 1, 1)
			else
				alphaFrame:Hide()
				alphaFrameShown = false
				button.text:SetTextColor(unpack(originalColor))
			end
		end
		
		Alpha.clickfunction = alpha
		
		alphaSlider:SetHook("OnValueChange", function(_, _, value)
			edit_texture:SetAlpha(value/100)
			if (window.callback_func) then
				window.accept(true)
			end
		end)

		local resizer = CreateFrame("Button", nil, window.widget)
		resizer:SetNormalTexture([[Interface\AddOns\Details\images\skins\default_skin]])
		resizer:SetHighlightTexture([[Interface\AddOns\Details\images\skins\default_skin]])
		resizer:GetNormalTexture():SetTexCoord(0.00146484375, 0.01513671875, 0.24560546875, 0.25927734375)
		resizer:GetHighlightTexture():SetTexCoord(0.00146484375, 0.01513671875, 0.24560546875, 0.25927734375)
		resizer:SetWidth(16)
		resizer:SetHeight(16)
		resizer:SetPoint("BOTTOMRIGHT", window.widget, "BOTTOMRIGHT", 0, 0)
		resizer:EnableMouse(true)
		resizer:SetFrameLevel(window.widget:GetFrameLevel() + 2)
		
		resizer:SetScript("OnMouseDown", function(self, button) 
			window.widget:StartSizing("BOTTOMRIGHT")
		end)
		
		resizer:SetScript("OnMouseUp", function(self, button) 
			window.widget:StopMovingOrSizing()
		end)
		
		window.widget:SetScript("OnMouseDown", function()
			window.widget:StartMoving()
		end)
		window.widget:SetScript("OnMouseUp", function()
			window.widget:StopMovingOrSizing()
		end)
		
		window.widget:SetScript("OnSizeChanged", function()
			edit_texture.width = window.width
			edit_texture.height = window.height
			leftSliderThumpTexture:SetHeight(window.height)
			rightSliderThumpTexture:SetHeight(window.height)
			topSliderThumpTexture:SetWidth(window.width)
			bottomSliderThumpTexture:SetWidth(window.width)
			
			rightCoordTexture.image:SetWidth(math.max((window.frame:GetWidth() / 100 * math.abs(rightSlider:GetValue()-100)), 1))
			leftCoordTexture.image:SetWidth(window.frame:GetWidth()/100*leftSlider:GetValue())
			bottomCoordTexture:SetHeight(math.max((window.frame:GetHeight() / 100 * math.abs(bottomSlider:GetValue()-100)), 1))
			topCoordTexture:SetHeight(window.frame:GetHeight()/100*topSlider:GetValue())
			
			if (window.callback_func) then
				window.accept(true)
			end
		end)
		

		
	--> flip
		local flip = function(side)
			if (side == 1) then
				haveHFlip = not haveHFlip
				if (window.callback_func) then
					window.accept(true)
				end
			elseif (side == 2) then
				haveVFlip = not haveVFlip
				if (window.callback_func) then
					window.accept(true)
				end
			end
		end
		
		local flipButtonH = g:NewButton(buttonsBackground, nil, "$parentFlipButton", nil, 100, 20, flip, 1, nil, nil, Loc["STRING_IMAGEEDIT_FLIPH"], 1)
		flipButtonH:SetPoint("topright", buttonsBackground, "topright", -8, -140)
		flipButtonH:InstallCustomTexture()
		--
		local flipButtonV = g:NewButton(buttonsBackground, nil, "$parentFlipButton2", nil, 100, 20, flip, 2, nil, nil, Loc["STRING_IMAGEEDIT_FLIPV"], 1)
		flipButtonV:SetPoint("topright", buttonsBackground, "topright", -8, -160)
		flipButtonV:InstallCustomTexture()
		
	--> accept
		window.accept = function(keep_editing)
		
			if (not keep_editing) then
				buttonsBackground:Hide()
				window:Hide()
				alphaFrame:Hide()
				ColorPickerFrame:Hide()
			end
			
			local coords = {}
			local l, r, t, b = leftSlider.value/100, rightSlider.value/100, topSlider.value/100, bottomSlider.value/100
			
			if (haveHFlip) then
				coords[1] = r
				coords[2] = l
			else
				coords[1] = l
				coords[2] = r
			end
			
			if (haveVFlip) then
				coords[3] = b
				coords[4] = t
			else
				coords[3] = t
				coords[4] = b
			end

			return window.callback_func(edit_texture.width, edit_texture.height, {edit_texture:GetVertexColor()}, edit_texture:GetAlpha(), coords, window.extra_param)
		end
		
		local acceptButton = g:NewButton(buttonsBackground, nil, "$parentAcceptButton", nil, 100, 20, window.accept, nil, nil, nil, Loc["STRING_IMAGEEDIT_DONE"], 1)
		acceptButton:SetPoint("topright", buttonsBackground, "topright", -8, -200)
		acceptButton:InstallCustomTexture()
		


window:Hide()
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		local ttexcoord
		function g:ImageEditor(callback, texture, texcoord, colors, width, height, extraParam, alpha, maximize)
		
			texcoord = texcoord or {0, 1, 0, 1}
			ttexcoord = texcoord
		
			colors = colors or {1, 1, 1, 1}
			
			alpha = alpha or 1
		
			edit_texture:SetTexture(texture)
			edit_texture.width = width
			edit_texture.height = height
			edit_texture.maximize = maximize
			
			edit_texture:SetVertexColor(colors[1], colors[2], colors[3])
			
			edit_texture:SetAlpha(alpha)

			_details:ScheduleTimer("RefreshImageEditor", 0.2)
			
			window:Show()
			window.callback_func = callback
			window.extra_param = extraParam
			buttonsBackground:Show()
			
			table.wipe(window.hooks)
		end
		
		function _details:RefreshImageEditor()
		
			if (edit_texture.maximize) then
				DetailsImageEdit:SetSize(266, 226)
			else
				DetailsImageEdit:SetSize(edit_texture.width, edit_texture.height)
			end
			
			local l, r, t, b = unpack(ttexcoord)
			
			if (l > r) then
				haveHFlip = true
				leftSlider:SetValue(r * 100)
				rightSlider:SetValue(l * 100)
			else
				haveHFlip = false
				leftSlider:SetValue(l * 100)
				rightSlider:SetValue(r * 100)
			end
			
			if (t > b) then
				haveVFlip = true
				topSlider:SetValue(b * 100)
				bottomSlider:SetValue(t * 100)
			else
				haveVFlip = false
				topSlider:SetValue(t * 100)
				bottomSlider:SetValue(b * 100)
			end

			if (window.callback_func) then
				window.accept(true)
			end

		end
		