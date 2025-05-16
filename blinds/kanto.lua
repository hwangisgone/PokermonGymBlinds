-- KANTO
local TYPE_CLR = GYM_BLINDS_TYPE_CLR

SMODS.Atlas {
	key = 'blinds_kanto',
	atlas_table = 'ANIMATION_ATLAS',
	path = 'blinds_kanto.png',
	px = 34,
	py = 34,
	frames = 21,
}

SMODS.Blind {
	key = 'boulder',
	atlas = 'blinds_kanto',
	pos = { y = 0 },
	boss_colour = TYPE_CLR['rock'],

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = { min = 1, max = 10 },
	config = {},
	vars = {},

	drawn_to_hand = function(self)
		if G.GAME.blind.prepped then
			for _, card in pairs(G.jokers.cards) do
				if goose_disable(G.GAME.blind.disabled, card, { 'Fire' })
				or goose_disable(G.GAME.blind.disabled, card, { 'Lightning' }) then
					SMODS.debuff_card(card, true, 'brock_boulder_debuff')
					card:juice_up()
					G.GAME.blind:wiggle()
				end
			end
		end
	end,

	disable = function(self)
		remove_debuff_all_jokers('brock_boulder_debuff')
	end,
	defeat = function(self)
		remove_debuff_all_jokers('brock_boulder_debuff')
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
	boss = { min = 1, max = 10 },
	config = { odd = 2 },
	vars = { 1, 2 },
	loc_vars = function(self)
		return { vars = { math.max(G.GAME.probabilities.normal, 1), self.config.odd } }
	end,
	collection_loc_vars = function(self)
		return { vars = { (G.GAME and G.GAME.probabilities.normal or 1), self.config.odd } }
	end,

	press_play = function(self)
		if pseudorandom(pseudoseed('misty')) < G.GAME.probabilities.normal / self.config.odd then
			local water_list = {}

			-- Remove jokers without energy
			for k, v in pairs(find_pokemon_type('Water')) do
				-- if v.ability.extra.energy_count and v.ability.extra.energy_count > 0 then
					table.insert(water_list, v)
				-- end
			end

			if #water_list > 0 then
				local chosen_joker = pseudorandom_element(water_list, pseudoseed('misty'))

				local original_escale = chosen_joker.ability.extra.escale
				chosen_joker.ability.extra.energy_count = (chosen_joker.ability.extra.energy_count or 0) - 1
				chosen_joker.ability.extra.escale = -1
				energize(chosen_joker, false, nil, true) -- energize(card, etype, evolving, silent)
				chosen_joker.ability.extra.escale = original_escale

				card_eval_status_text(chosen_joker, 'extra', nil, nil, nil, {
					message = localize('poke_reverse_energized_ex'),
					colour = TYPE_CLR['water'],
				})

				G.GAME.blind:wiggle()
				play_sound('whoosh1', 0.55, 0.62)
				chosen_joker:juice_up(0.1, 1)
			else
				G.GAME.blind:wiggle()
				play_sound('cancel')
			end
		end
	end,
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
	boss = { min = 1, max = 10 },
	config = {},
	vars = {},
	config = { lose = 5, need_ranks = nil },
	loc_vars = function(self)
		local ranks_text = localize('pkrm_gym_thunder_collection_note')

		if self.config.need_ranks then
			ranks_text = self.config.need_ranks[1].rank .. ' or ' .. self.config.need_ranks[2].rank
		end

		return { vars = { self.config.lose, ranks_text } }
	end,
	collection_loc_vars = function(self)
		return { vars = { self.config.lose, localize('pkrm_gym_thunder_collection_note') } }
	end,

	set_blind = function(self)
		self.config.need_ranks = gymblind_get_random_ranks(2, pseudoseed('ltsurge'))
		G.GAME.blind:set_text()
	end,

	calculate = function(self, card, context)
		if G.GAME.blind.disabled then return end

		-- TODO: just context.pre_discard Might be buggy??
		if context.pre_discard then
			local rank1 = self.config.need_ranks[1].id
			local rank2 = self.config.need_ranks[2].id

			for k, v in pairs(G.hand.highlighted) do
				if v:get_id() == rank1 or v:get_id() == rank2 then return end
			end

			G.GAME.blind.triggered = true
			G.GAME.blind:wiggle()
			ease_dollars(-self.config.lose)
		end
	end,

	defeat = function(self)
		self.config.need_ranks = nil
	end,
}

