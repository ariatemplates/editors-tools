require!{
# -------------------------------------------------------------------------- STD
	util
# -------------------------------------------------------------------------- 3rd
	_: lodash
# ---------------------------------------------------------------------- Own-STD
	'std/io'
}



class Logger
	/* Browser specific! Assumes $ from jQuery is available */
	window?{}console.log ?= -> $ '#TESTAREA' .append "<div>#it</div>"

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
	} = {}) ~> @options = defaultOptions with options

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
		if options.prefix => arg = ["#{options.char} #item" for item in arg]

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
		for item in arg => console.log item


logJSON = -> console.log io.serialize it

log = -> console.log util.inspect it, {
	-showHidden
	depth: null
	+colors
	+customInspect
}



exports <<< {
	Logger

	logJSON
	logJson: logJSON
	logjson: logJSON
	JSON: logJSON
	Json: logJSON
	json: logJSON

	log
}
