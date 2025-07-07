-- Frozen Flow
Balatest.TestPlay {
	name = 'e4_lorelei_effect_play',
	category = { 'kanto', 'blind' },

	blind = 'bl_pkrm_gym_e4_lorelei',

	hand_size = 6,
	deck = {
		cards = { -- 10 - 2S
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
		},
	},

	execute = function()
		Balatest.play_hand { '2S', '2S', '2S' }
	end,
	assert = function()
		Balatest.assert_eq(#G.hand.cards, 3)
	end,
}

Balatest.TestPlay {
	name = 'e4_lorelei_effect_discard',
	category = { 'kanto', 'blind' },

	blind = 'bl_pkrm_gym_e4_lorelei',

	hand_size = 6,
	deck = {
		cards = { -- 10 - 2S
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
		},
	},

	execute = function()
		Balatest.play_hand { '2S', '2S' }
		Balatest.discard { '2S' }
	end,
	assert = function()
		Balatest.assert_eq(#G.hand.cards, 3)
	end,
}

Balatest.TestPlay {
	name = 'e4_lorelei_effect_limit_draw',
	category = { 'kanto', 'blind' },

	blind = 'bl_pkrm_gym_e4_lorelei',

	hand_size = 6,
	deck = {
		cards = { -- 10 - 2S
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
		},
	},

	execute = function()
		Balatest.discard { '2S', '2S' }
		Balatest.play_hand { '2S', '2S' }
	end,
	assert = function()
		Balatest.assert_eq(#G.hand.cards, G.hand.config.card_limit)
	end,
}

Balatest.TestPlay {
	name = 'e4_lorelei_disable_chicot',
	category = { 'kanto', 'blind', 'disable' },

	blind = 'bl_pkrm_gym_e4_lorelei',
	jokers = { 'j_chicot' },

	hand_size = 8,
	deck = {
		cards = { -- 16 - 2S
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },

			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },

			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },

			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
		},
	},

	execute = function()
		Balatest.play_hand { '2S', '2S', '2S' }
		Balatest.discard { '2S', '2S' }
	end,
	assert = function()
		Balatest.assert_eq(#G.hand.cards, G.hand.config.card_limit)
	end,
}

Balatest.TestPlay {
	name = 'e4_lorelei_disable_weezing',
	category = { 'kanto', 'blind', 'disable' },

	blind = 'bl_pkrm_gym_e4_lorelei',
	jokers = { 'j_poke_weezing' },

	hand_size = 8,
	deck = {
		cards = { -- 16 - 2S
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },

			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },

			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },

			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
		},
	},

	execute = function()
		Balatest.discard { '2S', '2S', '2S' }
		Balatest.q(function()
			G.jokers.cards[1]:sell_card()
		end)
		Balatest.play_hand { '2S', '2S' }
	end,
	assert = function()
		Balatest.assert_eq(#G.hand.cards, G.hand.config.card_limit)
	end,
}

