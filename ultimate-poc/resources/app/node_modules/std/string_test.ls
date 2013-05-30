# TODO Add escape
# TODO Add surround

require! {
# ---------------------------------------------------------------------- Own STD
	'std/test/logger'
# ------------------------------------------------------------------------ Input
	'./string'
}

{Logger} = logger
$logger = Logger!



# Capitalize -------------------------------------------------------------------

$logger.separator 'Capitalize'
$logger.on!

$logger.fail -> string.capitalize!
$logger.log string.capitalize ''
$logger.log string.capitalize 'a'
$logger.log string.capitalize 'A'
$logger.log string.capitalize 'aA'
$logger.log string.capitalize 'Aa'
$logger.log string.capitalize 'AA'
$logger.log string.capitalize '-'
$logger.log string.capitalize '-a'
$logger.log string.capitalize '-A'

# Camel case -------------------------------------------------------------------

$logger.separator 'Camel case'
$logger.on!

$logger.fail -> string.getCamelCaseParts!
$logger.log string.getCamelCaseParts ''
$logger.log string.getCamelCaseParts 'a'
$logger.log string.getCamelCaseParts 'A'
$logger.log string.getCamelCaseParts 'aBCD'
$logger.log string.getCamelCaseParts 'aBooChooDoo'
$logger.log string.getCamelCaseParts 'This is a custom PhrAse-with_lotof bullshit'

# Escape -----------------------------------------------------------------------

$logger.separator 'Escape'
$logger.on!

$logger.log string.escape!

# Surround ---------------------------------------------------------------------

$logger.separator 'Surround'
$logger.on!

sample = 'str'

$logger.fail -> string.surround!
$logger.fail -> string.surround '' void
$logger.fail -> string.surround void sample
$logger.fail -> string.surround null sample
$logger.log string.surround '' sample
$logger.log string.surround 5 sample
$logger.log string.surround on sample
$logger.log string.surround '#' sample
