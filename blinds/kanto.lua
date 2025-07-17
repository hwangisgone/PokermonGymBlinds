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
	boss = { min = 1 },
	config = {},
	vars = {},

	drawn_to_hand = function(self)
		if G.GAME.blind.prepped then
			for _, card in pairs(G.jokers.cards) do
				if
					goose_disable(G.GAME.blind.disabled, card, { 'Fire' })
					or goose_disable(G.GAME.blind.disabled, card, { 'Lightning' })
				then
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
	boss = { min = 1 },
	config = { ante_reduced_chips = 10 },
	vars = {},

	loc_vars = function(self)
		return { vars = { self.config.ante_reduced_chips * G.GAME.round_resets.ante, '' } }
	end,
	collection_loc_vars = function(self)
		return {
			vars = { self.config.ante_reduced_chips * 2, localize('pkrm_gym_cascade_collection_note') },
		}
	end,

	calculate = function(self, blind, context)
		if blind.disabled then return end

		if context.final_scoring_step then
			local amount = self.config.ante_reduced_chips * G.GAME.round_resets.ante
			local count = 1

			repeat -- Do at least once
				local count_msg = count > 1 and ' (x' .. count .. ')' or ''
				local i = count

				hand_chips = math.max(mod_chips(hand_chips - amount), 0)
				update_hand_text({ delay = 0 }, { chips = hand_chips })

				G.E_MANAGER:add_event(Event {
					trigger = 'before',
					delay = math.max(0.5, 1.2 - i * 0.2), -- E.g. 1, 0.8, 0.6, 0.5 (slowly ramp up)
					func = function()
						blind.triggered = true
						blind:wiggle()
						play_sound('chips2', math.random() * 0.1 + 0.55, 0.12)

						attention_text {
							text = '-' .. amount .. count_msg,
							scale = 1,
							hold = 0.4 * (count - i + 1),
							backdrop_colour = TYPE_CLR['water'],
							backdrop_scale = 0.75 + (i * 0.2),
							align = 'bm',
							major = G.jokers,
							offset = { x = -2 * G.CARD_W, y = i - 1 },
						}

						return true
					end,
				})

				count = count + 1
			until pseudorandom(pseudoseed('misty')) > 0.5

			G.E_MANAGER:add_event(Event {
				trigger = 'before',
				delay = 3,
				func = function()
					-- G.GAME.blind:wiggle()
					-- play_sound('cancel')

					return true
				end,
			})
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
	boss = { min = 1 },
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

	calculate = function(self, blind, context)
		if blind.disabled then return end

		if context.pre_discard then
			local rank1 = self.config.need_ranks[1].id
			local rank2 = self.config.need_ranks[2].id

			for k, v in pairs(G.hand.highlighted) do
				if v:get_id() == rank1 or v:get_id() == rank2 then return end
			end

			blind.triggered = true
			blind:wiggle()
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
	boss = { min = 1 },
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
	boss = { min = 1 },
	config = {},
	vars = {},

	calculate = function(self, blind, context)
		if blind.disabled then return end

		if context.pre_discard or context.before then
			G.E_MANAGER:add_event(Event {
				trigger = 'immediate',
				func = function()
					blind:wiggle()
					blind.triggered = true
					return true
				end,
			})

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
	boss = { min = 5 },
	config = {},
	vars = {},

	calculate = function(self, blind, context)
		if G.GAME.blind.disabled then return end

		if context.using_consumeable then
			blind.used_consumable = true
			blind.no_debuff_cards = {}

			-- Recalculate debuffs
			for _, v in ipairs(G.hand.cards) do
				if v.debuff then
					G.E_MANAGER:add_event(Event {
						trigger = 'after',
						delay = 0.1,
						func = function()
							SMODS.recalc_debuff(v)
							blind.no_debuff_cards[v.ID] = true
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
					blind.used_consumable = false
					return true
				end,
			})
		end
	end,

	recalc_debuff = function(self, card, from_blind)
		local no_debuff_card_list = G.GAME.blind.no_debuff_cards or {}
		if
			card.ability.set ~= 'Joker'
			and not G.GAME.blind.used_consumable
			and not no_debuff_card_list[card.ID]
		then
			-- Ability is to prevent purified cards from being debuffed again
			return true
		else
			return false
		end
	end,

	defeat = function(self)
		G.GAME.blind.no_debuff_cards = nil
	end
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
		G.GAME.BL_PERSISTENCE = copy_table(G.localization.misc.blaine_quizzes.all_quizzes)
	end

	local quiz_table, key = pseudorandom_element(G.GAME.BL_PERSISTENCE, pseudoseed('blaine'))
	table.remove(G.GAME.BL_PERSISTENCE, key)

	return quiz_table
