<!--
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]



<br />
<p align="center">
  <h3 align="center">LuaWOO!</h3>

  <p align="center">
    A library that provides advanced Object Oriented Programming (OOP) mechanisms for the Lua language.    
  </p>
</p>


## Table of Contents

* [Features](#features)  
* [Usage](#usage)
* [Reference](#reference)
  * [class](#class)
  * [new](#new)
  * [cast](#cast)
  * [is_object](#is_object)
  * [is_class](#is_class)
  * [friend](#friend)
  * [Exceptions](#exceptions)    

* [Examples](#examples)
* [Roadmap](#roadmap)
* [Contributing](#contributing)
* [License](#license)
* [Contact](#contact)
* [Acknowledgements](#acknowledgements)


## Features
- Tested on Lua 5.4 but it should also work on 5.3 and maybe on lower versions.
- Single class inheritance
- True private, protected and public members (no underscore-naming tricks).
- Read-only properties.
- Operator overload: the Lua operators for addition (+), subtraction (-), multiplication (\*), 
  division (/), unary negation, exponentiation (^), concatenation (..), relation (==, <, <=),
  and string conversion (tostring()) can be overloaded.
- Constructors and destructors. It's possible for a constructor to call the parent class 
  constructor with different parameters.
- Class friends.
- Final classes.
- Virtual methods, optionally final and pure (abstract).
- Exceptions and try-catch-finally constructs.

## Usage
Just require the script *woo.lua* to your project. The following global symbols will be created:

- class
- new 
- cast
- is_object
- is_class
- friend
- Exception
- UnknownException
- try
- throw


## Reference

### class
	class(name, parent, attrs)

Defines a new class, returning a class object.

Parameters:
- **name**: (string) name of the class.
- **parent**: (class object) the parent class or *nil* if none.
- **attrs**: (table) the class attributes (*nil* sets default attributes). All attributes are optional:
  - *final*: if true, the class is defined as final (no other classes can be derived from it).
  - *friends*: a list of Lua objects that are considered friends of the class (i.e. they can access to the private and protected members). See also [friend()](#friend)
  - *members*: a hash that defines the class members (see below).
  - *ctor*: the constructor function (see below).
  - *dtor*: the destructor function (see below).

#### Class members (*members* attribute)
Class members defined in the *members* attribute define each member's attributes. The keys in this table are strings (member names) and the values are 
tables with the member's attributes. Depending on what kind of member is defined (methods or properties), the attributes may differ:

##### Defining properties
A property can be defined with a table with the attributes listed below. By default, a property is **public** unless either the **private** or **protected** attributes are specified:

- **private**: if true, the property is defined as private to the class. Only the class itself and friends will be able to access to this property.
- **protected**: if true, the property is defined as protected to the class. Only the class itself, the derived classes and friends will be able to access to this property. If **private** is set to true, the protected flag will be ignored.
- **read_only**: if true, the property is read-only.
- **value**: the initial property's value. It **cannot** be *nil*.

##### Defining methods
A method can be defined with a table with the attributes listed below. By default, a method is **public** unless either the **private** or **protected** attributes are specified:

- **private**: if true, the method is defined as private to the class. Only the class itself and friends will be able to access to this method.
- **protected**: if true, the method is defined as protected to the class. Only the class itself, the derived classes and friends will be able to access to this method. If **private** is set to true, the protected flag will be ignored.
- **method**: the function to be invoked. The first argument of the function is the instance of the class (aka "this"), which allows the method to access to its members.
- **virtual**: if true, the method is virtual. When you refer to a derived class object using a reference to the base class, you can call a virtual function for that object and execute the derived class’s version of the function (instead of the base's class version, as would happen if the method were not virtual). If the attribute **method** is set
to *true* (not to a function), then the method will be abstract (pure virtual), meaning that derived classes must implement the method or otherwise a runtime error will occur
when attempting to invoke it.
- **final**: if true and the method is virtual, it won't be able to be overridden by any derived class.


##### Operator overloading
Operator overloading is possible by defining methods whose names are the same as Lua's metamethods. For example, method "\_\_add" will overload the operator "+". Below there's a list of currently supported methods:

- **\_\_add**: overload the addition operator (+).
- **\_\_sub**: overload the subtraction operator (-).
- **\_\_mul**: overload the multiplication operator (*).
- **\_\_div**: overload the division operator (/).
- **\_\_unm**: overload the unary negation operator (-N).
- **\_\_pow**: overload the exponentiation operator (^).
- **\_\_concat**: overload the concatenation operator (..).
- **\_\_eq**: overload the equality relation operator (==).
- **\_\_lt**: overload the less than relation operator (<=).
- **\_\_lte**: overload the less than or equal to relation operator (<=).
- **\_\_tostring**: overload the string conversion operator (tostring()).

Example:

```
__add = function(this, b)
	return this.v + b.v
end
```

#### Constructor and destructor
A class can optionally have a constructor and a destructor function. A constructor is defined using the *ctor* class attribute, which must be a function that takes at least two arguments. The first argument is the instance of the class (*this*) and the second argument is a function that allows the user to invoke the parent class's constructor with specific arguments. The rest of the arguments are those passed to the [*new*](#new) function when the instance is created.

Example:

```
ctor = function(this, parent_ctor, arg1, arg2)
	parent_ctor(arg1 + arg2)
	this.value = arg1
end
```

On the other hand, a destructor can be defined using the *dtor* class attribute. This must be a function that only takes 1 argument (the instance, i.e. *this*), which is called when Lua's garbage collector frees the instance when no reference is left.

### new

	new(class[, ...])

Creates a new instance of the given class.

Parameters:
- **class**: (class object) a class object created by [class()](#class)
- ...: optional arguments passed to the constructor, if any.

#### Reading and writing instance's properties
Access to an instance's properties is done using the usual dot (.) operator. Example:

```
local prop_value = myinstance.value  -- Reading a property
myinstance.value = prop_value        -- Writing a property

```

If the scope in which the access is performed is incompatible with the property's access level (private, protected or public), the statement will throw an error. Similarly, any attempt to write a read-only property will also throw an error.


#### Calling instance's methods
Instance methods are called using the colon operator (:). Example:

```
local result = instance:my_method(arg1, arg2)
```

If the scope in which the method is called is incompatible with the method's access level (private, protected or public), the statement will throw an error. 

#### Qualified access
Besides the members defined in a class, an instance also contains some special members (read-only properties) that emulate a cast of that instance into any of the classes it derives from. For example, an instance of a class C, that derives from B, that derives from A, will have two properties named "B" and "A" that allow explicit access to the members of these classes. This acesss is useful when derived classes contain members with the same name but we want to refer to the member of a particular subclass.

Example:

```
local c = new(C)
print(c.foo) -- Refers to the effective "foo" member for the class C
print(C.B.foo) -- Refers to the "foo" member of class B
print(C.A.foo) -- Refers to the "foo" member of class A 
```

#### Built-in members
All instances have the following built-in members

- **__ref**: a unique identifier for the instance
- **__class**: the class of the instance
- **__is_a()**: method that checks if the instance is of the given class (or any of its ancestors)

### cast
	cast(instance, class)

Casts an instance to a given class. If the cast is not possible, throw an error.

Parameters:
- **instance**: (object) the instance to cast.
- **class**: (class object) the class to cast to.

### is_object
	is_object(arg[, class[, strict]])

Returns true if the given argument is an instance of a class. 

Parameters:
	- **arg**: value to test.
	- **class**: if specified, the class to test.
	- **strict**: if true, the given object's final class is compared against the given class. Otherwise the function will return true if the object's class also derives from the given class.

### is_class
	is_class(arg)

Returns true if the given argument is a class object.

### friend
	friend(instance, key)

Create a reference to an instance giving the caller full access to all of the members of its class, as long as the class was defined with the attribute *friends* containing the access key. 

Parameters:
- **instance**: (object) the instance to access to.
- **key**: (any value) a value that unlocks full access to the instance's class. This value might be secret by defining a Lua local variable in the script the class is defined in and setting it to a dummy Lua table.

Example:

```
local SECRET_KEY = {}

MyClass = class('MyClass', nil, {
	friends = {SECRET_KEY}
})

function my_friend(instance)
	print(friend(instance, SECRET_KEY).private_value) 
end
```

### Exceptions

LuaWOO defines two global classes that allow handling exceptions: Exception and UnknownException. The former is the base class of all exceptions that can be defined whereas the latter is a particular exception that handles everything thrown using Lua's *error()* function.

All exceptions have the public methods *get_message()* and *get_stack_trace()*, which return the exception's message and the stack trace, respectively. Instances of UnknownException also contain the public method *get_original_error()*, which returns the original argument passed to *error()*.

#### Throwing and handling exceptions
To throw an exception, the global **throw()** function is available. This function gets a single argument, which must be an object whose class derives from Exception. 
Example:


	throw(new(Exception, "This is an exception!"))


To handle exceptions, the global **try()** function is available. This function only takes one argument (a function containing the code to try) and returns a **try handle**, which allows the user to chain multiple *catch* clauses and a *finally* clause. **To run the try code the handle's *done* method must be eventually called**. The order of *catch* statements determines the order in which the exception is tested in order to be handled.

A *catch* statement is just a call to the try's handle "catch" method, which takes 2 arguments: a exception class, and a function (the exception handler). The exception handler takes only 1 argument: the exception.

	:catch(exception_class, handler)

On the other hand, the *finally* statement is just a call to the try's handle "finally" method,  which takes a single argument: a function to run when either the try succeeds or fails with an exception. This function is not passed any argument.

	:finally(func)

Example:

```
try(
	function()
		-- Some code that eventually calls throw() or error()
	end
)
:catch(MyException, function(exc)
  print("A MyException occurred")
end)
:catch(Exception, function(exc)
  print("A Exception occurred")
end)
:finally(function()
  print("This is always run")
end)
:done() -- Run the try!
```	


## Examples

See examples [here](https://github.com/claudix/lua-woo/tree/main/examples). To run them, switch to the examples directory and execute: 

	lua <example-script>.lua


<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/claudix/lua-woo/issues) for a list of proposed features (and known issues).


<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.



## Contact

Claudi Martinez - claudi.martinez@protonmail.com

Project Link: [https://github.com/claudix/lua-woo](https://github.com/claudix/lua-woo)



## Acknowledgements
To all the people that have contributed to Lua, a simple yet powerful scripting language.


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/claudix/lua-woo
[contributors-url]: https://github.com/claudix/lua-woo/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/claudix/lua-woo
[forks-url]: https://github.com/claudix/lua-woo/network/members
[stars-shield]: https://img.shields.io/github/stars/claudix/lua-woo
[stars-url]: https://github.com/claudix/lua-woo/stargazers
[issues-shield]: https://img.shields.io/github/issues/claudix/lua-woo
[issues-url]: https://github.com/claudix/lua-woo/issues
[license-shield]: https://img.shields.io/github/license/claudix/lua-woo
[license-url]: https://github.com/claudix/lua-woo/blob/master/LICENSE.txt



