SMODS.Shader({key = 'iridescent', path = 'iridescent.fs'})
SMODS.Sound({key = 'iridescent', path = 'multi_balance.ogg'})

SMODS.Edition {
    key = 'iridescent',
    shader = 'iridescent',
    config = { amp = 0.5 },
    in_shop = true,
    weight = 3,
    extra_cost = 5,
    sound = { sound = "iridescent", per = 1.2, vol = 0.7 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.edition.amp } }
    end,
    get_weight = function(self)
        return (G.GAME.edition_rate - 1) * G.P_CENTERS["e_negative"].weight + G.GAME.edition_rate * self.weight
    end,
    calculate = function(self, card, context)
        if context.post_joker or (context.main_scoring and context.cardarea == G.play) then
            return {
                amp = card.edition.amp
            }
        end
    end
}