require! {
	fs

	_: lodash

	string

	'./building-functions'
}


types = []
applyCategories = (container, suffix = '') -> for key, value of container
	key = "#key#suffix"
	switch typeof! value
	| 'Function' => types.push string.capitalize key
	| 'Object' => applyCategories value, key
applyCategories buildingFunctions

console.log types

types = for type in types
	"""
	| '#type'
		label = node.type
		children = node.links.children.list

		{label, children}



	"""

fs.writeFileSync 'types-gen.ls' types.join '\n'
