SMODS.Atlas{
	key = "blinds",
	path = "blinds.png",
	px = 34,
	py = 34
}

SMODS.Blind {
    key = "candle_final",
    dollars = 8,
    mult = 2,
    pos = { x = 0, y = 0 },
    boss = { showdown = true },
    boss_colour = HEX("e57a10"),
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.modify_hand then
                blind.triggered = true
                mult = mod_mult(math.max(math.floor(mult * 0.125), 1))
                hand_chips = mod_chips(math.max(math.floor(hand_chips * 0.125), 0))
                update_hand_text({ sound = 'chips2', modded = true }, { chips = hand_chips, mult = mult })
            end
        end
    end
}
SMODS.Blind {
    key = "club_final",
    dollars = 8,
    mult = 3,
    pos = { x = 0, y = 1 },
    boss = { showdown = true },
    boss_colour = HEX("5b9baa"),
    debuff_hand = function(self, cards, hand, handname, check)
        if G.GAME.blind.disabled then return end
        G.GAME.blind.triggered = false
        if to_number(G.GAME.hands[handname].level) > 1 then
            G.GAME.blind.triggered = true
            if not check then
            level_up_hand(nil, handname, nil, -G.GAME.hands[handname].level + 1)
            end
        end 
    end,
}
SMODS.Blind {
    key = "scepter_final",
    dollars = 8,
    mult = 1.5,
    pos = { x = 0, y = 2 },
    boss = { showdown = true },
    boss_colour = HEX("6a3847"),
    loc_vars = function(self, info_queue, card)
    update_score = function(self, args)
        local min = math.min(args.chips, args.mult)
        args.mult = min
        args.chips = min
        update_hand_text({delay = 0}, {mult = args.mult, chips = args.chips})

        G.E_MANAGER:add_event(Event({
            func = (function()
                local text = localize('deprecated')
                play_sound('gong', 0.74, 0.3)
                play_sound('gong', 0.74*1.5, 0.2)
                play_sound('tarot1', 0.5)
                ease_colour(G.C.UI_CHIPS, darken(G.C.UI_MULT, 0.5))
                ease_colour(G.C.UI_MULT, darken(G.C.UI_MULT, 0.5))
                attention_text({
                    scale = 1.4, text = text, hold = 2, align = 'cm', offset = {x = 0,y = -2.7},major = G.play
                })
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    blocking = false,
                    delay =  4.3,
                    func = (function() 
                            ease_colour(G.C.UI_CHIPS, G.C.BLUE, 2)
                            ease_colour(G.C.UI_MULT, G.C.RED, 2)
                        return true
                    end)
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    blocking = false,
                    no_delete = true,
                    delay =  6.3,
                    func = (function() 
                        G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
                        G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
                        return true
                    end)
                }))
                return true
            end)
        }))

        delay(0.6)

        return min
    end
}
SMODS.Blind {
    key = "coin_final",
    dollars = 8,
    mult = 2,
    pos = { x = 0, y = 3 },
    boss = { showdown = true },
    boss_colour = HEX("50bf7c"),
    config = {extra = {odds_flip = 3, odds_debuff = 4}},
    loc_vars = function(self)
        local numerator_flip, denominator_flip = SMODS.get_probability_vars(self, 1, G.GAME.blind.effect.extra.odds_flip, 'coin_flip')
        local numerator_debuff, denominator_debuff = SMODS.get_probability_vars(self, 1, G.GAME.blind.effect.extra.odds_debuff, 'coin_debuff')
        return { vars = { numerator_flip, denominator_flip, numerator_debuff, denominator_debuff } }
    end,
    calculate = function(self, blind, context)
        if context.hand_drawn then
            if not blind.disabled then
                for _, card in ipairs(context.hand_drawn) do
                    if SMODS.pseudorandom_probability(G.GAME.blind, 'coin_debuff', 1, G.GAME.blind.effect.extra.odds_debuff) then
                        card:set_debuff(true)
                        if card.debuff then card.debuffed_by_blind = true end
                    end
                end
            end
        end
        if not blind.disabled then
            if context.stay_flipped and context.to_area == G.hand and
                SMODS.pseudorandom_probability(blind, 'ele_coin_final', 1, G.GAME.blind.effect.extra.odds_flip) then
                return {
                    stay_flipped = true
                }
            end
        end
    end,
}
SMODS.Blind {
    key = "hourglass_final",
    dollars = 8,
    mult = 2,
    pos = { x = 0, y = 4 },
    boss = { showdown = true },
    boss_colour = HEX("efc03c"),
    set_blind = function(self)
        local deck_size = #G.deck.cards
        for i=1, math.floor(deck_size/3) do
            draw_card(G.deck, G.discard)
        end
    end,
}