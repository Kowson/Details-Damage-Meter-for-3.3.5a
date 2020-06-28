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
	AnimateTexCoords(self.ants, 256, 256, 48, 48, 22, elapsed, 0.01);
	local cooldown = self:GetParent().cooldown;
	-- we need some threshold to avoid dimming the glow during the gdc
	-- (using 1500 exactly seems risky, what if casting speed is slowed or something?)
	if(cooldown and cooldown:IsShown() and cooldown:GetCooldownDuration() > 3000) then
		self:SetAlpha(0.5);
	else
		self:SetAlpha(1.0);
	end
end