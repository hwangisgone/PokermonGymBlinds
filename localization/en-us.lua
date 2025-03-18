return {
	descriptions = {
		Blind = {
			-- Kanto
			bl_pkrm_gym_boulder = {name = 'The Boulder', text = {"{X:fire,C:white}Fire{} Jokers","are debuffed"}},
			bl_pkrm_gym_cascade = {name = 'The Cascade', text = {"After Play, #1# in #2# chance","to lose Energy", "in one Water Joker"}},
			bl_pkrm_gym_thunder = {name = 'The Thunder', text = {"Lose $5 every Discard", "that does not contain #1#"}},
			bl_pkrm_gym_rainbow = {name = 'The Rainbow', text = {"Wild and Polychrome cards", "are debuffed"}},
			bl_pkrm_gym_soul    = {name = 'The Soul'   , text = {"After Play, 3 leftmost cards", "held in hand get Poisoned"}},
			-- bl_pkrm_gym_soul_janine = {name = 'The Soul'   , text = {"1 in 6 cards drawn", "gets Poisoned"}},
			-- TODO: Soul with Janine instead of Koga
			bl_pkrm_gym_marsh   = {name = 'The Marsh'  , text = {"Cards played are debuffed", "until 1 tarot card used"}},
			bl_pkrm_gym_volcano = {name = 'The Volcano', text = {"Pokermon Trivia","Answer 3 correctly to win!"}},
			bl_pkrm_gym_earth   = {name = 'The Earth'  , text = {"Lose $#1#.", "Add X1 for every {C:red}-$#2#{}","in current debt"}},
			bl_pkrm_gym_e4_lorelei = {name = 'Seaglass Song', text = {"Elite Four - 1"}},
			bl_pkrm_gym_e4_bruno   = {name = 'Saffron Belt', text = {"Discarded poker hand", "will no longer score"}},
			bl_pkrm_gym_e4_agatha  = {name = 'Temp Bruno', text = {"Add 3 curse cards to deck", "every hand"}},
			bl_pkrm_gym_e4_lance   = {name = 'Sunset Scale', text = {"Elite Four - 4"}},
			bl_pkrm_gym_champion_kanto = {name = 'The Blue Chip', text = {"-1 hand size", "-1 consumable slot", "Rightmost joker is debuffed"}},
			-- Johto
			bl_pkrm_gym_zephyr  = {name = 'The Zephyr' , text = {"Discards 2 random", "extra cards"}},
			bl_pkrm_gym_hive    = {name = 'The Hive'   , text = {"Destroy rightmost card", "after scoring"}},
			bl_pkrm_gym_plain   = {name = 'The Plain'  , text = {"X1.2 Blind Requirements", "every hand"}},
			bl_pkrm_gym_fog     = {name = 'The Fog'    , text = {"Even cards are", "drawn face down"}},
			bl_pkrm_gym_storm   = {name = 'The Storm'  , text = {"Giovanni's Gym"}},
			bl_pkrm_gym_mineral = {name = 'The Mineral', text = {"Giovanni's Gym"}},
			bl_pkrm_gym_glacier = {name = 'The Glacier', text = {"Giovanni's Gym"}},
			bl_pkrm_gym_rising  = {name = 'The Rising' , text = {"Giovanni's Gym"}},
			bl_pkrm_gym_e4_will  = {name = 'Violet Mask', text = {"Must play at least", "2 face cards"}},
			bl_pkrm_gym_e4_koga  = {name = 'Fuchsia Poison', text = {"After Play, cards played", "and held in hand get Poisoned"}},
			bl_pkrm_gym_e4_karen = {name = 'Temp Bruno', text = {"Elite Four - 4"}},
			bl_pkrm_gym_champion_johto = {name = 'Scarlet Scale', text = {"Champion"}},
			-- Hoenn
			bl_pkrm_gym_stone   = {name = 'The Stone'  ,text = {"Sabrina's Gym"}},
			bl_pkrm_gym_knuckle = {name = 'The Knuckle',text = {"Giovanni's Gym"}},
			bl_pkrm_gym_dynamo  = {name = 'The Dynamo' ,text = {"Giovanni's Gym"}},
			bl_pkrm_gym_heat    = {name = 'The Heat'   ,text = {"Giovanni's Gym"}},
			bl_pkrm_gym_balance = {name = 'The Balance',text = {"Each hand only scores", "after 1 discard"}},
			bl_pkrm_gym_feather = {name = 'The Feather',text = {"Giovanni's Gym"}},
			bl_pkrm_gym_mind    = {name = 'The Mind'   ,text = {"Hand must contains Pair"}},
			bl_pkrm_gym_rain    = {name = 'The Rain'   ,text = {"Giovanni's Gym"}},
			bl_pkrm_gym_e4_sidney = {name = 'Temp Bruno', text = {"Elite Four - 1"}},
			bl_pkrm_gym_e4_phoebe = {name = 'Temp Bruno', text = {"Elite Four - 2"}},
			bl_pkrm_gym_e4_glacia = {name = 'Temp Bruno', text = {"Elite Four - 3"}},
			bl_pkrm_gym_e4_drake  = {name = 'Temp Bruno', text = {"Elite Four - 4"}},
			bl_pkrm_gym_champion_hoenn = {name = 'Temp Blue', text = {"Champion"}},
		}
	},
	misc = {
		dictionary = {
			pkrm_gym_setting_only_gym       = "Only gym boss blinds",
			pkrm_gym_setting_random_gym     = "Randomize gym boss blinds",
			pkrm_gym_setting_random_elite4  = "Randomize elite four order",
			pkrm_gym_setting_reduce_scaling = "Reduce scaling at Ante 9, 10",

			pkrm_gym_blaine_quizzes_loc = {
				single = "Choose one answer (Only the leftmost card in hand count)",
				multiple = "Choose multiple answers",
			},
			pkrm_gym_blaine_quizzes = {
				-- Jokers knowledge
				{
					type = "single",
					quiz = {"What do all Fire Jokers have in common?"},
					wrong_answers = {"Discard effect", "Fire Sticker", "Common rarity in its evolution family"},
					right_answers = {"Red color"}
				},
				{
					type = "single",
					quiz = {"Does Doduo evolve into Dodrio?"},
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
					type = "single", -- Too easy??
					quiz = {"What can Omastar create?"},
					wrong_answers = {},
					right_answers = {"$4", "a Tag", "an Item card", "a Tarot card"}
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
					quiz = {"Can an Energy card be used","on a Joker with different typing?"},
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
		}
	}
}