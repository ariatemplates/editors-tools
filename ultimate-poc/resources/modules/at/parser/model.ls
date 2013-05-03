module.exports = [

{
	+done
	name: 'file'
	description: '''The whole template file'''

	composition: [
		rule: 'template'
	]
}

{
	+todo
	name: 'template'
	description: '''A template statement'''

	type:
		name: 'block'
		overrides: [
			{name: 'statement-id', rule: 'template-id'}
			{name: 'js', rule: 'template-js-object'}
		]
}

# template: specialize {
# 	rule: 'block'
# 	specializations: [
# 		specialize {
# 			rule: 'id'
# 			composition: ['Template']
# 		}
# 	]
# }






{
	+fixme
	name: 'ws'
	description: '''A set of whitespaces'''

	composition: [

	]
}



{
	name: 'block'
	description: '''A block statement, that is with opening and closing tags, and arbitrary number of elements between'''

	types: [
		'template'
		# 'for'
		# 'if'

		# 'widget'
	]
	composition: [
		rule: 'opening'
		{
			rule: 'element'
			+multiple
			+optional
		}
		rule: 'closing'
	]
}

{
	name: 'opening'
	description: '''The opening tag of a statement'''

	+contextual

	composition: [
		{type: 'terminal', value: '{'}
		{type: 'rule', name: 'statement-id'} # Depending on the type of block
		{type: 'rule', name: 'js'} # Depending on the type of block
		{type: 'terminal', value: '}'}
	]
}

{
	name: 'closing'
	description: '''The closing tag of a statement'''

	composition: [
		{type: 'terminal', value: '{'}
		{type: 'rule', name: 'statement-id'}
		{type: 'rule', name: 'ws', +multiple}
		{type: 'terminal', value: '/}'}
	]
}


{
	name: 'statement-id'
	description: '''The id used in tags for a statement'''

	alternatives:
		'for-id'
		'if-id'
		'var-id'
		...
}

{
	name: 'template-id'
	description: '''The id used in template statements'''

	composition: [
		{+terminal, value: 'Template'}
	]
}

]
