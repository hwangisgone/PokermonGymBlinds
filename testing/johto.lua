-- The Hive
-- Test with destroy jokers

-- The Fog
local function fog_check_flip(hd_flip, sc_flip)
	local all_hd_flipped_correctly = true
	local all_sc_flipped_correctly = true

	for _, card in pairs(G.playing_cards) do
		if card.area ~= G.discard then
			if card:is_suit('Spades') or card:is_suit('Clubs') then
				if card.facing ~= sc_flip then all_sc_flipped_correctly = false end
			else
				if card.facing ~= hd_flip then all_hd_flipped_correctly = false end
			end
		end
	end

	return all_hd_flipped_correctly, all_sc_flipped_correctly
end

Balatest.TestPlay {
	name = 'fog_effect',
	category = { 'johto', 'blind', 'fog' },

	blind = 'bl_pkrm_gym_fog',

	execute = function() end,
	assert = function()
		local hd_correct, sc_correct = fog_check_flip('back', 'front')

		Balatest.assert(hd_correct)
		Balatest.assert(sc_correct)
	end,
}

Balatest.TestPlay {
	name = 'fog_disable_chicot',
	category = { 'johto', 'blind', 'disable', 'fog' },

	blind = 'bl_pkrm_gym_fog',
	jokers = { 'j_chicot' },

	execute = function() end,
	assert = function()
		local hd_correct, sc_correct = fog_check_flip('front', 'front')

		Balatest.assert(hd_correct)
		Balatest.assert(sc_correct)
	end,
}

Balatest.TestPlay {
	name = 'fog_disable_weezing',
	category = { 'johto', 'blind', 'disable', 'fog' },

	blind = 'bl_pkrm_gym_fog',
	jokers = { 'j_poke_weezing' },

	execute = function()
		Balatest.play_hand { '2S' }
		Balatest.q(function()
			G.jokers.cards[1]:sell_card()
		end)
	end,
	assert = function()
		local hd_correct, sc_correct = fog_check_flip('front', 'front')

		Balatest.assert(hd_correct)
		Balatest.assert(sc_correct)
	end,
}

-- The Mineral
local function mineral_setup_leftmost_card(enhancement, rank, suit)
	rank = rank or '2'
	suit = suit or 'Spades'

	local editing_card = G.hand.cards[1]
	if editing_card.base.value == rank and editing_card:is_suit(suit) then
		editing_card = G.hand.cards[2]
	end
	editing_card:set_ability(G.P_CENTERS[enhancement], nil, false)
