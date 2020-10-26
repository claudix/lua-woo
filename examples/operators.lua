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
package.path = package.path .. ';../?.lua'
require('woo')

local Number 
Number = class("Number", nil, {
	members = {
		value = {
			private = true,
			value = 0
		},

		get = {
			method = function(this)
				return this.value
			end
		},

		__eq = {			
			method = function(this, other)
				return other:__is_a(Number) and this.value == other.value
			end
		},

		__lt = {			
			method = function(this, other)
				return other:__is_a(Number) and this.value < other.value
			end
		},

		__le = {			
			method = function(this, other)
				return other:__is_a(Number) and this.value <= other.value
			end
		},

		__add = {			
			method = function(this, other)
				assert(other:__is_a(Number))
				return new(Number, this.value + other.value)
			end
		},

		__tostring = {			
			method = function(this)				
				return tostring(this.value)
			end
		}
	},		
	ctor = function(this, parent_ctor, value)
		this.value = value
	end
})

local a = new(Number, 100)
local b = new(Number, 200)
local c = a + b

print(tostring(a) .. ' + ' .. tostring(b) .. ' = ' .. tostring(c))