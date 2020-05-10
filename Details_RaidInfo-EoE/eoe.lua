--[[
=====================================================================================================
	Siege of Orgrimmar Mobs and Spells Ids for Details
=====================================================================================================
--]]

local L = LibStub ("AceLocale-3.0"):GetLocale ("Details_RaidInfo-EoE")

local _details = 		_G._details

local eoe = {

	id = 528,
	ej_id = 528,
	
	name = L["STRING_RAID_NAME"],
	
	icons = "Interface\\AddOns\\Details_RaidInfo-EoE\\images\\boss_faces",
	
	icon = "Interface\\AddOns\\Details_RaidInfo-EoE\\images\\icon256x128",
	
	is_raid = true,

	backgroundFile = {file = [[Interface\AddOns\Details_RaidInfo-EoE\images\icon256x128]], coords = {0, 1, 256/1024, 840/1024}},
	backgroundEJ = [[Interface\EncounterJournal\UI-EJ-LOREBG-SiegeofOrgrimmar]],
	
	boss_names = { 
			L["BOSS_MALYGOS"]
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
		734,
		[734] = 1, -- Malygos
	},
	
	encounter_ids2 = {
	},
	
	boss_ids = {
			[28859]	= 1,
	},
	
	trash_ids = {
	},
	
	encounters = {
	
------------> Malygos ------------------------------------------------------------------------------
		[1] = {
			
			boss =	L["BOSS_MALYGOS"],
			portrait = [[Interface\AddOns\Details_RaidInfo-EoE\images\malygos]],

			combat_end = {1, 28859},

			spell_mechanics =	{
					},

			continuo = {
			},
			
			phases = {
				{ -- Malygos 50% 
					spells = {
						56272, -- Arcane Breath 10
						60072, -- Arcane Breath 25
						56105, -- Vortex
						56152, -- Power Spark
						},
						
					adds = {
						28859, -- Malygos
						30084, -- Power Spark

					}
				},
				{ -- Add / Disc Phase
					spells = {
						57058, -- Arcane Shock 10
						60073, -- Arcane Shock 25
						57060, -- Haste
						56397, -- Arcane Barrage
						57432, -- Arcane Pulse
						61693, -- Arcane Storm 10
						61694, -- Arcane Storm 25
						},
						
					adds = {
						30245, -- Nexus Lord
						30249, -- Scion of Eternity
					}
				},
				{ -- Dragon Phase
					spells = {
						57430, -- Static Field
						56505, -- Surge of Power 10
						57407, -- Surge of Power 25
						},
						
					adds = {
						28859, -- Malygos
					}
				},
			}
		}, --> end Malygos
	} --> End EoE
}
_details:InstallEncounter (eoe)
