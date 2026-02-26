SMODS.Sound{
    key = "sfx_amp",
    path = "amp_old.ogg",
}
SMODS.Sound{
    key = "sfx_xamp",
    path = "xamp.ogg",
}

SMODS.Scoring_Parameter({
  key = 'amp',
  default_value = G.GAME and G.GAME.ampvalue or 1,
  colour = G.C.AMP,
  calculation_keys = {'amp', 'xamp'},
    calc_effect = function(self, effect, scored_card, key, amount, from_edition)
		if not SMODS.Calculation_Controls.chips then return end
	    if key == 'amp' and amount then
	        if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
	        self:modify(amount)
	        card_eval_status_text(scored_card, 'extra', nil, percent, nil,
	            {sound = "ele_sfx_amp", message = localize{type = 'variable', key = amount > 0 and 'a_chips' or 'a_chips_minus', vars = {amount..' Amp'}}, colour = self.colour})
	        return true
        end
        if key == 'xamp' and amount then
            if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
            self:modify(self.current * (amount))
            card_eval_status_text(scored_card, 'extra', nil, percent, nil,
                {sound = "ele_sfx_xamp", message = localize{type = 'variable', key = amount > 0 and 'a_chips' or 'a_chips_minus', vars = {'X'..amount}}, colour = self.colour})
            return true
        end
    end
})
SMODS.Scoring_Calculation{
    key = "amp",
    func = function(self, chips, mult, flames)
	    return chips * mult * SMODS.get_scoring_parameter(self.mod.prefix..'_amp', flames)
	end,
    parameters = {'chips', 'mult', SMODS.current_mod.prefix..'_amp'},
    replace_ui = function (self) --[[@overload fun(self): table]]
        local w = 1.28
        local h = 0.75
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
            {n=G.UIT.C, config={align = 'cm'}, nodes = { 
                SMODS.GUI.operator(0.3)
            }},
            {n=G.UIT.C, config={align = 'cm'}, nodes = { 
                {n=G.UIT.R, config={align = 'cm', id = 'hand_mult'}, nodes={
                    SMODS.GUI.score_container({
                        type = 'mult',
                        align = 'cm',
                        w = w,
                        h = h,
						scale = scale,
                    })
                }},
            }},
			{n=G.UIT.C, config={align = "cl", id = 'hand_operator_container'}, nodes={
				{n=G.UIT.T, config={text = "X", scale = 0.6, colour = G.C.ORANGE, shadow = true}},
			}},
            {n=G.UIT.C, config={align = 'cm'}, nodes = { 
			{n=G.UIT.R, config={align = 'cl', id = 'hand_ele_amp'}, nodes={
				SMODS.GUI.score_container({
					type = 'ele_amp',
					align = 'cl',
					w = w,
					h = h,
					scale = scale
				})
			}},
        }},
	}}
    end
}
local start_run_ref = Game.start_run
function Game:start_run(args)
    local ret = start_run_ref(self, args)
    SMODS.set_scoring_calculation("ele_amp")
    return ret
end