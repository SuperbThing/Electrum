SMODS.Scoring_Calculation{
    key = "nuclear_amp",
    func = function(self, chips, mult, flames)
	    return (chips ^ mult) * SMODS.get_scoring_parameter(self.mod.prefix..'_amp', flames)
	end,
    parameters = {'chips', 'mult', SMODS.current_mod.prefix..'_amp'},
    replace_ui = function (self) 
        local w = 1.45
        local h = 0.8
		local scale = 0.3
        return
        {n=G.UIT.R, config={align = "cm", minh = 1, padding = 0.1}, nodes={
            {n=G.UIT.C, config={align = 'cm'}, nodes = { 
                {n=G.UIT.R, config={align = 'cm', id = 'hand_chips'}, nodes={
                    SMODS.GUI.score_container({
                        type = 'chips',
                        text = 'chip_text',
                        align = 'cr',
                        w = w,
                        h = h,
						scale = scale,
                    })
                }},
            }},
			{n=G.UIT.C, config={align = "cl", id = 'hand_operator_container'}, nodes={
				{n=G.UIT.T, config={text = "^", scale = scale*1.6, colour = G.C.UI_MULT, shadow = true}},
			}},
            {n=G.UIT.C, config={align = 'cm'}, nodes = { 
                {n=G.UIT.R, config={align = 'cm', id = 'hand_mult'}, nodes={
                    SMODS.GUI.score_container({
                        type = 'mult',
                        align = 'cl',
                        w = w,
                        h = h,
						scale = scale,
                    })
                }},
            }},
			{n=G.UIT.C, config={align = "cl", id = 'hand_operator_container'}, nodes={
				{n=G.UIT.T, config={text = "X", scale = scale*1.25, colour = G.C.AMP, shadow = true}},
			}},
            {n=G.UIT.C, config={align = 'cm'}, nodes = { 
                {n=G.UIT.R, config={align = 'cl', id = 'hand_ele_amp'}, nodes={
                    SMODS.GUI.score_container({
                        type = 'ele_amp',
                        align = 'cl',
                        w = 0.9,
                        h = h,
                        scale = scale
                    })
                }},
            }},
        }}
    end
}
SMODS.Back:take_ownership('mxms_nuclear',
    { -- ctrl+v from the deck
        apply = function(self, back)
            --Change blind scaling
            G.GAME.modifiers.mxms_nuclear_size = true

            --Change scoring calc method
            G.E_MANAGER:add_event(Event({
                func = function()
                    -- replace it with the amp one
                    SMODS.set_scoring_calculation('ele_nuclear_amp')
                    return true;
                end
            }))

            --Change joker slots
            G.GAME.starting_params.joker_slots = G.GAME.starting_params.joker_slots - 4

                -- Following values for mid-run deck applying (crossmod)
            if G.jokers then
                G.jokers:change_size(-4)
            end
        end
    },
    true -- silent | suppresses mod badge
)