require! {
# -------------------------------------------------------------------------- App
	'std/test/logger'
# ------------------------------------------------------------------------ Input
	'./session'
}
# ------------------------------------------------------------------ Extractions
{Logger} = logger
{SessionManager} = session



$logger = Logger!
manager = SessionManager!



# ------------------------------------------------------------------------------

$logger.separator 'Construction'
$logger.on!

$logger.log manager



# ------------------------------------------------------------------------------

$logger.separator 'Initialization'
$logger.on!

key = manager.init!
$logger.log key
$logger.log manager

key2 = manager.init 'key2'
$logger.log key2
$logger.log manager

wrongKey = key2 + 1000

# ------------------------------------------------------------------------------

$logger.separator 'Get'
$logger.on!

$logger.log manager.get key
$logger.log manager.get key2
$logger.log manager.get wrongKey

# ------------------------------------------------------------------------------

$logger.separator 'Update'
$logger.on!

$logger.log manager.update key, 'key'
$logger.log manager.get key
$logger.log manager.update wrongKey, 'wrongkey'
$logger.log manager.get wrongKey
