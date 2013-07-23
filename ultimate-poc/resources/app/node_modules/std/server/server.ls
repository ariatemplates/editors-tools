require! {
# ---------------------------------------------------------------------- Own STD
	'std/array'
# -------------------------------------------------------------------------- App
	'./helpers'
	'./route'
	'./network'
}
# ------------------------------------------------------------------ Extractions
{Route} = route


/**
 *  DISCLAIMER For now this server works only with the system `zappajs`
 *
 * @fixme Mess with paths: cwd (= running VM), __dirname (= running module)
 */
class Server
	@factory = (input) -> if input instanceof @@ => input else new @@ ...

	(input, logger) ~>
		# Factory --------------------------------------------------------------

		spec = switch typeof! input
		# | 'String' => {routes: [input]}
		| 'Object' => input
		| _ => {}

		# system ---------------------------------------------------------------

		{system} = spec

		if not system? => throw {
			msg: 'No server system passed'
			args: <[ system ]>
		}

		@ <<< {system}

		# routes ---------------------------------------------------------------
		# - aliases
		# - collection
		#   - factory
		#   - content factory

		{routes, route} = spec
		routes? ?= route

		routes = array.factory routes

		routes = [Route.factory route, logger, @ for route in routes]

		@ <<< {routes}

		# options --------------------------------------------------------------

		{options} = input

		options ?= {}

		# ------------------------------------------------------------------ log

		{log} = options

		log ?= no

		# -------------------------------------------------------------- network
		# XXX Properties inside the network options are handled in another module

		{network} = options

		network ?= options

		# ---------------------------------------------------------------- fsMap
		# TODO Handle subproperties (root, view, ...)

		{fsMap} = options

		fsMap ?= options

		{root, views} = fsMap

		root ?= '.'

		root = "#{process.cwd!}/#root"

		fsMap = {root, views}

		# -------------------------------------------------------------- statics

		{statics} = options
		statics ?= options

		{relative} = statics
		relative ?= []

		{absolute} = statics
		absolute ?= []

		# options final --------------------------------------------------------

		@options = {
			log
			network
			fsMap
			statics: {relative, absolute}
		}



	log: -> if @options.log => helpers.log ...



	_register-middleware: ->
		{relative, absolute} = @options.statics
		console.log "#{@options.fsMap.root}/public"

		@system.use ... [
			\bodyParser
			@system.app.router
			@system.express.static "#{@options.fsMap.root}/public"
		] ++ [@system.express.static "#{@options.fsMap.root}/#path" for path in relative] ++ [@system.express.static path for path in absolute]

	_configure: ->
		@system.app.set \views "#{@options.fsMap.root}/#{@options.fsMap.views}"

	_register-routes: ->
		for route in @routes
			{url, method} = route
			@log "Creating route: #{method.toUpperCase!} #{url}"
			route.register-zappajs @system

	run: ->
		network.execOnAvailablePort @options.network with {cb: !(port) ~>
			@ <<< {port}

			let self = @ =>
				<-! @system port

				self.system = @

				self.logInfo!
				self._register-middleware!
				self._configure!
				self._register-routes!
		}



	logInfo: ->
		{relative, absolute} = @options.statics
		@log [
			"Server started on port: #{@port}"
			'Static locations: '
			[" - #path" for path in relative ++ absolute]
		] { +wrap, char: '#' x: 40, +prefix }





exports <<< {
	Server
}
