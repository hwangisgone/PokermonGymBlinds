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
	
	discovered = false,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10},
	config = { disabled = false },
	vars = {},
	
	drawn_to_hand = function(self)
		if G.GAME.blind.prepped then
			for _, card in pairs(G.jokers.cards) do
				if goose_disable(G.GAME.blind.disabled, card, {'Fire'}) then
					SMODS.debuff_card(card, true, 'brock_boulder_debuff')
					G.GAME.blind:wiggle()
				end
			end
		end
	end,

	disable = function(self)
		for _, card in pairs(G.jokers.cards) do
			SMODS.debuff_card(card, false, 'brock_boulder_debuff')
		end
		G.GAME.blind.triggered = false
	end,
}

SMODS.Blind {
	key = 'cascade',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 1 },
	boss_colour = TYPE_CLR['water'],

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {odd = 2},
	vars = {1,2},
	loc_vars = function(self)
		return {vars = {math.max(G.GAME.probabilities.normal, 1), self.config.odd}}
	end,
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
				local chosen_joker = pseudorandom_element(water_list, pseudoseed('misty'))
				
				local original_escale = chosen_joker.ability.extra.escale
				chosen_joker.ability.extra.energy_count = chosen_joker.ability.extra.energy_count - 1
				chosen_joker.ability.extra.escale = -1
				energize(chosen_joker, false, nil, true) -- energize(card, etype, evolving, silent)
				chosen_joker.ability.extra.escale = original_escale

				card_eval_status_text(chosen_joker, 'extra', nil, nil, nil, {message = localize("poke_reverse_energized_ex"), colour = TYPE_CLR['water']})

				G.GAME.blind:wiggle()
				play_sound('whoosh1', 0.55, 0.62)
				chosen_joker:juice_up(0.1, 1)
			else
				G.GAME.blind:wiggle()
				play_sound('cancel')
			end
		end
	end
}



SMODS.Blind {
	key = 'thunder',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 2 },
	-- boss_colour = HEX('dab700'),
	boss_colour = TYPE_CLR['electric'],

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
	config = {lose = 5, need_ranks = nil},
	loc_vars = function(self)
		local ranks_text = localize("pkrm_gym_thunder_collection_note")

		if self.config.need_ranks then
			ranks_text = self.config.need_ranks[1].rank.." or "..self.config.need_ranks[2].rank
		end

		return {vars = {self.config.lose, ranks_text}}
	end,
	collection_loc_vars = function(self)
		return {vars = {self.config.lose, localize("pkrm_gym_thunder_collection_note")}}
	end,

	set_blind = function(self)
		self.config.need_ranks = gymblind_get_random_ranks(2, pseudoseed('ltsurge'))
		G.GAME.blind:set_text()
	end,

	calculate = function(self, card, context)
		-- TODO: just context.pre_discard Might be buggy??
		if context.pre_discard and not G.GAME.blind.disabled then
			local rank1 = self.config.need_ranks[1].id
			local rank2 = self.config.need_ranks[2].id

			for k, v in pairs(G.hand.highlighted) do
				if v:get_id() == rank1 or v:get_id() == rank2 then

					return
				end
			end

			G.GAME.blind.triggered = true
			G.GAME.blind:wiggle()
			ease_dollars(-self.config.lose)
		end
	end,

	defeat = function(self)
		self.config.need_ranks = nil
	end
}


SMODS.Blind {
	key = 'rainbow',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 3 },
	boss_colour = TYPE_CLR['grass'],

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
	recalc_debuff = function(self, card, from_blind)
		if card.area ~= G.jokers then 
			if (card.edition and card.edition.polychrome) or card.ability.name == 'Wild Card' then
				SMODS.debuff_card(card, true, 'erika_rainbow_debuff')
				return false
			end
		end

		return false
	end,

	disable = function(self)
		for _, card in pairs(G.playing_cards) do
			SMODS.debuff_card(card, false, 'erika_rainbow_debuff')
		end
		G.GAME.blind.triggered = false
	end,
}

SMODS.Blind {
	key = 'soul',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 4 },
	boss_colour = TYPE_CLR['poison'],

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},

	calculate = function(self, card, context)
		-- TODO: just context.pre_discard Might be buggy??
		if (context.pre_discard or context.before) and not G.GAME.blind.disabled then
			for i = 1, #G.hand.cards do
				local percent = 1.15 - (i-0.999)/(#G.hand.cards-0.998)*0.3
				local this_card = G.hand.cards[i]

				if this_card.facing == 'front' and not this_card.highlighted then
					G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() 
						this_card:flip();
						play_sound('card1', percent);
						G.GAME.blind:wiggle()
						G.GAME.blind.triggered = true
						return true
					end}))
				end
			end
		end
	end,

	disable = function(self)
		for _, card in pairs(G.hand.cards) do
			if card.facing == 'back' then 
				card:flip();
			end
		end
		G.GAME.blind.triggered = false
	end,
}

