TOOLTIP_DEFAULT_COLOR = { r = 1, g = 1, b = 1 };
TOOLTIP_DEFAULT_BACKGROUND_COLOR = { r = 0.09, g = 0.09, b = 0.19 };

-- Panel Positions
PANEL_INSET_LEFT_OFFSET = 4;
PANEL_INSET_RIGHT_OFFSET = -6;
PANEL_INSET_BOTTOM_OFFSET = 4;
PANEL_INSET_BOTTOM_BUTTON_OFFSET = 26;
PANEL_INSET_TOP_OFFSET = -24;
PANEL_INSET_ATTIC_OFFSET = -60;

-- ButtonFrameTemplate code
function ButtonFrameTemplate_HideButtonBar(self)
	if self.bottomInset then 
		self.bottomInset:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", PANEL_INSET_RIGHT_OFFSET, PANEL_INSET_BOTTOM_OFFSET);
	else
		_G[self:GetName() .. "Inset"]:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", PANEL_INSET_RIGHT_OFFSET, PANEL_INSET_BOTTOM_OFFSET);
	end
	_G[self:GetName() .. "BtnCornerLeft"]:Hide();
	_G[self:GetName() .. "BtnCornerRight"]:Hide();
	_G[self:GetName() .. "ButtonBottomBorder"]:Hide();
end

function ButtonFrameTemplate_ShowButtonBar(self)
	if self.topInset then 
		self.topInset:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", PANEL_INSET_RIGHT_OFFSET, PANEL_INSET_BOTTOM_BUTTON_OFFSET);
	else
		_G[self:GetName() .. "Inset"]:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", PANEL_INSET_RIGHT_OFFSET, PANEL_INSET_BOTTOM_BUTTON_OFFSET);
	end
	_G[self:GetName() .. "BtnCornerLeft"]:Show();
	_G[self:GetName() .. "BtnCornerRight"]:Show();
	_G[self:GetName() .. "ButtonBottomBorder"]:Show();
end

function ButtonFrameTemplate_HideAttic(self)
	if self.topInset then 
		self.topInset:SetPoint("TOPLEFT", self, "TOPLEFT", PANEL_INSET_LEFT_OFFSET, PANEL_INSET_TOP_OFFSET);
	else
		self.Inset:SetPoint("TOPLEFT", self, "TOPLEFT", PANEL_INSET_LEFT_OFFSET, PANEL_INSET_TOP_OFFSET);
	end
	self.TopTileStreaks:Hide();
end

function ButtonFrameTemplate_ShowAttic(self)
	if self.topInset then 
		self.topInset:SetPoint("TOPLEFT", self, "TOPLEFT", PANEL_INSET_LEFT_OFFSET, PANEL_INSET_ATTIC_OFFSET);
	else
		self.Inset:SetPoint("TOPLEFT", self, "TOPLEFT", PANEL_INSET_LEFT_OFFSET, PANEL_INSET_ATTIC_OFFSET);
	end
	self.TopTileStreaks:Show();
end


function ButtonFrameTemplate_HidePortrait(self)
	self.portrait:Hide();
	self.portraitFrame:Hide();
	self.topLeftCorner:Show();
	self.topBorderBar:SetPoint("TOPLEFT", self.topLeftCorner, "TOPRIGHT",  0, 0);
	self.leftBorderBar:SetPoint("TOPLEFT", self.topLeftCorner, "BOTTOMLEFT",  0, 0);
end


function ButtonFrameTemplate_ShowPortrait(self)
	self.portrait:Show();
	self.portraitFrame:Show();
	self.topLeftCorner:Hide();
	self.topBorderBar:SetPoint("TOPLEFT", self.portraitFrame, "TOPRIGHT",  0, -10);
	self.leftBorderBar:SetPoint("TOPLEFT", self.portraitFrame, "BOTTOMLEFT",  8, 0);
end

-- A bit ugly, we want the talent frame to display a dialog box in certain conditions.
function PortraitFrameCloseButton_OnClick(self)
	if ( self:GetParent().onCloseCallback) then
		self:GetParent().onCloseCallback(self);
	else
		HideParentPanel(self);
	end	
end


function ActionButton_OverlayGlowAnimOutFinished(animGroup)
	local overlay = animGroup:GetParent();
	local actionButton = overlay:GetParent();
	overlay:Hide();
	actionButton.overlay = nil;
end


