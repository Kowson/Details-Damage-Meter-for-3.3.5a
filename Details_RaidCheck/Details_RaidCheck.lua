local _UnitAura = UnitAura
local _GetSpellInfo = GetSpellInfo
local _UnitClass = UnitClass
local _UnitName = UnitName
local _GetNumRaidMembers = GetNumRaidMembers or GetNumGroupMembers -- api local

local flask_list = {
    [67016] = true, -- Flask of the North (SP)
	[67017] = true, -- Flask of the North (AP)
	[67018] = true, -- Flask of the North (STR)
	[53755] = true, -- Flask of the Frost Wyrm
	[53758] = true, -- Flask of Stoneblood
	[53760] = true, -- Flask of Endless Rage
	[54212] = true, -- Flask of Pure Mojo
	[53752] = true, -- Lesser Flask of Toughness (50 Resilience)
	[17627] = true, -- Flask of Distilled Wisdom

	[33721] = true, -- Spellpower Elixir
	[53746] = true, -- Wrath Elixir
	[28497] = true, -- Elixir of Mighty Agility
	[53748] = true, -- Elixir of Mighty Strength
	[60346] = true, -- Elixir of Lightning Speed
	[60344] = true, -- Elixir of Expertise
	[60341] = true, -- Elixir of Deadly Strikes
	[60345] = true, -- Elixir of Armor Piercing
	[60340] = true, -- Elixir of Accuracy
	[53749] = true, -- Guru's Elixir

	[60343] = true, -- Elixir of Mighty Defense
	[53751] = true, -- Elixir of Mighty Fortitude
	[53764] = true, -- Elixir of Mighty Mageblood
	[60347] = true, -- Elixir of Mighty Thoughts
	[53763] = true, -- Elixir of Protection
	[53747] = true, -- Elixir of Spirit
}

local pre_potions_list = {
	[53908] = true, -- Potion of Speed
	[53909] = true, -- Potion of Wild Magic
	[28494] = true, -- Insane Strength Potion
	[53762] = true, -- Armor Potion
	[43186] = true, -- Runic Mana Potion
	[28499] = true, -- Super Mana Potion
}

local food_list = {
	[57325] = true, -- 80 AP
	[57327] = true, -- 46 SP
	[57329] = true, -- 40 Critical Strike Rating
	[57332] = true, -- 40 Haste Rating
	[57334] = true, -- 20 MP5
	[57356] = true, -- 40 Expertise Rating
	[57358] = true, -- 40 ARP
	[57360] = true, -- 40 Hit Rating
	[57363] = true, -- Tracking Humanoids
	[57365] = true, -- 40 Spirit
	[57367] = true, -- 40 AGI
	[57371] = true, -- 40 STR
	[57373] = true, -- Tracking Beasts
	[57399] = true, -- 80 AP, 46 SP
	[59230] = true, -- 40 Dodge Rating
	[65247] = true, -- 20 STR
}



--> localization
	local Loc = LibStub("AceLocale-3.0"):GetLocale("Details")
