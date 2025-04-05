-- HOENN
local TYPE_CLR = GYM_BLINDS_TYPE_CLR

SMODS.Atlas { 
	key = 'blinds_hoenn', 
	atlas_table = 'ANIMATION_ATLAS', 
	path = 'blinds_kanto.png',
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
	config = { card_count = 3 },
	vars = {3},

	loc_vars = function(self)
		return { vars = { self.config.card_count } }
	end,

	debuff_hand = function(self, cards, hand, handname, check)
		for _, card in pairs(cards) do
			local trigger_count = G.GAME.BL_EXTRA.temp_table['roxanne_triggered'] or 0

			if not card.ability.roxanne_stone_transform 
			-- and card.config.center.key ~= 'm_stone'
			and trigger_count < self.config.card_count then
				card.ability.roxanne_stone_transform = card.config.center

				local roxanne_stone = G.P_CENTERS.m_stone
				roxanne_stone.config.bonus = 0

				card:juice_up()
				card:set_ability(roxanne_stone, nil, true)

				attention_text({
					text = localize("bl_pkrm_gym_stone_ex"),
					scale = 0.75, 
					hold = 1,
					backdrop_colour = TYPE_CLR['rock'],
					align = 'cm',
					major = card,
					offset = {x = 0, y = 0}
				})
				
				G.ROOM.jiggle = G.ROOM.jiggle + 0.7

				G.GAME.BL_EXTRA.temp_table['roxanne_triggered'] = trigger_count + 1 
				G.GAME.blind:wiggle()
				G.GAME.blind.triggered = true
			end
		end

		return false
	end,

	disable = function(self)
		for _, card in pairs(G.playing_cards) do
			if card.ability.roxanne_stone_transform then
				local prev_enhancement = card.ability.roxanne_stone_transform
				card:set_ability(prev_enhancement, nil, false)
				card:juice_up()
			end
		end
		G.GAME.blind.triggered = false
	end,

	defeat = function(self)
		-- Remove so future encounter when disabled, won't revert changes in previous antes
		for _, card in pairs(G.playing_cards) do
			card.ability.roxanne_stone_transform = nil
		end
	end,
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

local basegame_card_highlight = Card.highlight
function Card:highlight(is_highlighted)
	if G.GAME.blind and G.GAME.blind.name == 'bl_pkrm_gym_knuckle' and not G.GAME.blind.disabled then
		if self.area and self.area == G.hand and not self.highlighted and is_highlighted then
			if #G.hand.highlighted <= G.hand.config.highlighted_limit then
				
				local leftmost_card = G.hand.cards[1]

				draw_card(G.hand, G.discard, 100, 'down', false, leftmost_card)
				draw_card(G.deck, G.hand, 100, 'up', false)

				-- This fix the "hovering deck problem"
				-- Where if selected card is also leftmost (or close to left), when moving it to deck
				-- it also opens the UI when you hover over the deck
				-- So instead of moving directly Hand -> Deck, we move Hand -> Discard -> Deck
				G.E_MANAGER:add_event(Event({
					trigger = "after", 
					delay = 0.5, 
					func = function() 
						draw_card(G.discard, G.deck, 100, 'down', false, leftmost_card)
						return true 
					end
				}))
			end
		end
	end

	basegame_card_highlight(self, is_highlighted)
end


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
		if G.GAME.blind.disabled then return end

		-- TOCHECK: context.pre_discard and context.cardarea == G.play??
		if context.pre_discard then
			G.GAME.blind:wiggle()
			G.GAME.blind.has_discarded = true
		elseif context.after then
			G.GAME.blind.has_discarded = false
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

	set_blind = function(self)
		G.E_MANAGER:add_event(Event({
			trigger = "after", 
			delay = 0.6,
			-- TOCHECK: Might be slightly buggy with 0.6
			-- Need a more concrete way of doing this, such as parent event releasing 'blocking' child event after 0.4
			blocking = false, 
			func = function()
				table.sort(G.deck.cards, function (a, b)
					local chipa, chipb = a:get_chip_bonus(), b:get_chip_bonus()
					return chipa == chipb and a:get_nominal() > b:get_nominal() or chipa > chipb
				end)
				return true 
			end
		}))
	end,
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
		-- TODO: what is check? "if not check then"
		return not next(hand['Pair'])
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