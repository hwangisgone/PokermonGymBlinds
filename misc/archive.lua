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

*/