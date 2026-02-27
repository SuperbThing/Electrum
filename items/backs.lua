SMODS.Atlas{
	key = "backs",
	path = "back.png",
	px = 71,
	py = 95
}

SMODS.Back {
    key = "infrared",
    atlas = "backs",
    pos = { x = 0, y = 0 },
    config = { extra = { ante_scaling = 2 } },
    loc_vars = function(self, info_queue, back)
        return { vars = { self.config.extra.ante_scaling } }
    end,
    apply = function(self, back)
        G.GAME.starting_params.ante_scaling = self.config.extra.ante_scaling
        G.E_MANAGER:add_event(Event({
            func = function()
                if not G.HUD then return false end
                SMODS.set_scoring_calculation('ele_amp_infrared')
                return true
            end
        }))
    end
}

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