end

local answer_cards_config = {
	H_T = { answer = 1, sprite_pos_x = 0 },
	H_9 = { answer = 2, sprite_pos_x = 1 },
	H_8 = { answer = 3, sprite_pos_x = 2 },
	H_7 = { answer = 4, sprite_pos_x = 3 },
	H_K = { answer = 'Yes', sprite_pos_x = 4 },
	H_Q = { answer = 'No', sprite_pos_x = 5 },
}

SMODS.Atlas {
	key = 'answer_cards',
	path = 'answer_cards.png',
	px = 71,
	py = 95,
}

SMODS.Enhancement {
	key = 'answer_card',
	atlas = 'answer_cards',
	pos = { x = 0, y = 0 },

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
		local answer_key = (card.ability.extra and card.ability.extra.answer_key) or 'Broken'
		if type(answer_key) == 'number' then answer_key = answer_key .. '.' end
		return { vars = { answer_key } }
	end,

	set_ability = function(self, card, initial, delay_sprites)
		if initial then
			card.ability.extra = card.ability.extra or {}

			for k, v in pairs(G.P_CARDS) do
				if card.config.card == v then
					card.ability.extra.answer_key = answer_cards_config[k].answer
					card.children.center:set_sprite_pos({
						x = answer_cards_config[k].sprite_pos_x,
						y = 0,
					})
					return
				end
			end

			card.ability.extra.answer_key = 1
		end
	end,

	set_sprites = function(self, card, front)
		if card.config.card_key then
			card.children.center:set_sprite_pos({
				x = answer_cards_config[card.config.card_key].sprite_pos_x,
				y = 0,
			})
		end
	end,

	calculate = function(self, card, context)
		-- Return to hand after Play/Discard
		if (context.after and context.cardarea == G.play) or (context.pre_discard and card.highlighted) then
			G.E_MANAGER:add_event(Event {
				trigger = 'immediate',
				func = function()
					draw_card(G.discard, G.hand, 100, 'up', false, card)
					return true
				end,
			})
		end

		if context.playing_card_end_of_round and context.cardarea == G.hand then card:start_dissolve() end
	end,
}

local function correct_attention_text(major, delay, offset_y, sound)
	G.E_MANAGER:add_event(Event {
		trigger = 'after',
		delay = (delay or 0),
		func = function()
			attention_text {
				text = localize('ex_right', 'blaine_quizzes'),
				backdrop_colour = G.C.GREEN,
				backdrop_scale = 1.2,
				scale = 1,
				hold = 2,
				major = major,
				align = (major == G.play and 'tm') or 'cm',
				offset = { x = 0, y = (offset_y or -0.1 * G.CARD_H) },
				silent = false,
			}

			if major ~= G.play and major.juice_up then major:juice_up() end

			G.GAME.blind:wiggle()
			play_sound((sound or 'gong'))

			return true
		end,
	})
end

local function wrong_attention_text(major, delay, offset_y)
	G.E_MANAGER:add_event(Event {
		trigger = 'after',
		delay = (delay or 0),
		func = function()
			attention_text {
				text = localize('ex_wrong', 'blaine_quizzes'),
				backdrop_colour = G.C.RED,
				backdrop_scale = 1.2,
				scale = 1,
				hold = 2,
				major = major,
				align = (major == G.play and 'tm') or 'cm',
				offset = { x = 0, y = (offset_y or 0) },
				silent = false,
			}

			if major.juice_up then major:juice_up() end

			G.GAME.blind:wiggle()
			return true
		end,
	})
