-- HOENN
local TYPE_CLR = GYM_BLINDS_TYPE_CLR

SMODS.Atlas {
	key = 'blinds_hoenn',
	atlas_table = 'ANIMATION_ATLAS',
	path = 'blinds_hoenn.png',
	px = 34,
	py = 34,
	frames = 21,
}
-- TODO:
-- knuckle: Make it smaller
-- feather: Make it smaller

local basegame_card_set_ability = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
	if self.ability and self.ability.roxanne_stone_transform and SMODS.has_enhancement(self, 'm_stone') then
		-- Reset Roxanne Stone card bonus (if not reset, the card will have -50 extra bonus)
		self.ability.bonus = self.config.center.config.bonus
	end

	basegame_card_set_ability(self, center, initial, delay_sprites)
end

SMODS.Blind {
	key = 'stone',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 0 },
	boss_colour = TYPE_CLR['rock'],

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = { min = 1, max = 10 },
	config = {},
	vars = {},

	press_play = function(self)
		for i, card in ipairs(G.hand.highlighted) do
			if card:is_face() and not SMODS.has_enhancement(card, 'm_stone') then
				card.ability.roxanne_stone_transform = card.config.center

				G.E_MANAGER:add_event(Event {
					trigger = 'after',
					delay = 0.5,
					func = function()
						card:juice_up()
						card:set_ability(G.P_CENTERS.m_stone, nil, false)
						card.ability.bonus = 0

						pkrm_gym_attention_text {
							text = localize('stone', 'pkrm_gym_ex'),
							backdrop_colour = TYPE_CLR['rock'],
							major = card,
						}

						G.ROOM.jiggle = G.ROOM.jiggle + 0.7

						G.GAME.blind:wiggle()
						G.GAME.blind.triggered = true

						return true
					end,
				})
			end
		end
	end,

	disable = function(self)
		for _, card in ipairs(G.playing_cards) do
			if card.ability.roxanne_stone_transform and not card.ability.roxanne_stone_no_turn_back then
				local prev_enhancement = card.ability.roxanne_stone_transform
				card:set_ability(prev_enhancement, nil, false)
				card:juice_up()
			end
		end
		G.GAME.blind.triggered = false
	end,

	defeat = function(self)
		-- So future encounter when disabled, won't revert changes in previous antes
		for _, card in pairs(G.playing_cards) do
			card.ability.roxanne_stone_no_turn_back = true
		end
	end,
}

SMODS.Blind {
	key = 'knuckle',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 1 },
	boss_colour = TYPE_CLR['fighting'],

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = { min = 1, max = 10 },
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

				-- -- Update June 26: No need, blind now just discards
				-- G.E_MANAGER:add_event(Event {
				-- 	trigger = 'after',
				-- 	delay = 0.4,
				-- 	func = function()
				-- 		draw_card(G.discard, G.deck, 100, 'down', false, leftmost_card)

				-- 		return true
				-- 	end,
				-- })
			end
		end
	end

	basegame_card_highlight(self, is_highlighted)
end

local function table_shift_positions(tbl, from_index, to_index)
	local value = tbl[from_index]

	table.remove(tbl, from_index)
	table.insert(tbl, to_index, value)
end

local function find_highest_rank_index_list(card_list)
	local highest_rank = card_list[1]:get_id()
	local highest_index_list = { 1 }

	for i = 2, #card_list do
		local card = card_list[i]

		if card:get_id() > highest_rank then
			highest_rank = card:get_id()
			highest_index_list = { i }
		elseif card:get_id() == highest_rank then
			table.insert(highest_index_list, i)
		end
	end

	return highest_index_list
end

local function filter_with_rank_only(card_list)
	local with_rank = {}

	for i = 1, #card_list do
		local card = card_list[i]

		if not SMODS.has_no_rank(card) then table.insert(with_rank, card) end
	end

	return with_rank
end

-- Input must include no cards with no rank (Stone)
local function find_lowest_rank(card_list)
	local lowest_card = card_list[1]
	local lowest_index = 1

	for i = 2, #card_list do
		local card = card_list[i]

		if card:get_id() < lowest_card:get_id() then
			lowest_card = card
			lowest_index = i
		end
	end

	return lowest_card, lowest_index
