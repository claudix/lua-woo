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
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/claudix/lua-woo">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">LuaWOO!</h3>

  <p align="center">
    A library that provides advanced Object Oriented Programming (OOP) mechanisms for the Lua language.
    <br />
    <a href="https://github.com/claudix/lua-woo"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/claudix/lua-woo">View Demo</a>
    ·
    <a href="https://github.com/claudix/lua-woo/issues">Report Bug</a>
    ·
    <a href="https://github.com/claudix/lua-woo/issues">Request Feature</a>
  </p>
</p>


## Table of Contents

* [Features](#features)  
* [Usage](#usage)
* [Reference](#reference)
  * [class](#class)
  * [new](#new)
  
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

Defines a new class.

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


### new

#### Reading and writing instance's properties

#### Calling instance's methods

#### Qualified access

### Exception


## Examples


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



<!-- CONTACT -->
## Contact

Claudi Martinez - claudi.martinez@protonmail.com

Project Link: [https://github.com/claudix/lua-woo](https://github.com/claudix/lua-woo)



## Acknowledgements
To all the people that have contributed to Lua, a simple yet powerful scripting language.


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/claudix/repo.svg?style=flat-square
[contributors-url]: https://github.com/claudix/repo/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/claudix/repo.svg?style=flat-square
[forks-url]: https://github.com/claudix/repo/network/members
[stars-shield]: https://img.shields.io/github/stars/claudix/repo.svg?style=flat-square
[stars-url]: https://github.com/claudix/repo/stargazers
[issues-shield]: https://img.shields.io/github/issues/claudix/repo.svg?style=flat-square
[issues-url]: https://github.com/claudix/repo/issues
[license-shield]: https://img.shields.io/github/license/claudix/repo.svg?style=flat-square
[license-url]: https://github.com/claudix/repo/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=flat-square&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/claudix
[product-screenshot]: images/screenshot.png



