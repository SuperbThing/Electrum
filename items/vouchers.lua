SMODS.Atlas{
	key = "vouchers",
	path = "vouch.png",
	px = 71,
	py = 95
}

SMODS.Voucher {
    key = 'metal_merchant',
    atlas = 'vouchers',
    pos = { x = 0, y = 0 },
    config = { extra = { rate = 2.4, display = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.display } }
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.metal_rate = 2 * card.ability.extra.rate
                return true
            end
        }))
    end
}
SMODS.Voucher {
    key = 'metal_tycoon',
    atlas = 'vouchers',
    pos = { x = 1, y = 0 },
    config = { extra = { rate = 8, display = 4 } },
    requires = { 'v_ele_metal_merchant' },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.display, } }
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.tarot_rate = 2 * card.ability.extra.rate
                return true
            end
        }))
    end,
}

-- SMODS.Voucher {
--     key = 'anvil',
--     atlas = 'vouchers',
--     pos = { x = 2, y = 0 },
--     config = { extra = { slots = 1 } },
--     loc_vars = function(self, info_queue, card)
--         return { vars = { card.ability.extra.slots } }
--     end,
--     redeem = function(self, card)
--         G.E_MANAGER:add_event(Event({
--             func = function()
--                 G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.slots
--                 return true
--             end
--         }))
--     end
-- }