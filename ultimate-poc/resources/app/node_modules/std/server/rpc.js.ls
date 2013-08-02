require! {
	oop

	'./http'
}


LoggerSpec = oop.Class {
	name: 'Logger specifications'

	schema:
		properties: [
			{name: 'info', type: oop.types.Function, default: -> console.log}
			{name: 'log', type: oop.types.Function, default: -> console.log}
			{name: 'error', type: oop.types.Function, default: -> console.error}
			{name: 'warning', type: oop.types.Function, default: -> console.log}
		]
}



RPCProxy = oop.Class {
	name: 'RPC Proxy'

	schema:
		properties: [
			{names: ['module']}
			{names: ['logger'], type: LoggerSpec}
			{names: ['name'], type: oop.types.String}
		]

	call:
		name: 'exec'
		exec: (route) ->
			# {method, argument} = route.req.body

			# if @module[method]?
			# 	try
			# 		route.json if typeof! @module[method] isnt 'Function' => @module[method] else @module[method] argument
			# 	catch exception
			# 		@logger.error exception
			# 		route.send http.codes.InternalError, "#exception"
			# else
			# 	route.send http.codes.NotImplemented
}


Module = {
	factory: (input) ->
		if prelude.isType 'Object' input
			return input

		if prelude.isType 'String' input
			if module.0 is \.
				throw {
					msg: 'Relative paths are unsupported'
					path: input
				}
			return require module

		throw {
			msg: 'Unknown module input format'
			type: typeof input
			module: input
		}
}

RPCManager = oop.Class {
	name: 'RPC Manager'

	schema: properties: {name: 'logger', type: LoggerSpec}

	init: -> @modules = {}

	call:
		alias: 'exec'
		def: (route) ->
			# {module} = route.req.body

			# if @modules[module]? => @modules[module].exec route
			# else route.send http.codes.NotImplemented, "Module '#module' doesn't exist"

	proto:
		add: (name, module) ->
			module = Module.factory module

			# if @modules[name]? => throw 'Module already existing'

			# @modules[name] = RPCProxy module, @logger

		remove:
}