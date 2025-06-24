-- JOHTO
local TYPE_CLR = GYM_BLINDS_TYPE_CLR

SMODS.Atlas {
	key = 'blinds_johto',
	atlas_table = 'ANIMATION_ATLAS',
	path = 'blinds_johto.png',
	px = 34,
	py = 34,
	frames = 21,
}

function rescore_hand(scoring_hand, config)
	local new_scoring_hand = {}
	local non_scoring_cards = {}

	for _, card in pairs(scoring_hand) do
		if config.is_unscored_func(card) then
			table.insert(non_scoring_cards, card)
		else
			table.insert(new_scoring_hand, card)
		end
	end

	if #non_scoring_cards > 0 then
		-- Remove original scoring_hand and replace it
		for i = 1, #scoring_hand do
			table.remove(scoring_hand, 1)
		end

		for i = 1, #new_scoring_hand do
			table.insert(scoring_hand, new_scoring_hand[i])
		end

		G.E_MANAGER:add_event(Event {
			trigger = 'after',
			delay = 0.1,
			func = function()
				config.blind_juice_func()

				return true
			end,
		})

		-- Repeated rank, unhighlight
		for _, card in pairs(non_scoring_cards) do
			G.E_MANAGER:add_event(Event {
				trigger = 'after',
				delay = 0.1,
				func = function()
					card:highlight(false)
					card:juice_up(0.3, 0.2)

					config.card_juice_func(card)

					return true
				end,
			})
		end
	end
end

SMODS.Blind {
	key = 'zephyr',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 0 },
	boss_colour = TYPE_CLR['flying'],

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = { min = 1, max = 10 },
	config = {},
	vars = {},

	calculate = function(self, blind, context)
		if G.GAME.blind.disabled then return end

		if context.before then
			local seen_ranks = {}

			rescore_hand(context.scoring_hand, {
				is_unscored_func = function(card)
					local card_rank = card:get_id()

					-- Intentional: Stone card is never unscored (Flying weaks to Rock)

					if not seen_ranks[card_rank] or SMODS.has_enhancement(card, 'm_stone') then
						-- First occurrence of this rank
						seen_ranks[card_rank] = true
						return false
					else
						return true
					end
				end,
				blind_juice_func = function()
					pkrm_gym_attention_text {
						text = localize('pkrm_gym_zephyr_ex'),
						backdrop_colour = TYPE_CLR['flying'],
						major = G.play,
					}

					G.GAME.blind:juice_up(0.3)
					play_sound('whoosh', 0.7, 0.6)
					G.GAME.blind.triggered = true
				end,
				card_juice_func = function(card)
					play_sound('card1', 0.4, 0.5)
					G.ROOM.jiggle = G.ROOM.jiggle + 0.5
				end,
			})
		end
	end,
}

SMODS.Blind {
	key = 'hive',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 1 },
	boss_colour = TYPE_CLR['bug'],

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = { min = 1, max = 10 },
	config = {},
	vars = {},

	calculate = function(self, blind, context)
		if G.GAME.blind.disabled then return end

		if context.final_scoring_step then
			local cutting_card = G.play.cards[#G.play.cards]

			G.E_MANAGER:add_event(Event {
				trigger = 'immediate',
				func = function()
					play_sound('slice1', 0.96 + math.random() * 0.08)
					cutting_card:start_dissolve({ HEX('57ecab') }, true, 1.6, false)

					-- Remove from discard, fix ghost card bug
					G.E_MANAGER:add_event(Event {
						trigger = 'after',
						delay = 0.5,
						func = function()
							for k, v in pairs(G.discard.cards) do
								if v.ID == cutting_card.ID then
									v:remove()
									break
								end
							end

							return true
						end,
					})

					return true
				end,
			})

			SMODS.calculate_context({scoring_hand = context.scoring_hand, remove_playing_cards = true, removed = { cutting_card }})
		end
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
	boss = { min = 1, max = 10 },
	config = { rollout = 150 },
	vars = {},

	press_play = function(self)
		G.GAME.blind.chips = G.GAME.blind.chips * (self.config.rollout / 100)
		G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)

		attention_text {
			text = 'X' .. (self.config.rollout / 100),
			scale = 0.8,
			hold = 2,
			cover = G.HUD_blind:get_UIE_by_ID('HUD_blind_count').parent,
			cover_colour = G.C.GOLD,
			align = 'cm',
		}

		G.GAME.blind.triggered = true
		G.GAME.blind:wiggle()
	end,
}

