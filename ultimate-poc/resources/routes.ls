require! {
	winston

	'./modules/js'
}



# Logging ----------------------------------------------------------------------

logger = new winston.Logger {
	transports: [
		new winston.transports.Console {
			+colorize
			-silent
			-timestamp
		}
		new winston.transports.File {
			filename: 'log.log'
			-colorize
			+timestamp
			-json
		}
	]
}



# HTTP -------------------------------------------------------------------------

HTTPCode = {
	'InternalError': 500
	'NotImplemented': 501
}



# RPC --------------------------------------------------------------------------

# TODO Use real JS Proxies (harmony)
class RPCProxy
	(@module) ~>

	exec: (route) ->
		{method, argument} = route.req.body
		logger.info method
		logger.info argument
		if @module[method]?
			try route.json that argument
			catch e =>
				route.send HTTPCode.InternalError, "#e"
				logger.error e
		else route.send HTTPCode.NotImplemented

rpc = new class RPCManager
	~> @modules = {}

	addModule: (module) ->
		@add module.displayName.toLowerCase!, module.instance

	add: (name, module) ->
		if @modules[name]? => throw 'Module already existing'
		@modules[name] = RPCProxy module

	remove: (name) -> if @modules[name]? => delete @modules[name]

	exec: (route) ->
		{module} = route.req.body
		logger.info module
		if @modules[module]? => that.exec route
		else route.send HTTPCode.NotImplemented



# Modules ----------------------------------------------------------------------

rpc.addModule js



# Routes -----------------------------------------------------------------------

module.exports = [

{
	method: \post
	url: '/rpc'
	handler: !-> rpc.exec @
}

{
	method: \get
	url: '/action'
	log:
		pre: 'Executing action...'
		post: '-' * 40
	handler: !->
		msg = 'I received this action!'
		logger.info msg
		@send msg
}

{
	method: \get
	url: '/shutdown'
	log:
		pre: 'Exiting...'
		post: '-' * 40
	handler: !->
		msg = 'Exiting backend application.'
		logger.info msg
		@send msg
		process.exit 0
}

]
