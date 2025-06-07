Balatest.TestPlay {
    jokers = { 'j_joker' }, -- Start with a Joker

    category = { 'kanto' }

    execute = function()
        Balatest.play_hand { '2S' } -- Play a High Card
    end,
    assert = function()
        Balatest.assert_chips(35) -- Total round score, *not* the last hand
    end
}

Balatest.TestPlay {
    jokers = { 'j_joker' }, -- Start with a Joker

    category = { 'kanto' }

    execute = function()
        Balatest.play_hand { '2S' } -- Play a High Card
    end,
    assert = function()
        Balatest.assert_chips(35) -- Total round score, *not* the last hand
    end
}