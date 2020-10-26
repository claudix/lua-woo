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

-- Define the Shape class
local Shape = class("Shape", nil, {
	members = {
		name = {
			protected = true,
			value = "Undefined shape"
		},

		compute_area = {
			method = true,
			virtual = true
		},

		get_name = {
			method = function(this)
				return this.name
			end
		},

		whoami = {
			virtual = true,
			method = function(this)
				print("I am a shape")
			end
		},

		same_area = {
			method = function(this, other)
				return this:compute_area() == other:compute_area()
			end
		}
	},
	dtor = function(this)
		print("Bye shape!" .. this:compute_area())
	end
})

-- Define the Rectangle class
local Rectangle
Rectangle = class("Rectangle", Shape, {
	members = {
		w = {
			protected = true,
			value = 0
		},
		h = {
			protected = true,
			value = 0
		},		
		set_w = {
			method = function(this, w)
				this.w = w
			end
		},
		set_h = {
			method = function(this, h)
				this.h = h
			end
		},		
		compute_area = {
			method = function(this)
				return this.w * this.h
			end
		},
		whoami = {
			virtual = true,
			method = function(this)
				print("I am a rectangle")
			end
		},
		__eq = {
			method = function(this, other)
				return other:__is_a(Rectangle) and this:compute_area() == other:compute_area()
			end
		}
	},

	ctor = function(this, parent_ctor, w, h)
		this.name = "Rectangle"
		this.w = w
		this.h = h
	end,

	dtor = function(this)
		print("Bye rectangle!")
	end
})

-- Define the Square class
local Square = class("Square", Rectangle, {
	members = {
		side = {
			protected = true,
			value = 0
		},
		set_side = {
			method = function(this, w)
				this.w = w
				this.h = w
			end
		},
		whoami = {
			virtual = true,
			method = function(this)
				print("I am a square")
			end
		}		
	},

	ctor = function(this, parent_ctor, s)
		parent_ctor(s,s)
		this.name = 'Square'
	end,

	dtor = function(this)
		print("Bye square!")
	end
})

local rect = new(Rectangle, 5, 5)
local sq = new(Square, 5)

print("AREA of " .. rect:get_name() .. " = " .. rect:compute_area())
print("AREA of " .. sq:get_name() .. " = " .. sq:compute_area())


print("Square and Rectangle have the same area? ", sq == rect)

print("Casting")
local sq_shape   = cast(sq, Shape)
local sq_rect = cast(sq, Rectangle)

print("\t", sq_shape:get_name(), sq_shape:compute_area())
print("\t", sq_rect:get_name(), sq_rect:compute_area())

print("Testing virtual method")
sq_shape:whoami()
sq_rect:whoami()
sq.Shape:whoami()
sq.Rectangle:whoami()
