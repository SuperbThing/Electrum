SMODS.Atlas{
	key = "modicon",
	path = "modicon.png",
	px = 34,
	py = 34
}

G.C.AMP = HEX('fda200')
G.C.METAL = HEX('d4b79b')

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


