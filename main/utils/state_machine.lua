-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.
local state = require "main.utils.state"

local M = {}
local Transition = {
	none = {},
	pop = {},
	push = {},
	switch = {},
	quit = {}
}

function M.create()
	local running = false
	
	local states = {}

	local current_state = nil
	local state_counter = 0
	
	function is_running()
		return self.running
	end
	
	function start(state) 
		assert( not current_state, "FSM already started")
		assert( state, "Provide state")
		current_state = state
		current_state.on_start()
	end

	function push(state)
		assert(state, "Provide state")
		assert(not state_stack[state], ("State %s already exists"):format(tostring(state)))
	end
end
		