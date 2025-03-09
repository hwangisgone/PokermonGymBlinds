-- KANTO
local TYPE_CLR = GYM_BLINDS_TYPE_CLR

SMODS.Atlas { 
	key = 'blinds_kanto', 
	atlas_table = 'ANIMATION_ATLAS', 
	path = 'blinds_kanto.png', 
	px = 34, 
	py = 34, 
	frames = 21 
}

SMODS.Blind {
	key = 'boulder',
	atlas = 'blinds_kanto',
	pos = { y = 0 },
	boss_colour = TYPE_CLR['rock'],
	
	discovered = true,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10},
	config = { disabled = false },
	vars = {},
	
	drawn_to_hand = function(self)
		if G.GAME.blind.prepped then
			for x,y in pairs(G.jokers.cards) do
				y:set_debuff(false)
			end
			for l,v in pairs(G.jokers.cards) do
				if goose_disable(v, 'Fire') then
					v:set_debuff(true)
					v:juice_up()
					G.GAME.blind:wiggle()
				end
			end
		end
	end,

	disable = function(self)
		self.config.disabled = true
  	end
}

SMODS.Blind {
	key = 'cascade',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 1 },
	boss_colour = TYPE_CLR['water'],

	discovered = true,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {odd = 2},
	vars = {1,2},
	collection_loc_vars = function(self)
		return {vars = {(G.GAME and G.GAME.probabilities.normal or 1), self.config.odd}}
	end,
	
	press_play = function(self)
		if pseudorandom(pseudoseed('misty')) < G.GAME.probabilities.normal / self.config.odd then
			local water_list = {}

			-- Remove jokers without energy
			for k,v in pairs(find_pokemon_type('Water')) do
				if v.ability.extra.energy_count and v.ability.extra.energy_count > 0 then
					table.insert(water_list, v)
				end
			end

			if #water_list > 0 then
				print(#water_list)
				local chosen_joker = pseudorandom_element(water_list, pseudoseed('misty'))

				chosen_joker.ability.extra.energy_count = chosen_joker.ability.extra.energy_count - 1
				energize(chosen_joker, false)

				G.GAME.blind:wiggle()
				play_sound('whoosh1', 0.55, 0.62)
				chosen_joker:juice_up(0.1, 1)
			else
				G.GAME.blind:juice_up()
				play_sound('cancel')
			end
		end
	end

	-- Vulpix: Chance
	-- Mewtwo: Energy
}



SMODS.Blind {
	key = 'thunder',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 2 },
	-- boss_colour = HEX('dab700'),
	boss_colour = TYPE_CLR['electric'],

	discovered = true,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'rainbow',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 3 },
	boss_colour = TYPE_CLR['grass'],

	discovered = true,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
	recalc_debuff = function(self, card, from_blind)
		if card.area ~= G.jokers then 
			if (card.edition and card.edition.polychrome) or card.ability.name == 'Wild Card' then
				card.debuffed_by_erika = true
				return true
			end
		end

		return false
	end,

	disable = function(self)
		for _, card in pairs(G.playing_cards) do
				if card.debuffed_by_erika then card:set_debuff(); card.debuffed_by_erika = nil end
		end
		self.triggered = false
	end,
}

SMODS.Blind {
	key = 'soul',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 4 },
	boss_colour = TYPE_CLR['poison'],

	discovered = true,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'marsh',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 5 },
	boss_colour = TYPE_CLR['psychic'],

	discovered = true,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'volcano',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 6 },
	boss_colour = TYPE_CLR['fire'],

	discovered = true,
	dollars = 5,
	mult = 3,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'earth',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 7 },
	-- boss_colour = TYPE_CLR['ground'],
	-- Used giovanni color
	boss_colour = G.C.BLACK,	

	discovered = true,
	dollars = 10,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'e4_lorelei',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 8 },
	boss_colour = TYPE_CLR['ice'],

	discovered = true,
	dollars = 8,
	mult = 2,
	boss = {min = 8, max = 10, showdown = true}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'e4_bruno',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 9 },
	boss_colour = TYPE_CLR['fighting'],

	discovered = true,
	dollars = 8,
	mult = 2,
	boss = {min = 8, max = 10, showdown = true}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'e4_agatha',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 10 },
	boss_colour = TYPE_CLR['ghost'],

	discovered = true,
	dollars = 8,
	mult = 2,
	boss = {min = 8, max = 10, showdown = true}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'e4_lance',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 11 },
	boss_colour = TYPE_CLR['dragon'],

	discovered = true,
	dollars = 8,
	mult = 2,
	boss = {min = 8, max = 10, showdown = true}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'champion_kanto',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 12 },
	boss_colour = G.C.UI_CHIPS,

	discovered = true,
	dollars = 16,
	mult = 4,
	boss = {min = 10, max = 10, showdown = true}, 
	config = {},
	vars = {},
}