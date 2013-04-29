require! {
	_: lodash
	zappa: 'zappajs'

	'./helpers'

	'./routes'

	conf: './serverconf'
}



{log} = helpers



# Runs the server on a port
helpers.findAvailablePort conf.network with {cb: (port) ->
	<- zappa port

	log [
		"Server started on port: #port"
		'Static locations: '
		[" - #{..}" for conf.statics]
	] { +wrap, char: '#' x: 40, +prefix }

	# Use middleware -----------------------------------------------------------

	@use ... _.flatten [
		\bodyParser
		@app.router
		\static
		[@express.static "#__dirname/#{..}" for conf.statics.relative]
		[@express.static .. for conf.statics.absolute]
	]

	# Define routes ------------------------------------------------------------

	for route in routes => let route
		handler = if route.handler? => that
		else if route.status? => !-> @send route.status
		else if route.view? => !-> @render (route.view): {hardcode}
		if handler? and route.method? and route.url?
			log "Creating route: #{route.method.toUpperCase!} #{route.url}"
			@[route.method.toLowerCase!] {(route.url): ->
				if route.log?pre? => log that
				handler ...
				if route.log?post? => log that
			}
}