end

local function find_highest_rank(card_list)
	local highest_card = card_list[1]
	local highest_index = 1

	for i = 2, #card_list do
		local card = card_list[i]

		if card:get_id() > highest_card:get_id() then
			highest_card = card
			highest_index = i
		end
	end

	return highest_card, highest_index
end

SMODS.Blind {
	key = 'dynamo',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 2 },
	boss_colour = TYPE_CLR['electric'],

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = { min = 1, max = 10 },
	config = {},
	vars = {},

	press_play = function(self)
		-- Check if either cards in play or in hand is full of no rank (Stone)
		local play_with_ranks = {}
		local hand_with_ranks = {}
		for i, card in ipairs(G.hand.cards) do
			if not SMODS.has_no_rank(card) then
				if card.highlighted then
					table.insert(play_with_ranks, card)
				else
					table.insert(hand_with_ranks, card)
				end
			end
		end

		if #play_with_ranks < 1 or #hand_with_ranks < 1 then return end

		local index_to_swap = find_highest_rank_index_list(play_with_ranks)

		for k, play_index in ipairs(index_to_swap) do
			G.E_MANAGER:add_event(Event {
				trigger = 'after',
				delay = 1,
				func = function()
					if #G.hand.cards < 1 then return true end

					local play_swap = G.play.cards[play_index]
					-- Hand may change after each swap so must do it dynamically
					local hand_swap, hand_index = find_lowest_rank(filter_with_rank_only(G.hand.cards))

					G.play:remove_card(play_swap)
					G.hand:emplace(play_swap, 'front')
					table_shift_positions(G.hand.cards, 1, hand_index)

					G.hand:remove_card(hand_swap)
					G.play:emplace(hand_swap, 'front')
					table_shift_positions(G.play.cards, 1, play_index)

					G.VIBRATION = G.VIBRATION + 0.6
					play_sound('card1', 1, 0.6)

					pkrm_gym_attention_text {
						text = localize('dynamo', 'pkrm_gym_ex'),
						backdrop_colour = TYPE_CLR['electric'],
						major = hand_swap,
					}

					G.GAME.blind:wiggle()

					return true
				end,
			})
		end

		-- Give a bit of pause for player to evaluate what's going on
		delay(1)
	end,
}

SMODS.Blind {
	key = 'heat',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 3 },
	boss_colour = TYPE_CLR['fire'],

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = { min = 1, max = 10 },
	config = {},
	vars = {},

	set_blind = function(self)
		G.GAME.BL_EXTRA.temp_table = {
			highest_rank_saved = 0,
		}
	end,

	calculate = function(self, blind, context)
		if G.GAME.blind.disabled then return end

		if context.after then
			local play_with_ranks = filter_with_rank_only(context.scoring_hand)

			if #play_with_ranks < 1 then return end

			local highest_card, highest_index = find_highest_rank(play_with_ranks)
			local highest_rank = highest_card:get_id()

			if highest_rank > G.GAME.BL_EXTRA.temp_table.highest_rank_saved then
				G.GAME.BL_EXTRA.temp_table.highest_rank_saved = highest_rank
			else
				return
			end

			G.E_MANAGER:add_event(Event {
				trigger = 'after',
				delay = 0.5,
				func = function()
					for i, card in ipairs(filter_with_rank_only(G.playing_cards)) do
						if card:get_id() < highest_rank then
							SMODS.debuff_card(card, true, 'flannery_heat_debuff')
							card:juice_up()
						end
					end

					pkrm_gym_attention_text {
						text = highest_card.base.value .. ' ' .. localize('heat', 'pkrm_gym_ex'),
						backdrop_colour = TYPE_CLR['fire'],
						major = G.play,
						hold = 2,
					}

					G.GAME.blind:wiggle()
					return true
				end,
			})
		end
	end,

	disable = function(self)
		remove_debuff_all_playing_cards('flannery_heat_debuff')
	end,
	defeat = function(self)
		remove_debuff_all_playing_cards('flannery_heat_debuff')
	end,
}