SMODS.Blind {
	key = 'rainbow',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 3 },
	boss_colour = TYPE_CLR['grass'],

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = { min = 1, max = 10 },
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
		remove_debuff_all_playing_cards('erika_rainbow_debuff')
	end,
	defeat = function(self)
		remove_debuff_all_playing_cards('erika_rainbow_debuff')
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
	boss = { min = 1, max = 10 },
	config = {},
	vars = {},

	calculate = function(self, card, context)
		if G.GAME.blind.disabled then return end

		-- TODO: just context.pre_discard Might be buggy??
		if context.pre_discard or context.before then
			for i = 1, #G.hand.cards do
				local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
				local this_card = G.hand.cards[i]

				-- previously check for front facing cards only: this_card.facing == 'front'
				if not this_card.highlighted then
					G.E_MANAGER:add_event(Event {
						trigger = 'after',
						delay = 0.15,
						func = function()
							this_card:flip()
							play_sound('card1', percent)
							G.GAME.blind:wiggle()
							G.GAME.blind.triggered = true
							return true
						end,
					})
				end
			end
		end
	end,

	disable = function(self)
		for _, card in pairs(G.hand.cards) do
			if card.facing == 'back' then card:flip() end
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
	boss = { min = 1, max = 10 },
	config = { extra = { used_consumable = false } },
	vars = {},

	calculate = function(self, card, context)
		if G.GAME.blind.disabled then return end

		if context.using_consumeable then
			self.config.extra.used_consumable = true

			-- Recalculate debuffs
			for _, v in ipairs(G.hand.cards) do
				if v.debuff then
					G.E_MANAGER:add_event(Event {
						trigger = 'after',
						delay = 0.1,
						func = function()
							SMODS.recalc_debuff(v)
							v.ability.sabrina_marsh_debuff = true
							play_sound('tarot1', 1)
							v:juice_up(0.1, 0.1)
							return true
						end,
					})
				end
			end

			G.E_MANAGER:add_event(Event {
				trigger = 'after',
				delay = 0.1,
				func = function()
					self.config.extra.used_consumable = false
					return true
				end,
			})
		end
	end,

	recalc_debuff = function(self, card, from_blind)
		if
			card.ability.set ~= 'Joker'
			and not self.config.extra.used_consumable
			and not card.ability.sabrina_marsh_debuff
		then
			-- ability is to prevent purified cards from being debuffed again
			return true
		else
			return false
		end
	end,
}

local function isYesNo(quiz_table)
	return (quiz_table.answers[1] == 'Yes' or quiz_table.answers[2] == 'Yes') and #quiz_table.answers == 2
end

