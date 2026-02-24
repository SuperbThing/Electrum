SMODS.Atlas{
	key = "metals",
	path = "metals.png",
	px = 71,
	py = 95
}

SMODS.ConsumableType {
    key = 'Metal',
    default = 'c_ele_iron',
    primary_colour = G.C.METAL,
    secondary_colour = G.C.METAL,
    collection_rows = { 5, 5 },
    shop_rate = 2,
    select_card = "consumeables",
}

SMODS.Consumable {
    key = "iron",
    set = "Metal", 
	atlas = "metals",
    pos = { x = 0, y = 0 },
	config = {
		extra = {
			rounds_required = 3,
			rounds_held = 0,
			charged = false,
			last_round = -1
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			card.ability.extra.rounds_required,
			card.ability.extra.rounds_held
		} }
	end,

    can_use = function(self, card)
        return card.ability.extra.charged
    end,

    use = function(self, card, area, copier)
    	for i = 1, 1 do
    		G.E_MANAGER:add_event(Event({
    			func = (function()
    				add_tag(Tag("tag_double"))
    				play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
    				play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
    				return true
    			end)
    		}))
    		delay(0.2)
    	end
    	delay(0.6)
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.repetition then
            -- Make sure it's still in consumables
            if card.area == G.consumeables then
                -- Prevent multiple increments per round
                if card.ability.extra.last_round ~= G.GAME.round then
                    
                    card.ability.extra.last_round = G.GAME.round
                    
                    if not card.ability.extra.charged then
                        card.ability.extra.rounds_held =
                            card.ability.extra.rounds_held + 1

                        if card.ability.extra.rounds_held >=
                        card.ability.extra.rounds_required then
                            
                            card.ability.extra.charged = true
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('metal_ready')})
                        end
                    end
                end
            
            else
                -- Reset if removed
                card.ability.extra.rounds_held = 0
                card.ability.extra.charged = false
            end
        end
    end
}
SMODS.Consumable {
    key = "gold",
    set = "Metal", 
	atlas = "metals",
    pos = { x = 1, y = 0 },
	config = {
		max_highlighted = 2,
		extra = {
			rounds_required = 2,
			rounds_held = 0,
			charged = false,
			last_round = -1
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			card.ability.extra.rounds_required,
			card.ability.extra.rounds_held,
			card.ability.max_highlighted
		} }
	end,

    can_use = function(self, card)
        return card.ability.extra.charged
        	and G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.max_highlighted
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.hand.highlighted[i]:set_ability(G.P_CENTERS.m_gold)
                    return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.repetition then
            
            if card.area == G.consumeables then
                
                if card.ability.extra.last_round ~= G.GAME.round then
                    
                    card.ability.extra.last_round = G.GAME.round
                    
                    if not card.ability.extra.charged then
                        card.ability.extra.rounds_held =
                            card.ability.extra.rounds_held + 1

                        if card.ability.extra.rounds_held >=
                        card.ability.extra.rounds_required then
                            
                            card.ability.extra.charged = true
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('metal_ready')})
                        end
                    end
                end
            
            else
                
                card.ability.extra.rounds_held = 0
                card.ability.extra.charged = false
            end
        end
    end
}
SMODS.Consumable {
    key = "copper",
    set = "Metal", 
	atlas = "metals",
    pos = { x = 2, y = 0 },
	config = {
		extra = {
			rounds_required = 2,
			rounds_held = 0,
			charged = false,
			last_round = -1,
			metals = 2,
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			card.ability.extra.rounds_required,
			card.ability.extra.rounds_held,
			card.ability.extra.metals
		} }
	end,

    can_use = function(self, card)
        return card.ability.extra.charged
			and (G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit) or
            	(card.area == G.consumeables)
    end,

    use = function(self, card, area, copier)
        for i = 1, math.min(card.ability.extra.metals, G.consumeables.config.card_limit - #G.consumeables.cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani')
                        SMODS.add_card({ set = 'Metal' })
                        card:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        end
        delay(0.6)
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.repetition then
            if card.area == G.consumeables then
                if card.ability.extra.last_round ~= G.GAME.round then
                    card.ability.extra.last_round = G.GAME.round

                    if not card.ability.extra.charged then
                        card.ability.extra.rounds_held =
                            card.ability.extra.rounds_held + 1
                        if card.ability.extra.rounds_held >=
                        card.ability.extra.rounds_required then
                            card.ability.extra.charged = true
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('metal_ready')})
                        end
                    end
                end
            else
                card.ability.extra.rounds_held = 0
                card.ability.extra.charged = false
            end
        end
    end
}
SMODS.Consumable {
    key = "silver",
    set = "Metal", 
	atlas = "metals",
    pos = { x = 3, y = 0 },
	config = {
		max_highlighted = 3,
		extra = {
			rounds_required = 2,
			rounds_held = 0,
			charged = false,
			last_round = -1
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			card.ability.extra.rounds_required,
			card.ability.extra.rounds_held,
			card.ability.max_highlighted
		} }
	end,

    can_use = function(self, card)
        return card.ability.extra.charged
        	and G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.max_highlighted
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.hand.highlighted[i]:set_ability(G.P_CENTERS.m_lucky)
                    return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.repetition then
            
            if card.area == G.consumeables then
                
                if card.ability.extra.last_round ~= G.GAME.round then
                    
                    card.ability.extra.last_round = G.GAME.round
                    
                    if not card.ability.extra.charged then
                        card.ability.extra.rounds_held =
                            card.ability.extra.rounds_held + 1

                        if card.ability.extra.rounds_held >=
                        card.ability.extra.rounds_required then
                            
                            card.ability.extra.charged = true
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('metal_ready')})
                        end
                    end
                end
            
            else
                
                card.ability.extra.rounds_held = 0
                card.ability.extra.charged = false
            end
        end
    end
}
SMODS.Consumable {
    key = "lead",
    set = "Metal", 
	atlas = "metals",
    pos = { x = 4, y = 0 },
	config = {
		extra = {
			rounds_required = 4,
			rounds_held = 0,
			charged = false,
			last_round = -1
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			card.ability.extra.rounds_required,
			card.ability.extra.rounds_held
		} }
	end,

    can_use = function(self, card)
        return card.ability.extra.charged
    end,

    use = function(self, card, area, copier)
    	for i = 1, 1 do
    		G.E_MANAGER:add_event(Event({
    			func = (function()
    				add_tag(Tag("tag_negative"))
    				play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
    				play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
    				return true
    			end)
    		}))
    		delay(0.2)
    	end
    	delay(0.6)
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.repetition then
            
            if card.area == G.consumeables then
                
                if card.ability.extra.last_round ~= G.GAME.round then
                    
                    card.ability.extra.last_round = G.GAME.round
                    
                    if not card.ability.extra.charged then
                        card.ability.extra.rounds_held =
                            card.ability.extra.rounds_held + 1

                        if card.ability.extra.rounds_held >=
                        card.ability.extra.rounds_required then
                            
                            card.ability.extra.charged = true
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('metal_ready')})
                        end
                    end
                end
            
            else
                
                card.ability.extra.rounds_held = 0
                card.ability.extra.charged = false
            end
        end
    end
}
SMODS.Consumable {
    key = "zinc",
    set = "Metal", 
	atlas = "metals",
    pos = { x = 5, y = 0 },
	config = {
		extra = {
			rounds_required = 2,
			rounds_held = 0,
			charged = false,
			last_round = -1
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			card.ability.extra.rounds_required,
			card.ability.extra.rounds_held
		} }
	end,

    can_use = function(self, card)
        return card.ability.extra.charged
    end,

    use = function(self, card, area, copier)
    	for i = 1, 1 do
    		G.E_MANAGER:add_event(Event({
    			func = (function()
    				add_tag(Tag("tag_uncommon"))
    				play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
    				play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
    				return true
    			end)
    		}))
    		delay(0.2)
    	end
    	delay(0.6)
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.repetition then
            
            if card.area == G.consumeables then
                
                if card.ability.extra.last_round ~= G.GAME.round then
                    
                    card.ability.extra.last_round = G.GAME.round
                    
                    if not card.ability.extra.charged then
                        card.ability.extra.rounds_held =
                            card.ability.extra.rounds_held + 1

                        if card.ability.extra.rounds_held >=
                        card.ability.extra.rounds_required then
                            
                            card.ability.extra.charged = true
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('metal_ready')})
                        end
                    end
                end
            
            else
                
                card.ability.extra.rounds_held = 0
                card.ability.extra.charged = false
            end
        end
    end
}
SMODS.Consumable {
    key = "brass",
    set = "Metal", 
	atlas = "metals",
    pos = { x = 6, y = 0 },
	config = {
		extra = {
			rounds_required = 2,
			rounds_held = 0,
			charged = false,
			last_round = -1,
			Tarots = 1,
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			card.ability.extra.rounds_required,
			card.ability.extra.rounds_held,
			card.ability.extra.Tarots
		}}
	end,

    can_use = function(self, card)
        return card.ability.extra.charged
    end,
    use = function(self, card, area, copier)
        for i = 1, card.ability.extra.Tarots do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    SMODS.add_card({ set = 'Tarot', edition = 'e_negative' })
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
        delay(0.6)
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.repetition then
            
            if card.area == G.consumeables then

                if card.ability.extra.last_round ~= G.GAME.round then
                    
                    card.ability.extra.last_round = G.GAME.round
                    
                    if not card.ability.extra.charged then
                        card.ability.extra.rounds_held =
                            card.ability.extra.rounds_held + 1

                        if card.ability.extra.rounds_held >=
                        card.ability.extra.rounds_required then
                            
                            card.ability.extra.charged = true
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('metal_ready')})
                        end
                    end
                end
            
            else
                
                card.ability.extra.rounds_held = 0
                card.ability.extra.charged = false
            end
        end
    end
}
SMODS.Consumable {
    key = "steel",
    set = "Metal", 
	atlas = "metals",
    pos = { x = 7, y = 0 },
	config = {
		max_highlighted = 2,
		extra = {
			rounds_required = 2,
			rounds_held = 0,
			charged = false,
			last_round = -1
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			card.ability.extra.rounds_required,
			card.ability.extra.rounds_held,
			card.ability.max_highlighted
		} }
	end,

    can_use = function(self, card)
        return card.ability.extra.charged
        	and G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.max_highlighted
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.hand.highlighted[i]:set_ability(G.P_CENTERS.m_steel)
                    return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.repetition then
            
            if card.area == G.consumeables then
                
                if card.ability.extra.last_round ~= G.GAME.round then
                    
                    card.ability.extra.last_round = G.GAME.round
                    
                    if not card.ability.extra.charged then
                        card.ability.extra.rounds_held =
                            card.ability.extra.rounds_held + 1

                        if card.ability.extra.rounds_held >=
                        card.ability.extra.rounds_required then
                            
                            card.ability.extra.charged = true
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('metal_ready')})
                        end
                    end
                end
            
            else
                
                card.ability.extra.rounds_held = 0
                card.ability.extra.charged = false
            end
        end
    end
}
SMODS.Consumable {
    key = "rose_gold",
    set = "Metal", 
	atlas = "metals",
    pos = { x = 0, y = 1 },
	config = {
		max_highlighted = 1,
		extra = {
			rounds_required = 2,
			rounds_held = 0,
			charged = false,
			last_round = -1
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			card.ability.extra.rounds_required,
			card.ability.extra.rounds_held,
			card.ability.max_highlighted
		} }
	end,

    can_use = function(self, card)
        return card.ability.extra.charged
        	and G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.max_highlighted
    end,
    use = function(self, card, area, copier)
        local conv_card = G.hand.highlighted[1]
        local seals = {
            "Red",
            "Blue",
            "Gold",
            "Purple"
        }
        local random_seal = seals[math.random(#seals)]
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
    
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
                func = function()
                conv_card:set_seal(random_seal, nil, true)
                return true
            end
        }))
    
        delay(0.5)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
                func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.repetition then
            
            if card.area == G.consumeables then
                
                if card.ability.extra.last_round ~= G.GAME.round then
                    
                    card.ability.extra.last_round = G.GAME.round
                    
                    if not card.ability.extra.charged then
                        card.ability.extra.rounds_held =
                            card.ability.extra.rounds_held + 1

                        if card.ability.extra.rounds_held >=
                        card.ability.extra.rounds_required then
                            
                            card.ability.extra.charged = true
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('metal_ready')})
                        end
                    end
                end
            
            else
                
                card.ability.extra.rounds_held = 0
                card.ability.extra.charged = false
            end
        end
    end
}
SMODS.Consumable {
    key = "uranium",
    set = "Metal", 
	atlas = "metals",
    pos = { x = 1, y = 1 },
	config = {
		max_highlighted = 1,
		extra = {
			rounds_required = 3,
			rounds_held = 0,
			charged = false,
			last_round = -1,
            odds = 3,
		}
	},
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds,
            'ele_uranium')
        return { vars = { card.ability.extra.rounds_required, card.ability.extra.rounds_held, numerator, denominator } }
    end,

    can_use = function(self, card)
        return card.ability.extra.charged
        	and #G.jokers.highlighted == 1
    end,
    use = function(self, card, area, copier)
        if SMODS.pseudorandom_probability(card, 'ele_uranium', 1, card.ability.extra.odds) then
            local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)

            local eligible_card = G.jokers.highlighted[1]
            local edition = SMODS.poll_edition { key = "ele_uranium", guaranteed = true, no_negative = true, options = { 'e_polychrome', 'e_holo', 'e_foil' } }
            eligible_card:set_edition(edition, true)
            check_for_unlock({ type = 'have_edition' })
        else
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    attention_text({
                        text = localize('k_nope_ex'),
                        scale = 1.3,
                        hold = 1.4,
                        major = card,
                        backdrop_colour = G.C.METAL,
                        align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.metal_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
                            'tm' or 'cm',
                        offset = { x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.metal_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0 },
                        silent = true
                    })
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.06 * G.SETTINGS.GAMESPEED,
                        blockable = false,
                        blocking = false,
                        func = function()
                            play_sound('tarot2', 0.76, 0.4)
                            return true
                        end
                    }))
                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.repetition then
            
            if card.area == G.consumeables then
                
                if card.ability.extra.last_round ~= G.GAME.round then
                    
                    card.ability.extra.last_round = G.GAME.round
                    
                    if not card.ability.extra.charged then
                        card.ability.extra.rounds_held =
                            card.ability.extra.rounds_held + 1

                        if card.ability.extra.rounds_held >=
                        card.ability.extra.rounds_required then
                            
                            card.ability.extra.charged = true
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('metal_ready')})
                        end
                    end
                end
            
            else
                
                card.ability.extra.rounds_held = 0
                card.ability.extra.charged = false
            end
        end
    end
}
SMODS.Consumable {
    key = "platinum",
    set = "Metal", 
	atlas = "metals",
    pos = { x = 2, y = 1 },
	config = {
		max_highlighted = 2,
		extra = {
			rounds_required = 2,
			rounds_held = 0,
			charged = false,
			last_round = -1
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			card.ability.extra.rounds_required,
			card.ability.extra.rounds_held,
			card.ability.max_highlighted
		} }
	end,

    can_use = function(self, card)
        return card.ability.extra.charged
        	and G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.max_highlighted
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.hand.highlighted[i]:set_ability(G.P_CENTERS.m_glass)
                    return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.repetition then
            
            if card.area == G.consumeables then
                
                if card.ability.extra.last_round ~= G.GAME.round then
                    
                    card.ability.extra.last_round = G.GAME.round
                    
                    if not card.ability.extra.charged then
                        card.ability.extra.rounds_held =
                            card.ability.extra.rounds_held + 1

                        if card.ability.extra.rounds_held >=
                        card.ability.extra.rounds_required then
                            
                            card.ability.extra.charged = true
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('metal_ready')})
                        end
                    end
                end
            
            else
                
                card.ability.extra.rounds_held = 0
                card.ability.extra.charged = false
            end
        end
    end
}
SMODS.Consumable {
    key = "titanium",
    set = "Metal", 
	atlas = "metals",
    pos = { x = 3, y = 1 },
	config = {
		extra = {
			rounds_required = 2,
			rounds_held = 0,
			charged = false,
			last_round = -1,
            chops = 30
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			card.ability.extra.rounds_required,
			card.ability.extra.rounds_held,
			card.ability.extra.chops
		} }
	end,

    can_use = function(self, card)
        return card.ability.extra.charged
    end,

    use = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                local chops = card.ability.extra.chops or 30
                G.GAME.blind.chips = math.floor(G.GAME.blind.chips * (1 - chops / 100))
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)

                local chips_UI = G.hand_text_area.blind_chips
                G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
                G.HUD_blind:recalculate()
                chips_UI:juice_up()

                if not silent then play_sound('xchips') end
                
                if G.GAME.chips - G.GAME.blind.chips >= 0 then
                    G.STATE = G.STATES.HAND_PLAYED
                    G.STATE_COMPLETE = true
                    end_round()
                end
                
                return true
            end
        }))
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.repetition then
            
            if card.area == G.consumeables then
                
                if card.ability.extra.last_round ~= G.GAME.round then
                    
                    card.ability.extra.last_round = G.GAME.round
                    
                    if not card.ability.extra.charged then
                        card.ability.extra.rounds_held =
                            card.ability.extra.rounds_held + 1

                        if card.ability.extra.rounds_held >=
                        card.ability.extra.rounds_required then
                            
                            card.ability.extra.charged = true
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('metal_ready')})
                        end
                    end
                end
            
            else
                
                card.ability.extra.rounds_held = 0
                card.ability.extra.charged = false
            end
        end
    end
}
SMODS.Consumable {
    key = "bronze",
    set = "Metal", 
	atlas = "metals",
    pos = { x = 4, y = 1 },
	config = {
		extra = {
			rounds_required = 2,
			rounds_held = 0,
			charged = false,
			last_round = -1,
            cards = 3
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			card.ability.extra.rounds_required,
			card.ability.extra.rounds_held,
			card.ability.extra.cards
		} }
	end,

    can_use = function(self, card)
        return card.ability.extra.charged
    end,

    use = function(self, card, area, copier)
    	for i = 1, 1 do
    		G.E_MANAGER:add_event(Event({
    			func = (function()
    				add_tag(Tag("tag_d_six"))
    				play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
    				play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
    				return true
    			end)
    		}))
    		delay(0.2)
    	end
    	delay(0.6)
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.repetition then
            
            if card.area == G.consumeables then
                
                if card.ability.extra.last_round ~= G.GAME.round then
                    
                    card.ability.extra.last_round = G.GAME.round
                    
                    if not card.ability.extra.charged then
                        card.ability.extra.rounds_held =
                            card.ability.extra.rounds_held + 1

                        if card.ability.extra.rounds_held >=
                        card.ability.extra.rounds_required then
                            
                            card.ability.extra.charged = true
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('metal_ready')})
                        end
                    end
                end
            
            else
                
                card.ability.extra.rounds_held = 0
                card.ability.extra.charged = false
            end
        end
    end
}
SMODS.Consumable {
    key = "bismuth",
    set = "Metal", 
	atlas = "metals",
    pos = { x = 5, y = 1 },
	config = {
		extra = {
			rounds_required = 3,
			rounds_held = 0,
			charged = false,
			last_round = -1
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			card.ability.extra.rounds_required,
			card.ability.extra.rounds_held
		} }
	end,

    can_use = function(self, card)
        return card.ability.extra.charged
    end,

    use = function(self, card, area, copier)
        local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)
        local jonkler = pseudorandom_element(editionless_jokers, 'ele_bismuth')
        jonkler:set_edition("e_polychrome", true)
        check_for_unlock({ type = 'have_edition' })
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.repetition then
            
            if card.area == G.consumeables then
                
                if card.ability.extra.last_round ~= G.GAME.round then
                    
                    card.ability.extra.last_round = G.GAME.round
                    
                    if not card.ability.extra.charged then
                        card.ability.extra.rounds_held =
                            card.ability.extra.rounds_held + 1

                        if card.ability.extra.rounds_held >=
                        card.ability.extra.rounds_required then
                            
                            card.ability.extra.charged = true
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('metal_ready')})
                        end
                    end
                end
            
            else
                
                card.ability.extra.rounds_held = 0
                card.ability.extra.charged = false
            end
        end
    end
}
SMODS.Consumable {
    key = "cobalt",
    set = "Metal", 
	atlas = "metals",
    pos = { x = 7, y = 1 },
	config = {
		extra = {
			rounds_required = 2,
			rounds_held = 0,
			charged = false,
			last_round = -1
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			card.ability.extra.rounds_required,
			card.ability.extra.rounds_held
		} }
	end,

    can_use = function(self, card)
        return card.ability.extra.charged
    end,

    use = function(self, card, area, copier)
        local most_played = G.GAME.current_round.most_played_poker_hand
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(most_played, 'poker_hands'),chips = G.GAME.hands[most_played].chips, mult = G.GAME.hands[most_played].mult, level=G.GAME.hands[most_played].level})
        level_up_hand(card, most_played, nil, card.ability.extra.level)
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
        delay(0.6)
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.repetition then
            
            if card.area == G.consumeables then
                
                if card.ability.extra.last_round ~= G.GAME.round then
                    
                    card.ability.extra.last_round = G.GAME.round
                    
                    if not card.ability.extra.charged then
                        card.ability.extra.rounds_held =
                            card.ability.extra.rounds_held + 1

                        if card.ability.extra.rounds_held >=
                        card.ability.extra.rounds_required then
                            
                            card.ability.extra.charged = true
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('metal_ready')})
                        end
                    end
                end
            
            else
                
                card.ability.extra.rounds_held = 0
                card.ability.extra.charged = false
            end
        end
    end
}
SMODS.Consumable {
    key = "tin",
    set = "Metal", 
	atlas = "metals",
    pos = { x = 0, y = 2 },
	config = {
		max_highlighted = 2,
		extra = {
			rounds_required = 2,
			rounds_held = 0,
			charged = false,
			last_round = -1
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			card.ability.extra.rounds_required,
			card.ability.extra.rounds_held,
			card.ability.max_highlighted
		} }
	end,

    can_use = function(self, card)
        return card.ability.extra.charged
        	and G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.max_highlighted
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.hand.highlighted[i]:set_ability(G.P_CENTERS.m_ele_cardboard)
                    return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.repetition then
            
            if card.area == G.consumeables then
                
                if card.ability.extra.last_round ~= G.GAME.round then
                    
                    card.ability.extra.last_round = G.GAME.round
                    
                    if not card.ability.extra.charged then
                        card.ability.extra.rounds_held =
                            card.ability.extra.rounds_held + 1

                        if card.ability.extra.rounds_held >=
                        card.ability.extra.rounds_required then
                            
                            card.ability.extra.charged = true
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('metal_ready')})
                        end
                    end
                end
            
            else
                
                card.ability.extra.rounds_held = 0
                card.ability.extra.charged = false
            end
        end
    end
}
SMODS.Consumable {
    key = "aluminum",
    set = "Metal", 
	atlas = "metals",
    pos = { x = 1, y = 2 },
	config = {
        max_highlighted = 1,
		extra = {
			rounds_required = 2,
			rounds_held = 0,
			charged = false,
			last_round = -1
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			card.ability.extra.rounds_required,
			card.ability.extra.rounds_held
		} }
	end,

    can_use = function(self, card)
        return card.ability.extra.charged
            and #G.hand.highlighted >= 1
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.4,
        func = function()
            local edition = "e_foil"
            local card = G.hand.highlighted[1]
            card:set_edition(edition, true)
            card:juice_up(0.3, 0.5)
            return true
            end
        }))
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.repetition then
            
            if card.area == G.consumeables then
                
                if card.ability.extra.last_round ~= G.GAME.round then
                    
                    card.ability.extra.last_round = G.GAME.round
                    
                    if not card.ability.extra.charged then
                        card.ability.extra.rounds_held =
                            card.ability.extra.rounds_held + 1

                        if card.ability.extra.rounds_held >=
                        card.ability.extra.rounds_required then
                            
                            card.ability.extra.charged = true
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('metal_ready')})
                        end
                    end
                end
            
            else
                
                card.ability.extra.rounds_held = 0
                card.ability.extra.charged = false
            end
        end
    end
}
SMODS.Consumable {
    key = "tungsten",
    set = "Metal", 
	atlas = "metals",
    pos = { x = 4, y = 2 },
	config = {
		extra = {
			rounds_required = 5,
			rounds_held = 0,
			charged = false,
			last_round = -1,
            Tags = 3,
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			card.ability.extra.rounds_required,
			card.ability.extra.rounds_held,
			card.ability.extra.Tags
		} }
	end,

    can_use = function(self, card)
        return card.ability.extra.charged
    end,
    use = function(self, card, area, copier)
    
        G.E_MANAGER:add_event(Event({
            func = (function()
                for i = 1, card.ability.extra.Tags do
                local tag_key = get_next_tag_key()
                while tag_key == 'tag_orbital' do
                -- nope!
                tag_key = get_next_tag_key()
                end
                add_tag(Tag(tag_key))
                end
                return true
            end),
        }))
        delay(0.6)
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.repetition then
            
            if card.area == G.consumeables then
                
                if card.ability.extra.last_round ~= G.GAME.round then
                    
                    card.ability.extra.last_round = G.GAME.round
                    
                    if not card.ability.extra.charged then
                        card.ability.extra.rounds_held =
                            card.ability.extra.rounds_held + 1

                        if card.ability.extra.rounds_held >=
                        card.ability.extra.rounds_required then
                            
                            card.ability.extra.charged = true
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('metal_ready')})
                        end
                    end
                end
            
            else
                
                card.ability.extra.rounds_held = 0
                card.ability.extra.charged = false
            end
        end
    end
}
SMODS.Consumable {
    key = "iridium",
    set = "Metal", 
	atlas = "metals",
    pos = { x = 5, y = 2 },
	config = {
		extra = {
			rounds_required = 3,
			rounds_held = 0,
			charged = false,
			last_round = -1
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			card.ability.extra.rounds_required,
			card.ability.extra.rounds_held
		} }
	end,

    can_use = function(self, card)
        return card.ability.extra.charged
    end,

    use = function(self, card, area, copier)
        local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)
        local jonkler = pseudorandom_element(editionless_jokers, 'ele_bismuth')
        jonkler:set_edition("e_ele_iridescent", true)
        check_for_unlock({ type = 'have_edition' })
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.repetition then
            
            if card.area == G.consumeables then
                
                if card.ability.extra.last_round ~= G.GAME.round then
                    
                    card.ability.extra.last_round = G.GAME.round
                    
                    if not card.ability.extra.charged then
                        card.ability.extra.rounds_held =
                            card.ability.extra.rounds_held + 1

                        if card.ability.extra.rounds_held >=
                        card.ability.extra.rounds_required then
                            
                            card.ability.extra.charged = true
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('metal_ready')})
                        end
                    end
                end
            
            else
                
                card.ability.extra.rounds_held = 0
                card.ability.extra.charged = false
            end
        end
    end
}
SMODS.Consumable {
    key = "electrum",
    set = "Metal", 
	atlas = "metals",
    pos = { x = 6, y = 2 },
	config = {
		extra = {
			rounds_required = 5,
			rounds_held = 0,
			charged = false,
			last_round = -1
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			card.ability.extra.rounds_required,
			card.ability.extra.rounds_held
		} }
	end,

    can_use = function(self, card)
        return card.ability.extra.charged
    end,

    use = function(self, card, area, copier)
        local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)
        local jonkler = pseudorandom_element(editionless_jokers, 'ele_bismuth')
        jonkler:set_edition("e_negative", true)
        check_for_unlock({ type = 'have_edition' })
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.repetition then
            
            if card.area == G.consumeables then
                
                if card.ability.extra.last_round ~= G.GAME.round then
                    
                    card.ability.extra.last_round = G.GAME.round
                    
                    if not card.ability.extra.charged then
                        card.ability.extra.rounds_held =
                            card.ability.extra.rounds_held + 1

                        if card.ability.extra.rounds_held >=
                        card.ability.extra.rounds_required then
                            
                            card.ability.extra.charged = true
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('metal_ready')})
                        end
                    end
                end
            
            else
                
                card.ability.extra.rounds_held = 0
                card.ability.extra.charged = false
            end
        end
    end
}
SMODS.Consumable {
    key = "netherite",
    set = "Spectral", 
	atlas = "metals",
    hidden = true,
    soul_set = 'Metal',
    pos = { x = 7, y = 2 },
	config = {
		extra = {
			rounds_required = 3,
			rounds_held = 0,
			charged = false,
			last_round = -1,
            slot = 1
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			card.ability.extra.rounds_required,
			card.ability.extra.rounds_held,
			card.ability.extra.slot
		} }
	end,

    can_use = function(self, card)
        return card.ability.extra.charged
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.jokers then
                G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slot
                end
                return true
            end,
        }))
        delay(0.5)
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.repetition then
            
            if card.area == G.consumeables then
                
                if card.ability.extra.last_round ~= G.GAME.round then
                    
                    card.ability.extra.last_round = G.GAME.round
                    
                    if not card.ability.extra.charged then
                        card.ability.extra.rounds_held =
                            card.ability.extra.rounds_held + 1

                        if card.ability.extra.rounds_held >=
                        card.ability.extra.rounds_required then
                            
                            card.ability.extra.charged = true
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('metal_ready')})
                        end
                    end
                end
            
            else
                
                card.ability.extra.rounds_held = 0
                card.ability.extra.charged = false
            end
        end
    end
}
SMODS.Booster {
    key = "metal_normal_1",
    weight = 1,
    kind = 'Metal',
    cost = 4,
    atlas = 'metals',
    pos = { x = 0, y = 3 },
    config = { extra = 2, choose = 1 },
    group_key = "k_metal_pack",
    draw_hand = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra },
            key = self.key:sub(1, -3),
        }
    end,
        ease_background_colour = function(self)
            ease_colour(G.C.DYN_UI.MAIN, G.C.METAL)
            ease_background_colour { new_colour = G.C.METAL, special_colour = darken(G.C.METAL, 0.5), contrast = 3 }
        end,
    create_card = function(self, card, i)
        return {
            set = "Metal",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append =
            "ele_met"
        }
    end,
}
SMODS.Booster {
    key = "metal_normal_2",
    weight = 1,
    kind = 'Metal',
    cost = 4,
    atlas = 'metals',
    pos = { x = 1, y = 3 },
    config = { extra = 2, choose = 1 },
    group_key = "k_metal_pack",
    draw_hand = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra },
            key = self.key:sub(1, -3),
        }
    end,
        ease_background_colour = function(self)
            ease_colour(G.C.DYN_UI.MAIN, G.C.METAL)
            ease_background_colour { new_colour = G.C.METAL, special_colour = darken(G.C.METAL, 0.5), contrast = 3 }
        end,
    create_card = function(self, card, i)
        return {
            set = "Metal",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append =
            "ele_met"
        }
    end,
}
SMODS.Booster {
    key = "metal_normal_3",
    weight = 1,
    kind = 'Metal',
    cost = 4,
    atlas = 'metals',
    pos = { x = 2, y = 3 },
    config = { extra = 2, choose = 1 },
    group_key = "k_metal_pack",
    draw_hand = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra },
            key = self.key:sub(1, -3),
        }
    end,
        ease_background_colour = function(self)
            ease_colour(G.C.DYN_UI.MAIN, G.C.METAL)
            ease_background_colour { new_colour = G.C.METAL, special_colour = darken(G.C.METAL, 0.5), contrast = 3 }
        end,
    create_card = function(self, card, i)
        return {
            set = "Metal",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append =
            "ele_met"
        }
    end,
}
SMODS.Booster {
    key = "metal_normal_4",
    weight = 1,
    kind = 'Metal',
    cost = 4,
    atlas = 'metals',
    pos = { x = 3, y = 3 },
    config = { extra = 2, choose = 1 },
    group_key = "k_metal_pack",
    draw_hand = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra },
            key = self.key:sub(1, -3),
        }
    end,
        ease_background_colour = function(self)
            ease_colour(G.C.DYN_UI.MAIN, G.C.METAL)
            ease_background_colour { new_colour = G.C.METAL, special_colour = darken(G.C.METAL, 0.5), contrast = 3 }
        end,
    create_card = function(self, card, i)
        return {
            set = "Metal",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append =
            "ele_met"
        }
    end,
}
SMODS.Booster {
    key = "metal_jumbo_1",
    weight = 1,
    kind = 'Metal',
    cost = 6,
    atlas = 'metals',
    pos = { x = 4, y = 3 },
    config = { extra = 4, choose = 1 },
    group_key = "k_metal_pack",
    draw_hand = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra },
            key = self.key:sub(1, -3),
        }
    end,
        ease_background_colour = function(self)
            ease_colour(G.C.DYN_UI.MAIN, G.C.METAL)
            ease_background_colour { new_colour = G.C.METAL, special_colour = darken(G.C.METAL, 0.5), contrast = 3 }
        end,
    create_card = function(self, card, i)
        return {
            set = "Metal",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append =
            "ele_met"
        }
    end,
}
SMODS.Booster {
    key = "metal_jumbo_2",
    weight = 1,
    kind = 'Metal',
    cost = 6,
    atlas = 'metals',
    pos = { x = 5, y = 3 },
    config = { extra = 4, choose = 1 },
    group_key = "k_metal_pack",
    draw_hand = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra },
            key = self.key:sub(1, -3),
        }
    end,
        ease_background_colour = function(self)
            ease_colour(G.C.DYN_UI.MAIN, G.C.METAL)
            ease_background_colour { new_colour = G.C.METAL, special_colour = darken(G.C.METAL, 0.5), contrast = 3 }
        end,
    create_card = function(self, card, i)
        return {
            set = "Metal",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append =
            "ele_met"
        }
    end,
}
SMODS.Booster {
    key = "metal_mega_1",
    weight = 0.25,
    kind = 'Metal',
    cost = 8,
    atlas = 'metals',
    pos = { x = 6, y = 3 },
    config = { extra = 4, choose = 2 },
    group_key = "k_metal_pack",
    draw_hand = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra },
            key = self.key:sub(1, -3),
        }
    end,
        ease_background_colour = function(self)
            ease_colour(G.C.DYN_UI.MAIN, G.C.METAL)
            ease_background_colour { new_colour = G.C.METAL, special_colour = darken(G.C.METAL, 0.2), contrast = 3 }
        end,
    create_card = function(self, card, i)
        return {
            set = "Metal",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append =
            "ele_met"
        }
    end,
}
SMODS.Booster {
    key = "metal_mega_2",
    weight = 0.25,
    kind = 'Metal',
    cost = 8,
    atlas = 'metals',
    pos = { x = 7, y = 3 },
    config = { extra = 4, choose = 2 },
    group_key = "k_metal_pack",
    draw_hand = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra },
            key = self.key:sub(1, -3),
        }
    end,
        ease_background_colour = function(self)
            ease_colour(G.C.DYN_UI.MAIN, G.C.METAL)
            ease_background_colour { new_colour = G.C.METAL, special_colour = darken(G.C.METAL, 0.5), contrast = 3 }
        end,
    create_card = function(self, card, i)
        return {
            set = "Metal",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append =
            "ele_met"
        }
    end,
}