SMODS.Blind {
	key = 'marsh',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 5 },
	boss_colour = TYPE_CLR['psychic'],

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {extra = { used_consumable = false }},
	vars = {},

	calculate = function(self, card, context)
		if context.using_consumeable then
			print("Used consumable")
			self.config.extra.used_consumable = true

			-- Recalculate debuffs
			for _, v in ipairs(G.hand.cards) do
				if v.debuff then
					G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() 
						SMODS.recalc_debuff(v)
						v.ability.sabrina_debuffed = true
						play_sound('tarot1', 1);
						v:juice_up(0.1, 0.1)
						return true
					end}))
				end
			end

			G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() 
				self.config.extra.used_consumable = false
				return true
			end}))	
		end
	end,

	recalc_debuff = function(self, card, from_blind)
		if card.ability.set ~= 'Joker' and not self.config.extra.used_consumable and not card.ability.sabrina_debuffed then
			return true
		else
			return false
		end
	end,
}

local function displayGUIquiz(quiz_table)
	local answer_rows = {}
	local current_row = {}
	

	if ((quiz_table.answers[1] == "Yes" or quiz_table.answers[2] == "Yes") and #quiz_table.answers == 2) then
		table.insert(answer_rows, 
			{n=G.UIT.C, config={padding = 0}, nodes = {
				{n=G.UIT.R, config = {padding = 0.1}, nodes = {
					{n=G.UIT.O, config={object = DynaText({scale = 0.5, string = "Yes", colours = {G.C.UI.TEXT_LIGHT}, 
							float = false, shadow = true, silent = true, pop_in = 0, pop_in_rate = 6}
					)}},
					{n = G.UIT.C, config = {minw = 1}},
					{n=G.UIT.O, config={object = DynaText({scale = 0.5, string = "No", colours = {G.C.UI.TEXT_LIGHT}, 
							float = false, shadow = true, silent = true, pop_in = 0, pop_in_rate = 6}
					)}},
				}},
				-- Consistent pacing
				{n=G.UIT.R, config = {minh = 0.6, padding = 0.1}}
			}}
		)
	else
		for i, answer in pairs(quiz_table.answers) do
			local display_text = i .. ". " .. answer
			
			table.insert(current_row, {n=G.UIT.R, config = {align = "cl", padding = 0.1}, nodes = {
				{n=G.UIT.O, config={object = DynaText({scale = 0.5, string = display_text, colours = {G.C.UI.TEXT_LIGHT}, 
						float = false, shadow = true, silent = true, pop_in = 0, pop_in_rate = 6}
				)}},
			}})
			
			-- End the column after 2 answers or final answer
			if #current_row == 2 or i == #quiz_table.answers then
				table.insert(answer_rows, 
					{n=G.UIT.C, config = {padding = 0}, nodes = current_row}
				)
				current_row = {}
			end
		end		
	end

	local first_line = quiz_table.quiz[#quiz_table.quiz-1] or ""
	local second_line = quiz_table.quiz[#quiz_table.quiz]

	-- minw = 8, minh = 6, 
	return {n=G.UIT.ROOT, config = {align = 'tm', padding = 0, colour = G.C.CLEAR}, nodes = {
			-- Quiz question
			{n=G.UIT.R, config = {align = 'tm', padding = 0.05}, nodes = {
				{n=G.UIT.O, config={object = DynaText({
					scale = 0.6, string = first_line, colours = {G.C.WHITE}, 
					float = true, bump_rate = 1, bump_amount = 10, shadow = true, silent = true, pop_in = 0, pop_in_rate = 6
				})}}
			}},
			{n=G.UIT.R, config = {align = 'tm', padding = 0.05}, nodes = {
				{n=G.UIT.O, config={object = DynaText({
					scale = 0.6, string = second_line, colours = {G.C.WHITE}, 
					float = true, bump_rate = 1, bump_amount = 10, shadow = true, silent = true, pop_in = 0, pop_in_rate = 6
				})}}
			}},

			-- Quiz type
			{n = G.UIT.R, config = {align = 'tm', padding = 0.1}, nodes = {
				{n=G.UIT.O, config={object = DynaText({scale = 0.4, string = quiz_table.type_loc, colours = {G.C.WHITE}, shadow = true, pop_in = 0, pop_in_rate = 6})}}
			}},
			
			-- Spacer
			{n = G.UIT.R, config = {minh = 0.1}},
			
			-- Answers section
			{n = G.UIT.R, config = {align = 'tm', padding = 0.2}, nodes = answer_rows}
		}
	}
end

local function redrawQuizUI(quiz_table)
	return UIBox{
		definition = displayGUIquiz(quiz_table),
		config = {
			align = 'tm',
			offset ={x=0,y=1}, 
			major = G.play,
		}
	}
end

BL_FUNCTION_TABLE['volcano_reload'] = function(temp_table)
	if type(temp_table) == 'table' then 
		G.GAME.blind.config.blind.custom_UI = redrawQuizUI(temp_table)
		G.GAME.blind.config.blind.quiz_table = temp_table
	end
end

local function blaine_get_quiz()
	-- Save quiz between blinds so that you get new quiz when rematched
	if not G.GAME.BL_PERSISTENCE or #G.GAME.BL_PERSISTENCE == 0 then
		G.GAME.BL_PERSISTENCE = copy_table(G.localization.misc.dictionary.pkrm_gym_blaine_quizzes)
	end

	local quiz_table, key = pseudorandom_element(G.GAME.BL_PERSISTENCE, pseudoseed('blaine'))
	table.remove(G.GAME.BL_PERSISTENCE, key)

	return quiz_table
end

SMODS.Enhancement {
	key = 'answer_card'
}

SMODS.Blind {
	key = 'volcano',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 6 },
	boss_colour = TYPE_CLR['fire'],

	discovered = false,
	dollars = 5,
	mult = 3,
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
	set_blind = function(self)
		G.GAME.BL_EXTRA.reload = 'volcano_reload'
		self.ready_new_quiz = true
	end,

	drawn_to_hand = function(self)
		if not self.ready_new_quiz then return end

		local quiz_table = blaine_get_quiz()

		local all_answers = {}
		for i, v in ipairs(quiz_table.wrong_answers) do all_answers[#all_answers + 1] = v end
		for i, v in ipairs(quiz_table.right_answers) do all_answers[#all_answers + 1] = v end
		pseudoshuffle(all_answers, pseudoseed('blaine'))

		quiz_table.answers = all_answers
		quiz_table.type_loc = G.localization.misc.dictionary.pkrm_gym_blaine_quizzes_loc[quiz_table.type]

		G.GAME.BL_EXTRA.temp_table = quiz_table

		if self.custom_UI and self.custom_UI.remove and type(self.custom_UI.remove) == 'function' then
			self.custom_UI:remove()
		end

		self.custom_UI = redrawQuizUI(quiz_table)
		self.quiz_table = quiz_table
		self.ready_new_quiz = false
	end,

	press_play = function(self)
		local quiz_table = self.quiz_table

		if quiz_table.type == 'single' then
			attention_text({
				text = "Correct!",
				backdrop_colour = G.C.GREEN,
				scale = 1.4, 
				hold = 2,
				major = G.play,
				align = 'tm',
				offset = {x = 0, y = 0},
				silent = false
			})

		elseif quiz_table.type == 'multiple' then
			attention_text({
				text = "Incorrect!",
				backdrop_colour = G.C.RED,
				scale = 1.4, 
				hold = 2,
				major = G.play,
				align = 'tm',
				offset = {x = 0, y = 0},
				silent = false
			})
		end

		G.GAME.blind:wiggle()

		self.ready_new_quiz = true
	end,

	disable = function(self)
		self.custom_UI:remove()
	end,

	defeat = function(self)
		self.custom_UI:remove()
	end,

	-- Remove debuff text at the start
	get_loc_debuff_text = function(self)
		return ""
	end,
}


function update_earth_score(blind, every_debt)
	local original_chips = get_blind_amount(G.GAME.round_resets.ante)
	local calculated_mult = blind.mult -- X2 in normal condition
	local current_money = get_current_dollars()

	if current_money < 0 then
		calculated_mult = calculated_mult + math.floor((-current_money) / every_debt)
	end
	print(current_money)
	print((-current_money) / every_debt)
	print(calculated_mult)

	local calculated_chips = original_chips*calculated_mult*G.GAME.starting_params.ante_scaling

	-- Animate change in chips
	if calculated_chips ~= blind.chips then
		blind.chips = calculated_chips
		blind.chip_text = number_format(calculated_chips)

		attention_text({
			text = 'X'..calculated_mult,
			scale = 1, 
			hold = 2,
			cover = G.HUD_blind:get_UIE_by_ID("HUD_blind_count").parent.parent,
			-- Team Rocket color
			cover_colour = HEX('b83020'),
			align = 'cm',
		})

		blind:wiggle()
	end
end

-- Only Giovanni do this so only checks for The Earth
local _ease_dollars = ease_dollars
function ease_dollars(mod, instant)
	_ease_dollars(mod, instant)

	if G.GAME.blind.name == 'bl_pkrm_gym_earth' then
		if instant then
			update_earth_score(G.GAME.blind, G.GAME.blind.config.blind.config.every_debt)
		else
			G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = function()
				update_earth_score(G.GAME.blind, G.GAME.blind.config.blind.config.every_debt)
				return true
			end
			}))
		end
	end
end

SMODS.Blind {
	key = 'earth',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 7 },
	-- boss_colour = TYPE_CLR['ground'],
	-- Used giovanni color
	boss_colour = G.C.BLACK,	

	discovered = false,
	dollars = 8,
	mult = 2,
	boss = {min = 1, max = 10}, 
	config = {lose = 80, every_debt = 5},
	vars = {},
	
	set_blind = function(self)
		self.config.lose = G.GAME.round_resets.ante * 10
	end,

	loc_vars = function(self)
		return {vars = {G.GAME.round_resets.ante * 10, self.config.every_debt}}
	end,
	collection_loc_vars = function(self)
		return {vars = {self.config.lose.." "..localize("pkrm_gym_earth_collection_note"), self.config.every_debt}}
	end,

	drawn_to_hand = function(self)
		if G.GAME.blind.prepped then
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.5, blockable = false, blocking = false, func = function()
				if not G.GAME.blind.disabled then
					G.ROOM.jiggle = G.ROOM.jiggle + 4
					ease_dollars(- self.config.lose, true)

					G.GAME.blind.triggered = true
					save_run()
				end

				return true 
			end}))
		end
	end,

	disable = function(self)
		if G.GAME.blind.triggered then
			ease_dollars(self.config.lose)
		end
	end,
}