end
Balatest.TestPlay {
	name = 'mineral_effect_steel',
	category = { 'johto', 'blind', 'mineral' },

	blind = 'bl_pkrm_gym_mineral',

	hand_size = 51,

	execute = function()
		mineral_setup_leftmost_card('m_steel')

		Balatest.play_hand { '2S' }
	end,
	assert = function()
		Balatest.assert(#G.hand.cards, 0)
	end,
}

Balatest.TestPlay {
	name = 'mineral_effect_stone',
	category = { 'johto', 'blind', 'mineral' },

	blind = 'bl_pkrm_gym_mineral',

	hand_size = 51,

	execute = function()
		mineral_setup_leftmost_card('m_stone')

		Balatest.play_hand { '2S' }
	end,
	assert = function()
		Balatest.assert(#G.hand.cards, 0)
	end,
}

Balatest.TestPlay {
	name = 'mineral_disable_chicot',
	category = { 'johto', 'blind', 'disable', 'mineral' },

	blind = 'bl_pkrm_gym_mineral',
	jokers = { 'j_chicot' },

	hand_size = 51,

	execute = function()
		mineral_setup_leftmost_card('m_steel')

		Balatest.play_hand { '2S' }
	end,
	assert = function()
		Balatest.assert_eq(#G.hand.cards, G.hand.config.card_limit)
	end,
}

Balatest.TestPlay {
	name = 'mineral_disable_weezing',
	category = { 'johto', 'blind', 'disable', 'mineral' },

	blind = 'bl_pkrm_gym_mineral',
	jokers = { 'j_poke_weezing' },

	hand_size = 51,

	execute = function()
		mineral_setup_leftmost_card('m_stone')
		
		Balatest.q(function()
			G.jokers.cards[1]:sell_card()
		end)
		Balatest.play_hand { '2S' }
	end,
	assert = function()
		Balatest.assert_eq(#G.hand.cards, G.hand.config.card_limit)
	end,
}

-- The Glacier
Balatest.TestPlay {
	name = 'glacier_effect_play',
	category = { 'johto', 'blind', 'glacier' },

	blind = 'bl_pkrm_gym_glacier',

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
	name = 'glacier_effect_discard',
	category = { 'johto', 'blind', 'glacier' },

	blind = 'bl_pkrm_gym_glacier',

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
		Balatest.discard { '2S' }
	end,
	assert = function()
		Balatest.assert_eq(#G.hand.cards, G.hand.config.card_limit)
	end,
}

Balatest.TestPlay {
	name = 'glacier_disable_chicot',
	category = { 'johto', 'blind', 'disable', 'glacier' },

	blind = 'bl_pkrm_gym_glacier',
	jokers = { 'j_chicot' },

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
		Balatest.assert_eq(#G.hand.cards, G.hand.config.card_limit)
	end,
}

Balatest.TestPlay {
	name = 'glacier_disable_weezing',
	category = { 'johto', 'blind', 'disable', 'glacier' },

	blind = 'bl_pkrm_gym_glacier',
	jokers = { 'j_poke_weezing' },

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
		Balatest.q(function()
			G.jokers.cards[1]:sell_card()
		end)
		Balatest.play_hand { '2S', '2S' }
	end,
	assert = function()
		Balatest.assert_eq(#G.hand.cards, G.hand.config.card_limit)
	end,
}

-- Magenta Mask
Balatest.TestPlay {
	name = 'e4_will_effect_right',
	category = { 'johto', 'blind', 'e4_will' },

	blind = 'bl_pkrm_gym_e4_will',

	execute = function()
		Balatest.play_hand { 'QS', 'KS' }
	end,
	assert = function()
		Balatest.assert_chips(15)
	end,
}

Balatest.TestPlay {
	name = 'e4_will_effect_wrong',
	category = { 'johto', 'blind', 'e4_will' },

	blind = 'bl_pkrm_gym_e4_will',

	execute = function()
		Balatest.play_hand { 'QS', 'QC' }
		Balatest.play_hand { 'QH' }
		Balatest.play_hand { '2S' }
	end,
	assert = function()
		Balatest.assert_chips(0)
	end,
}

Balatest.TestPlay {
	name = 'e4_will_disable_chicot',
	category = { 'johto', 'blind', 'disable', 'e4_will' },

	blind = 'bl_pkrm_gym_e4_will',
	jokers = { 'j_chicot' },

	execute = function()
		Balatest.play_hand { 'QS', 'QC' }
	end,
	assert = function()
		Balatest.assert_chips(60)
	end,
}

Balatest.TestPlay {
	name = 'e4_will_disable_weezing',
	category = { 'johto', 'blind', 'disable', 'e4_will' },

	blind = 'bl_pkrm_gym_e4_will',
	jokers = { 'j_poke_weezing' },

	execute = function()
		Balatest.play_hand { '2S' }
		Balatest.q(function()
			G.jokers.cards[1]:sell_card()
		end)
		Balatest.play_hand { 'QS', 'QC' }
	end,
	assert = function()
		Balatest.assert_chips(60)
	end,
}

Balatest.TestPlay {
	name = 'e4_will_panpour_stone_and_right',
	category = { 'johto', 'blind', 'e4_will' },

	blind = 'bl_pkrm_gym_e4_will',
	jokers = { 'j_poke_panpour' },

	deck = {
		cards = {
			{ r = 'K', s = 'S' },
			{ r = '4', s = 'C' },
			{ r = '5', s = 'C' },
			{ r = '4', s = 'S', e = 'm_stone' },
			{ r = '5', s = 'S' },
		},
	},
	execute = function()
		-- Different ranks
		Balatest.play_hand { '4C', '5C' }
		-- 1 rank + 1 no rank
		Balatest.play_hand { '4S', '5S' }
	end,
	assert = function()
		Balatest.assert_chips(70)
	end,
}

Balatest.TestPlay {
	name = 'e4_will_panpour_stone_and_wrong',
	category = { 'johto', 'blind', 'e4_will' },

	blind = 'bl_pkrm_gym_e4_will',
	jokers = { 'j_poke_panpour' },

	deck = {
		cards = {
			{ r = 'K', s = 'S' },
			{ r = '2', s = 'S', e = 'm_stone' },
			{ r = '3', s = 'S', e = 'm_stone' },
			{ r = '4', s = 'S', e = 'm_stone' },
			{ r = '4', s = 'C', e = 'm_stone' },
		},
	},
	execute = function()
		-- No ranks count as the same
		Balatest.play_hand { '2S', '3S' }
		-- Same rank
		Balatest.play_hand { '4S', '4C' }
	end,
	assert = function()
		Balatest.assert_chips(0)
	end,
}

-- Test for Karen
