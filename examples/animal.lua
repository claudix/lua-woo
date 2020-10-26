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


-- Define the Animal class
local Animal = class("Animal", nil, {
	members = {
		name = {
			private = true,
			value = "I have no name"
		},

		get_name = {
			method = function(this)
				return this.name
			end
		},

		talk = {
			virtual = true,
			method = function(this)
				print("I don't talk")
			end
		}
	},		
	ctor = function(this, parent_ctor, name)
		this.name = name
	end,
	dtor = function(this)
		print(string.format("A %s called %s is dead", this.__class.name:lower(), this.name))
	end
})

local Cat = class("Cat", Animal, {
	members = {
		talk = {
			method = function(this)
				print("Meow!")
			end
		}
	}
})

local Dog = class("Dog", Animal, {
	members = {
		talk = {
			method = function(this)
				print("Woof!")
			end
		}
	}
})

-- Create animals
local garfield = new(Cat, "Garfield")
local odie = new(Dog, "Odie")

-- Make them talk
garfield:talk()
odie:talk()

-- Cast to Animal and check virtual method works
cast(garfield, Animal):talk()
cast(odie, Animal):talk()

