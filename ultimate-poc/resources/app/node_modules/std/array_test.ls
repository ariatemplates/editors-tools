require! {
# ---------------------------------------------------------------------- Own STD
	'std/test/logger'
# ------------------------------------------------------------------------ Input
	'./array'
}

{Logger} = logger
$logger = Logger!



# split ------------------------------------------------------------------------
# TODO Test with

$logger.separator 'Split'
$logger.on!

data = [1 2 3 4 5 6 7 8 9 10 11]
empty = []
one = [1]

$logger.fail -> array.split!

$logger.fail -> array.split 0 data
$logger.fail -> array.split -1 data
$logger.fail -> array.split -5 data

$logger.log array.split 1 data
$logger.log array.split 2 data
$logger.log array.split 5 data

$logger.log array.split data.length - 1, data
$logger.log array.split data.length, data
$logger.log array.split data.length + 1, data

$logger.log array.split 0 empty

$logger.log array.split 1 empty
$logger.log array.split 2 empty
$logger.log array.split 5 empty

$logger.log array.split -1 empty
$logger.log array.split -5 empty

$logger.log array.split 0 one

$logger.log array.split 1 one
$logger.log array.split 2 one
$logger.log array.split 5 one

$logger.log array.split -1 one
$logger.log array.split -5 one



# removeAt ---------------------------------------------------------------------

$logger.separator 'Remove at'
$logger.on!

$logger.log array.removeAt!

$logger.log array.removeAt data, 0
$logger.log array.removeAt data, 1
$logger.log array.removeAt data, 5
$logger.log array.removeAt data, 20

$logger.log array.removeAt data, -1
$logger.log array.removeAt data, -5

# remove -----------------------------------------------------------------------

$logger.separator 'TODO Remove item'
$logger.on!

$logger.log array.remove!

# factory ----------------------------------------------------------------------

$logger.separator 'TODO Factory'
$logger.on!

$logger.log array.factory!
