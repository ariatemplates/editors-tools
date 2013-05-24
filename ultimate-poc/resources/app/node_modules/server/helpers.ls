require! {
# -------------------------------------------------------------------------- 3rd
	_: lodash
}


/**
 * Pretty console logging.
 *
 * If the given argument is anything except an array, it will be logged as is.
 *
 * If it is an array, the array will be flattened and processed regardings the options. Each item of the finally resulting array will be logged as is.
 *
 * For now the only available options concerns wrapping.
 *
 * - wrap: if the property evaluates to true, wrapping will be applied
 * - char, opt: evaluates to a string, defaults to '#'
 * - ...
 *
 * @param[in] arg {Array>Array,Any|Any} the argument to log. See full description.
 * @param[in][opt] options {Object} See full description.
 */
log = !(arg, options ? {}) ->
	switch typeof! arg
	| 'Array' # Array of strings! (arrays can be nested)
		{wrap} = options
		if wrap
			{char} = options
			char ?= '#'
			char = "#char"

			{prefix} = options
			if prefix => arg = ["#char #entry" for entry in arg]

			{x, xTop, xBottom} = options
			x ?= 1
			xTop ?= x
			xBottom ?= x
			arg = ["#char" * xTop] ++ arg ++ ["#char" * xBottom]

		array = _.flatten arg
		for array => console.log ..

	| _ => console.log arg



exports <<< {
	log
}
