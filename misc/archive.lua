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

*/