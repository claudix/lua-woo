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

local function devil()
	error("Arrgh!")
	--throw(new(Exception, "a generic exception"))
end

local function devil2()
	try(
		function()
			devil()
		end
	)
	:catch(UnknownException, function(exc)
		print(UnknownException.name)
		print(exc:get_message())
		print(exc:get_stack_trace())

	end)
	:catch(Exception, function(exc)
		print(Exception.name)
		print(exc:get_message())
		print(exc:get_stack_trace())	
	end)
	:finally(function()
		print("Running finally")
	end)
	:done()
end

try(
	function()
		devil2()
	end
)
:catch(Exception, function(exc)	
	print(Exception.name)
	print(exc:get_message())
	print(exc:get_stack_trace())

end)
:done()