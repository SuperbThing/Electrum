SMODS.Atlas{
	key = "backs",
	path = "back.png",
	px = 71,
	py = 95
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