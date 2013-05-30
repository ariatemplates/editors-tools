require! {
# -------------------------------------------------------------------------- 3rd
	_: lodash
}

################################################################################
# Logging: use this version in the future!!!
#
# TODO Merge the logging facilities below, putting the function behavior in the class
#
#
#
# TODO Prettying features
# Add support for lists
# Add support for boxing (prefix and possible suffix in addition to wrapping)
# ...
# TODO Allow wrapping also for simple args (mutualize code for things other than "function")
# TODO Handle wrapping with 0 repetitions, either at top or bottom, without adding a new line!
#
#
# FIXME Some edge cases are probably not handled, they will appear from use of this function, which should then be modified in consequence...
#
# TODO Code refactoring: Maybe use a default options object, and use prototype inheritance
#
#
# XXX If the provided function returns something, log it? (would not be a hook function anymore but a computation function)
################################################################################

class Logger
	doLog = yes
	defaultOptions = {
		+flatten
		-wrap
		-prefix
		char: '#'
		x: 1
	}

	({
		@doLog ? doLog
		options ? {}
	}) ~> @options = defaultOptions with options

	log: !(arg, options ? {}) ~> if @doLog
		# Defaults
		options = @options with options

		# Argument handling
		switch typeof! arg
		| 'Function' =>	arg ...; return

		| 'Array'
			if options.array => arg = [arg]
		| _ => arg = [arg]

		# Prefix
		if options.prefix => arg = ["#{options.char} #{..}" for arg]

		# TODO DRY ---
		# Underline
		if options.underline
			options.xBottom ?= options.x

			arg = arg ++ ["#{options.char}" * options.xBottom]

		# Top line
		else if options.topline
			options.xTop ?= options.x

			arg = ["#{options.char}" * options.xTop] ++ arg

		# Wrap
		else if options.wrap
			options.xTop ?= options.x
			options.xBottom ?= options.x

			arg = ["#{options.char}" * options.xTop] ++ arg ++ ["#{options.char}" * options.xBottom]
		# TODO End DRY ---

		# Flatten
		if options.flatten => arg = _.flatten arg

		# Log
		for arg => console.log ..



exports <<< {
	Logger
}
