--[[
=====================================================================================================
	Siege of Orgrimmar Mobs and Spells Ids for Details
=====================================================================================================
--]]

local L = LibStub ("AceLocale-3.0"):GetLocale ("Details_RaidInfo-ChamberOfAspects-OS")

local _details = 		_G._details

local obsidianSanctum = {

	id = 531,
	ej_id = 531,
	
	name = L["STRING_RAID_NAME"],
	
	icons = "Interface\\AddOns\\Details_RaidInfo-ChamberOfAspects\\images\\boss_faces_os",
	
	icon = "Interface\\AddOns\\Details_RaidInfo-ChamberOfAspects\\images\\icon256x128_os",
	
	is_raid = true,

	backgroundFile = {file = [[Interface\AddOns\Details_RaidInfo-ChamberOfAspects\images\icon256x128_os]], coords = {0, 1, 256/1024, 840/1024}},
	backgroundEJ = [[Interface\EncounterJournal\UI-EJ-LOREBG-SiegeofOrgrimmar]],
	
	boss_names = { 
			L["BOSS_SARTHARION"],
			L["BOSS_SHADRON"],
			L["BOSS_TENEBRON"],
			L["BOSS_VESPERON"],
	},
	--[[
	find_boss_encounter = function()
		if (_details.table_current and _details.table_current[1] and _details.table_current[1]._ActorTable) then
			for _, damage_actor in ipairs (_details.table_current[1]._ActorTable) do
				local serial = tonumber (damage_actor.serial:sub (9, 12), 16)
			end
		end
	end,
	]]--
	encounter_ids = {
		--> Ids by Index
		742, 738, 737, 740,
			[742] = 1, -- Sartharion
			[738] = 2, -- Shadron
			[737] = 3, -- Tenebron 
			[740] = 4, -- Vesperon
	},
	
	encounter_ids2 = {
	},
	
	boss_ids = {
			[28860]	= 1, -- Sartharion
			[30451] = 2, -- Shadron
			[30452] = 3, -- Tenebron
			[30449] = 4, -- Vesperon
	},
	
	trash_ids = {
		[30681] = true, -- Onyx Blaze Mistress
		[30680] = true, -- Onyx Brood General
		[30682] = true, -- Onyx Flight Captain
		[30453] = true, -- Onyx Sanctum Guardian
	},
	
	encounters = {
	
------------> Sartharion ------------------------------------------------------------------------------
		[1] = {
			
			boss =	L["BOSS_SARTHARION"],
			portrait = [[Interface\AddOns\Details_RaidInfo-ChamberOfAspects\images\sartharion]],

			combat_end = {1, 28860},
			equalize = true,

			spell_mechanics =	{
				[56909] = { 0x8000, 0x1 }, -- Cleave
				[56908] = { 0x8000, 0x1 }, -- Flame Breath 10
				[58956] = { 0x8000, 0x1 }, -- Flame Breath 25
				[56910] = { 0x8000 }, -- Tail Lash 10
				[58957] = { 0x8000 }, -- Tail Lash 25
				[57557] = { 0x8 }, -- Pyrobuffet
				[57570] = { 0x8000, 0x1 }, -- Shadow Breath (Drakes) 10
				[59126] = { 0x8000, 0x1 }, -- Shadow Breath (Drakes) 25
				[57581] = { 0x8 }, -- Void Blast (shadow fissure) 10
				[59128] = { 0x8 }, -- Void Blast (shadow fissure) 25
				[57491] = { 0x40, 0x80 }, -- Flame Wall
				[60430] = { 0x1 }, -- Molten Fury
				[61632] = { 0x2 }, -- Berserk
				[60708] = { 0x1000 }, -- Fade Armor
					},

			continuo = {
				56909, -- Cleave
				56908, -- Flame Breath 10
				58956, -- Flame Breath 25
				56910, -- Tail Lash 10
				58957, -- Tail Lash 25
				57557, -- Pyrobuffet
				61248, -- Power of Tenebron
				58105, -- Power of Shadron
				61251, -- Power of Vesperon
				61254, -- Will of Sartharion
				60639, -- Twilight Revenge
				61632, -- Berserk

				57570, -- Shadow Breath (Drakes) 10
				59126, -- Shadow Breath (Drakes) 25
				57581, -- Void Blast (shadow fissure) 10
				59128, -- Void Blast (shadow fissure) 25
				58766, -- Gift of Twilight
				57874, -- Twilight Shift
				61885, -- Twlight Residue
				60708, -- Fade Armor

				57491, -- Flame Wall
				60430, -- Molten Fury
			},
			
			phases = {
				{
					spells = {
						},
						
					adds = {
						28860, -- Sartharion
						30451, -- Shadron
						30452, -- Tenebron
						30449, -- Vesperon
						30616, -- Flame Wall
						57598, -- Raining Fire (Cyclone Aura)

						30882, -- Twilight Egg
						30890, -- Twilight Whelp
						30688, -- Disciple of Shadron
						30858, -- Disciple of Vesperon
						31218, -- Acolyte of Shadron
						31219, -- Acolyte of Vesperon

						30643, -- Lava Blaze

					}
				},
			}
		}, --> end Sartharion
------------> Shadron ------------------------------------------------------------------------------
		[2] = {
			
			boss =	L["BOSS_SHADRON"],
			portrait = [[Interface\AddOns\Details\images\UI-EJ-BOSS-Default]],

			combat_end = {1, 30451},
			equalize = true,

			spell_mechanics =	{
				[57570] = { 0x8000, 0x1 }, -- Shadow Breath (Drakes) 10
				[59126] = { 0x8000, 0x1 }, -- Shadow Breath (Drakes) 25
				[57581] = { 0x8 }, -- Void Blast (shadow fissure) 10
				[59128] = { 0x8 }, -- Void Blast (shadow fissure) 25
					},

			continuo = {
				57570, -- Shadow Breath (Drakes) 10
				59126, -- Shadow Breath (Drakes) 25
				57581, -- Void Blast (shadow fissure) 10
				59128, -- Void Blast (shadow fissure) 25
				58766, -- Gift of Twilight
				57874, -- Twilight Shift
				61885, -- Twlight Residue
			},
			
			phases = {
				{
					spells = {
						},
						
					adds = {
						30451, -- Shadron
						31218, -- Acolyte of Shadron
					}
				},
			}
		}, --> end Shadron
------------> Tenebron ------------------------------------------------------------------------------
		[3] = {
			
			boss =	L["BOSS_TENEBRON"],
			portrait = [[Interface\AddOns\Details\images\UI-EJ-BOSS-Default]],

			combat_end = {1, 30452},
			equalize = true,

			spell_mechanics =	{
				[57570] = { 0x8000, 0x1 }, -- Shadow Breath (Drakes) 10
				[59126] = { 0x8000, 0x1 }, -- Shadow Breath (Drakes) 25
				[57581] = { 0x8 }, -- Void Blast (shadow fissure) 10
				[59128] = { 0x8 }, -- Void Blast (shadow fissure) 25
					},

			continuo = {
				57570, -- Shadow Breath (Drakes) 10
				59126, -- Shadow Breath (Drakes) 25
				57581, -- Void Blast (shadow fissure) 10
				59128, -- Void Blast (shadow fissure) 25
				57874, -- Twilight Shift
				61885, -- Twlight Residue
				60708, -- Fade Armor 
			},
			
			phases = {
				{
					spells = {
						},
						
					adds = {
						30452, -- Tenebron
						30882, -- Twilight Egg
						30890, -- Twilight Whelp
					}
				},
			}
		}, --> end Tenebron
------------> Vesperon ------------------------------------------------------------------------------
		[4] = {
			
			boss =	L["BOSS_VESPERON"],
			portrait = [[Interface\AddOns\Details\images\UI-EJ-BOSS-Default]],

			combat_end = {1, 30449},
			equalize = true,

			spell_mechanics =	{
				[57570] = { 0x8000, 0x1 }, -- Shadow Breath (Drakes) 10
				[59126] = { 0x8000, 0x1 }, -- Shadow Breath (Drakes) 25
				[57581] = { 0x8 }, -- Void Blast (shadow fissure) 10
				[59128] = { 0x8 }, -- Void Blast (shadow fissure) 25
					},

			continuo = {
				57570, -- Shadow Breath (Drakes) 10
				59126, -- Shadow Breath (Drakes) 25
				57581, -- Void Blast (shadow fissure) 10
				59128, -- Void Blast (shadow fissure) 25
				57874, -- Twilight Shift
				61885, -- Twlight Residue
				58835, -- Twilight Torment
			},
			
			phases = {
				{
					spells = {
						},
						
					adds = {
						30449, -- Vesperon
						31219, -- Acolyte of Vesperon
					}
				},
			}
		}, --> end Vesperon
	} --> End OS
}
_details:InstallEncounter (obsidianSanctum)
