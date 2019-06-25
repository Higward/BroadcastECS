-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.
local M = {}

function M.create()

	local id = 0
	--- When a State is added t othe stack
	function instance.on_start(data)
	end

	--- When a State is removed from the stack
	function instance.on_stop(data)
	end

	--- When a State that was pushed over the current one, the current one is paused
	function instance.on_pause(data)
	end

	--- When the State that was pushed over the current State is popped, the current one is resume
	function instance.on_resume(data)
	end

	--- Handling events
	function instance.handle_event(data, event)
	end

	--- Called on the active State
	function instance.update(data, action)
	end

	--- Cheak if current State is active
	function instance.is_active(action)
		assert(action, "Provide an action_id")
		action = type(action) == "string" and hash(action) or action
		return action_map[action]
	end
end

local instance = M.create()

function M.on_start(data)
	return instance.on_start(data)
end

function M.on_stop(data)
	return instance.on_stop(data)
end

function M.on_pause(data)
	return instance.on_pause(data)
end

function M.on_resume(data)
	return instance.on_resume(data)
end

function M.handle_event(data, event)
	return instance.handle_event(data,event)
end

function M.update(data, action)
	return instance.update(data, action)
end

function M.is_active(action)
	return instance.is_active(action)
end