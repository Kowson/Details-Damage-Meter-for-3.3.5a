--[[
=====================================================================================================
	Siege of Orgrimmar Mobs and Spells Ids for Details
=====================================================================================================
--]]

local Loc = LibStub ("AceLocale-3.0"):GetLocale ("Details_RaidInfo-VoA")

local _details = 		_G._details

local voa = {

	id = 533,
	ej_id = 533,
	
	name = Loc ["STRING_RAID_NAME"],
	
	icons = "Interface\\AddOns\\Details_RaidInfo-VoA\\images\\boss_faces",
	
	icon = "Interface\\AddOns\\Details_RaidInfo-VoA\\images\\icon256x128",
	
	is_raid = true,

	backgroundFile = {file = [[Interface\AddOns\Details_RaidInfo-VoA\images\icon256x128]], coords = {0, 1, 256/1024, 840/1024}},
	backgroundEJ = [[Interface\EncounterJournal\UI-EJ-LOREBG-SiegeofOrgrimmar]],
	
	boss_names = { 
			"Archavon the Stone Watcher",
			"Emalon the Storm Watcher",
			"Koralon the Flame Watcher",
			"Toravon the Ice Watcher",
	},
	
	find_boss_encounter = function()
		--> find galakras (this encounter doesn't have a boss frames before galakras comes into in play)
		if (_details.table_current and _details.table_current[1] and _details.table_current[1]._ActorTable) then
			for _, damage_actor in ipairs (_details.table_current[1]._ActorTable) do
				local serial = tonumber (damage_actor.serial:sub (9, 12), 16)
				if (serial == 31125) then -- Archavon
					return 1
				elseif (serial == 33993) then -- Emalon
					return 2
				elseif (serial == 35013) then -- Koralon
					return 3
				elseif (serial == 38433) then -- Toravon
					return 4 
				end
			end
		end
	end,
	
	encounter_ids = {
		--> Ids by Index
		772, 1127, 1128, 1129,
			[772] = 1, -- Archavon
			[774] = 2, -- Emalon
			[776] = 3, -- Koralon
			[885] = 4, -- Toravon
	},
	
	encounter_ids2 = {
	},
	
	boss_ids = {
			[31125]	= 1,	-- Archavon
			[33993]	= 2,	-- Emalon
			[35013]	= 3,	-- Koralon
			[38433]	= 4,	-- Toravon
	},
	
	trash_ids = {
		-- Flame Leviathan
		[32353] = true, -- Archavon
		[34015] = true, -- Tempest
		[35143] = true, -- Flame
		[38482] = true, -- Frost
	},
	
	encounters = {
	
------------> Archavon ------------------------------------------------------------------------------
		[1] = {
			
			boss =	"Archavon the Stone Watcher",
			portrait = [[Interface\AddOns\Details_RaidInfo-VoA\images\archavon]],

			spell_mechanics =	{
						[58678] = {0x1}, --> Rock Shards
						[58960] = {0x40}, --> Leap 10
						[60894] = {0x40}, -->  Leap 25
						[58663] = {0x100}, --> Stomp 10
						[60880] = {0x100}, --> Stomp 25
						[58666] = {0x1}, --> Impale 10
						[60882] = {0x1}, --> Impale 25
					},

			continuo = {
						58678, --> Rock Shards
						58960, --> Leap 10
						60894, -->  Leap 25
						58663, --> Stomp 10
						60880, --> Stomp 25
						58666, --> Impale 10
						60882, --> Impale 25
			},
			
			phases = {
				--> phase 1 
				{
					spells = {
						-- all spells are continuous
						},
						
					adds = {
						31125, --> Archavon
					}
				},
			}
		}, --> end Archavon
		
		
------------> Emalon ------------------------------------------------------------------------------
		[2] = {

			boss =	"Emalon the Storm Watcher",
			portrait = [[Interface\AddOns\Details_RaidInfo-VoA\images\emalon]],
			combat_end = {1, 33993},
			spell_mechanics =	{
						[64217] = {0x1000}, --> Overcharged
						[64219] = {0x200}, --> Overcharged Blast
						[64218] = {0x200}, --> Overcharged
						[64213] = {0x2000}, --> Chain Lightning
						[64215] = {0x2000}, --> Chain Lightning
						[64216] = {0x80}, --> Lightning Nova
						[65279] = {0x80}, --> Lightning Nova
					},
		

		
			continuo = {
						64217, --> Overcharged
						64219, --> Overcharged Blast
						64218, --> Overcharged
						64213, --> Chain Lightning
						64215, --> Chain Lightning
						64216, --> Lightning Nova
						65279, --> Lightning Nova
			},
		
			phases = {
				{
					--> phase 1 - 
					spells = {
							--> no spell, is all continuo
						},
					adds = 	{
							33993, -- Emalon
							33998, -- Tempest Minion
						}
				}			
			} 
	
		}, --> end of Emalon
		
------------> Koralon ------------------------------------------------------------------------------

		[3] = {
			boss =	"Koralon the Flame Watcher",
			portrait = [[Interface\AddOns\Details_RaidInfo-VoA\images\koralon]],
			
			combat_end = {1, 35013},
			encounter_start = {delay = 0},
			equalize = true,
			
			spell_mechanics =	{
						[67329] = {0x1}, --> Burning Breath
						[67332] = {0x8}, --> Flaming Cinder
						[67333] = {0x200}, --> Meteor Fists
			},
			
			continuo = {
						67333, --> Burning Breath
						67329, --> Flaming Cinder
						67332, --> Meteor Fists
			},
			
			phases = {
				{
					adds = 	{
							35013, --> Koralon
					},
					spells = {
					},
				},
			}

		}, --> end of Koralon
		
------------> Toravon ------------------------------------------------------------------------------	
		[4] = {
			boss =	"Toravon the Ice Watcher",
			portrait = [[Interface\AddOns\Details_RaidInfo-VoA\images\toravon]],
			
			combat_end = {1, 38433},
			
			spell_mechanics = {
				[63024] = {0x10}, --> Freezing Ground
				[64234] = {0x1000}, --> Frozen Orb
				[63018] = {0x1, 0x10000}, --> Whiteout
				[65121] = {0x200}, --> Frozen Mallet
				[62776] = {0x1000}, --> Frozen Orb Damage
				[72120] = {0x1}, --> Frostbite
			},
			
			continuo = {
				63024, --> Freezing Ground
				64234, --> Frozen Orb
				63018, --> Whiteout
				65121,  --> Frozen Mallet
				62776, --> Frozen Orb Damage
				72120, --> Frostbite
			},
			
			phases = { 
				{ --> phase 1
					adds = {
						38433, --> Toravon
						38456, --> Frozen Orb
						38461, --> Frozen Orb Stalker
						} 
				}
			}
		}, --> end of Toravon
				
	} --> End VoA
}
_details:InstallEncounter (voa)
