-- The Stone

local function get_balatest_card_base_code(card)
	local value = card.base.value
	local rank = (value == '10') and value or value:sub(1, 1)
	local suit = card.base.suit:sub(1, 1)
	return rank .. suit
end

local function stone_check_playing_card_roxanned(cards_to_check)
	local checking = {}

	for k, v in pairs(cards_to_check) do
		checking[v] = true
	end

	local result = true

	for _, card in pairs(G.playing_cards) do
		if checking[get_balatest_card_base_code(card)] then
			local condition = SMODS.has_enhancement(card, 'm_stone')
				and card.ability.bonus == 0
				and card.ability.roxanne_stone_affected

			if not condition then
				result = false
				break
			end
		end
	end

	return result
end

local function stone_check_free_all()
	local result = true

	for _, card in pairs(G.playing_cards) do
		local condition = SMODS.has_enhancement(card, 'm_stone')
			and card.ability.bonus == 0
			and card.ability.roxanne_stone_affected

		if condition then
			result = false
			break
		end
	end

	return result
end

Balatest.TestPlay {
	name = 'stone_effect',
	category = { 'hoenn', 'blind', 'stone' },

	blind = 'bl_pkrm_gym_stone',

	execute = function()
		Balatest.play_hand { 'QS', 'QC' }
	end,
	assert = function()
		Balatest.assert_chips(5) -- High Card
		Balatest.assert(stone_check_playing_card_roxanned { 'QS', 'QC' })
	end,
}

Balatest.TestPlay {
	name = 'stone_disable_chicot',
	category = { 'hoenn', 'blind', 'disable', 'stone' },

	blind = 'bl_pkrm_gym_stone',
	jokers = { 'j_chicot' },

	execute = function()
		Balatest.play_hand { 'QS', 'QC' }
	end,
	assert = function()
		Balatest.assert_chips(60)
		Balatest.assert(stone_check_free_all())
	end,
}

Balatest.TestPlay {
	name = 'stone_disable_weezing',
	category = { 'hoenn', 'blind', 'disable', 'stone' },

	blind = 'bl_pkrm_gym_stone',
	jokers = { 'j_poke_weezing' },

	execute = function()
		Balatest.play_hand { 'KS', 'KC' }
		Balatest.q(function()
			G.jokers.cards[1]:sell_card()
		end)
		Balatest.play_hand { 'QS', 'QC' }
	end,
	assert = function()
		Balatest.assert_chips(5 + 60)
		Balatest.assert(stone_check_free_all())
	end,
}

Balatest.TestPlay {
	name = 'stone_panpour',
	category = { 'hoenn', 'blind', 'stone' },

	blind = 'bl_pkrm_gym_stone',
	jokers = { 'j_poke_panpour' },

	execute = function()
		Balatest.play_hand { '4C', '5C' }
		Balatest.play_hand { '4S', '5S' }
	end,
	assert = function()
		Balatest.assert_chips(10) -- High Card x2
		Balatest.assert(stone_check_playing_card_roxanned { '4C', '5C', '4S', '5S' })
	end,
}

Balatest.TestPlay {
	name = 'stone_other_enhancements',
	category = { 'hoenn', 'blind', 'stone' },

	blind = 'bl_pkrm_gym_stone',

	deck = {
		cards = {
			{ r = 'Q', s = 'S', e = 'm_bonus' },
			{ r = 'Q', s = 'C', e = 'm_mult' },
			{ r = 'Q', s = 'H', e = 'm_wild' },
			{ r = 'Q', s = 'D', e = 'm_glass' },
			{ r = 'K', s = 'S', e = 'm_steel' },
			{ r = 'K', s = 'C', e = 'm_steel' },
			{ r = 'K', s = 'H', e = 'm_gold' },
			{ r = 'K', s = 'D', e = 'm_lucky' },
			{ r = '2', s = 'S' },
		},
	},
	execute = function()
		Balatest.play_hand { 'KS', 'KC', 'KH', 'KD' } -- Play the Steel first
		Balatest.play_hand { 'QS', 'QC', 'QH', 'QD' }
	end,
	assert = function()
		Balatest.assert_chips(10) -- High Card x2
		Balatest.assert(stone_check_playing_card_roxanned {
			'QS',
			'QC',
			'QH',
			'QD',
			'KS',
			'KC',
			'KH',
			'KD',
		})
	end,
}

Balatest.TestPlay {
	name = 'stone_stone_enhancement',
	category = { 'hoenn', 'blind', 'stone' },

	blind = 'bl_pkrm_gym_stone',

	deck = {
		cards = {
			{ r = 'Q', s = 'S', e = 'm_stone' },
			{ r = 'Q', s = 'C', e = 'm_stone' },
			{ r = '2', s = 'S' },
		},
	},
	execute = function()
		Balatest.play_hand { 'QS', 'QC' }
	end,
	assert = function()
		Balatest.assert_chips(5 + 50 * 2) -- High Card Stone
		Balatest.assert(stone_check_free_all()) 
        -- Stone cards does not have rank and isn't affected, even with Pareidolia/Probopass
	end,
}

-- testing for feather

-- in hand, not in hand