SMODS.Blind {
	key = 'e4_lorelei',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 8 },
	boss_colour = TYPE_CLR['ice'],

	discovered = false,
	dollars = 8,
	mult = 2,
	boss = {min = 8, max = 10, showdown = true}, 
	config = {break_turns = 3},
	vars = {3},
	loc_vars = function(self)
		return {vars = {self.config.break_turns}}
	end,

	set_blind = function(self)
		G.GAME.BL_EXTRA.temp_table = {
			break_in = self.config.break_turns
		}
	end,

	press_play = function(self)
		local current_turn = G.GAME.BL_EXTRA.temp_table.break_in
		if current_turn == 0 then
			G.GAME.BL_EXTRA.temp_table.break_in = self.config.break_turns - 1
		else
			G.GAME.BL_EXTRA.temp_table.break_in = current_turn - 1
		end

		print(G.GAME.BL_EXTRA.temp_table.break_in)
	end,

	calculate = function(self, card, context)
		if context.after then
			if G.GAME.BL_EXTRA.temp_table.break_in == 0 then
				for _, card in ipairs(G.hand.cards) do
					G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.2,func = function() 
						card:shatter()
						return true
					end}))
				end
			end
			print(G.GAME.BL_EXTRA.temp_table.break_in)
		end
	end,

}

