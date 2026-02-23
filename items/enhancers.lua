SMODS.Atlas{
	key = "enhancers",
	path = "enhance.png",
	px = 71,
	py = 95
}

SMODS.Enhancement {
    key = 'amp',
    pos = { x = 0, y = 0 },
	atlas = "enhancers",
    config = { amp = 1.2 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.amp } }
    end,
	calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {amp = card.ability.amp}
        end
	end

}
SMODS.Enhancement {
    key = "cardboard",
    atlas = "enhancers",
    pos = { x = 1, y = 0 },
    config = { extra = { odds = 4 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator =
            SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'ele_cardboard')
        return { vars = { numerator, denominator } }
    end,
    calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.hand and context.other_card == card and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            if SMODS.pseudorandom_probability(card, 'ele_cardboard', 1, card.ability.extra.odds) then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.0,
                    func = function()
                        SMODS.add_card({ set = 'Tarot' })
                        G.GAME.consumeable_buffer = 0
                        return true
                    end
                }))
            end
        end
    end
}
  
  


