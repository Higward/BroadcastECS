-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.
local hex = require "main.utils.hexagon"

local M = {}

local function Point(x, y)
	return {x=x, y=y}
end

function M.point(x, y)
	return Point(x, y)
end

local function Orientation(f0, f1, f2, f3, b0, b1, b2, b3, start_angle)
	return {f0 = f0, f1 = f1, f2 = f2, f3 = f3, b0 = b0, b1 = b1, b2 = b2, b3 = b3, start_angle = start_angle}
end

layout_pointy = Orientation(math.sqrt(3.0), math.sqrt(3.0) / 2.0, 0.0, 3.0 / 2.0, math.sqrt(3.0) / 3.0, -1.0 / 3.0, 0.0, 2.0 / 3.0, 0.5)
layout_flat = Orientation(3.0 / 2.0, 0.0, math.sqrt(3.0) / 2.0, math.sqrt(3.0), 2.0 / 3.0, 0.0, -1.0 / 3.0, math.sqrt(3.0) / 3.0, 0.0)

-- @orientation : pointy top (layout_pointy) or flat top(layout_flat) orientarion of grid   
-- @size : Point(x, y) - size of pixel art, not of the hexagon
-- @origin : Point(x, y) - center of layout
function M.hex_layout_new(orientation, size, origin)
	return {orientation = orientation, size = Point(size.x, size.y), origin = Point(origin.x, origin.y)}
end

-- @layout : 
-- @h : Hex
function M.hex_to_pixel(layout, h)
	local o = layout.orientation
	local size = layout.size
	local origin = layout.origin
	local x = (o.f0 * h.q + o.f1 * h.r) * size.x
	local y = (o.f2 * h.q + o.f3 * h.r) * size.y
	return Point(x + origin.x, y + origin.y)
end

-- Where center-hex in 0, 0
function M.pixel_to_hex (layout, p)
	local o = layout.orientation
	local size = layout.size
	local origin = layout.origin
	
	local pt = Point((p.x - origin.x) / size.x, (p.y - origin.y) / size.y)
	local q = o.b0 * pt.x + o.b1 * pt.y
	local r = o.b2 * pt.x + o.b3 * pt.y
	return hex.new(q, r, -q -r)
end

return M