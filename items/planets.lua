SMODS.Atlas{
	key = "planets",
	path = "planets.png",
	px = 71,
	py = 95
}

SMODS.Consumable {
    key = "proximab",
    set = "Planet",
    cost = 3,
    pos = { x = 0, y = 0 },
    atlas = "planets",
    config = { hand_type = 'ele_blaze' },
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
            if G.GAME.hands['ele_blaze'].played >= 1 then
                return true
            end
        end
        return false
    end,
}
SMODS.Consumable {
    key = "proximac",
    set = "Planet",
    cost = 3,
    pos = { x = 1, y = 0 },
    atlas = "planets",
    config = { hand_type = 'ele_blaze_flush' },
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
            if G.GAME.hands['ele_blaze_flush'].played >= 1 then
                return true
            end
        end
        return false
    end,
}