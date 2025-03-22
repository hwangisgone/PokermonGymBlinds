-- HOENN
local TYPE_CLR = GYM_BLINDS_TYPE_CLR

SMODS.Atlas { 
	key = 'blinds_hoenn', 
	atlas_table = 'ANIMATION_ATLAS', 
	path = 'blinds_kanto.png', 
	-- TODO
	px = 34, 
	py = 34, 
	frames = 21 
}

SMODS.Blind {
	key = 'stone',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 7 },
	boss_colour = TYPE_CLR['rock'],	

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'knuckle',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 7 },
	boss_colour = TYPE_CLR['fighting'],	

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'dynamo',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 7 },
	boss_colour = TYPE_CLR['electric'],	

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'heat',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 7 },
	boss_colour = TYPE_CLR['fire'],	

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'balance',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 7 },
	boss_colour = TYPE_CLR['normal'],	

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},

	calculate = function(self, card, context)
		-- TODO: just context.pre_discard Might be buggy??\
		-- Also context.after? context.cardarea == G.play
		if not G.GAME.blind.disabled then
			if context.pre_discard then
				G.GAME.blind:wiggle()
				G.GAME.blind.has_discarded = true
			elseif context.after then
				G.GAME.blind.has_discarded = false
			end
		end
	end,

	debuff_hand = function(self, cards, hand, handname, check)
		return not G.GAME.blind.has_discarded
	end,
}

SMODS.Blind {
	key = 'feather',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 7 },
	boss_colour = TYPE_CLR['flying'],	

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'mind',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 7 },
	boss_colour = TYPE_CLR['psychic'],	

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},

	debuff_hand = function(self, cards, hand, handname, check)
		if not G.GAME.blind.disabled then
			-- TODO: what the hell is check? "if not check then"
			return not next(hand['Pair'])
		end
	end,
}

SMODS.Blind {
	key = 'rain',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 7 },
	boss_colour = TYPE_CLR['water'],	

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'e4_sidney',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 8 },
	boss_colour = TYPE_CLR['dark'],

	discovered = false,
	dollars = 8,
	mult = 2,
	boss = {min = 8, max = 10, showdown = true}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'e4_phoebe',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 9 },
	boss_colour = TYPE_CLR['ghost'],

	discovered = false,
	dollars = 8,
	mult = 2,
	boss = {min = 8, max = 10, showdown = true}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'e4_glacia',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 10 },
	boss_colour = TYPE_CLR['ice'],

	discovered = false,
	dollars = 8,
	mult = 2,
	boss = {min = 8, max = 10, showdown = true}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'e4_drake',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 11 },
	boss_colour = TYPE_CLR['dragon'],

	discovered = false,
	dollars = 8,
	mult = 2,
	boss = {min = 8, max = 10, showdown = true}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'champion_hoenn',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 12 },
	boss_colour = TYPE_CLR['water'],

	discovered = false,
	dollars = 12,
	mult = 4,
	boss = {min = 10, max = 10, showdown = true}, 
	config = {},
	vars = {},
}