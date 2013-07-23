require! {
# -------------------------------------------------------------------------- App
	'./http'
}


/**
 * @todo Use real JS Proxies (harmony)
 */
class RPCProxy
	(@module, @logger) ~>
		@logger ?= {
			info: console.log
			console.log
			console.error
			warning: console.log
		}

	exec: (route) ->
		{method, argument} = route.req.body

		if @module[method]?
			try
				route.json if typeof! @module[method] isnt 'Function' => @module[method] else @module[method] argument
			catch exception
				@logger.error exception
				route.send http.codes.InternalError, "#exception"
		else
			route.send http.codes.NotImplemented



/**
 * @todo Review collection design (add, remove methods)
 */
class RPCManager
	(@logger) ~> @modules = {}


	@module-factory = (module) ->
		switch typeof! module
		| 'Object' => module
		| 'String'
			if module.0 is \. => throw {
				msg: 'Relative paths are unsupported'
				path: module
			}
			require module
		| _ => throw {
			msg: 'Unknown module input format'
			type: typeof! module
			module
		}

	addModule: (module) ->
		module = @@module-factory module
		@add module@@displayName.toLowerCase!, module

	add: (name, module) ->
		module = @@module-factory module
		if @modules[name]? => throw 'Module already existing'

		@modules[name] = RPCProxy module, @logger

	remove: (name) -> if @modules[name]? => delete @modules[name]



	exec: (route) ->
		{module} = route.req.body

		if @modules[module]? => @modules[module].exec route
		else route.send http.codes.NotImplemented, "Module '#module' doesn't exist"





exports <<< {
	RPCProxy
	RPCManager
}
