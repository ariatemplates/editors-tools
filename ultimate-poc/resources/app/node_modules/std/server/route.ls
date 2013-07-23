class Route
	@factory = (input) -> if input instanceof @@ => input else new @@ ...

	(input, logger, server) ~>
		# Factory --------------------------------------------------------------

		spec = switch typeof! input
		| 'String' => {type: input}
		| 'Object' => input
		| _ => {}

		# logger ---------------------------------------------------------------

		@ <<< {logger}

		# server ---------------------------------------------------------------

		@ <<< {server}

		# type -----------------------------------------------------------------

		{type} = spec

		defaults = switch type
		# TODO Also generate REST paths, like POST /rpc/:module/:member
		# The problem here is that it generates multiple routes, and in this class we handle only one!! However all are related to the same RPC manager
		# However, in the case of RPC, we could have a flag, telling there are multiple routes to register (here 2), and then, as the RPC manager receives the @ anayway, it can check wether there are params or not, and work normally
		| 'rpc' => {
			method: \post
			url: '/rpc'
			handler: let RPC = new require('./rpc').RPCManager logger
				for name, mod of spec.modules => RPC.add name, mod
				!-> RPC.exec @
		}
		| 'shutdown'
			url: '/shutdown'
			handler: !->
				msg = 'Exiting backend application.'
				logger.info msg
				@send msg
				process.exit 0
		| 'ping' => {
			log: pre: 'Ping'
			url: '/ping'
			status: 200
		}
		| 'info' => {
			url: '/info'
			status: 501
			# handler: !-> @send server.info!
		}
		| _ => {}

		spec = defaults with spec

		# handler --------------------------------------------------------------
		# XXX This synonymy is not usual, as each term denotes a particular type of data. indeed, a status should be a number. However, if this is a string, this should work too. For that, consider the three properties as different, and 2 of them as being convenient ways to define an handler. It's more or less what I did before.

		{handler, status, view} = spec

		handler? ?= status
		handler? ?= view

		handler = switch typeof! handler
		| 'Number'
			let status = handler => !-> @send status
		| 'String'
			let view = handler => !-> @render (spec.view): {hardcode: require './coffeecup-extension'}
		| 'Function' => handler
		| _ => throw {
			msg: 'No valid handler found or generated'
			spec
		}

		@ <<< {handler}

		# method ---------------------------------------------------------------

		{method} = spec

		method ?= \get

		@ <<< {method}

		# url ------------------------------------------------------------------

		{url} = spec

		url ?= '/'

		@ <<< {url}

		# log ------------------------------------------------------------------

		{log} = spec

		@log ?= log



	register: (type, system) -->
		switch type
		| 'zappa', 'zappajs'
			system[@method.toLowerCase!] {
				(@url): let self = @ => ->
					if self.log?pre? => self.logger.info that
					self.handler ...
					if self.log?post? => self.logger.info that
			}

		| _ => throw {
			msg: 'Unsupported system'
			system: type
		}

	register-zappa: ::register 'zappa'
	register-zappajs: ::register 'zappajs'





exports <<< {
	Route
}