end

local function bad_answer_attention_text(text, major, delay)
	local config = {
		scale = 1,
		hold = 2,
		align = 'tm',
	}

	-- Align to card
	if major ~= G.play then
		config.scale = 0.7
		config.align = 'cm'
	end

	G.E_MANAGER:add_event(Event {
		trigger = 'after',
		delay = (delay or 0),
		func = function()
			attention_text {
				text = text,
				backdrop_colour = G.C.BLACK,
				backdrop_scale = 2,
				scale = config.scale,
				hold = config.hold,
				major = major,
				align = config.align,
				offset = { x = 0, y = 0 },
				silent = false,
			}

			G.ROOM.jiggle = G.ROOM.jiggle + 0.7
			play_sound('cancel')
			return true
		end,
	})
end

local function total_add_new_chips(score)
	if (SMODS.Mods['Talisman'] or {}).can_load then
		return (to_big(G.GAME.chips)) + (to_big(score))
	else
		return G.GAME.chips + score
	end
end

local function score_part_of_blind(division)
	local chip_UI = G.HUD:get_UIE_by_ID('chip_UI_count')
	local new_chips = total_add_new_chips(math.ceil(G.GAME.blind.chips / division))

	-- Blockable Event so that it happens after "Correct!"
	--Ease from current chips to the new number of chips
	G.E_MANAGER:add_event(Event {
		trigger = 'ease',
		ref_table = G.GAME,
		ref_value = 'chips',
		ease_to = new_chips,
		delay = 0.3,
		func = function(t)
			return math.floor(t)
		end,
	})

	G.E_MANAGER:add_event(Event {
		trigger = 'immediate',
		func = function()
			--Popup text next to the chips in UI showing number of chips gained/lost
			chip_UI:juice_up()

			return true
		end,
	})
end

