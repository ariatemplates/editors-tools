require! {
	'std/io'
	'std/string'
	'./conf'
}


reg = io.read conf.path

/**
 * An entry input is a list of lines
 */
parseEntry = (entry) ->
	output = {}

	[path, ...properties] = entry

	# Path ---------------------------------------------------------------------

	fullpath = /^\[([^])\]$/.exec path
	parts = fullpath.split '/'

	output.path = parts

	# Properties ---------------------------------------------------------------




parseReg = (reg) ->
	lines = string.lines reg
	entries = array.splitOn lines, ''
	[parseEntry for entry in entries]
