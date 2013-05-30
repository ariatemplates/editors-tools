require! {
# ---------------------------------------------------------------------- Own STD
	'std/test/logger'
# ------------------------------------------------------------------------ Input
	'./io'
}

{Logger} = logger
$logger = Logger!


# Rendering --------------------------------------------------------------------

content = {
	'Section 1': [
		'My 1st paragraph'
		[
			'A'
			[
				'super'
				'nested'
			]
			'list'
		]
	]
	'Section 2':
		'Section 2.1': [
			'My 2nd paragraph'
		]
}

# Markdown ---------------------------------------------------------------------

$logger.separator 'Markdown'
$logger.on!

$logger.logStr io.render 'md' content

# MediaWiki --------------------------------------------------------------------

$logger.separator 'Markdown'
$logger.on!

$logger.logStr io.render 'mw' content