SMODS.Blind {
	key = 'volcano',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 6 },
	boss_colour = TYPE_CLR['fire'],

	discovered = false,
	dollars = 5,
	mult = 3,
	boss = { min = 1 },
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
		quiz_table.type_loc = G.localization.misc.blaine_quizzes.quiz_types[quiz_table.type]

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
							bad_answer_attention_text(localize('warn_yesno', 'blaine_quizzes'), card)
						elseif not is_yes_no and type(card.ability.extra.answer_key) ~= 'number' then
							G.hand:remove_from_highlighted(card)
							bad_answer_attention_text(localize('warn_number', 'blaine_quizzes'), card)
						else
							selected = true
						end
					else
						G.hand:remove_from_highlighted(card)
						bad_answer_attention_text(localize('warn_single', 'blaine_quizzes'), card)
					end
				end
			end
		else
			for _, card in ipairs(cards) do
				if
					card.config.center.key == 'm_pkrm_gym_answer_card'
					and type(card.ability.extra.answer_key) ~= 'number'
				then
					G.hand:remove_from_highlighted(card)
					bad_answer_attention_text(localize('warn_number', 'blaine_quizzes'), card)
				end
			end
		end

		return false
	end,

	press_play = function(self)
		self.ready_new_quiz = true
		local quiz_table = self.quiz_table
		local is_yes_no = isYesNo(quiz_table)

		G.E_MANAGER:add_event(Event {
			trigger = 'after',
			delay = 0.1,
			func = function()
				if quiz_table.type == 'single' then
					local correct = false

					for k, v in pairs(G.play.cards) do
						if v.config.center.key == 'm_pkrm_gym_answer_card' then
							if is_yes_no then
								correct = v.ability.extra.answer_key == quiz_table.right_answers[1]
							else
								local my_answer = quiz_table.answers[v.ability.extra.answer_key]
								-- Single question may have multiple correct answers, any is equally correct
								for i, right in ipairs(quiz_table.right_answers) do
									if my_answer == right then
										correct = true
										break
									end
								end
							end

							if correct then
								correct_attention_text(v, 1)
								score_part_of_blind(3)
							else
								wrong_attention_text(v, 1)
							end

							return true
						end
					end
				elseif quiz_table.type == 'multiple' then
					local right_answers_set = {}
					local all_correct = true

					for _, answer in pairs(quiz_table.right_answers) do
						right_answers_set[answer] = true
					end

					for k, v in pairs(G.play.cards) do
						if v.config.center.key == 'm_pkrm_gym_answer_card' then
							local answer = quiz_table.answers[v.ability.extra.answer_key]
							if right_answers_set[answer] then
								correct_attention_text(v, 0.8, -0.2 * G.CARD_H, 'multhit1')
								right_answers_set[answer] = nil -- Remove from table
							else
								wrong_attention_text(v, 0.8, 0.2 * G.CARD_H)
								all_correct = false
							end
						end
					end

					-- Not all correct
					if not all_correct then
						bad_answer_attention_text(localize('ex_not_all_answer', 'blaine_quizzes'), G.play, 1)
						return true
					end

					-- Missing answer
					for _, answer in pairs(right_answers_set) do
						bad_answer_attention_text(localize('ex_missing_answer', 'blaine_quizzes'), G.play, 1)
						return true
					end

					correct_attention_text(G.play, 1)
					score_part_of_blind(3)
					return true
				end

				bad_answer_attention_text(localize('ex_no_answer', 'blaine_quizzes'), G.play, 1)
				return true
			end,
		})
	end,

	disable = function(self)
		if self.custom_UI then self.custom_UI:remove() end

		for _, card in pairs(G.playing_cards) do
			if SMODS.has_enhancement(card, 'm_pkrm_gym_answer_card') then card:start_dissolve() end
		end

		G.E_MANAGER:add_event(Event {
			trigger = 'after',
			delay = 0.1,
			func = function()
				G.E_MANAGER:add_event(Event {
					trigger = 'immediate',
					func = function()
						G.FUNCS.draw_from_deck_to_hand()
						return true
					end,
				})
				return true
			end,
		})
	end,

	defeat = function(self)
		if self.custom_UI then self.custom_UI:remove() end
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
	boss = { min = 7 },
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
	boss = { min = 8, showdown = true },
	config = { cards_left_to_draw = 2 },
	vars = { 2 },
	loc_vars = function(self)
		return { vars = { self.config.cards_left_to_draw } }
	end,

	calculate = function(self, blind, context)
		if blind.disabled then return end

		if context.before or context.pre_discard then
			local cards_left = 0
			for _, card in pairs(G.hand.cards) do
				if not card.highlighted then cards_left = cards_left + 1 end
			end

			if cards_left > self.config.cards_left_to_draw then blind.no_draw = true end
		end

		if context.drawing_cards then
			if blind.no_draw then
				blind.no_draw = false
				return {
					cards_to_draw = 0,
				}
			end
		end
	end,
}

local singleton_destroying = false

SMODS.Sticker {
	key = 'temporary',
	atlas = 'stickers',
	badge_colour = G.C.PERISHABLE,
	pos = { x = 0, y = 0 },
	rate = 0,

	calculate = function(self, card, context)
		if context.discard then
			if context.other_card.ability and context.other_card.ability['pkrm_gym_temporary'] then
				return { remove = true }
			end
		end

		if context.playing_card_end_of_round then -- Works even without a card in hand because G.deck is enabled
			if not singleton_destroying then -- Destroy all, including in discard
				singleton_destroying = true

				G.E_MANAGER:add_event(Event {
					trigger = 'immediate',
					func = function()
						for _, card in pairs(G.playing_cards) do
							if card.ability and card.ability['pkrm_gym_temporary'] then card:start_dissolve() end
						end

						singleton_destroying = false
						return true
					end,
				})
			end
		end
	end,
}

local function move_card_to(to, percent, dir, card, mute, vol)
	percent = percent or 50
	if dir == 'down' then percent = 1 - percent end

	local stay_flipped = G.GAME and G.GAME.blind and G.GAME.blind:stay_flipped(to, card)
	if (to == G.hand) and G.GAME.modifiers.flipped_cards then
		if pseudorandom(pseudoseed('flipped_card')) < 1 / G.GAME.modifiers.flipped_cards then stay_flipped = true end
	end
	to:emplace(card, nil, stay_flipped)

	if not mute then
		G.VIBRATION = G.VIBRATION + 0.6

		play_sound('card1', 0.85 + percent * 0.2 / 100, 0.6 * (vol or 1))
	end
