require! {
# -------------------------------------------------------------------------- 3rd
	_: lodash
# ---------------------------------------------------------------------- Own-STD
	'std/type'
}



################################################################################
# Splitting
################################################################################

split-pre-process = (chunkSize, array) ->
	if not array? => throw {msg: 'No array given'}
	if not chunkSize? => throw {msg: 'No chunk size given'}
	if chunkSize <= 0 => throw {msg: 'Invalid given chunk size: must be strictly positive', chunkSize}
	if chunkSize >= array.length => chunkSize = array.length

	{chunkSize, array}

split = (chunkSize, array) -->
	{chunkSize, array} = split-pre-process chunkSize, array

	[array[i til i+chunkSize] for i from 0 to array.length-1 by chunkSize]



################################################################################
# Removal
################################################################################

/** In place, chained */
removeAt = (array, index) -->
	array.splice index, 1
	array

/** In place, chained */
remove = (array, element) -->
	removeAt array, array.indexOf element
	array



################################################################################
# Factories
################################################################################

factory = ->
	if it?
		if type.isArray it => it
		else [it]
	else []



################################################################################
# Sorting
################################################################################

sortBy = (arr, property, undefinedAtBegining = yes) ->
	withProperty = _.select arr, (.[property]?)
	withoutProperty = _.reject arr, (.[property]?)

	withProperty= _.sortBy withProperty, (.[property])

	if undefinedAtBegining => withoutProperty ++ withProperty
	else withProperty ++ withoutProperty



################################################################################
# Transformation
################################################################################

/** Equivalent of underscore/lodash map (in classical functional programming) */
transform = (array, cb) -> [cb .. for array]




exports <<< {
	split

	removeAt
	removeat: removeAt
	remAt: removeAt
	remat: removeAt

	remove
	rem: remove

	factory

	sortBy
	sortby: sortBy

	transform
}
