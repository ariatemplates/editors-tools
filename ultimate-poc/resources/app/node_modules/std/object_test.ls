require! {
	'std/test/logger'
	'./object'
}

{Logger} = logger
$logger = Logger!



# Override ---------------------------------------------------------------------

$logger.separator 'Override'
$logger.on!

original = {'originalOnly', 'both'}
override = {'overrideOnly', both: 'bothOverriden'}

console.log 'Original: '
$logger.log original
console.log 'Override: '
$logger.log override
console.log 'Returned: '
$logger.log object.override original, override
console.log 'Original overriden: '
$logger.log original

# Default ----------------------------------------------------------------------

$logger.separator '''Default FIXME Don't use header of logs this way'''
$logger.on!

original = {'orignalOnly' inBoth: 'original'}
_default = {'defaultOnly', inBoth: 'default'}

console.log 'Original: '
$logger.log original
console.log 'Default: '
$logger.log _default
console.log 'Returned: '
$logger.log object.default original, _default
console.log 'Original processed: '
$logger.log original

# Factory ----------------------------------------------------------------------

$logger.separator 'Factory'
$logger.on!

$logger.log object.factory {'object'}
$logger.log object.factory 'noKey'
$logger.log object.factory 'value' 'key'
