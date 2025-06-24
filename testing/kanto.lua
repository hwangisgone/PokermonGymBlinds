Balatest.TestPlay {
	name = 'temporary_destroyed',
	category = { 'kanto', 'sticker' },

	execute = function()
		for _, card in pairs(G.playing_cards) do
			if card:is_suit('Spades') or card:is_suit('Clubs') then
				SMODS.Stickers['pkrm_gym_temporary']:apply(card, true)
			end
		end

		Balatest.play_hand { '2S', '3S', '4S', '6S', '8C' } -- Play a High Card
		Balatest.play_hand { '2C', '3C', '4C', '6C', '8S' } -- Play a High Card
		Balatest.discard { '10S', 'JS', 'QS', 'KS', 'AS' }
		Balatest.next_round()
	end,
	assert = function()
		Balatest.assert_eq(#G.playing_cards, 26)
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
