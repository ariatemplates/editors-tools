require! {
	fs
	util

	_: lodash

	'./parser'
}



logObject = (object) -> console.log util.inspect(object, {+colors, depth: null, -showHidden})

logException = ({name, offset, line, column, message, found, expected}) ->
	console.log """
		#name at L#line, C#column (#offset): #message
			- found: #found
			- expected: #expected
	"""

logSource = (source) ->
	align = (input, width, char = ' ') ->
		input = "#input"
		"#input#{"#char" * (width - input.length)}"

	lines = source.split /\r?\n/g
	maxNumberWidth = "#{lines.length}".length
	for line, index in lines => console.log "#{align index + 1, maxNumberWidth} #line"

	# TODO
	# - handle tabs, which are 1 character long but 4 spaces wide
	# - display other vertical digits
	# - display the exact number of columns, not the one rouded up to the nearest ten
	# - fix the first column ,to make it start a 1 instead of 0
	digits = [0 to 9] * ''
	maxlength = _.sortBy lines, (.length) .reverse!0.length
	console.log maxlength
	width = Math.round(maxlength / digits.length)
	width = 80 / digits.length
	console.log "#{' ' * maxNumberWidth} #{"#digits" * width}"

CONSOLE_WIDTH = 80

separator = -> console.log '-' * CONSOLE_WIDTH



source = fs.readFileSync 'test.tpl' 'utf-8'
try
	ast = parser.parse source
	logObject ast
catch e
	logException e
	separator!
	logSource source
	separator!

