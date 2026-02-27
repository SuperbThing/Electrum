SMODS.Atlas{
	key = "jokers",
	path = "jokers.png",
	px = 71,
	py = 95
}


SMODS.Joker {
    key = "cheerful",
	atlas = "jokers",
    pos = { x = 0, y = 0 },
    rarity = 1,
    blueprint_compat = true,
    cost = 3,
    config = { extra = { amp = 0.3, type = 'Pair' }, },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.amp, localize(card.ability.extra.type, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
            return {
                amp = card.ability.extra.amp
            }
        end
    end
}
SMODS.Joker {
    key = "goofy",
	atlas = "jokers",
    pos = { x = 1, y = 0 },
    rarity = 1,
    blueprint_compat = true,
    cost = 4,
    config = { extra = { amp = 0.7, type = 'Three of a Kind' }, },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.amp, localize(card.ability.extra.type, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
            return {
                amp = card.ability.extra.amp
            }
        end
    end
}
SMODS.Joker {
    key = "bonkers",
	atlas = "jokers",
    pos = { x = 2, y = 0 },
    rarity = 1,
    blueprint_compat = true,
    cost = 4,
    config = { extra = { amp = 0.5, type = 'Two Pair' }, },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.amp, localize(card.ability.extra.type, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
            return {
                amp = card.ability.extra.amp
            }
        end
    end
}
SMODS.Joker {
    key = "insane",
	atlas = "jokers",
    pos = { x = 3, y = 0 },
    rarity = 1,
    blueprint_compat = true,
    cost = 4,
    config = { extra = { amp = 0.7, type = 'Straight' }, },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.amp, localize(card.ability.extra.type, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
            return {
                amp = card.ability.extra.amp
            }
        end
    end
}
SMODS.Joker {
    key = "comical",
	atlas = "jokers",
    pos = { x = 4, y = 0 },
    rarity = 1,
    blueprint_compat = true,
    cost = 4,
    config = { extra = { amp = 0.5, type = 'Flush' }, },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.amp, localize(card.ability.extra.type, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
            return {
                amp = card.ability.extra.amp
            }
        end
    end
}
SMODS.Joker {
    key = "cardboard_joker",
    blueprint_compat = true,
    rarity = 2,
    cost = 7,
    pos = { x = 0, y = 1 },
	atlas = "jokers",
    config = { extra = { mult = 2 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_ele_cardboard
        local base_mult = (card and card.ability and card.ability.extra and card.ability.extra.mult) or self.config.extra.mult or 0
        local cardboard_tal = 0
        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_ele_cardboard') then
                    cardboard_tal = cardboard_tal + 1
                end
            end
        end
        return {
            vars = {
                base_mult, base_mult * cardboard_tal
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local base_mult = (card and card.ability and card.ability.extra and card.ability.extra.mult)
                or self.config.extra.mult or 0
            local cardboard_tal = 0
            if G.playing_cards then
                for _, playing_card in ipairs(G.playing_cards) do
                    if SMODS.has_enhancement(playing_card, 'm_ele_cardboard') then
                        cardboard_tal = cardboard_tal + 1
                    end
                end
            end
            return {
                mult = base_mult * cardboard_tal
            }
        end
    end,
    in_pool = function(self, args) 
        for _, playing_card in ipairs(G.playing_cards or {}) do
            if SMODS.has_enhancement(playing_card, 'm_ele_cardboard') then
                return true
            end
        end
        return false
    end
}
SMODS.Joker {
    key = "magnet",
    atlas = "jokers",
    pos = { x = 1, y = 1 },
    cost = 5,
    rarity = 1,
    config = {
        extra = {
            mult = 10,
            chips = 50
        }
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.other_consumeable and context.other_consumeable.ability.set == 'Metal' then
            return {
                mult = card.ability.extra.mult,
                chips = card.ability.extra.chips
            }
        end
    end
}
SMODS.Joker {
    key = "erratic",
    atlas = "jokers",
    pos = { x = 2, y = 1 },
    cost = 9,
    rarity = 3,
    config = { extra = { chips = 15, mult = 4, amp = 0.2 } },
    loc_vars = function(self, info_queue, card)
        local suit = (G.GAME.current_round.ele_erratic_card or {}).suit or 'Spades'
        return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.amp, localize(suit, 'suits_singular'), colours = { G.C.SUITS[suit] } } }
    end,
    calculate = function(self, card, context)
		if not G.GAME.current_round.ele_erratic_card then
			G.GAME.current_round.ele_erratic_card = { suit = 'Spades' }
		end
		local current = G.GAME.current_round.ele_erratic_card
		if context.individual and context.cardarea == G.play and context.other_card:is_suit(current.suit) then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
                amp = card.ability.extra.amp
            }
        end
    end
}

local function reset_ele_erratic_card()
	G.GAME.current_round.ele_erratic_card = G.GAME.current_round.ele_erratic_card or { suit = 'Spades' }
	local erratic_suits = {}
	for k, v in ipairs({ 'Spades', 'Hearts', 'Clubs', 'Diamonds' }) do
		if v ~= G.GAME.current_round.ele_erratic_card.suit then erratic_suits[#erratic_suits + 1] = v end
	end
	local erratic_card = pseudorandom_element(erratic_suits, 'ele_erratic' .. G.GAME.round_resets.ante)
	G.GAME.current_round.ele_erratic_card.suit = erratic_card
end

function SMODS.current_mod.reset_game_globals(run_start)
    reset_ele_erratic_card()
end
SMODS.Joker {
    key = "geiger",
    atlas = "jokers",
    pos = { x = 3, y = 1 },
    cost = 7,
    rarity = 2,
    config = { extra = { mult = 0, gain = 1 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.mult, card.ability.extra.gain}
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            local metal_count = 0
            for _, c in ipairs(G.consumeables.cards) do
                if c.ability.set == 'Metal' then
                    metal_count = metal_count + 1
                end
            end
            if metal_count > 0 then
                local gain_amount = metal_count * card.ability.extra.gain
                card.ability.extra.mult = card.ability.extra.mult + gain_amount
                card:juice_up()
                card_eval_status_text(card, 'extra', nil, nil, nil,
                    { message = "+" .. gain_amount .. " mult" })
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}
SMODS.Joker {
    key = "syrup",
    atlas = "jokers",
    blueprint_compat = true,
    eternal_compat = false,
    rarity = 1,
    cost = 5,
    pos = { x = 4, y = 1 },
    config = { extra = { amp_loss = 0.1, amp = 0.7 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.amp, card.ability.extra.amp_loss } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if card.ability.extra.amp - card.ability.extra.amp_loss <= 0 then
                SMODS.destroy_cards(card, nil, nil, true)
                return {
                    message = localize('drank'),
                    colour = G.C.FILTER
                }
            else
                card.ability.extra.amp = card.ability.extra.amp - card.ability.extra.amp_loss
                return {
                    message = localize('amp_loss'), colour = G.C.RED
                }
            end
        end
        if context.joker_main then
            return {
                amp = card.ability.extra.amp
            }
        end
    end
}
SMODS.Joker {
    key = "spectro",
    atlas = "jokers",
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    pos = { x = 0, y = 2 },
    config = { extra = { amp = 0.25 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.amp } }
    end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			return {
				amp = card.ability.extra.amp
			}
		end
	end
}
SMODS.Joker {
    key = "speaker",
    atlas = "jokers",
    pos = { x = 1, y = 2 },
    cost = 8,
    rarity = 2,
    config = {
        extra = {
            xamp = 1.2,
            xmult = 0.8
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xamp, card.ability.extra.xmult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xamp = card.ability.extra.xamp,
                xmult = card.ability.extra.xmult
            }
        end
    end
}
SMODS.Joker {
    key = "butter",
    atlas = "jokers",
    blueprint_compat = true,
    rarity = 1,
    cost = 6,
    pos = { x = 2, y = 2 },
    config = { extra = { amp = 0.2, hands_left = 10 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.amp, card.ability.extra.amp * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.metal or 0), card.ability.extra.hands_left } }
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == "metal" then
            return {
                message = localize { type = 'variable', key = 'a_amp', vars = { G.GAME.consumeable_usage_total.metal * card.ability.extra.amp } },
            }
        end
        if context.joker_main then
            return {
                amp = card.ability.extra.amp *
                    (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.metal or 0)
            }
        end
        if context.after and not context.blueprint then
            if card.ability.extra.hands_left - 1 <= 0 then
                SMODS.destroy_cards(card, nil, nil, true)
                return {
                    message = localize('eaten'),
                    colour = G.C.FILTER
                }
            else
                card.ability.extra.hands_left = card.ability.extra.hands_left - 1
                return {
                    message = card.ability.extra.hands_left .. '',
                    colour = G.C.FILTER
                }
            end
        end
    end,
}
SMODS.Joker {
    key = "metallurgist",
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    atlas = "jokers",
    pos = { x = 3, y = 2 },
    calculate = function(self, card, context)
        if context.setting_blind and context.blind.boss and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card {
                                set = 'Metal',
                                key_append = 'ele_metallurgist'
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                    SMODS.calculate_effect({ message = localize('plus_metal'), colour = G.C.METAL },
                        context.blueprint_card or card)
                    return true
                end)
            }))
            return nil, true 
        end
    end
}
SMODS.Joker {
    key = 'wave',
    config = { extra = { amp = 0.5, positive = true } },
    rarity = 1,
    cost = 3,
    blueprint_compat = true,
    pos = { x = 4, y = 2 },
    atlas = 'jokers',
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.amp } }
    end,
    calculate = function(self, card, context)
        local config = card.ability.extra
        if context.joker_main then
            return {
                amp = card.ability.extra.positive and card.ability.extra.amp or -card.ability.extra.amp
            }
        end
        if context.after and not context.blueprint then
            card.ability.extra.positive = not card.ability.extra.positive
        end
    end
}
SMODS.Joker {
    key = "stonks",
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    atlas = 'jokers',
    pos = { x = 0, y = 3 },
    config = { extra = { amp = 0.1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.amp, card.ability.extra.amp * math.max(0, (G.GAME.dollars / 2 or 0) + (G.GAME.dollar_buffer or 0)) } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                amp = card.ability.extra.amp * math.max(0, (G.GAME.dollars + (G.GAME.dollar_buffer or 0)))
            }
        end
    end,
}
SMODS.Joker {
    key = "majestic",
    blueprint_compat = true,
    rarity = 1,
    cost = 3,
    atlas = 'jokers',
    pos = { x = 2, y = 3 },
    config = { extra = { mult = 12, type = 'ele_blaze' } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, localize(card.ability.extra.type, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}
SMODS.Joker {
    key = "deceitful",
    blueprint_compat = true,
    rarity = 1,
    cost = 3,
    atlas = 'jokers',
    pos = { x = 3, y = 3 },
    config = { extra = { chips = 80, type = 'ele_blaze' } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, localize(card.ability.extra.type, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}
SMODS.Joker {
    key = "court",
    blueprint_compat = true,
    rarity = 3,
    cost = 8,
    atlas = 'jokers',
    pos = { x = 4, y = 3 },
    config = { extra = { xmult = 3, type = 'ele_blaze' } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, localize(card.ability.extra.type, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}
SMODS.Joker {
    key = "glorious",
    blueprint_compat = true,
    rarity = 1,
    cost = 3,
    atlas = 'jokers',
    pos = { x = 1, y = 3 },
    config = { extra = { amp = 0.7, type = 'ele_blaze' } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.amp, localize(card.ability.extra.type, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
            return {
                amp = card.ability.extra.amp
            }
        end
    end
}