local function displayGUIquiz(quiz_table)
	local answer_rows = {}
	local current_row = {}

	if isYesNo(quiz_table) then
		table.insert(answer_rows, {
			n = G.UIT.C,
			config = { padding = 0 },
			nodes = {
				{
					n = G.UIT.R,
					config = { padding = 0.1 },
					nodes = {
						{
							n = G.UIT.O,
							config = {
								object = DynaText {
									scale = 0.5,
									string = 'Yes',
									colours = { G.C.UI.TEXT_LIGHT },
									float = false,
									shadow = true,
									silent = true,
									pop_in = 0,
									pop_in_rate = 6,
								},
							},
						},
						{ n = G.UIT.C, config = { minw = 1 } },
						{
							n = G.UIT.O,
							config = {
								object = DynaText {
									scale = 0.5,
									string = 'No',
									colours = { G.C.UI.TEXT_LIGHT },
									float = false,
									shadow = true,
									silent = true,
									pop_in = 0,
									pop_in_rate = 6,
								},
							},
						},
					},
				},
				-- Consistent pacing
				{ n = G.UIT.R, config = { minh = 0.6, padding = 0.1 } },
			},
		})
	else
		for i, answer in pairs(quiz_table.answers) do
			local display_text = i .. '. ' .. answer

			table.insert(current_row, {
				n = G.UIT.R,
				config = { align = 'cl', padding = 0.1 },
				nodes = {
					{
						n = G.UIT.O,
						config = {
							object = DynaText {
								scale = 0.5,
								string = display_text,
								colours = { G.C.UI.TEXT_LIGHT },
								float = false,
								shadow = true,
								silent = true,
								pop_in = 0,
								pop_in_rate = 6,
							},
						},
					},
				},
			})

			-- End the column after 2 answers or final answer
			if #current_row == 2 or i == #quiz_table.answers then
				table.insert(answer_rows, { n = G.UIT.C, config = { padding = 0 }, nodes = current_row })
				current_row = {}
			end
		end
	end

	local first_line = quiz_table.quiz[#quiz_table.quiz - 1] or ''
	local second_line = quiz_table.quiz[#quiz_table.quiz]

	-- minw = 8, minh = 6,
	return {
		n = G.UIT.ROOT,
		config = { align = 'tm', padding = 0, colour = G.C.CLEAR },
		nodes = {
			-- Quiz question
			{
				n = G.UIT.R,
				config = { align = 'tm', padding = 0.05 },
				nodes = {
					{
						n = G.UIT.O,
						config = {
							object = DynaText {
								scale = 0.6,
								string = first_line,
								colours = { G.C.WHITE },
								float = true,
								bump_rate = 1,
								bump_amount = 10,
								shadow = true,
								silent = true,
								pop_in = 0,
								pop_in_rate = 6,
							},
						},
					},
				},
			},
			{
				n = G.UIT.R,
				config = { align = 'tm', padding = 0.05 },
				nodes = {
					{
						n = G.UIT.O,
						config = {
							object = DynaText {
								scale = 0.6,
								string = second_line,
								colours = { G.C.WHITE },
								float = true,
								bump_rate = 1,
								bump_amount = 10,
								shadow = true,
								silent = true,
								pop_in = 0,
								pop_in_rate = 6,
							},
						},
					},
				},
			},

			-- Quiz type
			{
				n = G.UIT.R,
				config = { align = 'tm', padding = 0.1 },
				nodes = {
					{
						n = G.UIT.O,
						config = {
							object = DynaText {
								scale = 0.4,
								string = quiz_table.type_loc,
								colours = { G.C.WHITE },
								shadow = true,
								pop_in = 0,
								pop_in_rate = 6,
							},
						},
					},
				},
			},

			-- Spacer
			{ n = G.UIT.R, config = { minh = 0.1 } },

			-- Answers section
			{ n = G.UIT.R, config = { align = 'tm', padding = 0.2 }, nodes = answer_rows },
		},
	}
end

local function redrawQuizUI(quiz_table)
	return UIBox {
		definition = displayGUIquiz(quiz_table),
		config = {
			align = 'tm',
			offset = { x = 0, y = 1 },
			major = G.play,
		},
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

local answer_cards_config = {
	H_T = 1,
	H_9 = 2,
	H_8 = 3,
	H_7 = 4,
	H_K = 'Yes',
	H_Q = 'No',
}

SMODS.Enhancement {
	key = 'answer_card',
	no_collection = true,
	no_rank = true,
	no_suit = true,
	replace_base_card = true,
	always_scores = true,
	weight = 0,

	in_pool = function(self, args)
		return false
	end,

	loc_vars = function(self, info_queue, card)
		local answer_key = card.ability.extra.answer_key
		if type(answer_key) == 'number' then answer_key = answer_key .. '.' end
		return { vars = { answer_key } }
	end,

	set_ability = function(self, card, initial, delay_sprites)
		if initial then
			card.ability.extra = card.ability.extra or {}

			for k, v in pairs(G.P_CARDS) do
				if card.config.card == v then
					card.ability.extra.answer_key = answer_cards_config[k]
					return
				end
			end

			card.ability.extra.answer_key = 1
		end
	end,

	calculate = function(self, card, context)
		-- Return to hand after Play/Discard
		if (context.after and context.cardarea == G.play)
		or (context.pre_discard and card.highlighted) then
			G.E_MANAGER:add_event(Event {
				trigger = 'immediate',
				func = function()
					draw_card(G.discard, G.hand, 100, 'up', false, card)
					return true
				end,
			})
		end

		if context.playing_card_end_of_round and context.cardarea == G.hand then
			card:start_dissolve()
		end
	end,
}

local function correct_attention_text(major)
	attention_text {
		text = localize('pkrm_gym_blaine_quizzes_ex_right'),
		backdrop_colour = G.C.GREEN,
		scale = 1,
		hold = 2,
		major = major,
		align = (major == G.play and 'tm') or 'cm',
		offset = { x = 0, y = 0 },
		silent = false,
	}

	G.GAME.blind:wiggle()
end

local function wrong_attention_text(major)
	attention_text {
		text = localize('pkrm_gym_blaine_quizzes_ex_wrong'),
		backdrop_colour = G.C.RED,
		scale = 1,
		hold = 2,
		major = major,
		align = (major == G.play and 'tm') or 'cm',
		offset = { x = 0, y = 0 },
		silent = false,
	}

	G.GAME.blind:wiggle()
end

local function bad_answer_attention_text(text, major)
	local config = {
		scale = 1.4,
		hold = 1.5,
		align = 'tm'
	}

	-- Align to card
	if major ~= G.play then
		config.scale = 0.7
		config.align = 'cm'
	end

	attention_text {
		text = text,
		backdrop_colour = G.C.BLACK,
		backdrop_scale = 1.8,
		scale = config.scale,
		hold = config.hold,
		major = major,
		align = config.align,
		offset = { x = 0, y = 0 },
		silent = false,
	}

	G.ROOM.jiggle = G.ROOM.jiggle + 0.7
	play_sound('cancel')
end

SMODS.Blind {
	key = 'volcano',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 6 },
	boss_colour = TYPE_CLR['fire'],

	discovered = false,
	dollars = 5,
	mult = 3,
	boss = { min = 1, max = 10 },
	config = {},
	vars = {},
	set_blind = function(self)
		G.GAME.BL_EXTRA.reload = 'volcano_reload'
		self.ready_new_quiz = true

		for k, v in pairs(answer_cards_config) do
			local card = create_playing_card({
				front = G.P_CARDS[k],
				center = G.P_CENTERS.m_pkrm_gym_answer_card,
			}, G.hand, nil, nil, { G.C.SECONDARY_SET.Enhanced })
		end
	end,

	drawn_to_hand = function(self)
		if not self.ready_new_quiz then return end

		local quiz_table = blaine_get_quiz()

		local all_answers = {}
		for i, v in ipairs(quiz_table.wrong_answers) do
			all_answers[#all_answers + 1] = v
		end
		for i, v in ipairs(quiz_table.right_answers) do
			all_answers[#all_answers + 1] = v
		end
		pseudoshuffle(all_answers, pseudoseed('blaine'))

		quiz_table.answers = all_answers
		quiz_table.type_loc = G.localization.misc.dictionary.pkrm_gym_blaine_quizzes_type_loc[quiz_table.type]

		G.GAME.BL_EXTRA.temp_table = quiz_table

		if self.custom_UI and self.custom_UI.remove and type(self.custom_UI.remove) == 'function' then
			self.custom_UI:remove()
		end

		self.custom_UI = redrawQuizUI(quiz_table)
		self.quiz_table = quiz_table
		self.ready_new_quiz = false
	end,

	debuff_hand = function(self, cards, hand, handname, check)
		local quiz_table = self.quiz_table

		if quiz_table.type == 'single' then
			local selected = false
			local is_yes_no = isYesNo(quiz_table)

			for _, card in ipairs(cards) do
				if card.config.center.key == 'm_pkrm_gym_answer_card' then
					if not selected then
						if is_yes_no and type(card.ability.extra.answer_key) ~= 'string' then
							G.hand:remove_from_highlighted(card)
							bad_answer_attention_text(localize('pkrm_gym_blaine_quizzes_warn_yesno'), card)

						elseif not is_yes_no and type(card.ability.extra.answer_key) ~= 'number' then
							G.hand:remove_from_highlighted(card)
							bad_answer_attention_text(localize('pkrm_gym_blaine_quizzes_warn_number'), card)
						else
							selected = true
						end
					else
						G.hand:remove_from_highlighted(card)
						bad_answer_attention_text(localize('pkrm_gym_blaine_quizzes_warn_single'), card)
					end
				end
			end
		else
			for _, card in ipairs(cards) do
				if card.config.center.key == 'm_pkrm_gym_answer_card'
				and type(card.ability.extra.answer_key) ~= 'string' then
					G.hand:remove_from_highlighted(card)
					bad_answer_attention_text(localize('pkrm_gym_blaine_quizzes_warn_number'), card)
				end
			end
		end

		return false
	end,

	calculate = function(self, card, context)
		if G.GAME.blind.disabled then return end

		if context.before then
			self.ready_new_quiz = true
			local quiz_table = self.quiz_table
			local is_yes_no = isYesNo(quiz_table)

			if quiz_table.type == 'single' then
				local correct = false

				for k, v in pairs(G.play.cards) do
					if v.config.center.key == 'm_pkrm_gym_answer_card' then
						if is_yes_no then
							correct =  v.ability.extra.answer_key == quiz_table.right_answers[1]
						else
							correct = quiz_table.answers[v.ability.extra.answer_key] == quiz_table.right_answers[1]
						end
						
						if correct then
							correct_attention_text(v)
						else
							wrong_attention_text(v)
						end
						return
					end
				end
				
			elseif quiz_table.type == 'multiple' then
				local right_answers = copy_table(quiz_table.right_answers)

				for k, v in pairs(G.play.cards) do
					if v.config.center.key == 'm_pkrm_gym_answer_card' then
						local include_answer = false
						
						for i, right_answer in ipairs(right_answers) do
							if quiz_table.answers[v.ability.extra.answer_key] == right_answer then
								include_answer = true
								table.remove(right_answers, i)
								break
							end
						end

						if include_answer then
							correct_attention_text(v)
						else
							wrong_attention_text(v)
						end

						if #right_answers == 0 then
							correct_attention_text(G.play)
							return
						end
					end
				end

				-- Not all correct
				wrong_attention_text(G.play)
			end

			bad_answer_attention_text(localize('pkrm_gym_blaine_quizzes_warn_no_answer'), G.play)
		end
	end,

	disable = function(self)
		if self.custom_UI then
			self.custom_UI:remove()
		end

		for _, card in pairs(G.playing_cards) do
			if SMODS.has_enhancement(card, 'm_pkrm_gym_answer_card') then
				card:start_dissolve()
			end
		end

		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.1,
			func = function()
				G.E_MANAGER:add_event(Event({
					trigger = 'immediate',
					func = function()
						G.FUNCS.draw_from_deck_to_hand()
						return true
					end
				}))
				return true
			end
		}))
	end,

	defeat = function(self)
		if self.custom_UI then
			self.custom_UI:remove()
		end
	end,

	-- Remove debuff text at the start
	get_loc_debuff_text = function(self)
		return ''
	end,
}

BL_FUNCTION_TABLE['earth_ease_dollars'] = function(mod)
	local blind = G.GAME.blind
	local every_earned = G.GAME.blind.config.blind.config.every_earned

	G.GAME.BL_EXTRA.temp_table.total_earned = (G.GAME.BL_EXTRA.temp_table.total_earned or 0) + mod

	local total_earned = G.GAME.BL_EXTRA.temp_table.total_earned
	local original_chips = get_blind_amount(G.GAME.round_resets.ante)
	local calculated_mult = blind.mult -- X8 in normal condition

	calculated_mult = math.max(calculated_mult - math.floor(total_earned / every_earned), 2)

	print(total_earned)
	print(total_earned / every_earned)
	print(calculated_mult)

	local calculated_chips = original_chips * calculated_mult * G.GAME.starting_params.ante_scaling

	-- Animate change in chips
	if calculated_chips ~= blind.chips then
		blind.chips = calculated_chips
		blind.chip_text = number_format(calculated_chips)

		attention_text {
			text = 'X' .. calculated_mult,
			scale = 1,
			hold = 2,
			cover = G.HUD_blind:get_UIE_by_ID('HUD_blind_count').parent.parent,
			-- Team Rocket color
			cover_colour = HEX('b83020'),
			align = 'cm',
		}

		blind:wiggle()
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
	mult = 8,
	boss = { min = 1, max = 10 },
	config = { every_earned = 5 },
	vars = {},

	set_blind = function(self)
		G.GAME.BL_EXTRA.ease_dollars = 'earth_ease_dollars'
	end,

	loc_vars = function(self)
		return { vars = { self.config.every_earned } }
	end,
	collection_loc_vars = function(self)
		return { vars = { self.config.every_earned } }
	end,

	-- drawn_to_hand = function(self)
	-- 	if G.GAME.blind.prepped then
	-- 		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.5, blockable = false, blocking = false, func = function()
	-- 			if not G.GAME.blind.disabled then
	-- 				G.ROOM.jiggle = G.ROOM.jiggle + 4
	-- 				ease_dollars(- self.config.lose, true)

	-- 				G.GAME.blind.triggered = true
	-- 				save_run()
	-- 			end

	-- 			return true
	-- 		end}))
	-- 	end
	-- end,

	disable = function(self)
		G.GAME.BL_EXTRA.ease_dollars = nil

		local original_chips = get_blind_amount(G.GAME.round_resets.ante)
		local calculated_mult = 2
		local calculated_chips = original_chips * calculated_mult * G.GAME.starting_params.ante_scaling

		G.GAME.blind.chips = calculated_chips
		G.GAME.blind.chip_text = number_format(calculated_chips)
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
	boss = { min = 8, max = 10, showdown = true },
	config = { break_turns = 3 },
	vars = { 3 },
	loc_vars = function(self)
		return { vars = { self.config.break_turns } }
	end,

	set_blind = function(self)
		G.GAME.BL_EXTRA.temp_table = {
			break_in = self.config.break_turns,
		}
	end,

	press_play = function(self)
		local current_turn = G.GAME.BL_EXTRA.temp_table.break_in
		if current_turn == 0 then
			G.GAME.BL_EXTRA.temp_table.break_in = self.config.break_turns - 1
		else
			G.GAME.BL_EXTRA.temp_table.break_in = current_turn - 1
		end

		-- print(G.GAME.BL_EXTRA.temp_table.break_in)
	end,

	calculate = function(self, card, context)
		if G.GAME.blind.disabled then return end

		if context.after then
			if G.GAME.BL_EXTRA.temp_table.break_in == 0 then
				for _, card in ipairs(G.hand.cards) do
					G.E_MANAGER:add_event(Event {
						trigger = 'after',
						delay = 0.2,
						func = function()
							card:shatter()
							return true
						end,
					})
				end
			end
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
	boss = { min = 8, max = 10, showdown = true },
	config = {},
	vars = {},

	set_blind = function(self)
		G.GAME.BL_EXTRA.temp_table = {}
	end,

	calculate = function(self, card, context)
		if G.GAME.blind.disabled then return end

		if context.pre_discard then
			local text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)

			G.GAME.BL_EXTRA.temp_table[text] = true

			G.GAME.blind:wiggle()
			play_sound('cancel', 2, 0.9)
		end
	end,

	debuff_hand = function(self, cards, hand, handname, check)
		local is_debuffed = false
		local disabled_hands = G.GAME.BL_EXTRA.temp_table

		for k, v in pairs(disabled_hands) do
			if k == handname then
				is_debuffed = true
				break
			end
		end

		return is_debuffed
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
			for k, v in pairs(disabled_hands) do
				text = text .. k
				if i < (total - 1) then
					text = text .. ', '
				elseif i == (total - 1) then
					text = text .. ' and '
				end
				i = i + 1
			end
			text = text .. ' will not score'
		end

		return text
	end,
}

