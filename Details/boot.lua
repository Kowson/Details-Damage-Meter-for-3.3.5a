-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> global name declaration
 
		_ = nil
		_details = LibStub("AceAddon-3.0"):NewAddon("_details", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0", "NickTag-1.0")
		_details.build_counter = 100
		_details.userversion = "v1.3.0"
		_details.realversion = 12
		_details.version = _details.userversion .. " (core " .. _details.realversion .. ")"

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> initialization stuff
 
do 

	local _details = _G._details
	
	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
	--[[
		|cFFFFFF00-|r Fixed the gap between the button and its menu which sometimes traveling the mouse between them was activating tooltips from window's bars.\n\n|cFFFFFF00-|r Fixed an annoying menu blink when the window was near the right side of the screen.\n\n|cFFFFFF00-|r Fixed the stretch grab which was over other windows even with the 'stretch always on top' option disabled.\n\n
	]]--
	Loc["STRING_VERSION_LOG"] = "|cFFFFFF00v1.3.0 (|cFFFFCC00Aug 16, 2020|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Fixed combat initialization when the player start casting a Dot spell.\n\n|cFFFFFF00-|r Added new custom display: Damage Taken By Spell.\n\n|cFFFFFF00-|r Fixed problem with memory clean up time out after combat.\n\n|cFFFFFF00-|r Fixed a script time out problem when erasing data while in combat.\n\n|cFFFFFF00-|r Fixed the gap between the button and its menu which sometimes traveling the mouse between them was activating tooltips from window's bars.\n\n|cFFFFFF00-|r Fixed an annoying menu blink when the window was near the right side of the screen.\n\n|cFFFFFF00-|r Fixed the stretch grab which was over other windows even with the 'stretch always on top' option disabled.\n\n|cFFFFFF00-|r Fixed death's tooltip which wasn't respecting tooltip's configuration set on options panel.\n\n|cFFFFFF00-|r Now when the window is close to the top of the screen, menus will anchor on bottom side of the menu icons.\n\n|cFFFFFF00-|r Added micro displays options on Window Settings bracket.\n\n|cFFFFFF00-|r Fixed Latency on status bar.\n\n|cFFFFFF00-|r Fixed the problem with bar's custom texts.\n\n|cFFFFFF00-|r Lua functions inside custom texts, Chart Data scripts and Custom Displays scripts are now protected calls and won't break the addon functionality if an error occurs.\n\n|cFFFFFF00-|r Fixed a bug with tank avoidance tables.\n\n|cFFFFFF00-|r Tiny Threat: added option to use class colors instead of green-to-red colors.\n\n|cFFFFFF00-|r Added option to enable shadows on toolbar's buttons.\n\n|cFFFFFF00-|r Added option to set the spacing between each button on toolbar.\n\n|cFFFFFF00-|r Finally we merged the left and right menus into only one with 6 icons.\n\n|cFFFFFF00-|r Removed window button and added a new option bracket to manage windows under Mode Menu.\n\n|cFFFFFF00-|r Few changes on 'Default Skin', 'Minimalistic', 'Simple Gray' and 'ElvUI Frame Style BW' (need reaply).\n\n|cFFFFFF00- Important:|r If the menus is out of the position, just reaply the skin.\n\n"
	Loc["STRING_DETAILS1"] = "|cffffaeaeDetails!:|r "

	--> startup
		_details.initializing = true
		_details.enabled = true
		_details.__index = _details
		_details._time = time()
		_details.debug = false
		_details.opened_windows = 0
		_details.last_combat_time = 0
		
	--> containers
		--> All parse functions
			_details.parser = {} 
			_details.parser_functions = {}
			_details.parser_frame = CreateFrame("Frame", nil, _UIParent)
			_details.parser_frame:Hide()
		--> Shields information for absorbs
			_details.shields = {} 
		--> Frames functions
			_details.gump = {} 
			function _details:GetFramework()
				return self.gump
			end
		--> Metatable functions for initializing the data
			_details.refresh = {} 
		--> Metatable functions for cleaning and saving the data
			_details.clear = {} 
		--> Fast switch panel config
			_details.switch = {} 
		--> Saved styles
			_details.savedStyles = {}
		--> Contain attributes and sub attributos which have a detailed window(left click on a row)
			_details.row_singleclick_overwrite = {} 
		--> Report options
			_details.ReportOptions = {}
		--> Buffs ids and functions
			_details.Buffs = {} --> initialize buff table
		--> Group cache
			_details.cache_damage_group = {}
			_details.cache_healing_group = {}
		--> Ignored pets
			_details.pets_ignored = {}
			_details.pets_no_owner = {}
		--> Available windows skins
			_details.skins = {}
		--> Parser hooks
			_details.hooks = {}
		--> Information about current boss fight
			_details.encounter_end_table = {}
			_details.encounter_table = {}
		--> Information about current arena fight
			_details.arena_table = {}
			_details.arena_info = {
				[562] = {file = "LoadScreenBladesEdgeArena", coords = {0, 1, 0.29296875, 0.9375}}, -- Circle of Blood Arena
				[617] = {file = "LoadScreenDalaranSewersArena", coords = {0, 1, 0.29296875, 0.857421875}}, -- Dalaran Arena
				[559] = {file = "LoadScreenNagrandArenaBattlegrounds", coords = {0, 1, 0.341796875, 1}}, -- Ring of Trials
				[572] = {file = "LoadScreenRuinsofLordaeronBattlegrounds", coords = {0, 1, 0.341796875, 1}}, -- Ruins of Lordaeron
				[618] = {file = "LoadScreenOrgrimmarArena", coords = {0, 1, 0.29296875, 0.857421875}}, -- Ring of Valor
			}
		--> Unused instances
			_details.unused_instances = {}
			
			function _details:GetArenaInfo(mapid)
				local t = _details.arena_info[mapid]
				if (t) then
					return t.file, t.coords
				end
			end
			
		--> tooltip
			_details.tooltip_backdrop = {
				bgFile =[[Interface\AddOns\Details\images\UI-DialogBox-Background-Dark]], 
				edgeFile =[[Interface\Tooltips\UI-Tooltip-Border]], 
				tile = true,
				edgeSize = 16, 
				tileSize = 16, 
				insets = {left = 3, right = 3, top = 4, bottom = 4}
			}
			_details.tooltip_border_color = {1, 1, 1, 1}
			_details.tooltip_spell_icon = {file =[[Interface\CHARACTERFRAME\UI-StateIcon]], coords = {36/64, 58/64, 7/64, 26/64}}
			--_details.tooltip_target_icon = {file =[[Interface\CHARACTERFRAME\UI-StateIcon]], coords = {36/64, 58/64, 7/64, 26/64}}
		
		
	--> Plugins
		--> raid -------------------------------------------------------------------
			--> general function for raid mode plugins
				_details.RaidTables = {} 
			--> menu for raid modes
				_details.RaidTables.Menu = {} 
			--> plugin objects for raid mode
				_details.RaidTables.Plugins = {} 
			--> name to plugin object
				_details.RaidTables.NameTable = {} 
			--> using by
				_details.RaidTables.InstancesInUse = {} 
				_details.RaidTables.PluginsInUse = {} 

		--> solo -------------------------------------------------------------------
			--> general functions for solo mode plugins
				_details.SoloTables = {} 
			--> maintain plugin menu
				_details.SoloTables.Menu = {} 
			--> plugins objects for solo mode
				_details.SoloTables.Plugins = {} 
			--> name to plugin object
				_details.SoloTables.NameTable = {} 
		
		--> toolbar -------------------------------------------------------------------
			--> plugins container
				_details.ToolBar = {}
			--> current showing icons
				_details.ToolBar.Shown = {}
				_details.ToolBar.AllButtons = {}
			--> plugin objects
				_details.ToolBar.Plugins = {}
			--> name to plugin object
				_details.ToolBar.NameTable = {}
				_details.ToolBar.Menu = {}
		
		--> statusbar -------------------------------------------------------------------
			--> plugins container
				_details.StatusBar = {}
			--> maintain plugin menu
				_details.StatusBar.Menu = {} 
			--> plugins object
				_details.StatusBar.Plugins = {} 
			--> name to plugin object
				_details.StatusBar.NameTable = {} 

	--> constants
		_details._details_props = {
			DATA_TYPE_START = 1,	--> Something on start
			DATA_TYPE_END = 2,	--> Something on end

			MODE_ALONE = 1,	--> Solo
			MODE_GROUP = 2,	--> Group
			MODE_ALL = 3,		--> Everything
			MODE_RAID = 4,	--> Raid
		}
		_details.modes = {
			alone = 1, --> Solo
			group = 2,	--> Group
			all = 3,	--> Everything
			raid = 4	--> Raid
		}

		_details.dividers = {
			open = "(",	--> open
			close = ")",	--> close
			placing = ". " --> dot
		}
		
		_details.role_texcoord = {
			DAMAGER = "72:130:69:127",
			HEALER = "72:130:2:60",
			TANK = "5:63:69:127",
			NONE = "139:196:69:127",
		}
		
		_details.player_class = {
			["HUNTER"] = true,
			["WARRIOR"] = true,
			["PALADIN"] = true,
			["SHAMAN"] = true,
			["MAGE"] = true,
			["ROGUE"] = true,
			["PRIEST"] = true,
			["WARLOCK"] = true,
			["DRUID"] = true,
			["DEATHKNIGHT"] = true,
		}
		
		local Loc = LibStub("AceLocale-3.0"):GetLocale("Details")
		
		_details.segments = {
			label = Loc["STRING_SEGMENT"]..": ", 
			overall = Loc["STRING_TOTAL"], 
			overall_standard = Loc["STRING_OVERALL"],
			current = Loc["STRING_CURRENT"], 
			current_standard = Loc["STRING_CURRENTFIGHT"],
			past = Loc["STRING_FIGHTNUMBER"] 
		}
		
		_details._details_props["mode_name"] = {
				[_details._details_props["MODE_ALONE"]] = Loc["STRING_MODE_SELF"], 
				[_details._details_props["MODE_GROUP"]] = Loc["STRING_MODE_GROUP"], 
				[_details._details_props["MODE_ALL"]] = Loc["STRING_MODE_ALL"],
				[_details._details_props["MODE_RAID"]] = Loc["STRING_MODE_RAID"]
		}
		
		--[[global]] DETAILS_MODE_SOLO = 1
		--[[global]] DETAILS_MODE_RAID = 4
		--[[global]] DETAILS_MODE_GROUP = 2
		--[[global]] DETAILS_MODE_ALL = 3

		_details.icons = {
			--> report window
			report = { 
					up = "Interface\\FriendsFrame\\UI-Toast-FriendOnlineIcon",
					down = "Interface\\MINIMAP\\TRACKING\\Profession",
					disabled = "Interface\\MINIMAP\\TRACKING\\Profession",
					highlight = nil
				}
		}
	
		_details.missTypes = {"ABSORB", "BLOCK", "DEFLECT", "DODGE", "EVADE", "IMMUNE", "MISS", "PARRY", "REFLECT", "RESIST"} --> do not localize-me

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> frames
	
	local _CreateFrame = CreateFrame --api locals
	local _UIParent = UIParent --api locals
	
	--> Info Window
		_details.window_info = _CreateFrame("Frame", "Details_WindowInfo", _UIParent)

	--> Event Frame
		_details.listener = _CreateFrame("Frame", nil, _UIParent)
		_details.listener:RegisterEvent("ADDON_LOADED")
		_details.listener:RegisterEvent("PLAYER_LOGOUT")
		_details.listener:SetFrameStrata("LOW")
		_details.listener:SetFrameLevel(9)
		_details.listener.FrameTime = 0
		
		_details.overlay_frame = _CreateFrame("Frame", nil, _UIParent)
		_details.overlay_frame:SetFrameStrata("TOOLTIP")

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> functions
	
	_details.empty_function = function() end
	
	--> register textures and fonts for shared media
		local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
		--default bars
		SharedMedia:Register("statusbar", "Details D'ictum",[[Interface\AddOns\Details\images\bar4]])
		SharedMedia:Register("statusbar", "Details Vidro",[[Interface\AddOns\Details\images\bar4_vidro]])
		SharedMedia:Register("statusbar", "Details D'ictum(reverse)",[[Interface\AddOns\Details\images\bar4_reverse]])
		--flat bars
		SharedMedia:Register("statusbar", "Details Serenity",[[Interface\AddOns\Details\images\bar_serenity]])
		SharedMedia:Register("statusbar", "BantoBar",[[Interface\AddOns\Details\images\BantoBar]])
		SharedMedia:Register("statusbar", "Skyline",[[Interface\AddOns\Details\images\bar_skyline]])
		--window bg and bar border
		SharedMedia:Register("background", "Details Ground",[[Interface\AddOns\Details\images\background]])
		SharedMedia:Register("border", "Details BarBorder 1",[[Interface\AddOns\Details\images\border_1]])
		SharedMedia:Register("border", "Details BarBorder 2",[[Interface\AddOns\Details\images\border_2]])
		--misc fonts
		SharedMedia:Register("font", "Oswald",[[Interface\Addons\Details\fonts\Oswald-Regular.otf]])
		SharedMedia:Register("font", "Nueva Std Cond",[[Interface\Addons\Details\fonts\NuevaStd-Cond.otf]])
		SharedMedia:Register("font", "Accidental Presidency",[[Interface\Addons\Details\fonts\Accidental Presidency.ttf]])
		SharedMedia:Register("font", "TrashHand",[[Interface\Addons\Details\fonts\TrashHand.TTF]])
		SharedMedia:Register("font", "Harry P",[[Interface\Addons\Details\fonts\HARRYP__.TTF]])
		SharedMedia:Register("font", "FORCED SQUARE",[[Interface\Addons\Details\fonts\FORCED SQUARE.ttf]])
	
	--> global 'vardump' for dump table contents over chat panel
		function vardump(t)
			if (type(t) ~= "table") then
				return
			end
			for a,b in pairs(t) do 
				print(a,b)
			end
		end
		
	--> global 'table_deepcopy' copies a full table	
		function table_deepcopy(orig)
			local orig_type = type(orig)
			local copy
			if orig_type == 'table' then
				copy = {}
				for orig_key, orig_value in next, orig, nil do
					copy[table_deepcopy(orig_key)] = table_deepcopy(orig_value)
				end
			else
				copy = orig
			end
			return copy
		end
	
	--> delay messages
		function _details:DelayMsg(msg)
			_details.delaymsgs = _details.delaymsgs or {}
			_details.delaymsgs[#_details.delaymsgs+1] = msg
		end
		function _details:ShowDelayMsg()
			if (_details.delaymsgs and #_details.delaymsgs > 0) then
				for _, msg in ipairs(_details.delaymsgs) do 
					print(msg)
				end
			end
			_details.delaymsgs = {}
		end
	
	--> print messages
		function _details:Msg(_string, arg1, arg2, arg3, arg4)
			if (self.__name) then
				--> yes, we have a name!
				print("|cffffaeae" .. self.__name .. "|r |cffcc7c7c(plugin)|r: " .. _string, arg1 or "", arg2 or "", arg3 or "", arg4 or "")
			else
				print(Loc["STRING_DETAILS1"] .. _string, arg1 or "", arg2 or "", arg3 or "", arg4 or "")
			end
		end
		
	--> welcome
		function _details:WelcomeMsgLogon()
			_details:Msg("|cffb0b0b0you can always reset the addon running the command '/details reinstall' if it does fail to load after being updated.|r")
		end
		_details:ScheduleTimer("WelcomeMsgLogon", 8)
	
	--> key binds
		--> header
			_G["BINDING_HEADER_Details"] = "Details!"
		--> keys
			_G["BINDING_NAME_DETAILS_RESET_SEGMENTS"] = "Reset Segments"
			_G["BINDING_NAME_DETAILS_SCROLL_UP"] = "Scroll Up All Windows"
			_G["BINDING_NAME_DETAILS_SCROLL_DOWN"] = "Scroll Down All Windows"
	
end