SMODS.Blind {
	key = 'fog',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 3 },
	boss_colour = TYPE_CLR['ghost'],

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = { min = 1, max = 10 },
	config = {},
	vars = {},

	stay_flipped = function(self, area, card)
		if area == G.hand then return not (card:is_suit('Spades') or card:is_suit('Clubs')) end
		return false
	end,

	disable = function(self)
		for _, card in pairs(G.hand.cards) do
			if card.facing == 'back' then card:flip() end
		end
		G.GAME.blind.triggered = false
	end,
}

SMODS.Blind {
	key = 'storm',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 4 },
	boss_colour = TYPE_CLR['fighting'],

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = { min = 1, max = 10 },
	config = { suits = { 'Spades', 'Hearts', 'Clubs', 'Diamonds' }, index = 1 },
	vars = {},

	loc_vars = function(self)
		return { vars = { self.config.suits[self.config.index] } }
	end,
	collection_loc_vars = function(self)
		return { vars = { self.config.suits[self.config.index] } }
	end,

	calculate = function(self, blind, context)
		if G.GAME.blind.disabled then return end

		if context.after then
			G.E_MANAGER:add_event(Event {
				trigger = 'immediate',
				func = function()
					if self.config.index == #self.config.suits then
						self.config.index = 1
					else
						self.config.index = self.config.index + 1
					end

					for _, card in pairs(G.playing_cards) do
						SMODS.recalc_debuff(card)
					end

					G.GAME.blind:set_text()
					G.GAME.blind:wiggle()
					return true
				end,
			})
		end
	end,

	recalc_debuff = function(self, card, from_blind)
		if card:is_suit(self.config.suits[self.config.index]) then
			SMODS.debuff_card(card, true, 'chuck_storm_debuff')
			card:juice_up()
		else
			SMODS.debuff_card(card, false, 'chuck_storm_debuff')
		end

		return false
	end,

	disable = function(self)
		remove_debuff_all_playing_cards('chuck_storm_debuff')
	end,
	defeat = function(self)
		remove_debuff_all_playing_cards('chuck_storm_debuff')
	end,
}

SMODS.Blind {
	key = 'mineral',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 5 },
	boss_colour = TYPE_CLR['steel'],

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = { min = 1, max = 10 },
	config = {},
	vars = {},

	press_play = function(self)
		local flavor_text = ''
		local has_steel_or_stone = false
		local has_steel = false
		local has_stone = false
	
		for _, card in pairs(G.hand.cards) do
			if not card.highlighted then
				has_steel = SMODS.has_enhancement(card, 'm_steel')
				has_stone = SMODS.has_enhancement(card, 'm_stone')
				
				if has_steel or has_stone then
					has_steel_or_stone = true

					if has_steel then
						flavor_text = localize('pkrm_gym_mineral_ex_steel')
					else
						flavor_text = localize('pkrm_gym_mineral_ex_stone')
					end

					break
				end
			end
		end

		if not has_steel_or_stone then return end

		G.E_MANAGER:add_event(Event {
			trigger = 'after',
			delay = 0.5,
			func = function()
				G.GAME.blind:wiggle()

				pkrm_gym_attention_text {
					text = flavor_text,
					backdrop_colour = TYPE_CLR['steel'],
					major = G.hand,
				}

				local any_selected = false
				for _, card in pairs(G.hand.cards) do
					card:highlight(true)
					G.hand.highlighted[#G.hand.highlighted+1] = card
					any_selected = true
					play_sound('card1', 1)
				end
				if any_selected then G.FUNCS.discard_cards_from_highlighted(nil, true) end

				return true
			end
		})

		delay(0.7)
	end,
}

SMODS.Blind {
	key = 'glacier',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 6 },
	boss_colour = TYPE_CLR['ice'],

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = { min = 1, max = 10 },
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
	boss = { min = 1, max = 10 },
	config = {},
	vars = {},

	calculate = function(self, blind, context)
		if G.GAME.blind.disabled then return end

		if context.before then
			for i = 1, #context.scoring_hand do
				local this_card = context.scoring_hand[i]
				local percent_pitch = 0.8 + i * 0.05
				local percent_vol = 0.3 + i * 0.05

				G.E_MANAGER:add_event(Event {
					trigger = 'after',
					delay = 0.4,
					func = function()
						play_sound('highlight2', percent_pitch, percent_vol)
						this_card:juice_up(0.5, 0.2)

						this_card:flip()
						poke_vary_rank(this_card, false, nil, true)
						this_card:flip()

						SMODS.juice_up_blind()
						G.GAME.blind.triggered = true
						return true
					end,
				})
			end
		end
	end,
}

