/*

// Old Balance: Each hand only scores after discard

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

*/