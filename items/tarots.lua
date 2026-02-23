SMODS.Atlas{
	key = "tarots",
	path = "tarot.png",
	px = 71,
	py = 95
}

SMODS.Consumable {
    key = 'resonance',
    set = 'Tarot',
    atlas = 'tarots',
    pos = { x = 0, y = 0 },
    config = { max_highlighted = 2, mod_conv = 'm_ele_amp' },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end
}
SMODS.Consumable {
    key = 'effigy',
    set = 'Tarot',
    atlas = 'tarots',
    pos = { x = 1, y = 0 },
    config = { max_highlighted = 1, mod_conv = 'm_ele_cardboard' },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end
}