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
    config = { extra = { balance = 20, ante_scaling = 1.5, chops = 50 } },
    loc_vars = function(self, info_queue, back)
        return { vars = { self.config.extra.balance, self.config.extra.chops, self.config.ante_scaling } }
    end,
    calculate = function(self, back, context)
        if context.final_scoring_step then
            -- going all in on the locals lol
            local amp_param = SMODS.Scoring_Parameters[self.mod.prefix..'_amp']
            local current_amp = amp_param.current
            local balance = self.config.extra.balance
            local diff_mult = current_amp - mult
            local diff_amp =  mult - current_amp
            local balanced_mult = mult + ((balance * diff_mult) / 200)
            local balanced_amp = current_amp + ((balance * diff_amp) / 200)
            
            mult = mod_mult(balanced_mult)
            amp_param:modify(balanced_amp - 1)

            update_hand_text({delay = 0}, { mult = balanced_mult, amp = balanced_amp })
            G.E_MANAGER:add_event(Event({
                func = (function()
                local text = localize('balanced')
                    play_sound('gong', 0.94, 0.3)
                    play_sound('gong', 0.94*1.5, 0.2)
                    play_sound('tarot1', 1.5)
                    ease_colour(G.C.AMP, {0.99, 0.5, 0.16, 1})
                    ease_colour(G.C.UI_MULT, {0.99, 0.5, 0.16, 1})
                    attention_text({
                        scale = 1.4, text = text, hold = 2, align = 'cm', offset = {x = 0,y = -2.7},major = G.play
                    })
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        blockable = false,
                        blocking = false,
                        delay =  0.8,
                        func = (function()
                                ease_colour(G.C.AMP, G.C.ORANGE, 0.8)
                                ease_colour(G.C.UI_MULT, G.C.RED, 0.8)
                            return true
                        end)
                    }))
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        blockable = false,
                        blocking = false,
                        no_delete = true,
                        delay =  1.3,
                        func = (function()
                            G.C.AMP[1], G.C.AMP[2], G.C.AMP[3], G.C.AMP[4] = G.C.ORANGE[1], G.C.ORANGE[2], G.C.ORANGE[3], G.C.ORANGE[4]
                            G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
                            return true
                        end)
                    }))
                    return true
                end)
            }))
            delay(0.6)

            hand_chips = mod_chips(hand_chips-(hand_chips*(self.config.extra.chops/100)))
            update_hand_text({delay = 0}, { chips = hand_chips })
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    return true
                end
            }))
            delay(0.3)
            return true
        end
    end,
    apply = function(self, back)
        G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * self.config.extra.ante_scaling
    end,
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