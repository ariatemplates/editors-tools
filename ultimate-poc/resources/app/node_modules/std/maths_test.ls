require! {
# ---------------------------------------------------------------------- Own STD
	'std/test/logger'
# ------------------------------------------------------------------------ Input
	'./maths'
}

{Logger} = logger
$logger = Logger!



# Sum --------------------------------------------------------------------------

$logger.separator 'Sum'
$logger.on!

$logger.log maths.sum!
$logger.log maths.sum []
$logger.log maths.sum 1
$logger.log maths.sum [1 1]



# Mean -------------------------------------------------------------------------

$logger.separator 'Mean'
$logger.on!

$logger.log maths.mean!
$logger.log maths.mean []
$logger.log maths.mean 5
$logger.log maths.mean [5 15]



# Odd --------------------------------------------------------------------------

$logger.separator 'Odd'
$logger.on!

$logger.fail -> maths.isOdd!
$logger.log maths.isOdd 0
$logger.log maths.isOdd 1
$logger.log maths.isOdd 2
$logger.log maths.isOdd 3
$logger.log maths.isOdd 4



# Even -------------------------------------------------------------------------

$logger.separator 'Even'
$logger.on!

$logger.fail -> maths.isEven!
$logger.log maths.isEven 0
$logger.log maths.isEven 1
$logger.log maths.isEven 2
$logger.log maths.isEven 3
$logger.log maths.isEven 4
