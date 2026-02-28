SMODS.Atlas{
	key = "modicon",
	path = "modicon.png",
	px = 34,
	py = 34
}

G.C.AMP = HEX('fda200')
G.C.METAL = HEX('d4b79b')
SMODS.Gradient {
    key = 'mump',
    colours = {
        HEX('FE5F55'), HEX('FDA200')
    },
    cycle = 5,
    interpolation = 'trig'
}

assert(SMODS.load_file("items/amp.lua"))()
assert(SMODS.load_file("items/enhancers.lua"))()
assert(SMODS.load_file("items/metals.lua"))()
assert(SMODS.load_file("items/editions.lua"))()
assert(SMODS.load_file("items/backs.lua"))()
assert(SMODS.load_file("items/vouchers.lua"))()
assert(SMODS.load_file("items/tarots.lua"))()
assert(SMODS.load_file("items/jokers.lua"))()
assert(SMODS.load_file("items/blinds.lua"))()
assert(SMODS.load_file("items/poker_hands.lua"))()
assert(SMODS.load_file("items/planets.lua"))()
assert(SMODS.load_file("items/tags.lua"))()

if next(SMODS.find_mod("CardSleeves")) then
    assert(SMODS.load_file("crossmod/sleeves.lua"))()
end

-- if next(SMODS.find_mod("Bunco")) then
--     assert(SMODS.load_file("crossmod/spectrum.lua"))()
-- end