-- Slate Shackles
Balatest.TestPlay {
	name = 'temporary_destroyed',
	category = { 'kanto', 'sticker' },

	execute = function()
		for _, card in pairs(G.playing_cards) do
			if card:is_suit('Spades') or card:is_suit('Clubs') then
				SMODS.Stickers['pkrm_gym_temporary']:apply(card, true)
			end
		end

		Balatest.play_hand { '2S', '3S', '4S', '6S', '8C' }
		Balatest.play_hand { '2C', '3C', '4C', '6C', '8S' }
		Balatest.discard { '10S', 'JS', 'QS', 'KS', 'AS' }
		Balatest.next_round()
	end,
	assert = function()
		Balatest.assert_eq(#G.playing_cards, 26)
	end,
}

Balatest.TestPlay {
	name = 'temporary_destroyed_only_in_deck',
	category = { 'kanto', 'sticker' },

	hand_size = 8,

	execute = function()
		for _, card in pairs(G.playing_cards) do
			if card:is_suit('Spades') then
				SMODS.Stickers['pkrm_gym_temporary']:apply(card, true)
				if card.area == G.hand then
					G.hand:remove_card(card)
					G.deck:emplace(card, nil, true)
				end
			end
		end

		local new_card = SMODS.create_card {
			set = 'Base',
			area = G.hand,
			skip_materialize = true,
			rank = '2',
			suit = 'C',
		}
		G.hand:emplace(new_card, nil, true)

		Balatest.play_hand { '2C' }
		Balatest.next_round()
	end,
	assert = function()
		Balatest.assert_eq(#G.playing_cards, 39) -- 1 suit gone
	end,
}

local function get_balatest_card_base_code(card)
	local value = card.base.value
	local rank = (value == '10') and value or value:sub(1, 1)
	local suit = card.base.suit:sub(1, 1)
	return rank .. suit
end

Balatest.TestPlay {
	name = 'temporary_destroyed_only_in_discard',
	category = { 'kanto', 'sticker' },

	execute = function()
		local discard_pack = {}

		for _, card in pairs(G.playing_cards) do
			if card:is_suit('Spades') then
				SMODS.Stickers['pkrm_gym_temporary']:apply(card, true)

				table.insert(discard_pack, get_balatest_card_base_code(card))

				if #discard_pack == 5 then
					Balatest.discard(copy_table(discard_pack))
					discard_pack = {}
				end
			end
		end

		Balatest.discard(discard_pack)
		Balatest.discard { '10C', 'JC', 'QC', 'KC', 'AC' }
		Balatest.next_round()
	end,
	assert = function()
		Balatest.assert_eq(#G.playing_cards, 39) -- 1 suit gone
	end,
}

Balatest.TestPlay {
	name = 'e4_bruno_effect',
	category = { 'kanto', 'blind', 'e4_bruno' },

	blind = 'bl_pkrm_gym_e4_bruno',

	hand_size = 8,
	deck = {
		cards = { -- 16 - 2S
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },

			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },

			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },

			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
		},
	},

	execute = function() end,
	assert = function()
		Balatest.assert_eq(#G.playing_cards, 52)

		local total_temp_stone_cards = 0
		for _, card in pairs(G.playing_cards) do
			if card.ability['pkrm_gym_temporary'] and SMODS.has_enhancement(card, 'm_stone') then
				total_temp_stone_cards = total_temp_stone_cards + 1
			end
		end

		Balatest.assert_eq(total_temp_stone_cards, 52 - 16) -- 16 2 of Spades
	end,
}

Balatest.TestPlay {
	name = 'e4_bruno_disable_chicot',
	category = { 'kanto', 'blind', 'disable', 'e4_bruno' },

	blind = 'bl_pkrm_gym_e4_bruno',
	jokers = { 'j_chicot' },

	hand_size = 8,
	deck = {
		cards = { -- 8 - 2S
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },

			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
		},
	},

	execute = function() end,
	assert = function()
		Balatest.assert_eq(#G.playing_cards, 8)
	end,
}

Balatest.TestPlay {
	name = 'e4_bruno_disable_weezing',
	category = { 'kanto', 'blind', 'disable', 'e4_bruno' },

	blind = 'bl_pkrm_gym_e4_bruno',
	jokers = { 'j_poke_weezing' },

	hand_size = 8,
	deck = {
		cards = { -- 16 - 2S
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },

			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
			{ r = '2', s = 'S' },
		},
	},

	execute = function()
		Balatest.discard { '2S', '2S', '2S' }
		Balatest.q(function()
			G.jokers.cards[1]:sell_card()
		end)
		Balatest.play_hand { '2S' }
	end,
	assert = function()
		Balatest.assert_eq(#G.playing_cards, 8)
	end,
}

-- Cursed Cane
Balatest.TestPlay {
	name = 'e4_agatha_effect_no_joker',
	category = { 'kanto', 'blind', 'e4_agatha' },

	blind = 'bl_pkrm_gym_e4_agatha',

	execute = function()
		Balatest.play_hand { '5S' }
	end,
	assert = function()
		Balatest.assert_chips(10)
	end,
}

Balatest.TestPlay {
	name = 'e4_agatha_effect_no_energizable_joker',
	category = { 'kanto', 'blind', 'e4_agatha' },

	blind = 'bl_pkrm_gym_e4_agatha',

	jokers = { 'j_poke_gengar' },

	execute = function()
		Balatest.play_hand { '5S' }
	end,
	assert = function()
		Balatest.assert_chips(10)
	end,
}

Balatest.TestPlay {
	name = 'e4_agatha_effect',
	category = { 'kanto', 'blind', 'e4_agatha' },

	blind = 'bl_pkrm_gym_e4_agatha',

	jokers = { 'j_poke_beedrill' },
	consumeables = { 'c_poke_grass_energy', 'c_poke_grass_energy' },

	execute = function()
		-- Energize twice
		Balatest.use(G.consumeables.cards[1])
		Balatest.use(G.consumeables.cards[2])
		Balatest.play_hand { '5S' }
		Balatest.play_hand { '5C' }
	end,
	assert = function()
		Balatest.assert_eq(G.jokers.cards[1].ability.extra.energy_count, 0)
		Balatest.assert_chips((10 + 80 + 24) + (10 + 80)) -- With 1 energy + 0 energy
	end,
}

Balatest.TestPlay {
	name = 'e4_agatha_effect_joker_not_energized',
	category = { 'kanto', 'blind', 'e4_agatha' },

	blind = 'bl_pkrm_gym_e4_agatha',

	jokers = { 'j_poke_beedrill' },

	execute = function()
		Balatest.play_hand { '5S' }
	end,
	assert = function()
		Balatest.assert_eq(G.jokers.cards[1].ability.extra.energy_count, -1)
		Balatest.assert_chips(10 + 80 - 24) -- With -1 energy
	end,
}

Balatest.TestPlay {
	name = 'e4_agatha_effect_joker_not_energized_evolving',
	category = { 'kanto', 'blind', 'e4_agatha' },

	blind = 'bl_pkrm_gym_e4_agatha',

	jokers = { 'j_poke_weedle' },
	consumeables = { 'c_poke_transformation' },

	execute = function()
		Balatest.play_hand { '5S' }
		Balatest.play_hand { '5H' }

		Balatest.q(function()
			G.jokers.cards[1]:click()
		end)
		Balatest.use(G.consumeables.cards[1])

		Balatest.play_hand { '5C' }
	end,
	assert = function()
		Balatest.assert_eq(G.jokers.cards[1].ability.extra.energy_count, -2)
		Balatest.assert_chips((10 + 20 - 6) + (10 + 20 - 6 * 2) + (10 + 80 - 24 * 2)) 
		-- With -1 energy (weedle)
		-- and -2 energy (weedle)
		-- and -2 energy (beedril after energized by transformation)
	end,
}

Balatest.TestPlay {
	name = 'e4_agatha_effect_non_pokermon',
	category = { 'kanto', 'blind', 'e4_agatha' },

	blind = 'bl_pkrm_gym_e4_agatha',

	jokers = { 'j_sly' }, -- Pair

	execute = function()
		Balatest.play_hand { '5S', '5C' }
	end,
	assert = function()
		Balatest.assert_chips((20 + 50 * (1 - 0.3)) * 2) -- With -1 energy
	end,
}

Balatest.TestPlay {
	name = 'e4_agatha_disable_chicot',
	category = { 'kanto', 'blind', 'disable', 'e4_agatha' },

	blind = 'bl_pkrm_gym_e4_agatha',

	jokers = { 'j_poke_beedrill', 'j_chicot' },
	consumeables = { 'c_poke_grass_energy' },

	execute = function()
		Balatest.use(G.consumeables.cards[1])
		Balatest.play_hand { '5S' }
	end,
	assert = function()
		Balatest.assert_eq(G.jokers.cards[1].ability.extra.energy_count, 1)
		Balatest.assert_chips(10 + 80 + 24) -- With 1 energy
	end,
}

Balatest.TestPlay {
	name = 'e4_agatha_disable_weezing',
	category = { 'kanto', 'blind', 'disable', 'e4_agatha' },

	blind = 'bl_pkrm_gym_e4_agatha',

	jokers = { 'j_poke_weezing', 'j_poke_beedrill' },
	consumeables = { 'c_poke_grass_energy' },

	execute = function()
		Balatest.q(function()
			G.jokers.cards[1]:sell_card()
		end)
		Balatest.use(G.consumeables.cards[1])
		Balatest.play_hand { '5S' }
	end,
	assert = function()
		Balatest.assert_eq(G.jokers.cards[1].ability.extra.energy_count, 1)
		Balatest.assert_chips(10 + 80 + 24) -- With 1 energy
	end,
}

-- The Blue Chip
Balatest.TestPlay {
	name = 'champion_kanto_normal',
	category = { 'kanto', 'blind' },

	blind = 'bl_pkrm_gym_champion_kanto',

	execute = function()
		Balatest.play_hand { '2S', '2C', '4S', '4C' } -- 2 Pair
		Balatest.play_hand { '10S', 'JS', 'QS', 'KS', 'AS' } -- Royal Flush
	end,
	assert = function()
		Balatest.assert_chips(0)
	end,
}

Balatest.TestPlay {
	name = 'champion_kanto_editions',
	category = { 'kanto', 'blind' },

	blind = 'bl_pkrm_gym_champion_kanto',
	jokers = { { id = 'j_poke_bulbasaur', edition = 'foil' } },

	deck = {
		cards = {
			{ r = 'K', s = 'S' },
			{ r = '2', s = 'S', d = 'foil' },
			{ r = '2', s = 'C', d = 'foil' },
			{ r = '4', s = 'S', d = 'polychrome' },
			{ r = '4', s = 'C', d = 'holo' },
		},
	},

	execute = function()
		Balatest.play_hand { '2S', '2C', '4S', '4C' } -- Play a 2 Pair
	end,
	assert = function()
		-- Foil Bulbasaur x (2 Pair x Poly + Holo)
		Balatest.assert_chips(50 * (2 * 1.5 + 10))
	end,
}

Balatest.TestPlay {
	name = 'champion_kanto_enhancements',
	category = { 'kanto', 'blind' },

	blind = 'bl_pkrm_gym_champion_kanto',
	jokers = { { id = 'j_poke_beedrill', edition = 'foil' } },

	deck = {
		cards = {
			{ r = 'K', s = 'S' },
			{ r = 'A', s = 'S', e = 'm_stone', d = 'holo' },
			{ r = '2', s = 'S', e = 'm_bonus' },
			{ r = '2', s = 'C', e = 'm_lucky', d = 'foil' },
			{ r = '4', s = 'S', e = 'm_mult' },
			{ r = '4', s = 'C', e = 'm_bonus', d = 'holo' },
		},
	},

	execute = function()
		G.GAME.probabilities.normal = 15 -- Guaranteed Lucky trigger

		Balatest.play_hand { 'AS', '2S', '2C', '4S', '4C' } -- Play a 2 Pair
	end,
	assert = function()
		-- Foil Beedrill x (2 Pair + Lucky + Mult + 2 Holo)
		Balatest.assert_chips((50 + 80) * (2 + 20 + 4 + 10 + 10))
		Balatest.assert_eq(G.GAME.dollars, 20)
	end,
}

Balatest.TestPlay {
	name = 'champion_kanto_disable_chicot',
	category = { 'kanto', 'blind', 'disable', 'champ_blue' },

	blind = 'bl_pkrm_gym_champion_kanto',
	jokers = { 'j_chicot' },

	execute = function()
		Balatest.play_hand { '2S', '2C', '4S', '4C' } -- 2 Pair
		Balatest.play_hand { '10S', 'JS', 'QS', 'KS', 'AS' } -- Royal Flush
	end,
	assert = function()
		-- Works normally, can't disable
		Balatest.assert_chips(0)
	end,
}

Balatest.TestPlay {
	name = 'champion_kanto_disable_weezing',
	category = { 'kanto', 'blind', 'disable', 'champ_blue' },

	blind = 'bl_pkrm_gym_champion_kanto',
	jokers = { 'j_poke_weezing' },

	execute = function()
		Balatest.q(function()
			G.jokers.cards[1]:sell_card()
		end)
		Balatest.play_hand { '2S', '2C', '4S', '4C' } -- 2 Pair
		Balatest.play_hand { '10S', 'JS', 'QS', 'KS', 'AS' } -- Royal Flush
	end,
	assert = function()
		-- Works normally, can't disable
		Balatest.assert_chips(0)
	end,
}