end

SMODS.Blind {
	key = 'e4_bruno',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 9 },
	boss_colour = GYM_SHOWDOWN_CLR['bruno'],

	discovered = false,
	dollars = 8,
	mult = 2,
	boss = { min = 8, showdown = true },
	config = {},
	vars = {},

	calculate = function(self, blind, context)
		if blind.disabled then return end
		if not context.first_hand_drawn then return end

		local stone_count = 52 - #G.playing_cards
		local original_deck_limit = G.deck.config.card_limit

		if stone_count > 0 then
			for i = 1, stone_count do
				G.E_MANAGER:add_event(Event {
					trigger = 'after',
					delay = 0.2,
					func = function()
						local created_stone = SMODS.create_card {
							set = 'Base',
							enhancement = 'm_stone',
							skip_materialize = true,
							-- stickers = { 'pkrm_gym_temporary' }
						}

						created_stone:add_sticker('pkrm_gym_temporary', true)

						local angle = math.random() * 2 * 3.14
						local card_pos = {
							x = (math.random() * 5 + 8) * math.sin(angle) + G.ROOM.T.w / 2,
							y = (math.random() * 3 + 6) * math.cos(angle) + G.ROOM.T.h / 2 - 1.5,
						}

						created_stone:hard_set_T(card_pos.x, card_pos.y)
						created_stone.T.r = -angle
						created_stone:start_materialize { GYM_SHOWDOWN_CLR['bruno'] }

						local delay = (stone_count - i) * 0.2

						G.E_MANAGER:add_event(Event {
							trigger = 'after',
							blocking = false,
							delay = delay,
							func = function()
								table.insert(G.playing_cards, created_stone)

								if pseudorandom(pseudoseed('e4_bruno')) < 0.02 then
									move_card_to(G.hand, 100, 'up', created_stone, nil, 0.5)
								else
									move_card_to(G.deck, 100, 'up', created_stone, nil, 0.5)
								end

								G.deck.config.card_limit = original_deck_limit
								G.ROOM.jiggle = G.ROOM.jiggle + 0.2

								return true
							end,
						})

						if stone_count == i then
							-- Reshuffle after all is shoved into deck
							G.E_MANAGER:add_event(Event {
								trigger = 'after',
								delay = stone_count * 0.2 + 0.5,
								func = function()
									G.deck:shuffle('nr' .. G.GAME.round_resets.ante)
									blind:wiggle()
									blind.triggered = true
									return true
								end,
							})
						end

						return true
					end,
				})
			end
		end
	end,

	disable = function(self)
		for _, card in pairs(G.playing_cards) do
			if card.ability['pkrm_gym_temporary'] and SMODS.has_enhancement(card, 'm_stone') then
				card:start_dissolve { GYM_SHOWDOWN_CLR['bruno'] }
			end
		end
	end,
}

function can_reduce_energy(card)
	if type(card.ability.extra) == 'table' then
		for name, _ in pairs(energy_values) do
			if type(card.ability.extra[name]) == 'number' then return true end
		end
	elseif type(card.ability.extra) == 'number' then
		return true
	elseif
		(card.ability.mult and card.ability.mult > 0)
		or (card.ability.t_mult and card.ability.t_mult > 0)
		or (card.ability.t_chips and card.ability.t_chips > 0)
		or (card.ability.x_mult and card.ability.x_mult > 1)
	then
		return true
	end
	return false
end

local negative_energy_values = {}
for k, v in pairs(energy_values) do
	negative_energy_values[k] = -v
end

