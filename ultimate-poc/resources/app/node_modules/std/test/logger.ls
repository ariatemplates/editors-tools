# TODO be able to desribe test as data, as for the rest. Example:
# {
# 	name: obvious
# 	description: obvious
# 	category: can be the method tested, or like 'performances', ...
# 	type: 'fail', 'log', ...
# 	handler: the function to execute
# 	log: in case of type 'log', sometimes the handler does some stuff but doesn't return the value to log. Specify here a function returning this value
# 	fixme: boolean indicating wether you validated the test or not
# }

# Add also a specific module to build tests for functions, giving set of datas, and generating different sets of parameters to call these functions, automatically detecting which cases should fail and which should fail

require! {
# -------------------------------------------------------------------------- STD
	util
}



# TODO Use a proxy for on and off. When on, forward. When off, filter.

class Logger
	~>
		@ <<< {
			logCount: 1
			sepCount: 1
			-doLog
			overrides: {}
			blacklist: []
			+turnOffOnSeparator
			outputWidth: 80
		}



	on: -> @doLog = yes
	off: -> @doLog = no

	separator: !(label) ->
		console.log!
		prefix = "#{@sepCount}#{if label? => " - #that" else ''} "
		dashes = '-' * (@outputWidth - prefix.length)
		console.log "#prefix#dashes"
		console.log!

		@logCount = 1
		@sepCount++
		if @turnOffOnSeparator => @off!

	delimiter: !-> if @doLog => console.log '-' * (@outputWidth / 2)

	log: !(value, prefix) -> if @doLog
		prefix ?= ''
		str = @stringify value
		console.log "#{@logCount}: #prefix#str"
		@logCount++

	logString: !-> console.log it
	logstring: ::logString
	logStr: ::logString
	logstr: ::logString

	fail: !-> if @doLog
		try
			it!
			@log 'WARNING: didn\'t fail as expected'
		catch e => @log e, 'Exception: '

	fatal: !->
		console.log!
		console.log 'CHECK THIS: '
		@fail it
		@stop 1

	stop: !(code = 0) -> process.exit 0

	setFactory: -> @factoryFunction = it

	factory: !(input, context) -> @log {
		input
		context
		result: @factoryFunction input, context
	}



	# stringify: -> util.inspect @clean(it), {depth: null, +colors, -showHidden}
	stringify: -> util.inspect it, {depth: null, +colors, -showHidden}

	# clean: (node) ->
	# 	switch typeof! node
	# 	| 'Object'
	# 		result = {}
	# 		for key, value of node | key not in @blacklist
	# 			overriden = @override key, value
	# 			if typeof! overriden isnt 'Function' => result[key] = @clean overriden
	# 	| 'Array' => result = [@clean .. for node]
	# 	| _ => result = node
	# 	result

	override: (key, value) -> if @overrides[key]? => @overrides[key] value else value





exports <<< {
	Logger
}
