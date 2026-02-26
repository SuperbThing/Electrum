SMODS.Atlas({
    key = 'blinds',
    path = 'blinds.png',
    atlas_table = 'ANIMATION_ATLAS',
    frames = 21,
    px = 34,
    py = 34
})

SMODS.Blind {
    key = "candle_final",
    dollars = 8,
    mult = 2,
    atlas = 'blinds',
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
    atlas = 'blinds',
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
    atlas = 'blinds',
    pos = { x = 0, y = 2 },
    boss = { showdown = true },
    config = { extra = { change = 10 } },
    boss_colour = HEX("6a3847"),
    loc_vars = function(self, info_queue, card)
        return {vars = {self.config.extra.change}}
    end,
    collection_loc_vars = function(self)
        return {vars = {self.config.extra.change}}
    end,
    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        for _, card in pairs(cards) do
            G.E_MANAGER:add_event(Event({ trigger = 'after', func = function()
                G.GAME.blind.chips = G.GAME.blind.chips * (1 + self.config.extra.change/100)
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                card:juice_up()
                play_sound('xchips', 0.75)
                return true
            end })) 
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('scepter_up')})
        end
        return mult, hand_chips, false
    end
}
SMODS.Blind {
    key = "coin_final",
    dollars = 8,
    mult = 2,
    atlas = 'blinds',
    pos = { x = 0, y = 3 },
    boss = { showdown = true },
    boss_colour = HEX("50bf7c"),
    loc_vars = function(self)
        local numerator_flip, denominator_flip = SMODS.get_probability_vars(self, 1, 3, 'coin_flip')
        local numerator_debuff, denominator_debuff = SMODS.get_probability_vars(self, 1, 4, 'coin_debuff')
        return { vars = { numerator_flip, denominator_flip, numerator_debuff, denominator_debuff } }
    end,
    calculate = function(self, blind, context)
        if context.hand_drawn then
            if not blind.disabled then
                for _, card in ipairs(context.hand_drawn) do
                    if SMODS.pseudorandom_probability(blind, 'coin_debuff', 1, 4) then
                        card:set_debuff(true)
                        if card.debuff then card.debuffed_by_blind = true end
                    end
                end
            end
        end
        if not blind.disabled then
            if context.stay_flipped and context.to_area == G.hand and
                SMODS.pseudorandom_probability(blind, 'ele_coin_final', 1, 3) then
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
    atlas = 'blinds',
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