--> create the plugin object
	local DetailsRaidCheck = _details:NewPluginObject("DetailsRaidCheck", DETAILSPLUGIN_ALWAYSENABLED)
	tinsert(UISpecialFrames, "DetailsRaidCheck")
	DetailsRaidCheck:SetPluginDescription(Loc["STRING_RAIDCHECK_PLUGIN_DESC"])

	local CreatePluginFrames = function()

		DetailsRaidCheck.usedprepot_table = {}
		DetailsRaidCheck.haveflask_table = {}
		DetailsRaidCheck.havefood_table = {}

		DetailsRaidCheck.on_raid = false
		DetailsRaidCheck.tracking_buffs = false

		local empty_table = {}

		function DetailsRaidCheck:OnDetailsEvent(event, ...)

			if (event == "ZONE_TYPE_CHANGED") then
				DetailsRaidCheck:CheckZone(...)
			elseif (event == "COMBAT_PREPOTION_UPDATED") then

				DetailsRaidCheck.usedprepot_table = select(1, ...)
			elseif (event == "COMBAT_PLAYER_LEAVE") then
				if (DetailsRaidCheck.on_raid) then
					DetailsRaidCheck:StartTrackBuffs()
				end

			elseif (event == "COMBAT_PLAYER_ENTER") then
				if (DetailsRaidCheck.on_raid) then
					DetailsRaidCheck:StopTrackBuffs()
				end
			elseif (event == "DETAILS_STARTED") then
				DetailsRaidCheck:CheckZone()
			elseif (event == "PLUGIN_DISABLED") then
				DetailsRaidCheck.on_raid = false
				DetailsRaidCheck.tracking_buffs = false
				DetailsRaidCheck:StopTrackBuffs()
				--> HIDE ICON
			elseif (event == "PLUGIN_ENABLED") then
				DetailsRaidCheck:CheckZone()
			end
		end

		DetailsRaidCheck.ToolbarButton = _details.ToolBar:NewPluginToolbarButton(DetailsRaidCheck.empty_function, [[Interface\AddOns\Details_RaidCheck\icon]], Loc["STRING_RAIDCHECK_PLUGIN_NAME"], "", 16, 16, "RAIDCHECK_PLUGIN_BUTTON")
		DetailsRaidCheck.ToolbarButton.shadow = true --> loads icon_shadow.tga when the instance is showing icons with shadows
		DetailsRaidCheck:ShowToolbarIcon(DetailsRaidCheck.ToolbarButton, "star")

		function DetailsRaidCheck:SetGreenIcon()
			local lower_instance = _details:GetLowerInstanceNumber()
			if (not lower_instance) then
				return
			end
			local instance = _details:GetInstance(lower_instance)

			if (instance.menu_icons.shadow) then
				DetailsRaidCheck.ToolbarButton:SetNormalTexture([[Interface\AddOns\Details_RaidCheck\icon_shadow]])
				DetailsRaidCheck.ToolbarButton:SetPushedTexture([[Interface\AddOns\Details_RaidCheck\icon_shadow]])
				DetailsRaidCheck.ToolbarButton:SetDisabledTexture([[Interface\AddOns\Details_RaidCheck\icon_shadow]])
				DetailsRaidCheck.ToolbarButton:SetHighlightTexture([[Interface\AddOns\Details_RaidCheck\icon_shadow]], "ADD")
			else
				DetailsRaidCheck.ToolbarButton:SetNormalTexture([[Interface\AddOns\Details_RaidCheck\icon]])
				DetailsRaidCheck.ToolbarButton:SetPushedTexture([[Interface\AddOns\Details_RaidCheck\icon]])
				DetailsRaidCheck.ToolbarButton:SetDisabledTexture([[Interface\AddOns\Details_RaidCheck\icon]])
				DetailsRaidCheck.ToolbarButton:SetHighlightTexture([[Interface\AddOns\Details_RaidCheck\icon]], "ADD")
			end
		end

		function DetailsRaidCheck:SetRedIcon()
			local lower_instance = _details:GetLowerInstanceNumber()
			if (not lower_instance) then
				return
			end
			local instance = _details:GetInstance(lower_instance)

			if (instance.menu_icons.shadow) then
				DetailsRaidCheck.ToolbarButton:SetNormalTexture([[Interface\AddOns\Details_RaidCheck\icon_red_shadow]])
				DetailsRaidCheck.ToolbarButton:SetPushedTexture([[Interface\AddOns\Details_RaidCheck\icon_red_shadow]])
				DetailsRaidCheck.ToolbarButton:SetDisabledTexture([[Interface\AddOns\Details_RaidCheck\icon_red_shadow]])
				DetailsRaidCheck.ToolbarButton:SetHighlightTexture([[Interface\AddOns\Details_RaidCheck\icon_red_shadow]], "ADD")
			else
				DetailsRaidCheck.ToolbarButton:SetNormalTexture([[Interface\AddOns\Details_RaidCheck\icon_red]])
				DetailsRaidCheck.ToolbarButton:SetPushedTexture([[Interface\AddOns\Details_RaidCheck\icon_red]])
				DetailsRaidCheck.ToolbarButton:SetDisabledTexture([[Interface\AddOns\Details_RaidCheck\icon_red]])
				DetailsRaidCheck.ToolbarButton:SetHighlightTexture([[Interface\AddOns\Details_RaidCheck\icon_red]], "ADD")
			end
		end

		local show_panel = CreateFrame("frame", nil, UIParent)
		show_panel:SetSize(400, 300)
		show_panel:SetBackdrop({bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16})
		show_panel:SetPoint("bottom", DetailsRaidCheck.ToolbarButton, "top", 0, 10)

		local food_str = show_panel:CreateFontString(nil, "overlay", "GameFontHighlightSmall")
		food_str:SetJustifyH ("left")
		food_str:SetPoint("topleft", show_panel, "topleft", 15, -20)

		local flask_str = show_panel:CreateFontString(nil, "overlay", "GameFontHighlightSmall")
		flask_str:SetJustifyH ("left")
		flask_str:SetPoint("topleft", show_panel, "topleft", 150, -20)

		local prepot_str = show_panel:CreateFontString(nil, "overlay", "GameFontHighlightSmall")
		prepot_str:SetJustifyH ("left")
		prepot_str:SetPoint("topleft", show_panel, "topleft", 285, -20)

		show_panel:Hide()

		--> overwrite the default scripts
		DetailsRaidCheck.ToolbarButton:SetScript("OnClick", function(self, button)
		end)

		local update_panel = function(self)
			local s, f, p, n = "No Food:\n\n", "No Flask:\n\n", "Used Pre Pot:\n\n", "Not Used Pre Pot:\n\n"
			for i = 1, _GetNumRaidMembers(), 1 do
				local name = UnitName("raid" .. i)

				if (not DetailsRaidCheck.havefood_table[name]) then
					local _, class = _UnitClass(name)
					local class_color = "FFFFFFFF"

					if (class) then
						local coords = CLASS_ICON_TCOORDS[class]
						class_color = "|TInterface\\AddOns\\Details\\images\\classes_small_alpha:12:12:0:-5:128:128:" .. coords[1]*128 .. ":" .. coords[2]*128 .. ":" .. coords[3]*128 .. ":" .. coords[4]*128 .. "|t |c" .. RAID_CLASS_COLORS[class].colorStr
					end
					s = s .. class_color .. name .. "|r\n"
				end

				if (not DetailsRaidCheck.haveflask_table[name]) then
					local _, class = _UnitClass (name)
					local class_color = "FFFFFFFF"

					if (class) then
						local coords = CLASS_ICON_TCOORDS[class]
						class_color = "|TInterface\\AddOns\\Details\\images\\classes_small_alpha:12:12:0:-5:128:128:" .. coords[1]*128 .. ":" .. coords[2]*128 .. ":" .. coords[3]*128 .. ":" .. coords[4]*128 .. "|t |c" .. RAID_CLASS_COLORS[class].colorStr
					end
					f = f .. class_color .. name .. "|r\n"
				end
			end

			food_str:SetText(s)
			flask_str:SetText(f)

			for player_name, potid in pairs(DetailsRaidCheck.usedprepot_table) do
				local name, _, icon = _GetSpellInfo(potid)
				local _, class = _UnitClass(player_name)
				local class_color = "FFFFFFFF"

				if (class) then
					class_color = RAID_CLASS_COLORS[class].colorStr
				end

				p = p .. "|T" .. icon .. ":12:12:0:-5:64:64:0:64:0:64|t |c" .. class_color .. player_name .. "|r\n"
			end
			for i = 1, _GetNumRaidMembers(), 1 do
				local playerName, realmName = _UnitName("raid" .. i)
				if (realmName and realmName ~= "") then
					playerName = playerName .. "-" .. realmName
				end

				if (not DetailsRaidCheck.usedprepot_table[playerName]) then
					local _, class = _UnitClass(playerName)
					local class_color = "FFFFFFFF"

					if (class) then
						local coords = CLASS_ICON_TCOORDS[class]
						class_color = "|TInterface\\AddOns\\Details\\images\\classes_small_alpha:12:12:0:-5:128:128:" .. coords[1]*128 .. ":" .. coords[2]*128 .. ":" .. coords[3]*128 .. ":" .. coords[4]*128 .. "|t |c" .. RAID_CLASS_COLORS[class].colorStr
					end

					n = n .. class_color .. playerName .. "|r\n"
				end
			end

			prepot_str:SetText (p .. "\n\n" .. n)
		end

		DetailsRaidCheck.ToolbarButton:SetScript("OnEnter", function (self)
			show_panel:Show()
			show_panel:SetScript("OnUpdate", update_panel)
		end)

		DetailsRaidCheck.ToolbarButton:SetScript("OnLeave", function (self)
			show_panel:Hide()
			show_panel:SetScript("OnUpdate", nil)
		end)

		function DetailsRaidCheck:CheckZone(...)
			local zone_type = select(1, ...)

			if (not zone_type) then
				zone_type = select(2, GetInstanceInfo())
			end

			if (zone_type == "raid") then
				DetailsRaidCheck.on_raid = true

				if (not DetailsRaidCheck.in_combat) then
					DetailsRaidCheck:StartTrackBuffs()
				end
			else
				DetailsRaidCheck.on_raid = false
				if (DetailsRaidCheck.tracking_buffs) then
					DetailsRaidCheck:StopTrackBuffs()
				end
			end
		end

		function DetailsRaidCheck:BuffTrackTick()
			for player_name, have in pairs(DetailsRaidCheck.haveflask_table) do
				DetailsRaidCheck.haveflask_table[player_name] = nil
			end
			for player_name, have in pairs(DetailsRaidCheck.havefood_table) do
				DetailsRaidCheck.havefood_table[player_name] = nil
			end

			for i = 1, _GetNumRaidMembers(), 1 do
				local name = UnitName("raid" .. i)
				for buffIndex = 1, 41 do
					local bname, _, _, _, _, _, _, _, _, _, spellid  = _UnitAura("raid" .. i, buffIndex, nil, "HELPFUL")

					if (bname and flask_list[spellid]) then
						DetailsRaidCheck.haveflask_table[name] = true
					end

					if (bname and food_list[spellid]) then
						DetailsRaidCheck.havefood_table[name] = true
					end
				end
			end
		end

