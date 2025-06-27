/*

// Old Balance: Each hand only scores after discard

calculate = function(self, card, context)
    if G.GAME.blind.disabled then return end

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

// Old Koga: 


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


-- Old storm

-- bl_pkrm_gym_storm   = {name = 'The Storm'  , text = {"All but 1 hand", "becomes discard"}},

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
	end,
}

-- Old Koga: After selecting card, flip down cards held in hand

	debuff_hand = function(self, cards, hand, handname, check)
		local count = 0
		local to_flip = {}

		for _, card in pairs(G.hand.cards) do
			if not card.ability.koga_flipped then
				card.ability.koga_flipped = true
				count = count + 1
				table.insert(to_flip, card)
			end
		end

		if count > 0 then
			G.GAME.blind:wiggle()
			G.GAME.blind.triggered = true

			pkrm_gym_attention_text {
				text = localize('pkrm_gym_e4_koga_ex'),
				backdrop_colour = TYPE_CLR['poison'],
				major = G.hand,
			}
		end

		for i = 1, #to_flip do
			local percent = 1.15 - (i - 0.999) / (#to_flip - 0.998) * 0.3
			local this_card = to_flip[i]

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

		return false
	end,

-- Old Mind: Hand must contain a Pair

	debuff_hand = function(self, cards, hand, handname, check)
		-- TODO: what is check? "if not check then"
		return not next(hand['Pair'])
	end,

-- Old Dynamo
-- bl_pkrm_gym_dynamo  = {name = 'The Dynamo' ,text = {"Debuff all played cards", "except the lowest", "and highest ranks"}},

	calculate = function(self, card, context)
		if G.GAME.blind.disabled then return end

		if context.before then
			local highest_card = context.full_hand[1]
			local lowest_card = context.full_hand[1]
			
			for i = 2, #context.full_hand do
				local card = context.full_hand[i]
				
				if not SMODS.has_no_rank(card) then
					if card:get_id() > highest_card:get_id() then
						highest_card = card
					end
					
					if card:get_id() < lowest_card:get_id() then
						highest_card = card
					end
				end
			end

			for i, card in ipairs(context.full_hand) do
				if card:get_id() == highest_card:get_id()
				or card:get_id() == lowest_card:get_id()
				or SMODS.has_no_rank(card) then
					-- Do nothing
				else
					SMODS.debuff_card(card, true, 'wattson_dynamo_debuff')
				end
			end
		end
	end,

	defeat = function(self)
		remove_debuff_all_playing_cards('wattson_dynamo_debuff')
	end,

-- Old Feather: lowest rank are drawn first

set_blind = function(self)
    G.E_MANAGER:add_event(Event {
        trigger = 'after',
        delay = 0.6,
        -- TOCHECK: Might be slightly buggy with 0.6
        -- Need a more concrete way of doing this, such as parent event releasing 'blocking' child event after 0.4
        blocking = false,
        func = function()
            table.sort(G.deck.cards, function(a, b)
                local chipa, chipb = a:get_chip_bonus(), b:get_chip_bonus()
                return chipa == chipb and a:get_nominal() > b:get_nominal() or chipa > chipb
            end)
            return true
        end,
    })
end,

-- Old Feather 2: Add a 9 to deck for every unscored card

local ALL_NINES = {}
for _, v in pairs(G.P_CARDS) do
  if v.value == '9' then
	table.insert(ALL_NINES, v)
  end
end

local function get_unscored_indices(full_hand, scoring_hand)
	local scored_map = {}
	for _,v in ipairs(scoring_hand) do 
		scored_map[v] = true
	end

	local unscored_indices = {}
	for i,v in ipairs(full_hand) do 
		if not scored_map[v] then
			table.insert(unscored_indices, i)
		end
	end

	return unscored_indices
end

SMODS.Blind {
	key = 'feather',
	atlas = 'blinds_hoenn',
	pos = { x = 0, y = 5 },
	boss_colour = TYPE_CLR['flying'],

	discovered = false,
	dollars = 5,
	mult = 2,
	boss = { min = 1, max = 10 },
	config = {},
	vars = {},

	calculate = function(self, card, context)
		if G.GAME.blind.disabled then return end

		if context.final_scoring_step then
			local unscored_indices = get_unscored_indices(G.play.cards, context.scoring_hand)

			if #unscored_indices < 1 then return end

			local nine_list = {}

			G.E_MANAGER:add_event(Event {
				trigger = 'before',
				delay = 2,
				func = function()
					local added_card_count = 0

					for _, index in ipairs(unscored_indices) do
						local created_nine = create_playing_card({
							front = pseudorandom_element(ALL_NINES, pseudoseed('winona')), 
							center = G.P_CENTERS.c_base
						}, G.play, nil, nil, { TYPE_CLR['flying'] })

						added_card_count = added_card_count + 1

						table_shift_positions(G.play.cards, #G.play.cards, index + added_card_count)

						table.insert(nine_list, created_nine)
					end

					pkrm_gym_attention_text {
						text = localize('pkrm_gym_feather_ex'),
						backdrop_colour = TYPE_CLR['flying'],
						major = G.play,
					}

					G.GAME.blind:wiggle()

					return true
				end
			})

			for i = 1, #unscored_indices do
				G.E_MANAGER:add_event(Event {
					trigger = 'before',
					delay = 0.5,
					func = function()
						-- Divide by 2 so player doesn't draw them immediately and get a flush five
						local random_index = pseudorandom('winona', 1, #G.deck.cards)

						G.play:remove_card(nine_list[i])
						G.deck:emplace(nine_list[i], 'front')

						table_shift_positions(G.deck.cards, 1, random_index)
						play_sound('card1', 1, 0.6)

						return true
					end
				})
			end

			G.E_MANAGER:add_event(Event {
				trigger = 'after',
				delay = 1,
			})
		end
	end
}


-- bl_pkrm_gym_cascade = {name = 'The Cascade', text = {"After Play, #1# in #2# chance","to lose Energy", "in one Water Joker"}},
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

-- Lorelei: Cards are destroyed after 3 hands
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

	calculate = function(self, blind, context)
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

-- bl_pkrm_gym_e4_bruno   = {name = 'Saffron Shackles', text = {"Discarded poker hand", "will not score"}},
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

	calculate = function(self, blind, context)
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


-- bl_pkrm_gym_e4_agatha  = {name = 'Cursed Cane'    , text = {"Unscored and", "discarded cards", "return to deck"}},



*/