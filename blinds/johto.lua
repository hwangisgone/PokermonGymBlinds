-- JOHTO
local TYPE_CLR = GYM_BLINDS_TYPE_CLR

SMODS.Blind {
	key = 'zephyr',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 7 },
	boss_colour = TYPE_CLR['flying'],	

	discovered = true,
	dollars = 10,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'hive',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 7 },
	boss_colour = TYPE_CLR['bug'],	

	discovered = true,
	dollars = 10,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'plain',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 7 },
	boss_colour = TYPE_CLR['normal'],	

	discovered = true,
	dollars = 10,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},

	press_play = function(self)
		G.GAME.blind.chips = G.GAME.blind.chips * (1 + 20/100)
		G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
		self.triggered = true

    G.GAME.blind:wiggle()
	end
}

SMODS.Blind {
	key = 'fog',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 7 },
	boss_colour = TYPE_CLR['ghost'],	

	discovered = true,
	dollars = 10,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'storm',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 7 },
	boss_colour = TYPE_CLR['fighting'],	

	discovered = true,
	dollars = 10,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'mineral',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 7 },
	boss_colour = TYPE_CLR['steel'],	

	discovered = true,
	dollars = 10,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'glacier',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 7 },
	boss_colour = TYPE_CLR['ice'],	

	discovered = true,
	dollars = 10,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'rising',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 7 },
	boss_colour = TYPE_CLR['dragon'],	

	discovered = true,
	dollars = 10,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'e4_will',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 8 },
	boss_colour = TYPE_CLR['psychic'],

	discovered = true,
	dollars = 8,
	mult = 2,
	boss = {min = 8, max = 10, showdown = true}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'e4_koga',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 10 },
	boss_colour = TYPE_CLR['poison'],

	discovered = true,
	dollars = 8,
	mult = 2,
	boss = {min = 8, max = 10, showdown = true}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'e4_karen',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 11 },
	boss_colour = TYPE_CLR['dark'],

	discovered = true,
	dollars = 8,
	mult = 2,
	boss = {min = 8, max = 10, showdown = true}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'champion_johto',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 12 },
	boss_colour = TYPE_CLR['dragon'],

	discovered = true,
	dollars = 16,
	mult = 4,
	boss = {min = 10, max = 10, showdown = true}, 
	config = {},
	vars = {},
}