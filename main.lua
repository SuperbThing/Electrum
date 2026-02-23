SMODS.Atlas{
	key = "modicon",
	path = "modicon.png",
	px = 34,
	py = 34
}

assert(SMODS.load_file("items/amp.lua"))()
assert(SMODS.load_file("items/enhancers.lua"))()
assert(SMODS.load_file("items/metals.lua"))()
assert(SMODS.load_file("items/editions.lua"))()
assert(SMODS.load_file("items/backs.lua"))()
assert(SMODS.load_file("items/vouchers.lua"))()
assert(SMODS.load_file("items/tarots.lua"))()


function poll_metal_edition(_key, _mod, _no_poly)
    _mod = _mod or 1
    local edition_poll = pseudorandom(pseudoseed(_key or 'edition_generic'))
	if edition_poll > 1 - 0.003 * _mod * (G.GAME.used_vouchers.v_ele_crucible and 50 or 1) then
		return { negative = true }
	elseif edition_poll > 1 - 0.006 * G.GAME.edition_rate * _mod and not _no_poly then
		return { polychrome = true }
	end
    return nil
end

function create_metal(...)
    local card = create_card("metal", ...)
    local edition = poll_metal_edition("random_metal", 1, not (card.ability.extra and card.ability.extra > 0))
    card:set_edition(edition)
    return card
end