function ActionButton_OverlayGlowOnUpdate(self, elapsed)
	AnimateAnts(self.ants, 256, 256, 48, 48, 25, elapsed, 0.01);
	local cooldown = self:GetParent().cooldown;
	-- we need some threshold to avoid dimming the glow during the gdc
	-- (using 1500 exactly seems risky, what if casting speed is slowed or something?)
	if(cooldown and cooldown:IsShown() and cooldown:GetCooldownDuration() > 3000) then
		self:SetAlpha(0.5);
	else
		self:SetAlpha(1.0);
	end
end

function AnimateAnts(texture, textureWidth, textureHeight, frameWidth, frameHeight, numFrames, elapsed, throttle)
	if ( not texture.frame ) then
		-- initialize everything
		texture.frame = 1;
		texture.throttle = throttle;
		texture.numColumns = floor(textureWidth/frameWidth);
		texture.numRows = floor(textureHeight/frameHeight);
		texture.columnWidth = frameWidth/textureWidth;
		texture.rowHeight = frameHeight/textureHeight;
	end
	local frame = texture.frame;
	if ( not texture.throttle or texture.throttle > throttle ) then
		local framesToAdvance = floor(texture.throttle / throttle);
		while ( frame + framesToAdvance > numFrames ) do
			frame = frame - numFrames;
		end
		frame = frame + framesToAdvance;
		texture.throttle = 0;
		local left = mod(frame-1, texture.numColumns)*texture.columnWidth;
		local right = left + texture.columnWidth;
		local bottom = ceil(frame/texture.numColumns)*texture.rowHeight;
		local top = bottom - texture.rowHeight;
		texture:SetTexCoord(left, right, top, bottom);

		texture.frame = frame;
	else
		texture.throttle = texture.throttle + elapsed;
	end
end

--> WatchFrame copy, got removed on WoD
local function DetailsTutorialAlertFrame_OnFinishSlideIn(frame)
	frame.ScrollChild.Shine:Show();
	frame.ScrollChild.IconShine:Show();
	frame.ScrollChild.Shine.Flash:Play();
	frame.ScrollChild.IconShine.Flash:Play();
end

local function DetailsTutorialAlertFrame_OnUpdate(frame, timestep)
	local animData = frame.animData;
	local height = animData.height;
	local scrollStart = animData.scrollStart;
	local scrollEnd = animData.scrollEnd;
	local endTime = animData.slideInTime + (animData.endDelay or 0);

	if (frame.startDelay) then
		frame.startDelay = frame.startDelay - timestep;
		if (frame.startDelay <= 0) then
			frame.startDelay = nil;
		else
			return;
		end
	end

	if (frame.isFirst) then
		height = height + 10;
		scrollEnd = scrollEnd - 10;
	end

	frame.totalTime = frame.totalTime+timestep;
	if (frame.totalTime > endTime) then
		frame.totalTime = endTime;
	end

	local scrollPos = scrollEnd;
	if (animData.slideInTime and animData.slideInTime > 0) then
		height = height*(frame.totalTime/animData.slideInTime);
		scrollPos = scrollStart + (scrollEnd-scrollStart)*(frame.totalTime/animData.slideInTime);
	end
	if (animData.reverse) then
		height = max(animData.height - height, 1);
	end
	frame:SetHeight(height);
	frame:UpdateScrollChildRect();
	frame:SetVerticalScroll(floor(scrollPos+0.5));

	if (frame.totalTime >= endTime) then
		frame:SetScript("OnUpdate", nil);
		if (animData.onFinishFunc) then
			animData.onFinishFunc(frame);
		end
	end
end

function DetailsTutorialAlertFrame_SlideInFrame(frame, animType)
	frame.totalTime = 0;
	frame.animData = {height = 72, scrollStart = 65, scrollEnd = -9, slideInTime = 0.4, onFinishFunc = DetailsTutorialAlertFrame_OnFinishSlideIn};
	frame.slideInTime = frame.animData.slideInTime;
	frame:SetHeight(1);
	if (frame.animData.reverse) then
		frame:SetHeight(frame.animData["height"]);
	else
		frame:SetHeight(1);
	end
	frame.startDelay = frame.animData.startDelay;
	frame:SetScript("OnUpdate", DetailsTutorialAlertFrame_OnUpdate);
end

--Micro Button alerts
function MicroButtonAlert_OnLoad(self)
	self.Text:SetSpacing(4);
	if ( self.label ) then
		self.Text:SetText(self.label);
	end
end