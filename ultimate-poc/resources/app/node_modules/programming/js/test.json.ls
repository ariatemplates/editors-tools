method = 'fold'



source = 'var a'
args = {
	# Session ------------------------------------------------------------------

	'init': {
		contentId: '/absolute/path/to/some/file'
		source
	}

	# Outline ------------------------------------------------------------------

	'outline': {
		source
		options: {+simple}
	}



	# Highlight ----------------------------------------------------------------

	'highlight': {source}

	# 'stylesheet': {}


	# Format -------------------------------------------------------------------

	'format':
		source: 'var a =    2+ 5 ;'
		options: {
			+outline
			+highlight
		}



	# Parse ----------------------------------------------------------------

	'parse': {source}



	# Fold ----------------------------------------------------------------

	'fold': {
		source: '''
			// Not foldable
			if (i == 5) {
				for (key in obj) {
					ok();
				}
			}
			/* Neither */
			/*
			 * This one is.
			 */
		'''
	}



	# Others ----------------------------------------------------------------

	# method: 'validate'
	# method: 'complete'

}



{
	module: 'js'
	method
	argument: args[method]
}
