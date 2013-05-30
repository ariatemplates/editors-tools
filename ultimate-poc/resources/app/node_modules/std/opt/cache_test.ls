require! {
# -------------------------------------------------------------------------- App
	'std/test/logger'
# ------------------------------------------------------------------------ Input
	'./cache'
}
# ------------------------------------------------------------------ Extractions
{Logger} = logger
{Cache} = cache





$logger = Logger!
functionNames = <[ compute obsolete ]>
logFunctions = (names) -> $logger.overrides = {[name, (.toString!)] for name in functionNames}
hideFunctions = -> $logger.overrides = {[name, '[Function]'] for name in functionNames}



index = 0
obsolete = no
cache = Cache {
	compute: ->
		console.log 'Computed'
		index++
	obsolete: -> obsolete
}

# Construction -----------------------------------------------------------------
logFunctions!

$logger.separator 'Construction'
$logger.on!

$logger.log cache

hideFunctions!

# Request ----------------------------------------------------------------------

$logger.separator 'Get'
$logger.on!

$logger.log cache.get!
$logger.log cache.get!

# Invalidation -----------------------------------------------------------------

$logger.separator 'Invalidation'
$logger.on!

obsolete = yes
$logger.log cache.get!
obsolete = no

# Check ------------------------------------------------------------------------
$logger.overrides = {}

$logger.separator 'Check'
$logger.on!

$logger.log cache.check!
$logger.log cache.check yes
obsolete = yes
$logger.log cache.check!
$logger.log cache.check yes
$logger.log cache.check yes