SMODS.Blind {
	key = 'balance',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 4 },
	boss_colour = TYPE_CLR['normal'],

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = { min = 5, max = 10 },
	config = {},
	vars = {},

	set_blind = function(self)
		G.GAME.BL_EXTRA.temp_table = {
			discarded_hand = nil,
		}
	end,

	get_loc_debuff_text = function(self)
		if G.GAME.BL_EXTRA.temp_table.discarded_hand then
			return localize {
				type = 'variable',
				key = 'bl_pkrm_gym_balance_debuff_text',
				vars = { G.GAME.BL_EXTRA.temp_table.discarded_hand },
			}
		else
			return localize('bl_pkrm_gym_balance_debuff_text_initial')
		end
	end,

	calculate = function(self, blind, context)
		if G.GAME.blind.disabled then return end

		if context.pre_discard then
			G.GAME.BL_EXTRA.temp_table.discarded_hand = G.FUNCS.get_poker_hand_info(G.hand.highlighted)

			G.GAME.blind:wiggle()
		end
	end,

	debuff_hand = function(self, cards, hand, handname, check)
		return not (G.GAME.BL_EXTRA.temp_table.discarded_hand == handname)
	end,
}

SMODS.Blind {
	key = 'feather',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 5 },
	boss_colour = TYPE_CLR['flying'],

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = { min = 1, max = 10 },
	config = { lose = 2 },
	vars = {},

	loc_vars = function(self)
		return { vars = { self.config.lose } }
	end,
	collection_loc_vars = function(self)
		return { vars = { self.config.lose } }
	end,

	press_play = function(self)
		local not_released_nines = {}

		for i, card in ipairs(G.deck.cards) do
			if card.base.value == '9' then table.insert(not_released_nines, card) end
		end

		for i, card in ipairs(G.hand.cards) do
			if card.base.value == '9' and not card.highlighted then table.insert(not_released_nines, card) end
		end

		if #not_released_nines < 1 then return end

		G.E_MANAGER:add_event(Event {
			trigger = 'after',
			delay = 0.5,
			func = function()
				for k, card in pairs(not_released_nines) do
					card:juice_up()

					if card.area == G.hand then
						pkrm_gym_attention_text {
							text = '-' .. localize('$') .. self.config.lose,
							backdrop_colour = TYPE_CLR['flying'],
							major = card,
						}
					end
				end

				pkrm_gym_attention_text {
					text = localize('feather', 'pkrm_gym_ex'),
					backdrop_colour = TYPE_CLR['flying'],
					major = G.play,
				}

				ease_dollars(-#not_released_nines * self.config.lose)
				G.VIBRATION = G.VIBRATION + 0.6
				G.GAME.blind:wiggle()

				return true
			end,
		})

		delay(0.5)
	end,
}

local function find_first_pair()
	local seen = {}

	for i, card in ipairs(G.hand.cards) do
		local check_rank = card:get_id()

		if seen[check_rank] then
			return { seen[check_rank], card }
		else
			seen[check_rank] = card
		end
	end

	return nil -- No pair found
end

SMODS.Blind {
	key = 'mind',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 6 },
	boss_colour = TYPE_CLR['psychic'],

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = { min = 1, max = 10 },
	config = {},
	vars = {},

	drawn_to_hand = function(self)
		local found_pair = find_first_pair()

		if found_pair then
			for i, card in ipairs(found_pair) do
				card.ability.forced_selection = true
				G.hand:add_to_highlighted(card)
			end
		end
	end,

	disable = function(self)
		for i, card in ipairs(G.playing_cards) do
			card.ability.forced_selection = nil
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
	boss = { min = 1, max = 10 },
	config = {},
	vars = {},

	debuff_hand = function(self, cards, hand, handname, check)
		local all_suits = {}
		local all_ranks = {}

		for i, card in ipairs(cards) do
			if not SMODS.has_no_rank(card) then all_ranks[card:get_id()] = true end

			if not SMODS.has_no_suit(card) then all_suits[card.base.suit] = true end
		end

		local rank_count = 0
		for _ in pairs(all_ranks) do
			rank_count = rank_count + 1
		end

		local suit_count = 0
		for _ in pairs(all_suits) do
			suit_count = suit_count + 1
		end

		return rank_count <= suit_count
	end,
}

