-- JOHTO
local TYPE_CLR = GYM_BLINDS_TYPE_CLR

SMODS.Atlas { 
	key = 'blinds_johto', 
	atlas_table = 'ANIMATION_ATLAS', 
	path = 'blinds_johto.png', 
	px = 34, 
	py = 34, 
	frames = 21 
}

SMODS.Blind {
	key = 'zephyr',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 0 },
	boss_colour = TYPE_CLR['flying'],	

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

BL_FUNCTION_TABLE['hive_after_scoring'] = function(scoring_hand)
	local rightmost_card = G.play.cards[#G.play.cards]

	G.E_MANAGER:add_event(Event({ trigger = 'after', func = function()
		-- Scyther effect
		rightmost_card:juice_up()
		rightmost_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
		play_sound('slice1', 0.96+math.random()*0.08)

		G.GAME.blind:wiggle()

		return true
	end }))
end

SMODS.Blind {
	key = 'hive',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 1 },
	boss_colour = TYPE_CLR['bug'],	

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
	set_blind = function(self)
		G.GAME.BL_EXTRA.after_scoring = 'hive_after_scoring'
	end,

	press_play = function(self)
		G.GAME.blind.triggered = true
	end,

	disabled = function(self)
		G.GAME.BL_EXTRA.after_scoring = nil
	end,
}

SMODS.Blind {
	key = 'plain',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 2 },
	boss_colour = TYPE_CLR['normal'],	

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = { rollout = 120 },
	vars = {},

	press_play = function(self)
		G.GAME.blind.chips = G.GAME.blind.chips * (self.config.rollout/100)
		G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)

		attention_text({
		  text = 'X'..(self.config.rollout/100),
		  scale = 0.8, 
		  hold = 1.5,
		  cover = G.HUD_blind:get_UIE_by_ID("HUD_blind_count").parent,
		  cover_colour = G.C.GOLD,
		  align = 'cm',
		})

		G.GAME.blind.triggered = true
		G.GAME.blind:wiggle()
	end
}


function card_is_even(card)
	local id = card:get_id()
	return id == 2 or 
			id == 4 or 
			id == 6 or 
			id == 8 or 
			id == 10
end

function card_is_odd(card)
	local id = card:get_id()
	return id == 3 or 
			id == 5 or 
			id == 7 or 
			id == 8 or 
			id == 14
end

SMODS.Blind {
	key = 'fog',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 3 },
	boss_colour = TYPE_CLR['ghost'],	

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},

	stay_flipped = function(self, area, card)
		if area == G.hand then
			return card_is_even(card)
		end
		return false
	end
}

SMODS.Blind {
	key = 'storm',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 4 },
	boss_colour = TYPE_CLR['fighting'],	

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'mineral',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 5 },
	boss_colour = TYPE_CLR['steel'],	

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'glacier',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 6 },
	boss_colour = TYPE_CLR['ice'],	

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'rising',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 7 },
	boss_colour = TYPE_CLR['dragon'],	

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'e4_will',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 8 },
	boss_colour = TYPE_CLR['psychic'],

	discovered = false,
	dollars = 8,
	mult = 2,
	boss = {min = 8, max = 10, showdown = true}, 
	config = {},
	vars = {},

	debuff_hand = function(self, cards, hand, handname, check)
		if not G.GAME.blind.disabled then
			local face_count = 0
			for i = 1, #cards do
				if cards[i]:is_face() and (cards[i].facing == 'front' or not check) then
					face_count = face_count + 1
				end
			end

			if face_count < 2 then
				return true
			else
				return false
			end
		end
	end,
}

SMODS.Blind {
	key = 'e4_koga',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 9 },
	boss_colour = TYPE_CLR['poison'],

	discovered = false,
	dollars = 8,
	mult = 2,
	boss = {min = 8, max = 10, showdown = true}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'e4_karen',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 10 },
	boss_colour = TYPE_CLR['dark'],

	discovered = false,
	dollars = 8,
	mult = 2,
	boss = {min = 8, max = 10, showdown = true}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'champion_johto',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 11 },
	boss_colour = TYPE_CLR['dragon'],

	discovered = false,
	dollars = 12,
	mult = 4,
	boss = {min = 10, max = 10, showdown = true}, 
	config = {},
	vars = {},
}