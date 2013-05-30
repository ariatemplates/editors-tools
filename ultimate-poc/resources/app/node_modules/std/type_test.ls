require! {
# ---------------------------------------------------------------------- Own STD
	'std/test/logger'
# ------------------------------------------------------------------------ Input
	'./type'
}

{Logger} = logger
$logger = Logger!

# Data preparation -------------------------------------------------------------

nb = 0
bool = on
str = ''
re = /\ /g
date = new Date!
arr = []
obj = {}
fn = ->

# Number -----------------------------------------------------------------------

$logger.separator 'Number'
$logger.on!

$logger.log type.is 'Number' nb
$logger.log type.is 'Number' bool
$logger.log type.is 'Number' str
$logger.log type.is 'Number' re
$logger.log type.is 'Number' date
$logger.log type.is 'Number' arr
$logger.log type.is 'Number' obj
$logger.log type.is 'Number' fn


# Boolean -----------------------------------------------------------------------

$logger.separator 'Boolean'
$logger.on!

$logger.log type.is 'Boolean' nb
$logger.log type.is 'Boolean' bool
$logger.log type.is 'Boolean' str
$logger.log type.is 'Boolean' re
$logger.log type.is 'Boolean' date
$logger.log type.is 'Boolean' arr
$logger.log type.is 'Boolean' obj
$logger.log type.is 'Boolean' fn


# String -----------------------------------------------------------------------

$logger.separator 'String'
$logger.on!

$logger.log type.is 'String' nb
$logger.log type.is 'String' bool
$logger.log type.is 'String' str
$logger.log type.is 'String' re
$logger.log type.is 'String' date
$logger.log type.is 'String' arr
$logger.log type.is 'String' obj
$logger.log type.is 'String' fn


# RegExp -----------------------------------------------------------------------

$logger.separator 'RegExp'
$logger.on!

$logger.log type.is 'RegExp' nb
$logger.log type.is 'RegExp' bool
$logger.log type.is 'RegExp' str
$logger.log type.is 'RegExp' re
$logger.log type.is 'RegExp' date
$logger.log type.is 'RegExp' arr
$logger.log type.is 'RegExp' obj
$logger.log type.is 'RegExp' fn


# Date -----------------------------------------------------------------------

$logger.separator 'Date'
$logger.on!

$logger.log type.is 'Date' nb
$logger.log type.is 'Date' bool
$logger.log type.is 'Date' str
$logger.log type.is 'Date' re
$logger.log type.is 'Date' date
$logger.log type.is 'Date' arr
$logger.log type.is 'Date' obj
$logger.log type.is 'Date' fn


# Array -----------------------------------------------------------------------

$logger.separator 'Array'
$logger.on!

$logger.log type.is 'Array' nb
$logger.log type.is 'Array' bool
$logger.log type.is 'Array' str
$logger.log type.is 'Array' re
$logger.log type.is 'Array' date
$logger.log type.is 'Array' arr
$logger.log type.is 'Array' obj
$logger.log type.is 'Array' fn


# Object -----------------------------------------------------------------------

$logger.separator 'Object'
$logger.on!

$logger.log type.is 'Object' nb
$logger.log type.is 'Object' bool
$logger.log type.is 'Object' str
$logger.log type.is 'Object' re
$logger.log type.is 'Object' date
$logger.log type.is 'Object' arr
$logger.log type.is 'Object' obj
$logger.log type.is 'Object' fn


# Function -----------------------------------------------------------------------

$logger.separator 'Function'
$logger.on!

$logger.log type.is 'Function' nb
$logger.log type.is 'Function' bool
$logger.log type.is 'Function' str
$logger.log type.is 'Function' re
$logger.log type.is 'Function' date
$logger.log type.is 'Function' arr
$logger.log type.is 'Function' obj
$logger.log type.is 'Function' fn

