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
		if context.before then
			local new_scoring_hand = {}
			local non_scoring_cards = {}
			local seen_ranks = {}

			for _, card in pairs(context.scoring_hand) do
				local card_rank = card:get_id()
				
				-- Intentional: Stone card is never unscored (Flying weaks to Rock)

				if not seen_ranks[card_rank] or card.config.center.key == 'm_stone' then
					-- First occurrence of this rank
					seen_ranks[card_rank] = true
					table.insert(new_scoring_hand, card)
				else
					table.insert(non_scoring_cards, card)
				end
			end

			if #non_scoring_cards > 0 then
				-- Remove original scoring_hand and replace it
				for i = 1, #context.scoring_hand do
					table.remove(context.scoring_hand, 1)
				end

				for i = 1, #new_scoring_hand do
					table.insert(context.scoring_hand, new_scoring_hand[i])
				end

				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.1,
					func = function() 
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
							card:juice_up(0.5, 0.2)
							play_sound('card1', 0.4, 0.5)
							G.ROOM.jiggle = G.ROOM.jiggle + 0.5
							return true 
						end
					}))
				end
			end
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
		if context.final_scoring_step then
			local rightmost_card = G.play.cards[#G.play.cards]
			
			-- Scyther effect
			-- Card:start_dissolve(dissolve_colours, silent, dissolve_time_fac, no_juice)
			G.E_MANAGER:add_event(Event({ trigger = 'immediate', func = function()
				rightmost_card:start_dissolve({HEX("57ecab")}, true, 1.6, false)
				play_sound('slice1', 0.96+math.random()*0.08)

				G.GAME.blind:wiggle()
				G.GAME.blind.triggered = true

				return true
			end}))
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
	-- TODO: reework config stuffs to use extra? https://github.com/Steamodded/smods/wiki/API-Documentation#common-parameters


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
		if not G.GAME.blind.disabled then
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
	config = {poison_chips = 10},
	vars = {},
	loc_vars = function(self)
		return {vars = {self.config.poison_chips}}
	end,
	collection_loc_vars = function(self)
		return {vars = {self.config.poison_chips}}
	end,

	calculate = function(self, card, context)
		-- TODO: just context.pre_discard Might be buggy??
		if context.before and not G.GAME.blind.disabled then
			for i = 1, #G.hand.cards do
				local percent = 1.15 - (i-0.999)/(#G.hand.cards-0.998)*0.3
				local this_card = G.hand.cards[i]

				if not this_card.highlighted then
					G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() 
						this_card:flip();

						this_card.ability.perma_bonus = this_card.ability.perma_bonus - self.config.poison_chips
						this_card.ability.koga_poison_bonus = (this_card.ability.koga_poison_bonus or 0) - self.config.poison_chips

						attention_text({
							text = localize("pkrm_gym_e4_koga_ex"),
							scale = 0.5, 
							hold = 1,
							backdrop_colour = TYPE_CLR['poison'],
							align = 'tm',
							major = this_card,
							offset = {x = 0, y = -0.05*G.CARD_H}
						})

						play_sound('cancel', percent);
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
		
		-- Remove poison negative bonus chips
		for _, card in pairs(G.playing_cards) do
			if card.ability.koga_poison_bonus and card.ability.koga_poison_bonus < 0 then
				card.ability.perma_bonus = card.ability.perma_bonus - card.ability.koga_poison_bonus
				card.ability.koga_poison_bonus = nil
				card:juice_up(0.1, 0.1)
			end
		end
	end,

	defeat = function(self)
		for _, card in pairs(G.playing_cards) do
			if card.koga_poison_bonus and card.koga_poison_bonus < 0 then
				card.ability.perma_bonus = card.ability.perma_bonus - card.koga_poison_bonus
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