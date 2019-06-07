-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

local M = {}

function M.new(q, r, s)
	assert(q+r+s==0,string.format("Construct error: [%d, %d, %d]",q,r,s))
	return {q=q, r=r, s=s}
end

function M.equal(a, b)
	if (a.q == b.q and a.r == b.r and a.s == b.s) then
		return true 
	end
	return false 
end

function M.add(a,b)
	return M.new(a.q + b.q, a.r + b.r, a.s + b.s)
end

function M.substract(a,b)
	return M.new(a.q - b.q, a.r - b.r, a.s - b.s)
end

function M.scale(a,k)
	return M.new(a.q * k, a.r * k, a.s * k)
end

directions = {
	M.new(1, 0, -1), 
	M.new(1, -1, 0), 
	M.new(0, -1, 1), 
	M.new(-1, 0, 1), 
	M.new(-1, 1, 0), 
	M.new(0, 1, -1)
}

function M.neighbor(a, d)
	assert((0 < d and d < 7), "Incorrect directon. Direction must be in 1 to 6")
	return M.add(a, directions[d])
end

function M.length (a)
	return math.floor((math.abs(a.q) + math.abs(a.r) + math.abs(a.s)) / 2)
end

function M.distance (a, b)
	return M.length(M.substract(a, b))
end

function M.round (h)
	local qi = math.floor(math.floor (0.5 + h.q))
	local ri = math.floor(math.floor (0.5 + h.r))
	local si = math.floor(math.floor (0.5 + h.s))
	local q_diff = math.abs(qi - h.q)
	local r_diff = math.abs(ri - h.r)
	local s_diff = math.abs(si - h.s)
	if q_diff > r_diff and q_diff > s_diff then
		qi = -ri - si
	else
		if r_diff > s_diff then
			ri = -qi - si
		else
			si = -qi - ri
		end
	end
	return M.new(qi, ri, si)
end

function M.lerp(a, b, t)
	return M.new(a.q * (1.0 - t) + b.q * t, a.r * (1.0 - t) + b.r * t, a.s * (1.0 - t) + b.s * t)
end

function M.rotate_left(a)
	return M.new(-a.s, -a.q, -a.r)
end

function M.equal_array(a,b)
	for i = 0, #a - 1 do
		if M.equal(a[1+i], b[1+i]) == false then
			return false
		end
	end
	return true
end

function M.linedraw (a, b)
	local N = M.distance(a, b)
	local a_nudge = M.new(a.q + 0.000001, a.r + 0.000001, a.s - 0.000002)
	local b_nudge = M.new(b.q + 0.000001, b.r + 0.000001, b.s - 0.000002)
	local results = {}
	local step = 1.0 / math.max(N, 1)
	for i = 0, N do
		table.insert(results, M.round(M.lerp(a_nudge, b_nudge, step * i)))
	end
	return results
end

function M.range(a, r)
	local results = {}
	for i = -r,r do
		for j = math.max(-r, -i - r), math.min(r, -i + r) do
			local s = -i-j
			table.insert(results, M.add(a, M.new(i, j, s)))
		end
	end
	return results
end

function M.intersecting_range(a, b, r)
	local results = {}
	local q_min = math.max(a.q - r, b.q - r)
	local q_max = math.min(a.q + r, b.q + r)
	local r_min = math.max(a.r - r, b.r - r)
	local r_max = math.min(a.r + r, b.r + r)
	local s_min = math.max(a.s - r, b.s - r)
	local s_max = math.min(a.s + r, b.s + r)
	
	for i = q_min,q_max do
		for j = math.max(r_min, -i - s_max),math.min(r_max, -i - s_min) do
			local s = -i-j
			table.insert(results, M.new(i, j, s))
		end
	end
	return results
end

function M.ring(h, r)
	local results = {}
	local hex = M.add(h, M.scale(directions[5], r))
	for i = 1, 6 do 
		for j = 0, r-1 do
			table.insert(results, hex)
			hex = M.neighbor(hex, i)
		end
	end
	return results
end

function M.spiral(h, r)
	local results = {h}
	for k = 1, r do
		for _, j in pairs(M.ring(h, k)) do
			table.insert(results, j)
		end
	end
	return results
end

return M