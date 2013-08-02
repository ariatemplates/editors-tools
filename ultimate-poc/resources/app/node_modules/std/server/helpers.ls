require! {
# -------------------------------------------------------------------------- 3rd
	prelude: 'prelude-ls'
	lodash

	dop
	oop
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
	options = dop.processProperties options, {
		properties: [
			{name: 'wrap', type: oop.types.Boolean, default: off}
			{name: 'char', type: oop.types.String, default: '#'}
			{name: 'prefix', type: oop.types.Boolean, default: off}

			{name: 'x', type: oop.types.Number, default: 1}
			{name: 'xTop', type: oop.types.Number}
			{name: 'xBottom', type: oop.types.Number}
		]
	}

	/* Array of strings! (arrays can be nested) */
	if prelude.isType 'Array' arg
		if options.wrap
			{char} = options

			if options.prefix => arg = ["#char #line" for line in arg]

			{xTop, xBottom} = options
			xTop ?= options.x
			xBottom ?= options.x
			arg = ["#char" * xTop] ++ arg ++ ["#char" * xBottom]

		array = lodash.flatten arg
		for line in array => console.log line
	else
		console.log arg



exports <<< {
	log
}
