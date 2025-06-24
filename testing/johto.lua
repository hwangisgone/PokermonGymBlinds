-- The Fog
function fog_check_flip(hd_flip, sc_flip)
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
	category = { 'johto', 'blind' },

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
	category = { 'johto', 'blind', 'disable' },

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
	category = { 'johto', 'blind', 'disable' },

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

-- Magenta Mask
Balatest.TestPlay {
	name = 'e4_will_effect_right',
	category = { 'johto', 'blind' },

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
	category = { 'johto', 'blind' },

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
	category = { 'johto', 'blind', 'disable' },

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
	category = { 'johto', 'blind', 'disable' },

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
	category = { 'johto', 'blind' },

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
	category = { 'johto', 'blind' },

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