SMODS.Blind {
	key = 'e4_agatha',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 10 },
	boss_colour = TYPE_CLR['ghost'],

	discovered = false,
	dollars = 8,
	mult = 2,
	boss = { min = 8, showdown = true },
	config = {},
	vars = {},

	press_play = function(self)
		local with_energy_list = {}

		-- Filter jokers with energy only
		for _, card in pairs(G.jokers.cards) do
			if can_reduce_energy(card) then table.insert(with_energy_list, card) end
		end

		-- Note: currently can reduce energy to negative
		if #with_energy_list > 0 then
			local chosen_joker = pseudorandom_element(with_energy_list, pseudoseed('e4_agatha'))

			if type(chosen_joker.ability.extra) == 'table' then
				local original_escale = chosen_joker.ability.extra.escale
				chosen_joker.ability.extra.energy_count = (chosen_joker.ability.extra.energy_count or 0) - 1
				chosen_joker.ability.extra.escale = -1
				energize(chosen_joker, false, nil, true) -- energize(card, etype, evolving, silent)
				chosen_joker.ability.extra.escale = original_escale
			else
				local normal_energy_values = copy_table(energy_values)
				energy_values = negative_energy_values

				energize(chosen_joker, false, nil, true)

				energy_values = normal_energy_values
			end

			pkrm_gym_attention_text {
				text = localize('e4_agatha', 'pkrm_gym_ex'),
				backdrop_colour = TYPE_CLR['ghost'],
				major = chosen_joker,
				align = 'bm',
				offset_y = 0,
			}

			-- card_eval_status_text(chosen_joker, 'extra', nil, nil, nil, {
			-- 	message = localize('poke_reverse_energized_ex', 'pkrm_gym_ex'),
			-- 	colour = TYPE_CLR['ghost'],
			-- })

			G.GAME.blind:wiggle()
			play_sound('whoosh1', 0.55, 0.62)
			chosen_joker:juice_up()
		else
			G.GAME.blind:wiggle()
			play_sound('cancel')
		end
	end,
}

SMODS.Blind {
	key = 'e4_lance',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 11 },
	boss_colour = GYM_SHOWDOWN_CLR['lance'],

	discovered = false,
	dollars = 8,
	mult = 2,
	boss = { min = 8, showdown = true },
	config = {},
	vars = {},

	press_play = function(self)
		-- Due to press_play being called before the cards handled, we need to subtract 1 from the hands left
		local hands_left = G.GAME.current_round.hands_left - 1
		local played_length = #G.hand.highlighted

		for i, card in ipairs(G.hand.highlighted) do
			if (played_length - i) < hands_left then
				G.E_MANAGER:add_event(Event {
					trigger = 'after',
					delay = 0.5,
					func = function()
						SMODS.debuff_card(card, true, 'e4_lance_debuff')
						card:juice_up()

						G.GAME.blind:wiggle()

						return true
					end,
				})
			end
		end
	end,

	defeat = function(self)
		remove_debuff_all_playing_cards('e4_lance_debuff')
	end,
}

local basegame_card_get_chip_bonus = Card.get_chip_bonus
function Card:get_chip_bonus()
	if G.GAME.blind and G.GAME.blind.name == 'bl_pkrm_gym_champion_kanto' and not G.GAME.blind.disabled then
		return 0
	end

	return basegame_card_get_chip_bonus(self)
end

local basegame_foil_calculate_func = G.P_CENTERS.e_foil.calculate
G.P_CENTERS.e_foil.calculate = function(self, card, context)
	local returned_table = basegame_foil_calculate_func(self, card, context)

	if context.main_scoring and context.cardarea == G.play then
		if G.GAME.blind and G.GAME.blind.name == 'bl_pkrm_gym_champion_kanto' and not G.GAME.blind.disabled then
			if type(returned_table) == 'table' then returned_table.chips = 0 end
		end
	end

	return returned_table
end

SMODS.Blind {
	key = 'champion_kanto',
	atlas = 'blinds_kanto',
	pos = { x = 0, y = 12 },
	boss_colour = GYM_SHOWDOWN_CLR['blue'],

	discovered = false,
	dollars = 12,
	mult = 4,
	boss = { min = 10, showdown = true },
	config = { blue_penalty_chips = 12 },
	vars = { 12 },

	modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
		return mult, 0, true
	end,

	disable = function(self)
		G.GAME.blind.disabled = false

		champion_no_disable_attention_text()
	end,
}
