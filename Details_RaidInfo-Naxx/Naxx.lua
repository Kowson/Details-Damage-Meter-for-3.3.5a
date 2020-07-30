--[[
=====================================================================================================
	Siege of Orgrimmar Mobs and Spells Ids for Details
=====================================================================================================
--]]

local L = LibStub ("AceLocale-3.0"):GetLocale ("Details_RaidInfo-Naxx")

local _details = 		_G._details

local naxx = {

	id = 536,
	ej_id = 536,
	
	name = L ["STRING_RAID_NAME"],
	
	icons = "Interface\\AddOns\\Details_RaidInfo-Naxx\\images\\boss_faces",
	
	icon = "Interface\\AddOns\\Details_RaidInfo-Naxx\\images\\icon256x128",
	
	is_raid = true,

	backgroundFile = {file = [[Interface\LFGFrame\UI-LFG-BACKGROUND-Naxxramas]], coords = {0, 1, 256/1024, 840/1024}},
	backgroundEJ = [[Interface\EncounterJournal\UI-EJ-LOREBG-Naxxramas]],
	
	boss_names = {
		L["STRING_ANUB"],
		L["STRING_WIDOW"],
		L["STRING_MAEXXNA"],

		L["STRING_NOTH"],
		L["STRING_HEIGAN"],
		L["STRING_LOATHEB"],

		L["STRING_INSTRUCTOR"],
		L["STRING_GOTHIK"],
		L["STRING_HORSEMEN"],

		L["STRING_PATCHWERK"],
		L["STRING_GROBBULUS"],
		L["STRING_GLUTH"],
		L["STRING_THADDIUS"],

		L["STRING_SAPPHIRON"],
		L["STRING_KT"]
	},

	find_boss_encounter = function()
		--> find horsemen or KT or thaddius
		if (_details.table_current and _details.table_current[1] and _details.table_current[1]._ActorTable) then
			for _, damage_actor in ipairs(_details.table_current[1]._ActorTable) do
				local serial = tonumber(damage_actor.serial:sub(9, 12), 16)
				if (serial == 15990) then -- KT
					return 15 --> kt 
				elseif (serial == 16064) then -- thane horseman guy
					return 9 -- horsemen 
				elseif (serial == 15929 or serial == 15930) then -- stalagg / feugen
					return 13 -- thaddius
				end
			end
		end
	end,
	
	encounter_ids = {
		--> Ids by Index
		673, 677, 679, -- spider
		681, 683, 685, -- plague
		687, 690, 692, -- military
		694, 696, 698, 700, -- construct
		702, 704, -- final
		-- Spider
		[673] = 1, -- Anub'Rekhan
		[677] = 2, -- Grand Widow Faerlina
		[679] = 3, -- Maexxna
		-- Plague
		[681] = 4, -- Noth the Plaguebringer
		[683] = 5, -- Heigan the Unclean
		[685] = 6, -- Loatheb
		-- Military
		[687] = 7, -- Instructor Razuvious
		[690] = 8, -- Gothik the Harvester
		[692] = 9, -- The Four Horsemen
		-- Construct
		[694] = 10, -- Patchwerk
		[696] = 11, -- Grobbulus
		[698] = 12, -- Gluth
		[700] = 13, -- Thaddius
		-- Final
		[702] = 14, -- Sapphiron
		[704] = 15, -- Kel'Thuzad
	},
	
	encounter_ids2 = {
		-- Spider
		[674] = 1, -- Anub'Rekhan
		[678] = 2, -- Grand Widow Faerlina
		[680] = 3, -- Maexxna
		-- Plague
		[682] = 4, -- Noth the Plaguebringer
		[684] = 5, -- Heigan the Unclean
		[686] = 6, -- Loatheb
		-- Military
		[689] = 7, -- Instructor Razuvious
		[691] = 8, -- Gothik the Harvester
		[693] = 9, -- The Four Horsemen
		-- Construct
		[695] = 10, -- Patchwerk
		[697] = 11, -- Grobbulus
		[699] = 12, -- Gluth
		[701] = 13, -- Thaddius
		-- Final
		[703] = 14, -- Sapphiron
		[706] = 15, -- Kel'Thuzad
	},
	
	boss_ids = {
		-- Spider
			[15956]	= 1, -- Anub'Rekhan
			[15953] = 2, -- Grand Widow Faerlina
			[15952] = 3, -- Maexxna
		-- Plague
			[15954] = 4, -- Noth the Plaguebringer
			[15936] = 5, -- Heigan the Unclean
			[16011] = 6, -- Loatheb
		-- Military
			[16061] = 7, -- Instructor Razuvious
			[16060] = 8, -- Gothik the Harvester
			[16064] = 9, -- Thane
			[30549] = 9, -- Rivendare
			[16065] = 9, -- Blaumeux
			[16063] = 9, -- Zelik
		-- Construct
			[16028] = 10, -- Patchwerk
			[15931] = 11, -- Grobbulus
			[15932] = 12, -- Gluth
			[15928] = 13, -- Thaddius
		-- Final
			[15989] = 14, -- Sapphiron
			[15990] = 15, -- Kel'Thuzad
	},
	
	trash_ids = {
	},
	
	encounters = {
	
------------> Anub'Rekhan ------------------------------------------------------------------------------
		[1] = {
			
			boss =	L["STRING_ANUB"],
			portrait = [[Interface\AddOns\Details_RaidInfo-Naxx\images\anubrekhan]],

			spell_mechanics =	{
				[28785] = {0x1}, -- Swarm 10
				[54021] = {0x1}, -- Swarm 25
				[28783] = {0x40}, -- Impale 10
				[56090] = {0x40}, -- Impale 25
			},

			continuo = {
				28785, -- Swarm 10
				54021, -- Swarm 25
				28783, -- Impale 10
				56090, -- Impale 25
			},
			
			phases = {
				{
					spells = {					
						},
						
					adds = {
						15956, -- Anub'Rekhan
					}
				},
			}
		}, --> end of Beasts of Northrend
		
		
------------> Grand Widow Faerlina ------------------------------------------------------------------------------
		[2] = {

			boss =	L["STRING_WIDOW"],
			portrait = [[Interface\AddOns\Details_RaidInfo-Naxximages\widow]],


			spell_mechanics =	{
				[28798] = {0x1}, -- Frenzy 10
				[28796] = {0x1}, -- Poison Bolt Volley 10
				[28794] = {0x40}, -- Rain of Fire 10
				[54100] = {0x1}, -- Frenzy 25
				[54098] = {0x1}, -- Poison Bolt Volley 25
				[54099] = {0x40}, -- Rain of Fire 25

				[54095] = {0x1}, -- Worshiper Fireball 10
				[54096] = {0x1}, -- Worshiper Fireball 25
				[28732] = {0x1}, -- Worshiper Widows Embrace 

				[56107] = {0x1}, -- Follower Charge 25
				[54093] = {0x1}, -- Follower Silence 25
			},
		

		
			continuo = {
				28798, -- Frenzy 10
				28796, -- Poison Bolt Volley 10
				28794, -- Rain of Fire 10
				54100, -- Frenzy 25
				54098, -- Poison Bolt Volley 25
				54099, -- Rain of Fire 25

				54095, -- Worshiper Fireball 10
				54096, -- Worshiper Fireball 25
				28732, -- Worshiper Widows Embrace

				56107, -- Follower Charge 25
				54093, -- Follower Silence 25
			},
		
			phases = {
				{
					--> phase 1 - 
					spells = {
						},
					adds = 	{
						16506, -- Worshiper
						16505, -- Follower
						15953, -- Grand Widow Faerlina
						}
				}			
			} 
	
		}, --> end of Grand Widow

------------> Maexxna ------------------------------------------------------------------------------	
		[3] = {
			boss =	L["STRING_MAEXXNA"],
			portrait = [[Interface\AddOns\Details_RaidInfo-Naxx\images\maexxna]],
			
			
			spell_mechanics = {
				[54123] = {0x1}, -- Frenzy 10
				[54121] = {0x1}, -- Necrotic Poison 10
				[28741] = {0x1}, -- Poison Shock 10
				[29484] = {0x100}, -- Web Spray 10

				[54124] = {0x1}, -- Frenzy25
				[28776] = {0x1}, -- Necrotic Poison 25
				[54122] = {0x1}, -- Poison Shock 25
				[54125] = {0x100}, -- Web Spray 25

				[28622] = {0x1}, -- Web Wrap
			},
			
			continuo = {           
				54123, -- Frenzy 10
				54121, -- Necrotic Poison 10
				28741, -- Poison Shock 10
				29484, -- Web Spray 10

				54124, -- Frenzy 25
				28776, -- Necrotic Poison 25
				54122, -- Poison Shock 25
				54125, -- Web Spray 25
			},
			
			phases = { 
				{ --> phase 1
					adds = {
						16486, -- Web Wrap Cocoon
						17055, -- Spiderlings
						} 
				}
			}
		}, --> end of Maexxna
		
------------> Noth the Plaguebringer ------------------------------------------------------------------------------	
		[4] = {
			boss =	L["STRING_NOTH"],
			portrait = [[Interface\AddOns\Details_RaidInfo-Naxx\images\noth]],
			
			spell_mechanics = {
				
			},

			continuo = {	
			},
			
			phases = { 
				{ -- Phase 1: Ground Phase
					adds = {			
						15954, -- Noth the Plaguebringer
						16984, -- Plagued Warrior
					},
					spells = {							
						29213, -- Curse of the Plaguebringer
						29208, -- Blink
						29212, -- Cripple

						29214, -- Wrath of the Plaguebringer 10

						54836, -- Wrath of the Plaguebringer 25

						15496, -- Warrior Cleave
						}
				},

				{ -- Phase 2: Add Phase
					adds = {			
						16983, -- Plagued Champion
						16981, -- Plagued Guardian
					},
					spells = {			
						32736, -- Champion Mortal Strike 
						30138, -- Champion Shadow Shock 10
						54889, -- Champion Shadow Shock 25

						54890, -- Arcane Explosion 10
						54891, -- Arcane Explosion 25
						}
				},
			}
		}, --> end of Noth the Plaguebringer

------------> Heigan the Unclean ------------------------------------------------------------------------------	
		[5] = {
			boss =	L["STRING_HEIGAN"],
			portrait = [[Interface\AddOns\Details_RaidInfo-Naxx\images\heigan]],
			
			spell_mechanics = {
				[29371] = {0x10000}, -- Eruption
				[29310] = {0x1}, -- Spell Disruption
				[29998] = {0x4}, -- Decrepit Fever 10
				[55011] = {0x4}, -- Decrepit Fever 25
				[30122] = {0x1000}, -- Plague Cloud
			},

			continuo = {
				29371, -- Eruption	
			},
			
			phases = { 
				{ -- Phase 1: Move
					adds = {			
						15936, -- Heigan
					},
					spells = {
						29310, -- Spell disruption
						29998, -- Decrepit Fever 10
						55011, -- Decrepit Fever 25

					}
				},
				{ -- Phase 2: Dance
					adds = {			
						15936, -- Heigan
					},
					spells = {
						30122, -- Plague Cloud
					}
				},
			}
		}, --> end of Heigan the Unclean

------------> Loatheb ------------------------------------------------------------------------------	
		[6] = {
			boss =	L["STRING_LOATHEB"],
			portrait = [[Interface\AddOns\Details_RaidInfo-Naxx\images\loatheb]],
			
			spell_mechanics = {
				[55593] = {0x1}, -- Necrotic Aura
				[29232] = {0x1}, -- Fungal Creep
				[29865] = {0x4}, -- Deathbloom 10
				[55053] = {0x4}, -- Deathbloom 25
				[29204] = {0x100}, -- Inevitable Doom 10
				[55052] = {0x100} -- Inevitable Doom 25
			},

			continuo = {
				55593, -- Necrotic Aura
				29232, -- Fungal Creep
				29865, -- Deathbloom 10
				55053, -- Deathbloom 25
				29204, -- Inevitable Doom 10
				55052, -- Inevitable Doom 25
			},
			
			phases = { 
				{
					adds = {		
						16011, -- Loatheb
						16286, -- Spore	
					},
					spells = {

					}
				},
			}
		}, --> end of Heigan the Unclean

------------> Instructor Razuvious ------------------------------------------------------------------------------	
		[7] = {
			boss =	L["STRING_INSTRUCTOR"],
			portrait = [[Interface\AddOns\Details_RaidInfo-Naxx\images\razuvious]],
			
			combat_end = {1, 16061},

			spell_mechanics = {
			},

			continuo = {
				55470, -- Unbalacing Strike
				55550, -- Jagged Knife
				55543, -- Disrupting Shout 10
				29107, -- Disrupting Shout 25

				61696, -- Understudy Blood Strike
				29060, -- Understudy Taunt
				29061, -- Understudy Bone Barrier
				29125, -- Understudy Hopeless
			},
			
			phases = { 
				{
					adds = {		
						16061, -- Razuvious
						16803, -- Understudy
					},
					spells = {
					}
				},
			}
		}, --> end of Instructor Razuvious

------------> Gothik the Harvester ------------------------------------------------------------------------------	
		[8] = {
			boss =	L["STRING_GOTHIK"],
			portrait = [[Interface\AddOns\Details_RaidInfo-Naxx\images\gothik]],
			
			spell_mechanics = {
			},

			continuo = {
			},
			
			phases = { 
				{ -- Phase 1: Adds
					adds = {		
						16124, -- Trainee
						16125, -- Death Knight
						16126, -- Rider
						16127, -- Undead Trainee
						16148, -- Undead Death Knight
						16150, -- Undead Rider
						16149, -- Undead Horse
					},
					spells = {
						55604, -- Death Plague 10
						55645, -- Death Plague 25
						27825, -- Shadow Mark 
						55606, -- Unholy Aura 10
						55608, -- Unholy Aura 25
						27831, -- Shadow Bolt Volley 10
						55638, -- Shadow Bolt Volley 25
						27989, -- Arcane Explosion 10
						56407, -- Arcane Explosion 25
						56408, -- Whirlwind
						27994, -- Drain Life 10
						55646, -- Drain Life 25
						55648, -- Unholy Frenzy 10
						27995, -- Unholy Frenzy 25
						27993, -- Stomp
					}
				},
				{ -- Phase 2: Gothik
					adds = {		
						16060, -- Gothik
					},
					spells = {
						29317, -- Shadow Bolt 10
						56405, -- Shadow Bolt 25
						28679, -- Harvest Soul
					}
				},
			}
		}, --> end of Gothik the Harvester

------------> The Four Horsemen ------------------------------------------------------------------------------	
		[9] = {
			boss =	L["STRING_HORSEMEN"],
			portrait = [[Interface\AddOns\Details_RaidInfo-Naxx\images\horsemen]],
			
			spell_mechanics = {
			},

			continuo = {
				-- Thane
				28832, -- Mark
				28884, -- Meteor 10
				57467, -- Meteor 25
				-- Blaumeux
				28833, -- Mark
				57374, -- Shadow Bolt 10
				28863, -- Void Zone 10
				57381, -- Unyielding Pain
				57464, -- Shadow Bolt 25
				57463, -- Void Zone 25
				-- Rivendare
				28834, -- Mark
				28882, -- Unholy Shadow 10
				57369, -- Unholy Shadow 25
				-- Zelik
				28835, -- Mark
				57376, -- Holy Bolt
				28883, -- Holy Wrath 10
				57377, -- Condemnation
				57466, -- Holy Wrath 25
			},
			
			phases = { 
				{
					adds = {
						16064, -- Thane
						16065, -- Blaumeux
						30549, -- Rivendare
						16063, -- Zelik
					},
					spells = {

					}
				},
			}
		}, --> end of The Four Horsemen

------------> Patchwerk ------------------------------------------------------------------------------	
		[10] = {
			boss =	L["STRING_PATCHWERK"],
			portrait = [[Interface\AddOns\Details_RaidInfo-Naxx\images\patchwerk]],
			
			spell_mechanics = {
			},

			continuo = {
				41926, -- Hateful Strike 10
				59192, -- Hateful Strike 25
				28131, -- Frenzy 
				26662, -- Berserk 
				32309, -- Slime Bolt (Enrage Ability)
			},
			
			phases = { 
				{
					adds = {	
						16028, -- Patckwerk	
					},
					spells = {

					}
				},
			}
		}, --> end of Patchwerk

------------> Grobbulus ------------------------------------------------------------------------------	
		[11] = {
			boss =	L["STRING_GROBBULUS"],
			portrait = [[Interface\AddOns\Details_RaidInfo-Naxx\images\grobbulus]],
			
			spell_mechanics = {
			},

			continuo = {
				28240, -- Posion Cloud 
				28169, -- Mutating Injection
				28157, -- Slime Spray 10
				54364, -- Slime Spray 25
				26662, -- Berserk
			},
			
			phases = { 
				{
					adds = {	
						16290, -- Fallout Slime
						15931, -- Grobbulus	
					},
					spells = {

					}
				},
			}
		}, --> end of Grobbulus
		
------------> Gluth ------------------------------------------------------------------------------	
		[12] = {
			boss =	L["STRING_GLUTH"],
			portrait = [[Interface\AddOns\Details_RaidInfo-Naxx\images\gluth]],
			
			spell_mechanics = {
			},

			continuo = {
				54378, -- Mortal Wound
				28371, -- Enrage 10
				54427, -- Enrage 25
				28374, -- Decimate
				29306, -- Infected Wound
				26662, -- Berserk
				28404, -- Consume Zombie Chow
			},
			
			phases = { 
				{
					adds = {		
						16360, -- Zombie Chow
						15932, -- Gluth
					},
					spells = {

					}
				},
			}
		}, --> end of Gluth
				
------------> Thaddius ------------------------------------------------------------------------------	
		[13] = {
			boss =	L["STRING_THADDIUS"],
			portrait = [[Interface\AddOns\Details_RaidInfo-Naxx\images\thaddius]],
			
			combat_end = {1, 15928},

			spell_mechanics = {
			},

			continuo = {
			},
			
			phases = { 
				{ -- Phase 1: Stalagg & Feugen
					adds = {		
						15929, -- Stalagg
						15930, -- Feugen
						16218, -- Tesla Coil
					},
					spells = {
						54529, -- Stalagg Power Surge 10
						28134, -- Stalagg Power Surge 25
						28338, -- Magnetic Pull
						28099, -- Shock (Tesla Coil)
						28135, -- Feugen Static Field 10
						54528, -- Feugen Static Field 25
					}
				},
				{ -- Phase 2: Thaddius
					adds = {		
						15928, -- Thaddius
					},
					spells = {
						28089, -- Polarity Shift
						28059, -- Positive Charge
						28084, -- Negative Charge
						28167, -- Chain Lightning 10
						54531, -- Chain Lightning 25
						28299, -- Ball Lightning 
						27680, -- Berserk
					}
				},
			}
		}, --> end of Thaddius

				
------------> Sapphiron ------------------------------------------------------------------------------	
		[14] = {
			boss =	L["STRING_SAPPHIRON"],
			portrait = [[Interface\AddOns\Details_RaidInfo-Naxx\images\sapphiron]],
			
			spell_mechanics = {
			},

			continuo = {
				28531, -- Frost Aura 10
				55799, -- Frost Aura 25
				19983, -- Cleave
				55697, -- Tail Sweep 10
				55696, -- Tail Sweep 25
				28542, -- Life Drain 10
				55665, -- Life Drain 25
				28560, -- Summon Blizzard
				28547, -- Chill 10
				55699, -- Chill 25
				26662, -- Berserk
				28522, -- Ice Bolt
				28526, -- Ice Bolt (?)
				28524, -- Frost Breath
			},
			
			phases = { 
				{
					adds = {
						15989, -- Sapphiron
					},
					spells = {

					}
				},
			}
		}, --> end of Sapphiron

				
------------> Kel'Thuzad ------------------------------------------------------------------------------	
		[15] = {
			boss =	L["STRING_KT"],
			portrait = [[Interface\AddOns\Details_RaidInfo-Naxx\images\kelthuzad]],
			
			combat_end = {1, 15990},
			spell_mechanics = {
			},

			continuo = {
			},
			
			phases = { 
				{ -- Phase 1: Add Phase
					adds = {		
						16427, -- Soldier of the Frozen Wastes
						16428, -- Unstoppable Abomination
						16429, -- Soul Weaver
					},
					spells = {
						28457, -- Dark Blast 10
						55714, -- Dark Blast 25
						28467, -- Mortal Wound
						28459, -- Wail of Souls 10
						55765, -- Wail of Souls 25
					}
				},
				{ -- Phase 2: KT
					adds = {		
						15990, -- Kel'Thuzad
						16441, -- Guardian of Icecrown
						16129, -- Shadow Fissure
					},
					spells = {
						28470, -- Blood Tap
						28478, -- Frostbolt Single 10
						55802, -- Frostbolt Single 25
						28479, -- Frostbolt Volley 10
						55807, -- Frostbolt Volley 25
						27810, -- Shadow Fissure
						27812, -- Void Blast
						27819, -- Detonate Mana
						27808, -- Frost Blast
						28408, -- Chains of Kel'Thuzad 25
					}
				},
			}
		}, --> end of Kel'Thuzad
	} --> End Naxxramas
}
_details:InstallEncounter (naxx)