SMODS.Blind {
	key = 'e4_agatha',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 10 },
	boss_colour = TYPE_CLR['ghost'],

	discovered = false,
	dollars = 8,
	mult = 2,
	boss = { min = 8, max = 10, showdown = true },
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
	boss = { min = 8, max = 10, showdown = true },
	config = {},
	vars = {},

	calculate = function(self, card, context)
		if G.GAME.blind.disabled then return end

		if context.before then
			local hands_left = G.GAME.current_round.hands_left
			local played_length = #G.play.cards

			for k, v in pairs(G.play.cards) do
				if (played_length - k) < hands_left then
					SMODS.debuff_card(v, true, 'e4_lance_debuff')
					v:juice_up()
				end
			end

			G.GAME.blind:wiggle()
		end
	end,
}

local pokermon_chip_drain = poke_stabilize_chip_drain
poke_stabilize_chip_drain = function(card)
	card.ability.nominal_drain = 0
	-- if card.ability.boss_drain then
	-- 	card.ability.boss_drain = nil
	-- else
	-- 	pokermon_chip_drain(card)
	-- end
end

SMODS.Blind {
	key = 'champion_kanto',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 12 },
	boss_colour = GYM_SHOWDOWN_CLR['blue'],

	discovered = false,
	dollars = 12,
	mult = 4,
	boss = { min = 10, max = 10, showdown = true },
	config = { blue_penalty_chips = 12 },
	vars = { 12 },

	calculate = function(self, card, context)
		if G.GAME.blind.disabled then return end

		if context.before then
			for k, v in pairs(G.play.cards) do
				-- G.E_MANAGER:add_event(Event({trigger = 'immediate',func = function()
				v:juice_up(0.5, 0.1)
				-- card.ability.nominal_drain = self.config.blue_penalty_chips
				-- card.ability.boss_drain = true
				v.ability.perma_bonus = v.ability.perma_bonus - self.config.blue_penalty_chips
				print(v:get_chip_bonus())
			end
		elseif context.after then
			G.E_MANAGER:add_event(Event {
				trigger = 'immediate',
				func = function()
					for k, card in pairs(G.play.cards) do
						print('TRIGGERED')
						card.ability.perma_bonus = card.ability.perma_bonus + self.config.blue_penalty_chips
					end
					return true
				end,
			})
		end
	end,
}
