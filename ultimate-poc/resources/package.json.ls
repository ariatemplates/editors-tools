{
	# Identification -----------------------------------------------------------

	name:  'ultimate-editor-services'
	version: '0.0.1'
	decription: '''
		A server providing common services for source code edition.
	'''
	keywords: <[
		editor
		ide
		poc
	]>
	author:
		name: 'Yannick Meine'
		email: 'yannick.meine@amadeus.com'



	# Use ----------------------------------------------------------------------

	scripts:
		start: 'lsc app/index'



	# Deployment ---------------------------------------------------------------

	-preferGlobal
	+'private'

	dependencies:
		# -------------------------------------------------------------- General
		lodash: '*'
		'prelude-ls': '*'
		# ------------------------------------------------------------------ STD
		zappajs: '*'
		portscanner: '*'
		winston: '*'
		LiveScript: '1.1.1' # LiveScript is not yet stable enough
		# ---------------------------------------------------------------- Modes
		pegjs: '*'
		# JS
		esprima: '*'
		'js-beautify': '*'
		jshint: '*'
		reflect: '*'
		pegjs: '*'
}
