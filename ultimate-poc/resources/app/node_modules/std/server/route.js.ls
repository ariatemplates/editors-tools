require! {
	'std/oop'
}

RouteHandler = {
	factory: ->
		handler = switch typeof! handler
		| 'Number'
			let status = handler => !-> @send status
		| 'Function' => handler
		| _ => throw {
			msg: 'No valid handler generated'
			spec
		}
}

Route = oop.Class {
	name: 'Route'

	schema:
		inputToSpec: 'String': 'type'
		properties: [
			{name: 'type'}
			{names: <[handler status]>}
		]

	init: (logger, server) ->
		@ <<< {logger, server}

		var defaults
		/*
		 * TODO Also generate REST paths, like POST /rpc/:module/:member
		 * The problem here is that it generates multiple routes, and in this class we handle only one!! However * all are related to the same RPC manager
		However, in the case of RPC, we could have a flag, telling there are multiple routes to register (here 2), and then, as the RPC manager receives the @ anayway, it can check wether there are params or not, and work normally
		 */
		if type is 'rpc'
			defaults = {
				method: \post
				url: '/rpc'
				handler: let RPC = new require('./rpc').RPCManager logger
					for name, mod of spec.modules => RPC.add name, mod
					!-> RPC.exec @
			}
		else if type is 'shutdown'
			defaults = {
				url: '/shutdown'
				handler: !->
					msg = 'Exiting backend application.'
					logger.info msg
					@send msg
					process.exit 0
			}
		else if type is 'ping'
			defaults = {
				log: pre: 'Ping'
				url: '/ping'
				status: 200
			}
		else if type is 'info'
			defaults = {
				url: '/info'
				status: 501
				/* handler: !-> @send server.info! */
			}
		else
			defaults = {}
}