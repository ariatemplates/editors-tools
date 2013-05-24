require! {
# -------------------------------------------------------------------------- 3rd
	zappa: 'zappajs'
# -------------------------------------------------------------------------- App
	'./server'
}
{Server} = server



module.exports = (routes, options, logger) ->
	server = Server {system: zappa, routes, options} logger
	server.run!
