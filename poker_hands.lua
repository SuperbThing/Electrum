
SMODS.PokerHandPart {
    key = "blaze",
    func = function (hand)
        local minimum = 5

        if next(SMODS.find_card('j_four_fingers')) then
            minimum = 4
        end

        if #hand < minimum then return {} end

        local track_ranks = {}

        for _,card in ipairs(hand) do
            local rank = card:get_id()
            track_ranks[rank] = track_ranks[rank] or {}
            table.insert(track_ranks[rank], card)
        end

        if not (
            -- A rank is not tracked if the rank is not in the hand
            track_ranks[13]     -- kings
            and track_ranks[12] -- queens
            and track_ranks[11] -- come on what do you think this is
        ) then return {} end

        local scoring_cards = SMODS.merge_lists{
            track_ranks[13],
            track_ranks[12],
            track_ranks[11]
        }

        return {scoring_cards}
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