--		DETAILS_PLUGIN_RAIDCHECK
--		/run vardump (DETAILS_PLUGIN_RAIDCHECK.havefood_table)
--		DETAILS_PLUGIN_RAIDCHECK.tracking_buffs
--		/run DETAILS_PLUGIN_RAIDCHECK:StartTrackBuffs()
--		/run DETAILS_PLUGIN_RAIDCHECK:StopTrackBuffs()

		function DetailsRaidCheck:StartTrackBuffs()
			if (not DetailsRaidCheck.tracking_buffs) then
				DetailsRaidCheck.tracking_buffs = true

				table.wipe(DetailsRaidCheck.haveflask_table)
				table.wipe(DetailsRaidCheck.havefood_table)

				if (DetailsRaidCheck.tracking_buffs_process) then
					DetailsRaidCheck:CancelTimer(DetailsRaidCheck.tracking_buffs_process)
				end

				DetailsRaidCheck.tracking_buffs_process = DetailsRaidCheck:ScheduleRepeatingTimer("BuffTrackTick", 1)
			end
		end

		function DetailsRaidCheck:StopTrackBuffs()
			if (DetailsRaidCheck.tracking_buffs) then
				DetailsRaidCheck.tracking_buffs = false

				if (DetailsRaidCheck.tracking_buffs_process) then
					DetailsRaidCheck:CancelTimer(DetailsRaidCheck.tracking_buffs_process)
				end
			else
				if (DetailsRaidCheck.tracking_buffs_process) then
					DetailsRaidCheck:CancelTimer(DetailsRaidCheck.tracking_buffs_process)
				end
			end
		end
	end

	function DetailsRaidCheck:OnEvent(_, event, ...)

		if (event == "ADDON_LOADED") then
			local AddonName = select(1, ...)
			if (AddonName == "Details_RaidCheck") then
				if (_G._details) then
					--> create widgets
					CreatePluginFrames()

					--> core version required
					local MINIMAL_DETAILS_VERSION_REQUIRED = 20

					local default_settings = {
						pre_pot_healers = false, --do not report pre pot for healers
						pre_pot_tanks = false, --do not report pre pot for tanks
						show_icon = 5, --when show the icon
					}

					--> install
					local install, saveddata, is_enabled = _G._details:InstallPlugin("TOOLBAR", Loc["STRING_RAIDCHECK_PLUGIN_NAME"], [[Interface\AddOns\Details_RaidCheck\icon]], DetailsRaidCheck, "DETAILS_PLUGIN_RAIDCHECK", MINIMAL_DETAILS_VERSION_REQUIRED, "Details! Team", "v1.0", default_settings)
					if (type(install) == "table" and install.error) then
						return print(install.error)
					end

					--> register needed events
					_G._details:RegisterEvent(DetailsRaidCheck, "COMBAT_PLAYER_LEAVE")
					_G._details:RegisterEvent(DetailsRaidCheck, "COMBAT_PLAYER_ENTER")
					_G._details:RegisterEvent(DetailsRaidCheck, "COMBAT_PREPOTION_UPDATED")
					_G._details:RegisterEvent(DetailsRaidCheck, "ZONE_TYPE_CHANGED")
				end
			end
		end
	end