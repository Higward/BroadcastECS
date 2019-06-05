-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

local hex = require "main.utils.hexagon"
local layout = require "main.utils.layout"

function t1()
	local mid = hex.new(0, 0, 0)
	local a = hex.new(-1,0,1)
	local samefirst = hex.new(-1,0,1)
	local b = hex.new(3,0,-3)
	
	assert(hex.equal(a, samefirst),"Equal error")
	assert(hex.equal(hex.new(2, 0, -2), hex.add(a, b)))
	assert(hex.equal(hex.new(-4, 0, 4), hex.substract(a, b)))
	assert(hex.equal(hex.new(-2, 0, 2), hex.scale(a, 2)))
	assert(hex.equal(hex.new(0, -1, 1), hex.neighbor(a, 2)))
	assert(1 == hex.length(a))
	assert(4 == hex.distance(a, b))

	local r = {hex.new(0, -1, 1)}
	for i = 1, 5 do
		table.insert(r, hex.rotate_left(r[i]))
	end
	table.insert(r, mid)
	
	local r2 = hex.range(mid, 1)
	-- for _,k in pairs(r2) do 
	-- 	pprint(string.format("--[%d, %d, %d]", k.q, k.r, k.s))
	-- end
	local r3 = hex.intersecting_range(a, b, 1)
	assert(hex.equal(r3, {}))
	local r4 = hex.intersecting_range(mid, mid, 1)
	assert(hex.equal(r4, r2))
end

function t2()
	local l = layout.hex_layout_new(layout_flat, layout.point(1, 1), layout.point(0, 0))
	local l2 = layout.pixel_to_hex(l, layout.point(0, 1))
	
	assert(hex.equal(hex.new(0, 1, -1),hex.round(l2)))
end

t1()
t2()