--
-- lua-woo - Advanced OOP features for Lua
--
-- Copyright 2020 Claudi Martinez <claudi.martinez@protonmail.com>
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
require('class')

local THROW_FRIEND_KEY = {}
function throw(exc)
	assert(is_object(exc, Exception), "Expecting a Exception object")
	friend(exc, THROW_FRIEND_KEY).stack_trace = debug.traceback(nil, 2) 
	error(exc)
end

Exception = class("Exception", nil, {
	friends = {THROW_FRIEND_KEY},
	members = {				
		stack_trace = {
			private = true,
			value = ''
		},
		message = {
			private = true,
			value = ''
		},		
		get_stack_trace = {
			method = function(this)
				return this.stack_trace
			end
		},
		get_message = { 
			method = function(this)
				return this.message
			end
		},
		__tostring = {
			method = function(this)
				return this.__class.name .. ": " .. this.message
			end
		}
	},
	ctor = function(this, parent_ctor, msg)
		assert(type(msg) == 'string', "Exception message must be a string")
		this.message = msg
	end
})

UnknownException = class("UnknownException", Exception, {
	members = {
		original_error = {
			private = true,
			value = ''
		},

		get_original_error = {
			method = function(this)
				return this.original_error
			end
		}
	},
	ctor = function(this, parent_ctor, err)
		parent_ctor(tostring(err))
		this.original_error = err
	end
})

local function exception_message_handler(err)
	local exc
	
	if is_object(err, Exception) then
		exc = err
	else
		-- Other error. Encapsulate it.
		exc = new(UnknownException, err)				
	end			

	return exc
end


function try(tryblock)	
	assert(type(tryblock) == 'function', "expecting a function argument")

	local finally_block
	local catch_chain = {}

	local exec_try = function()
		local ok, exc = xpcall(tryblock, exception_message_handler)
		
		if not ok then
			-- Iterate all catchers
			for _, item in ipairs(catch_chain) do
				local exc_type = item[1]
				local handler  = item[2]

				if exc:__is_a(exc_type) then
					-- Handle!
					local ok, handler_exc = xpcall(handler, exception_message_handler, exc)
					if ok then
						-- Exception successfully handled
						exc = nil 
					else
						-- Handler failed!
						exc = handler_exc					
					end

					break
				end
			end			
		end

		-- Run finally block
		if finally_block then
			finally_block()
		end

		-- Propagate exception if not handled 
		if not ok and exc then
			error(exc)
		end
	end

	local state_mt -- Forward decl
	local state = {
		catch = function(self, exc_type, handler)
			assert(getmetatable(self) == state_mt, "incorrect try-catch-finally syntax")
			assert(is_class(exc_type), "invalid exception type in catch block")
			assert(type(handler) == 'function', "invalid exception handler in catch block")

			table.insert(catch_chain, {exc_type, handler})

			return self	
		end,

		finally = function(self, handler)			
			assert(getmetatable(self) == state_mt, "incorrect try-catch-finally syntax")
			finally_block = handler
			return self
		end,

		done = function(self)
			assert(getmetatable(self) == state_mt, "incorrect try-catch-finally syntax")
			exec_try()
		end
	}

	state_mt = {
		__index = state,
		__newindex = function(t,k,v)
			error("Protected table")
		end
	}

	return setmetatable({}, state_mt)	
end
