SMODS.PokerHand { 
    key = 'blaze_spectrum',
    chips = 120,
    mult = 14,
    visible = false,
    l_chips = 40,
    l_mult = 5,
    example = {
        { 'C_Q',                true },
        { 'H_J',                true },
        { 'bunc_FLEURON_Q',     true },
        { 'D_K',                true },
        { 'S_K',                true }
    },

    evaluate = function(parts)
        if not next(parts.ele_blaze) or not parts.bunc_spectrum or not next(parts.bunc_spectrum) then return {} end
        return { SMODS.merge_lists(parts.ele_blaze, parts.bunc_spectrum) }
    end
}
SMODS.Consumable {
    key = "proximad",
    set = "Planet",
    cost = 3,
    pos = { x = 2, y = 0 },
    atlas = "planets",
    config = { hand_type = 'ele_blaze_spectrum' },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                G.GAME.hands[card.ability.hand_type].level,
                localize(card.ability.hand_type, 'poker_hands'),
                G.GAME.hands[card.ability.hand_type].l_chips,
                G.GAME.hands[card.ability.hand_type].l_mult,
                colours = { (G.GAME.hands[card.ability.hand_type].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[card.ability.hand_type].level)]) }
            },
        }
    end,
    in_pool = function(self, args)
        if G.GAME then
            if G.GAME.hands['ele_blaze_spectrum'].played >= 1 then
                return true
            end
        end
        return false
    end,
}