return {
	descriptions = {
		Blind = {
			-- Kanto
			bl_pkrm_gym_boulder = {name = 'The Boulder', text = {"{X:lightning,C:white}Lightning{} and {X:fire,C:white}Fire{}","Jokers are disabled"}},
			bl_pkrm_gym_cascade = {name = 'The Cascade', text = {"-#1# chips#2#.","50% chance to", "do it again"}}, -- 8!!
			bl_pkrm_gym_thunder = {name = 'The Thunder', text = {"Lose $#1# when Discard", "without #2#"}},
			bl_pkrm_gym_rainbow = {name = 'The Rainbow', text = {"Wild and Polychrome cards", "are debuffed"}},
			bl_pkrm_gym_soul    = {name = 'The Soul'   , text = {"After Play or Discard,", "flip cards held in hand"}},
			bl_pkrm_gym_soul_janine = {name = 'The Soul'   , text = {"After Play or Discard,", "flip cards in deck"}}, -- 9!!
			-- TODO: Soul with Janine after Johto instead of Koga
			bl_pkrm_gym_marsh   = {name = 'The Marsh'  , text = {"Drawn cards are debuffed", "until 1 Consumable used"}},
			bl_pkrm_gym_volcano = {name = 'The Volcano', text = {"Pokermon Trivia","Answer 3 correct to win!"}},
			bl_pkrm_gym_earth   = {name = 'The Earth'  , text = {"Very big blind.", "-1X in size for every {C:gold}$#1#{}","earned this round"}},
			bl_pkrm_gym_e4_lorelei = {name = 'Frozen Flow' , text = {"Only draw cards when", "hand has #1# or fewer cards"}},
			bl_pkrm_gym_e4_bruno   = {name = 'Slate Shackles', text = {"Add a temporary Stone card", "per card below 52", "in full deck"}},
			bl_pkrm_gym_e4_agatha  = {name = 'Cursed Cane'    , text = {"One random Joker", "has its Energy drained", "every hand"}}, -- 5!!
			bl_pkrm_gym_e4_lance   = {name = 'Sunset Scale'  , text = {"Debuff one rightmost","scoring card", "for each remaining hand"}},
			bl_pkrm_gym_champion_kanto = {name = 'The Blue Chip', text = {"0 Base Chip.", "All cards score no chip"}},
			-- Johto
			bl_pkrm_gym_zephyr  = {name = 'The Zephyr' , text = {"Repeated ranks", "are unscored"}},
			bl_pkrm_gym_hive    = {name = 'The Hive'   , text = {"Destroy rightmost card", "after scoring"}},
			bl_pkrm_gym_plain   = {name = 'The Plain'  , text = {"Blind gets X1.5 bigger", "every hand"}},
			bl_pkrm_gym_fog     = {name = 'The Fog'    , text = {"Only Spade, Club cards", "are drawn face up"}},
			bl_pkrm_gym_storm   = {name = 'The Storm'  , text = {"#1# are debuffed.","Suit changes in order","after scoring"}},
			bl_pkrm_gym_mineral = {name = 'The Mineral', text = {"If Steel or Stone card", "is held in hand,", "discard entire hand on Play"}},
			bl_pkrm_gym_glacier = {name = 'The Glacier', text = {"Cards are not drawn", "after Play"}},
			bl_pkrm_gym_rising  = {name = 'The Rising' , text = {"Card ranks increase", "before scoring"}},
			bl_pkrm_gym_e4_will  = {name = 'Magenta Mask'  , text = {"Must play at least", "2 different face cards"}},
			bl_pkrm_gym_e4_koga  = {name = 'Fuchsia Fume', text = {"Draw all cards face down.", "After Play, flip cards", "held in hand"}},
			bl_pkrm_gym_e4_karen = {name = 'Saffron Star'    , text = {"Drawn cards are debuffed", "until #1# is played"}},
			bl_pkrm_gym_champion_johto = {name = 'The Scarlet Scale', text = {"Disable one rightmost Joker", "for each remaining hand"}},
			-- Hoenn
			bl_pkrm_gym_stone   = {name = 'The Stone'  ,text = {"Played face cards", "become Stone cards", "and give no chip"}},
			bl_pkrm_gym_knuckle = {name = 'The Knuckle',text = {"Selecting a card discards", "leftmost cards in hand"}},
			bl_pkrm_gym_dynamo  = {name = 'The Dynamo' ,text = {"Switch highest rank in play", "with lowest rank in hand"}},
			bl_pkrm_gym_heat    = {name = 'The Heat'   ,text = {"Ranks lower than","highest scored rank","are debuffed"}},
			bl_pkrm_gym_balance = {name = 'The Balance',text = {"Can only play", "last discarded poker hand"}},
			bl_pkrm_gym_feather = {name = 'The Feather',text = {"Lose $#1# for every 9", "in deck or held in hand"}},
			bl_pkrm_gym_mind    = {name = 'The Mind'   ,text = {"Forces a Pair to", "always be selected"}},
			bl_pkrm_gym_rain    = {name = 'The Rain'   ,text = {"Must play", "more ranks than suits"}},
			bl_pkrm_gym_rain_juan = {name = 'The Rain'   ,text = {"Mult is capped by Chips"}},
			bl_pkrm_gym_e4_sidney = {name = 'Slick Scythe'    ,text = {"After each Draw,", "debuff two random ranks", "in deck"}},
			bl_pkrm_gym_e4_phoebe = {name = 'Pale Petal'      ,text = {"Jokers with no energy", "are disabled"}}, -- 1!!
			-- Hollow Hibiscus (Her flower) | Lost Lantern (Dusclop)
			bl_pkrm_gym_e4_glacia = {name = 'Glistening Gown' ,text = {"Lose $#1#.", "-1 hand size per {C:red}-$#2#{}", "in current debt"}},
			bl_pkrm_gym_e4_drake  = {name = 'Azure Anchor'   ,text = {"Debuff the lowest rank", "in scoring"}}, -- 2!!
			bl_pkrm_gym_champion_hoenn = {name = 'The Platinum Pin',text = {"Each unique rank", "held in hand", "gives X#1# Mult"}},
			-- maybe i should name him Platinum Pot lmao (poker ref)
			-- Alternative names:
			-- Platinum Pendant
			-- Azure Amulet
			-- Teal Token
			-- Steel Signet/Stickpin
			-- Titanium Token
			bl_pkrm_gym_champion_hoenn_wallace = {name = 'The Dazzing Drop', text = {"Played suits", "are debuffed"}}, -- 7!!

			-- Sinnoh
			bl_pkrm_gym_coal   = {name = 'The Coal'  , text = {"Nothing yet"}},
			bl_pkrm_gym_forest = {name = 'The Forest', text = {"Nothing yet"}},
			bl_pkrm_gym_cobble = {name = 'The Cobble', text = {"Nothing yet"}},
			bl_pkrm_gym_fen    = {name = 'The Fen'   , text = {"Nothing yet"}},
			bl_pkrm_gym_relic  = {name = 'The Relic' , text = {"Nothing yet"}},
			bl_pkrm_gym_mine   = {name = 'The Mine'  , text = {"Nothing yet"}},
			bl_pkrm_gym_icicle = {name = 'The Icicle', text = {"Nothing yet"}},
			bl_pkrm_gym_beacon = {name = 'The Beacon', text = {"Nothing yet"}},
			bl_pkrm_gym_e4_aaron  = {name = 'Temp E4', text = {"Elite Four - 1"}},
			bl_pkrm_gym_e4_bertha = {name = 'Temp E4', text = {"Elite Four - 2"}},
			bl_pkrm_gym_e4_flint  = {name = 'Temp E4', text = {"Elite Four - 3"}},
			bl_pkrm_gym_e4_lucian = {name = 'Temp E4', text = {"Elite Four - 4"}},
			bl_pkrm_gym_champion_sinnoh = {name = 'Temp Champ', text = {"Champion"}},
		},
		Enhanced = {
            m_pkrm_gym_answer_card = {
                name = "Answer Card",
                text = {
                    "Answer for {C:attention}#1#{}",
                    "No rank or suit",
					"Returns to hand when discarded",
                    "Removed at end of round",
                },
            },
        },
		Other = {
			pkrm_gym_temporary = {
				name = "Temporary",
				text = { 
					"{S:1.1,C:red,E:2}Self destructs{}",
					"when discarded",
					"or at end of round"
				},
			},
			p_pkrm_gym_starter_pack = {
                name = "Starter Pack",
				text = {
                    "Choose {C:attention}#1#{} of",
                    "{C:attention}#2#{C:joker} Starter Pokermons{}",
                },
            },
			energy_drained = {
                name = "Energy Drained",
                text = {
                    "{C:attention}#1#{}/#2#",
                }
            },
		},
	},
	misc = {
		challenge_names = {
            c_pkrm_gym_kanto = "Red, Blue & Yellow",
			c_pkrm_gym_johto = "Gold, Silver & Crystal",
			c_pkrm_gym_hoenn = "Ruby, Sapphire & Emerald",
        },
		dictionary = {
			k_pkrm_gym_starter_pack = "Starter Pack",

			pkrm_gym_setting_only_gym             = "Only gym boss blinds",
			pkrm_gym_setting_ordered_gym          = "Ordered gym blinds",
			pkrm_gym_setting_pokermon_league      = "Pokermon League (Ante 9, 10)",
			pkrm_gym_setting_random_elite4_order  = "Randomize Elite Four order",
			pkrm_gym_setting_reduce_scaling       = "Reduce scaling at Ante 9, 10",

			pkrm_gym_champion_no_disable = "Champion Blind cannot be disabled",

			bl_pkrm_gym_e4_bruno_debuff_text_initial = "Discarded poker hand will no longer score",
			bl_pkrm_gym_balance_debuff_text_initial = "No poker hand discarded yet",

			-- Notes in collection
			pkrm_gym_cascade_collection_note = " (ante x 10)",
			pkrm_gym_thunder_collection_note = "(2 random ranks)",
			pkrm_gym_e4_glacia_collection_note = "(ante x 4)",
		},
		tooltips = {
			pkrm_gym_setting_only_gym = {
				"Allows only Gym Blinds",
				"{br:3}---",
				"Disabling this allows vanilla blinds to spawn",
				"and all blinds spawn in {C:attention}random{} order.",
				"Showdown blinds are considered {C:enhanced}Elite Four{}",
			},
			pkrm_gym_setting_ordered_gym = {
				"Beat Gym Blinds in the same order in",
				"official Pokemon games or anime",
				"{br:3}---",
				"Disabling this randomizes gyms across all regions.",
				"Also randomizes {C:enhanced}Elite Four{} and {C:legendary}Champion{} if League is enabled.",
			},
			pkrm_gym_setting_pokermon_league = {
				"Win the game at {C:attention}Ante 10{}",
				"Enables {C:enhanced}Elite Four{} & {C:legendary}Champion{} blinds at Ante 9 and 10",
				"{C:inactive}(2 boss blinds at Ante 9, and 3 at Ante 10){}",
				"{br:3}---",
				"Disabling this reverts to normal Balatro behavior,",
				"{C:inactive}(7 normal blinds as gyms and 1 showdown blind as Elite Four){}",
			},
		},
		pkrm_gym_ex = {
			poke_reverse_energized = "Lose energy!",
			e4_agatha = "Dream Eater",

			zephyr = "Gust",
			mineral_steel = "Magnet Pull",
			mineral_stone = "Iron Tail",
			e4_koga = "Toxic",

			stone = "Rock Tomb",
			dynamo = "Volt Switch",
			heat = "Overheated!",
			feather = "Cloud Nine",
			e4_sidney_1 = "Night Slash",
			e4_sidney_2 = "Crunch",
			e4_drake = "Dragon Claw",
		},
		blaine_quizzes = {
			ex_right = "Correct!",
			ex_wrong = "Incorrect!",
			warn_single = "One answer only!",
			warn_number = "Number only!",
			warn_yesno = "Yes/No only!",
			
			ex_no_answer = "No answer!",
			ex_missing_answer = "Missing answer!",
			ex_not_all_answer = "Not all correct!",

			quiz_types = {
				single = "Choose one answer",
				multiple = "Choose ALL correct answers",
			},
			all_quizzes = {
				-- Jokers knowledge
				{
					type = "single",
					quiz = {"What do all Fire Jokers have in common?"},
					wrong_answers = {"Discard effect", "Fire Sticker", "Common rarity in its evolution family"},
					right_answers = {"Red color"}
				},
				{
					type = "single",
					quiz = {"Does Doduo evolve into Dotrio?"},
					wrong_answers = {"Yes"},
					right_answers = {"No"}
				},
				{
					type = "single",
					quiz = {"What does Raichu Joker do?"},
					wrong_answers = {"Earn $120", "Gets debuffed until end of round if triggers", "Thundershock"},
					right_answers = {"Earn money"}
				},
				{
					type = "single",
					quiz = {"What does Raticate Joker have?"},
					wrong_answers = {"Safari rarity", "Retrigger effect"},
					right_answers = {"insane synergy", "Normal type"}
				},
				{
					type = "single",
					quiz = {"Venomoth adds _ to listed probabilities."},
					wrong_answers = {"1", "3", "4"},
					right_answers = {"2"}
				},
				{
					type = "single",
					quiz = {"What does Sixth Sense and Ninetales have in common?"},
					wrong_answers = {"Synergize with 6", "Create Tarot cards", "Uncommon rarity"},
					right_answers = {"Can generate Medium"}
				},
				{
					type = "single",
					quiz = {"What can Omastar create multiple times per round?"},
					wrong_answers = {"Tags", "Spectral cards", "Playing cards"},
					right_answers = {"$4"}
				},
				{
					type = "single",
					quiz = {"Which of the following Jokers is a Basic Joker?"},
					wrong_answers = {"Cleffa", "Mantyke", "Skiploom"},
					right_answers = {"Hitmontop"}
				},
				{
					type = "multiple",
					quiz = {"Which of the following types exist on a Baby Joker?"},
					wrong_answers = {"Normal", "Electric"},
					right_answers = {"Water", "Fighting"}
				},
				{
					type = "single",
					quiz = {"Which of the following Joker","gives mult to Diamond suit in play?"},
					wrong_answers = {"Gluttonous Joker", "Rough Gem", "Porygon"},
					right_answers = {"Starmie"}
				},
				-- System questions
				{
					type = "single",
					quiz = {"Eligible Jokers evolve as soon as","you use correct evolution stone?"},
					wrong_answers = {"Yes"},
					right_answers = {"No"}
				},
				{
					type = "single",
					quiz = {"Shiny Jokers have different sprites?"},
					wrong_answers = {"No"},
					right_answers = {"Yes"}
				},
				{
					type = "single",
					quiz = {"In any case, could an Energy card be used","on a Joker with different typing?"},
					wrong_answers = {"No"},
					right_answers = {"Yes"}
				},
				{
					type = "single",
					quiz = {"There's a way to evolve a Pokémon","to its highest stage in 1 round?"},
					wrong_answers = {"No"},
					right_answers = {"Yes"}
				},
				-- Misc
				{
					type = "single",
					quiz = {"What does Pocket Tag do?"},
					wrong_answers = {"Gives a Pocket Pack", "Gives a Basic Joker", "Shop has a free Basic Joker"},
					right_answers = {"Gives a Mega Pocket Pack"}
				},
				-- Quizzes that is in Pokemon (with some changes to fit Pokermon)
				{
					type = "single",
					quiz = {"Caterpie evolves into Metapod?"},
					wrong_answers = {"No"},
					right_answers = {"Yes"}
				},
				{
					type = "single",
					quiz = {"There are nine certified Pokémon League Blinds?"},
					wrong_answers = {"Yes"},
					right_answers = {"No"}
				},
				{
					type = "single",
					quiz = {"Poliwag evolves three times?"},
					wrong_answers = {"Yes"},
					right_answers = {"No"}
				},
				{
					type = "single",
					quiz = {"Are Lightning moves effective","against Ground-type Jokers?"},
					wrong_answers = {"Yes"},
					right_answers = {"No"}
				},
				{
					type = "single",
					quiz = {"Pokémon Jokers of the same kind","and energy level are not identical?"},
					wrong_answers = {"No"},
					right_answers = {"Yes"}
				},
				{
					type = "single",
					quiz = {"How many Badges certified","by the Pokémon League are there?"},
					wrong_answers = {"Seven", "Nine", "Ten"},
					right_answers = {"Eight"}
				},
				{
					type = "single",
					quiz = {"Which of these is the Spitfire Pokémon?"},
					wrong_answers = {"Growlithe"},
					right_answers = {"Magmar"}
				},
				{
					type = "single",
					quiz = {"A Steel-type sticker used on a","Fire-type Pokémon Joker will be...?"},
					wrong_answers = {"Super effective!", "Not very effective"},
					right_answers = {"Have no effectiveness"}
				},
				{
					type = "single",
					quiz = {"True or false!","Jumbo Pocket Pack contains the Item Tombstony."},
					wrong_answers = {"TRUE"},
					right_answers = {"FALSE", "What's that?"}
				}
			}
		},

		labels = {
			pkrm_gym_temporary = "Temporary"
		},
		v_dictionary = {
			bl_pkrm_gym_balance_debuff_text = "Must play the last discarded hand (#1#)",
		},
		v_text = {
			ch_c_pkrm_gym_text_only_forced_regional_jokers = { "Only Pokermon Jokers in {C:attention}#1#{} appear" },
            ch_c_pkrm_gym_text_only_forced_region = { "Become the Pokermon Champion in {C:attention}#1#{}!" },
		},
	}
}