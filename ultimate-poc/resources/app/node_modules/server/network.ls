require! {
# -------------------------------------------------------------------------- 3rd
	portscanner
}



/**
 * @todo Just return the port, don't use a callback
 * @todo Check validity of the hostname with a regexp or url module
 * @todo Externalize default values, in a conf file for instance
 */
findAvailablePort = (spec) ->
	# Pre-processing -----------------------------------------------------------

	# host ---------------------------------------------------------------------

	{hostname, host, ip} = spec

	hostname ?= host
	hostname? ?= ip
	hostname ?= 'localhost'

	# ports --------------------------------------------------------------------

	{ports} = spec
	ports ?= spec

	{prefered} = ports
	if typeof! prefered isnt 'Number' => prefered = void
	prefered ?= 3000

	{min} = ports
	if typeof! min isnt 'Number' => min = void
	min ?= 0

	{max} = ports
	if typeof! max isnt 'Number' => max = void
	max ?= 65535 # 2^16 - 1

	# callback -----------------------------------------------------------------

	{cb, fn} = spec

	cb? ?= fn

	if not cb? => throw {
		msg: 'Missing argument'
		names: <[ cb fn ]>
	}

	if typeof! cb isnt 'Function' => throw {
		msg: 'Wrong type'
		argument: <[ cb fn ]>
		expected: 'Function'
		actual: typeof! cb
	}

	# error callback -----------------------------------------------------------

	{errorcb} = spec

	if typeof! cb isnt 'Function' => errorcb = void

	errorcb ?= ->
		console.log 'No port found, exiting application...'
		process.exit 1

	# Execution ----------------------------------------------------------------

	(error, status) <- portscanner.checkPortStatus prefered, hostname
	if status is \closed => cb prefered
	else
		(error, availableport) <- portscanner.findAPortNotInUse min, max, hostname
		if error? => errorcb error
		else cb availableport



exports <<< {
	findAvailablePort
	execOnAvailablePort: findAvailablePort
}
