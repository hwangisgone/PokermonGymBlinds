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

		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.1,
			func = function() 

				config.blind_juice_func()

				return true
			end
		}))

		-- Repeated rank, unhighlight
		for _, card in pairs(non_scoring_cards) do
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function() 
					card:highlight(false)
					card:juice_up(0.3, 0.2)

					config.card_juice_func(card)

					return true 
				end
			}))
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
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},
	
	calculate = function(self, card, context)
		if G.GAME.blind.disabled then return end

		if context.before then
			local seen_ranks = {}

			rescore_hand(context.scoring_hand, {
				is_unscored_func = function(card) 
					local card_rank = card:get_id()

					-- Intentional: Stone card is never unscored (Flying weaks to Rock)

					if not seen_ranks[card_rank] or card.config.center.key == 'm_stone' then
						-- First occurrence of this rank
						seen_ranks[card_rank] = true
						return false
					else
						return true
					end
				end, 
				blind_juice_func = function()
					attention_text({
						text = localize("pkrm_gym_zephyr_ex"),
						scale = 1.3, 
						hold = 0.7,
						backdrop_colour = TYPE_CLR['flying'],
						align = 'tm',
						major = G.play,
						offset = {x = 0, y = -0.1*G.CARD_H}
					})

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
	boss = {min = 1, max = 10}, 
	config = {},
	vars = {},

	calculate = function(self, card, context)
		if G.GAME.blind.disabled then return end

		if context.destroy_card and context.cardarea == G.play then

			if context.destroying_card.ID == G.play.cards[#G.play.cards].ID then
				local cutting_card = context.destroying_card

				

				G.E_MANAGER:add_event(Event({ trigger = 'immediate', func = function()
					play_sound('slice1', 0.96+math.random()*0.08)
					cutting_card:start_dissolve({HEX("57ecab")}, true, 1.6, false)

					return true
				end}))

				return {
					remove = true
				}
			end

			if context.remove_playing_cards then
				print("DESTROYING...")
			end



			-- local rightmost_card = G.play.cards[#G.play.cards]
			
			-- -- Scyther effect
			-- -- Card:start_dissolve(dissolve_colours, silent, dissolve_time_fac, no_juice)
			-- G.E_MANAGER:add_event(Event({ trigger = 'immediate', func = function()
			-- 	rightmost_card:start_dissolve({HEX("57ecab")}, true, 1.6, false)
			-- 	rightmost_card.destroyed = true

			-- 	play_sound('slice1', 0.96+math.random()*0.08)

			-- 	G.GAME.blind:wiggle()
			-- 	G.GAME.blind.triggered = true

			-- 	return true
			-- end}))
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
			return not (card:is_suit('Spades') or card:is_suit('Clubs'))
		end
		return false
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

	set_blind = function(self)
		local hands_usable = math.max(G.GAME.current_round.hands_left - 1, 0)
		ease_hands_played(-hands_usable)
		ease_discard(hands_usable)
	end
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

	calculate = function(self, card, context)
		if G.GAME.blind.disabled then return end

		if context.before then
			for i = 1, #context.scoring_hand do
				local this_card = context.scoring_hand[i]
				local percent_pitch = 0.8 + i*0.05 
				local percent_vol = 0.6 + i*0.05		


				G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.4,func = function() 
					
					play_sound('highlight2', percent_pitch, percent_vol)
					this_card:juice_up(0.5, 0.2)

					this_card:flip()
					poke_vary_rank(this_card, false, nil, true)
					this_card:flip()

					SMODS.juice_up_blind()
					G.GAME.blind.triggered = true
					return true
				end}))
		
			end
		end
	end
}

SMODS.Blind {
	key = 'e4_will',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 8 },
	boss_colour = GYM_SHOWDOWN_CLR['will'],

	discovered = false,
	dollars = 8,
	mult = 2,
	boss = {min = 8, max = 10, showdown = true}, 
	config = {},
	vars = {},

	debuff_hand = function(self, cards, hand, handname, check)
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

	calculate = function(self, card, context)
		if G.GAME.blind.disabled then return end

		if context.before then
			rescore_hand(context.scoring_hand, {
				is_unscored_func = function(card) 
					return not card.ability.koga_flipped
				end,
				blind_juice_func = function()
					G.GAME.blind:wiggle()
					G.GAME.blind.triggered = true 
				end, 
				card_juice_func = function(card)
					attention_text({
						text = localize("pkrm_gym_e4_koga_ex"),
						scale = 0.5, 
						hold = 1,
						backdrop_colour = TYPE_CLR['poison'],
						align = 'tm',
						major = card,
						offset = {x = 0, y = -0.05*G.CARD_H}
					})

					play_sound('cancel', 1);
					G.ROOM.jiggle = G.ROOM.jiggle + 0.2
				end,
			})

		-- TODO: just context.pre_discard Might be buggy??
		elseif context.pre_discard then
			for i = 1, #G.hand.cards do
				local percent = 1.15 - (i-0.999)/(#G.hand.cards-0.998)*0.3
				local this_card = G.hand.cards[i]

				if this_card.facing == 'front' and not this_card.highlighted then
					G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() 
						this_card:flip();
						this_card.ability.koga_flipped = true
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
	boss = {min = 8, max = 10, showdown = true}, 
	config = {},
	vars = {},
}

SMODS.Blind {
	key = 'champion_johto',
	atlas = 'blinds_johto',
	pos = { x = 0, y = 11 },
	boss_colour = GYM_SHOWDOWN_CLR['lance'],

	discovered = false,
	dollars = 12,
	mult = 4,
	boss = {min = 10, max = 10, showdown = true}, 
	config = {},
	vars = {},
}