local function shuffle_numberlist(list, seed)
	math.randomseed(seed)

	for i = #list, 2, -1 do
		local j = math.random(i)
		list[i], list[j] = list[j], list[i]
	end
end

SMODS.Blind {
	key = 'e4_sidney',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 8 },
	boss_colour = TYPE_CLR['dark'],

	discovered = false,
	dollars = 8,
	mult = 2,
	boss = { min = 8, max = 10, showdown = true },
	config = {},
	vars = {},

	drawn_to_hand = function(self)
		local to_check_deck = filter_with_rank_only(G.deck.cards)

		local checked_ranks = {}
		local ranks_only_in_deck = {}
		for _, card in pairs(to_check_deck) do
			if not checked_ranks[card.base.id] and not card.debuff then
				checked_ranks[card.base.id] = true
				table.insert(ranks_only_in_deck, card.base.id)
			end
		end

		if #ranks_only_in_deck < 1 then return end

		-- Select 2 random ranks
		shuffle_numberlist(ranks_only_in_deck, pseudoseed('sidney'))
		local selected_ranks = {}

		selected_ranks[ranks_only_in_deck[1]] = true
		if #ranks_only_in_deck > 1 then selected_ranks[ranks_only_in_deck[2]] = true end

		-- Debuff
		for _, card in pairs(to_check_deck) do
			if selected_ranks[card.base.id] then
				SMODS.debuff_card(card, true, 'e4_sidney_debuff')
				card:juice_up()
			end
		end

		if #G.deck.cards > 0 then G.deck.cards[1]:juice_up() end

		local display_text = localize('e4_sidney_1', 'pkrm_gym_ex')
		if pseudorandom(pseudoseed('sidney')) < 0.25 then display_text = localize('e4_sidney_2', 'pkrm_gym_ex') end

		pkrm_gym_attention_text {
			text = display_text,
			backdrop_colour = TYPE_CLR['dark'],
			major = G.deck,
			offset_y = -0.5,
		}

		G.GAME.blind:wiggle()
		G.VIBRATION = G.VIBRATION + 1
	end,

	disable = function(self)
		remove_debuff_all_playing_cards('e4_sidney_debuff')
	end,
	defeat = function(self)
		remove_debuff_all_playing_cards('e4_sidney_debuff')
	end,
}

SMODS.Blind {
	key = 'e4_phoebe',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 9 },
	boss_colour = TYPE_CLR['ghost'],

	discovered = false,
	dollars = 8,
	mult = 2,
	boss = { min = 8, max = 10, showdown = true },
	config = {},
	vars = {},
}

BL_FUNCTION_TABLE['e4_glacia_ease_dollars'] = function()
	local blind = G.GAME.blind
	local every_debt = G.GAME.blind.config.blind.config.every_debt

	local original_hand_size = (G.GAME.BL_EXTRA.temp_table.original_hand_size or 8)
	local current_hand_size = G.hand.config.card_limit

	local current_money = get_current_dollars()

	local target_hand_size = original_hand_size
	if current_money < 0 then
		target_hand_size = original_hand_size - math.floor(math.abs(current_money) / every_debt)
	end

	-- Now compute relative change and apply it
	local change = target_hand_size - current_hand_size
	G.hand:change_size(change)

	-- print(current_money)
	-- print(math.floor(-current_money / every_debt))
	-- print(target_hand_size)
	-- print(current_hand_size)

	blind:wiggle()
end

SMODS.Blind {
	key = 'e4_glacia',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 10 },
	boss_colour = TYPE_CLR['ice'],

	discovered = false,
	dollars = 8,
	mult = 2,
	boss = { min = 8, max = 10, showdown = true },
	config = { lose = 40, every_debt = 5 },
	vars = {},

	set_blind = function(self)
		self.config.lose = G.GAME.round_resets.ante * 4
		G.GAME.BL_EXTRA.ease_dollars = 'e4_glacia_ease_dollars'
		G.GAME.BL_EXTRA.temp_table.original_hand_size = G.hand.config.card_limit

		G.ROOM.jiggle = G.ROOM.jiggle + 4
		ease_dollars(-self.config.lose, true)

		G.GAME.blind.triggered = true
	end,

	loc_vars = function(self)
		return { vars = { G.GAME.round_resets.ante * 4, self.config.every_debt } }
	end,
	collection_loc_vars = function(self)
		return {
			vars = { self.config.lose .. ' ' .. localize('pkrm_gym_e4_glacia_collection_note'), self.config.every_debt },
		}
	end,

	disable = function(self)
		ease_dollars(G.GAME.round_resets.ante * 4)

		G.GAME.BL_EXTRA.ease_dollars = nil
	end,

	defeat = function(self)
		local change = G.GAME.BL_EXTRA.temp_table.original_hand_size - G.hand.config.card_limit
		-- change = target_hand_size - current_hand_size
		G.hand:change_size(change)
	end,
}

