require! {
# -------------------------------------------------------------------------- STD
	fs
	util
# -------------------------------------------------------------------------- 3rd
	_: lodash
# ------------------------------------------------------------------------ Input
	parser: './'
	'./test-options'
}
# ------------------------------------------------------------------ Extractions
{readFileSync:read} = fs


################################################################################
# Logger
################################################################################

class Logger
	~>
		@ <<< {
			console-width: 80
		}

	stringify: util.inspect _, {+colors, depth: null, -showHidden}
	log: console.log



	separator: -> @log '-' * @console-width

	align: (input, width, char = ' ') ->
		input = "#input"
		"#input#{"#char" * (width - input.length)}"



	ast: -> @log @stringify it

	exception: ({name, offset, line, column, message, found, expected}) -> @log """
		#name at L#line, C#column (#offset): #message
			- found: #found
			- expected: #expected
	"""

	source: (source) ->
		lines = source.split /\r?\n/g
		maxNumberWidth = "#{lines.length}".length
		for line, index in lines => @log "#{@align index + 1, maxNumberWidth} #line"

		# TODO
		# - handle tabs, which are 1 character long but 4 spaces wide
		# - display other vertical digits
		# - display the exact number of columns, not the one rouded up to the nearest ten
		# - fix the first column ,to make it start a 1 instead of 0
		digits = [0 to 9] * ''
		maxlength = _.sortBy lines, (.length) .reverse!0.length
		@log maxlength
		width = Math.round(maxlength / digits.length)
		width = 80 / digits.length
		@log "#{' ' * maxNumberWidth} #{"#digits" * width}"




################################################################################
# Test
################################################################################

logger = new Logger!

source = read testOptions.path, testOptions.encoding
try
	ast = parser.parse source
	output = switch testOptions.loggingMode
	| 'simplified' => ast.simplify!
	| 'simpletree' => ast.simpleTree!
	| 'raw' => ast
	logger.ast output
catch exception
	if typeof! exception is 'Error' => console.log exception
	else
		logger.exception exception
		if source.length < testOptions.max-source-length
			logger.separator!
			logger.source source
			logger.separator!

