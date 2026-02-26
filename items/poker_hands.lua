SMODS.PokerHandPart {
    key = "blaze",
    func = function(hand)
        local ret = {}
        local minimum = 5
        if next(SMODS.find_card('j_four_fingers')) then minimum = 4 end -- four fingers compat

        if #hand < minimum then return {} end

        for _, playing_card in ipairs(hand) do
            if playing_card:is_face() then ret[#ret + 1] = playing_card end
        end

        if #ret < minimum then return {} end
        return {ret,}
    end
}

SMODS.PokerHand {
    key = "blaze",
    mult = 4,
    chips = 25,
    l_mult = 3,
    l_chips = 15,
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
    mult = 14,
    chips = 120,
    l_mult = 4,
    l_chips = 30,
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