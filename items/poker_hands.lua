SMODS.PokerHandPart {
    key = "blaze",
    func = function (hand)
        local minimum = 5
        if next(SMODS.find_card('j_four_fingers')) then
            minimum = 4
        end
        if #hand < minimum then return {} end
        local scoring_cards = {}
        for _, card in ipairs(hand) do
            local rank = card:get_id()
            -- Reject immediately if any card is NOT J, Q, or K
            if rank ~= 11 and rank ~= 12 and rank ~= 13 then
                return {}
            end
            table.insert(scoring_cards, card)
        end
        return { scoring_cards }
    end
}
SMODS.PokerHand {
    key = "blaze",
    mult = 4,
    chips = 25,
    l_mult = 3,
    l_chips = 15,
    visible = false,
    example = {
        { 'H_K', true },
        { 'C_Q', true },
        { 'D_Q', true },
        { 'H_J', true },
        { 'S_K', true }
    },
    evaluate = function(parts, hand)
        return parts.ele_blaze
    end
}
SMODS.PokerHand {
    key = "blaze_flush",
    mult = 10,
    chips = 100,
    l_mult = 4,
    l_chips = 30,
    visible = false,
    example = {
        { 'D_J', true },
        { 'D_Q', true },
        { 'D_K', true },
        { 'D_J', true },
        { 'D_K', true }
    },
    evaluate = function(parts, hand)
        if not next(parts.ele_blaze) or not next(parts._flush) then return end
        return { SMODS.merge_lists(parts.ele_blaze, parts._flush) }
    end,
}