SMODS.Blind {
	key = 'e4_bruno',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 9 },
	boss_colour = TYPE_CLR['fighting'],

	discovered = false,
	dollars = 8,
	mult = 2,
	boss = {min = 8, max = 10, showdown = true}, 
	config = {},
	vars = {},

	set_blind = function(self)
		G.GAME.BL_EXTRA.temp_table = {}
	end,

	calculate = function(self, card, context)
		if context.pre_discard then
			local text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)

			G.GAME.BL_EXTRA.temp_table[text] = true
			
			G.GAME.blind:wiggle()
			play_sound('cancel', 2, 0.9);
		end
	end,

	debuff_hand = function(self, cards, hand, handname, check)
		if not G.GAME.blind.disabled then
			local is_debuffed = false
			local disabled_hands = G.GAME.BL_EXTRA.temp_table

			for k,v in pairs(disabled_hands) do
				if k == handname then
					is_debuffed = true
					break
				end
			end

			return is_debuffed
		end
	end,

	get_loc_debuff_text = function(self)
		local disabled_hands = G.GAME.BL_EXTRA.temp_table
		local text = 'Discarded poker hand will no longer score'

		local total = 0
		for _ in pairs(disabled_hands) do
			total = total + 1
		end

		if total > 0 then
			text = ''
			local i = 1
			for k,v in pairs(disabled_hands) do
				text = text..k
				if i < (total - 1) then
					text = text..', '
				elseif i == (total - 1) then
					text = text..' and '
				end
				i = i + 1
			end
			text = text..' will not score'
		end

		return text
	end
}

SMODS.Blind {
	key = 'e4_agatha',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 10 },
	boss_colour = TYPE_CLR['ghost'],

	discovered = false,
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
	boss_colour = GYM_SHOWDOWN_CLR['lance'],

	discovered = false,
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
	boss_colour = GYM_SHOWDOWN_CLR['blue'],

	discovered = false,
	dollars = 12,
	mult = 4,
	boss = {min = 10, max = 10, showdown = true}, 
	config = {},
	vars = {},
}