SMODS.Blind {
	key = 'e4_will',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 8 },
	boss_colour = GYM_SHOWDOWN_CLR['will'],

	discovered = false,
	dollars = 8,
	mult = 2,
	boss = { min = 8, max = 10, showdown = true },
	config = {},
	vars = {},

	debuff_hand = function(self, cards, hand, handname, check)
		local face_ranks = {}
		local face_count = 0

		for i, card in ipairs(cards) do
			if card:is_face() 
			and (card.facing == 'front' or not check) then
				local rank_id = (SMODS.has_no_rank(card) and -1) or card:get_id()
				
				if not face_ranks[rank_id] then
					face_ranks[rank_id] = true
					face_count = face_count + 1
				end
			end
		end

		if face_count < 2 then
			return true
		else
			return false
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
	boss = { min = 8, max = 10, showdown = true },
	config = {},
	vars = {},

	stay_flipped = function(self, area, card)
		if area == G.hand then
			return true
		end

		return false
	end,

	calculate = function(self, blind, context)
		if G.GAME.blind.disabled then return end

		if context.before then
			
			G.E_MANAGER:add_event(Event {
				trigger = 'immediate',
				func = function()
					pkrm_gym_attention_text {
						text = localize('pkrm_gym_e4_koga_ex'),
						backdrop_colour = TYPE_CLR['poison'],
						major = G.hand,
						hold = 0.75,
						align = 'cm',
					}

					G.GAME.blind:wiggle()
					G.GAME.blind.triggered = true

					return true
				end
			})

			for i = 1, #G.hand.cards do
				local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
				local this_card = G.hand.cards[i]

				-- previously check for front facing cards only: this_card.facing == 'front'

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
	end,

	disable = function(self)
		for _, card in pairs(G.hand.cards) do
			if card.facing == 'back' then
				card:flip()
			end
		end
		G.GAME.blind.triggered = false
	end,
}

SMODS.Blind {
	key = 'e4_karen',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 10 },
	boss_colour = TYPE_CLR['dark'],

	discovered = false,
	dollars = 8,
	mult = 2,
	boss = { min = 8, max = 10, showdown = true },
	config = {},
	vars = {},
}

local lance_debuff = function(self)
	local hands_left = G.GAME.current_round.hands_left
	local jokers_count = #G.jokers.cards

	for k, v in pairs(G.jokers.cards) do
		if v.debuff then
			SMODS.debuff_card(v, false, 'lance_champion_johto_debuff')
			v:juice_up()
		end

		if (jokers_count - k) < hands_left then
			if not v.debuff then
				SMODS.debuff_card(v, true, 'lance_champion_johto_debuff')
				v:juice_up()
			end
		end
	end

	G.GAME.blind:wiggle()
end

SMODS.Blind {
	key = 'champion_johto',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 11 },
	boss_colour = GYM_SHOWDOWN_CLR['lance'],

	discovered = false,
	dollars = 12,
	mult = 4,
	boss = { min = 10, max = 10, showdown = true },
	config = {},
	vars = {},

	drawn_to_hand = function(self)
		if G.GAME.blind.prepped then lance_debuff() end
	end,

	calculate = function(self, blind, context)
		-- if G.GAME.blind.disabled then G.GAME.blind.disabled = false end

		if context.before or (context.selling_card and context.cardarea == G.jokers) then
			lance_debuff()
		elseif context.card_added then
			G.E_MANAGER:add_event(Event {
				trigger = 'after',
				delay = 0.2,
				func = function()
					lance_debuff()
					return true
				end,
			})
		end
	end,

	disable = function(self)
		G.GAME.blind.disabled = false

		champion_no_disable_attention_text()
	end,

	defeat = function(self)
		for k, v in pairs(G.jokers.cards) do
			if v.debuff then
				SMODS.debuff_card(v, false, 'lance_champion_johto_debuff')
				v:juice_up()
			end
		end
	end,
}
