local function fog_check_flip(hd_flip, sc_flip)
    local all_hd_flipped_correctly = true
    local all_sc_flipped_correctly = true

    for _, card in pairs(G.playing_cards) do
        if card:is_suit('Spades') or card:is_suit('Clubs') then 
            if card.facing ~= sc_flip then
                all_sc_flipped_correctly = false
            end
        else
            if card.facing ~= hd_flip then
                all_hd_flipped_correctly = false
            end
        end
    end

    return all_hd_flipped_correctly, all_sc_flipped_correctly
end

Balatest.TestPlay {
    name = 'fog_effect',
    category = { 'johto', 'blind' },

    blind = 'bl_pkrm_gym_fog',

    execute = function()
    end,
    assert = function()
        local hd_correct, sc_correct = fog_check_flip('back', 'front')

        Balatest.assert(hd_correct)
        Balatest.assert(sc_correct)
    end
}

Balatest.TestPlay {
    name = 'fog_disable_chicot',
    category = { 'johto', 'blind', 'disable' },

    blind = 'bl_pkrm_gym_fog',
    jokers = { 'j_chicot' },

    execute = function()
    end,
    assert = function()
        local hd_correct, sc_correct = fog_check_flip('front', 'front')

        Balatest.assert(hd_correct)
        Balatest.assert(sc_correct)
    end
}

Balatest.TestPlay {
    name = 'fog_disable_weezing',
    category = { 'johto', 'blind', 'disable' },

    blind = 'bl_pkrm_gym_fog',
    jokers = { 'j_poke_weezing' },

    execute = function()
        Balatest.play_hand { '2S' }
        G.jokers.cards[1]:sell_card()
        Balatest.wait_for_input()
    end,
    assert = function()
        local hd_correct, sc_correct = fog_check_flip('front', 'front')

        Balatest.assert(hd_correct)
        Balatest.assert(sc_correct)
    end
}