# TODO

* consider using `prelude-ls` instead of `lodash`, especially for
	* the `sortBy` implementation in `arrays.ls` with the use of `reject` and `select`
	* maths library
* as for IO, consider being able to configure a module, or single functions. For instance, asking for a strict mode with checkings and exceptions, or a smooth mode, with default return values (even if it can sometimes be ambiguous), optimized form, etc.
* create a module for validation, the one I use to throw errors from constructor when I check both existence anbd type(s)

# Modules

## Type

### TODO

* Add the types 'Undefined' and `Null`
* Add the fix for `null` values
* Be able to have a funciton checking only native types, but accepting as input a _fuzzy_ string. For instance: `type.is 'str' str` would return `true`. in another context this could collide with custom types, but onyl if we consider the set of native types.

## Date

### FIXME

* For format: use UTC instead? Unix?

## String

### TODO

* Add a function similar to surround, but instead of repeaing the string in the suffix, add the reversed form of it. However, this could be even better with semantics. Examples:
	* "=== str ===": this way the string is wrapped by spaces in addition to equal sign
	* ">>> str <<<": this implies knowing the 'inverse' of a character (brackets too)

## Data

* Input -> to get the initial data
* List of 'filters':
	- Sort
	- Reject
	- Transform
	- ...
* Output -> fs or GUI, ...
* Functions, plus description, taxonomy
* Common filters
* ...
