{
	# Identification -----------------------------------------------------------

	name:  'ultimate-editor-services'
	version: '0.0.1'
	decription: '''

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
		# --------------------------------------------------------------- Server
		zappajs: '*'
		portscanner: '*'
		# -------------------------------------------------------------- Logging
		winston: '*'
		# --------------------------------------- For modules used by the server
		esprima: '*'
		'js-beautify': '*'
		jshint: '*'
		reflect: '*'
		pegjs: '*'

		# Why??
		gauss: '*'
}