SMODS.Blind {
	key = 'e4_drake',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 11 },
	boss_colour = TYPE_CLR['dragon'],

	discovered = false,
	dollars = 8,
	mult = 2,
	boss = { min = 8, max = 10, showdown = true },
	config = {},
	vars = {},

	press_play = function(self)
		local _, _, _, scoring_hand = G.FUNCS.get_poker_hand_info(G.hand.highlighted)

		local card_list = filter_with_rank_only(scoring_hand)

		if #card_list < 1 then return end

		local lowest_cards = { card_list[1] }

		for i = 2, #card_list do
			local card = card_list[i]
			local current_rank = card:get_id()
			local lowest_rank = lowest_cards[1]:get_id()

			if current_rank <= lowest_rank then
				if current_rank < lowest_rank then lowest_cards = {} end
				table.insert(lowest_cards, card)
			end
		end

		G.E_MANAGER:add_event(Event {
			trigger = 'after',
			delay = 0.5,
			func = function()
				for k, card in pairs(lowest_cards) do
					SMODS.debuff_card(card, true, 'e4_drake_debuff')
					card:juice_up()
				end

				G.GAME.blind:wiggle()

				pkrm_gym_attention_text {
					text = localize('e4_drake', 'pkrm_gym_ex'),
					backdrop_colour = TYPE_CLR['dragon'],
					major = G.play,
				}

				return true
			end,
		})
	end,

	disable = function(self)
		remove_debuff_all_playing_cards('e4_drake_debuff')
	end,
	defeat = function(self)
		remove_debuff_all_playing_cards('e4_drake_debuff')
	end,
}

SMODS.Blind {
	key = 'champion_hoenn',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 12 },
	boss_colour = TYPE_CLR['steel'],

	discovered = false,
	dollars = 12,
	mult = 4,
	boss = { min = 10, max = 10, showdown = true },
	config = { lower_xmult = 0.75 },
	vars = {},

	loc_vars = function(self)
		return { vars = { self.config.lower_xmult } }
	end,
	collection_loc_vars = function(self)
		return { vars = { self.config.lower_xmult } }
	end,

	calculate = function(self, blind, context)
		if blind.disabled then return end

		if context.before then
			local rank_counts = {}

			for _, card in pairs(G.hand.cards) do
				if not SMODS.has_no_rank(card) then rank_counts[card.base.id] = (rank_counts[card.base.id] or 0) + 1 end
			end

			for _, card in pairs(G.hand.cards) do
				if SMODS.has_no_rank(card) then
					if SMODS.has_enhancement(card, 'm_stone') then card.rank_is_unique = true end
				else
					if rank_counts[card.base.id] and rank_counts[card.base.id] < 2 then card.rank_is_unique = true end
				end
			end
		end

		if context.individual then
			if context.other_card.rank_is_unique then return {
				xmult = self.config.lower_xmult,
			} end
		end

		if context.after then
			for _, card in pairs(G.hand.cards) do
				if card.rank_is_unique then card.rank_is_unique = nil end
			end
		end
	end,

	disable = function(self)
		G.GAME.blind.disabled = false

		champion_no_disable_attention_text()
	end,
}

SMODS.Blind {
	key = 'champion_hoenn_wallace',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 12 },
	boss_colour = TYPE_CLR['water'],

	discovered = false,
	dollars = 12,
	mult = 4,
	boss = { min = 10, max = 10, showdown = true },
	config = {},
	vars = {},

	disable = function(self)
		G.GAME.blind.disabled = false

		champion_no_disable_attention_text()
	end,
}
