Balatest.TestPlay {
    jokers = { 'j_joker' }, -- Start with a Joker

    category = { 'kanto' },

    execute = function()
        Balatest.play_hand { '2S' } -- Play a High Card
    end,
    assert = function()
        Balatest.assert_chips(35) -- Total round score, *not* the last hand
    end
}

Balatest.TestPlay {
    name = 'temporary_destroyed',
    category = { 'kanto', 'sticker' },

    execute = function()
        for _, card in pairs(G.playing_cards) do
            if card:is_suit('Spades') or card:is_suit('Clubs') then 
                SMODS.Stickers["pkrm_gym_temporary"]:apply(card, true)
            end
        end

        Balatest.play_hand { '2S', '3S', '4S', '6S', '8C' } -- Play a High Card
        Balatest.play_hand { '2C', '3C', '4C', '6C', '8S' } -- Play a High Card
        Balatest.discard { '10S', 'JS', 'QS', 'KS', 'AS' }
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.playing_cards, 26)
    end
}