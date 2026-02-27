SMODS.Atlas{
	key = "backs",
	path = "back.png",
	px = 71,
	py = 95
}

-- SMODS.Back {
--     key = "infrared",
--     atlas = "backs",
--     pos = { x = 0, y = 0 },
--     config = { extra = { chops = 2 } },
--     loc_vars = function(self, info_queue, back)
--         return { vars = { self.config.extra.chops } }
--     end,
--     calculate = function(self, back, context)
--         if context.final_scoring_step then
--             mult = mod_mult(mult / self.config.extra.chops)
--             update_hand_text({delay = 0}, {mult = mult})
--             G.E_MANAGER:add_event(Event({
--                 func = function()
--                     play_sound('tarot1', 1.0)
--                     return true
--                 end
--             }))
--         delay(0.6)
--         end
--     end,
--     apply = function(self)
--         set_current_amp_operator("amp_infrared")
--     end
-- }

SMODS.Back {
    key = "forge",
    atlas = "backs",
    pos = { x = 1, y = 0 },
    config = { voucher = 'v_ele_metal_merchant', consumables = { 'c_ele_copper' } },
    loc_vars = function(self, info_queue, back)
        return {
            vars = { localize { type = 'name_text', key = self.config.voucher, set = 'Voucher' },
                localize { type = 'name_text', key = self.config.consumables[1], set = 'Metal' }
            }
        }
    end,
}