module.exports = {

# Enable console logging or not ------------------------------------------------
	+log

# Network preferences ----------------------------------------------------------
	network:
		hostname: \localhost
		ports:
			prefered: 3000
			min: 49152
			max: 65535

# Static mappings --------------------------------------------------------------
	# statics:
	# 	absolute: [
	# 		'G:/dev/git/at_ymeine/src'
	# 	]
	# 	relative: [
	# 		'app'
	# 	]

# File system mapping: semantic location -> real location ----------------------
	# fsMap: {
	# 	root: '.'
	# 	lib: 'public'
	# 	data: 'data'
	# 	app: 'app'
	# }

# Default file encoding --------------------------------------------------------
	encoding: 'utf-8'
}
