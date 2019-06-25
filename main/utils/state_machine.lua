-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.
local state = require "main.utils.state"

	local running = false

	local M = {}
	local Transition = {
		none = {},
		pop = {},
		push = {},
		switch = {},
		quit = {}
	}

function M.create()
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
		assert(not states[state], ("State %s already exists"):format(tostring(state)))
		current_state.on_pause()
		current_state = state
		state_counter = state_counter + 1
		table.insert(states, state)
		current_state.on_start()
	end

	function pop(state)
		assert(state, "Provide state")
		current_state.on_quit()
		table.remove(states)
		if state_counter > 0 then
			current_state = states
			state_counter = state_counter-1
			current_state.on_resume()
		end
	end

	function quit()
		current_state.on_quit()
		states = {}
	end

	function switch(state)
		assert(state, "Provide state")
		current_state.on_quit()
		current_state = state
		current_state.on_start()
	end
end
		