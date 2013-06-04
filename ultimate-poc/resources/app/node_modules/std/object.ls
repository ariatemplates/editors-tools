require! {
# ---------------------------------------------------------------------- Own-STD
	'std/type'
}





/** Overrides values of an object given another object, without adding any property of course */
override = (original, newValues = {}) ->
	for key, value of newValues
		if original[key]? => original[key] = value
	original



/** Apply defaults value to an object given another object, using a mixing method (instead of prototype inheritance) */
_default = (original, def) ->
	for key of def => original[key] ?= def[key]
	original



/**
 * Given a single value, if it is not an object, builds a new one with this value under the given key
 * If no key is given, it uses the value itself as a key
 */
factory = (value, key = value) ->
	if type.isObject value => value
	else {(key): value}


# FIXME The spec is not well defined
# The first use of transform is not simple: calling a callback, no added value
# the rec method for no just handles the keys
# Add the real recursive, with links
transform = (obj, cb, rec = no) ->
	if not rec => cb obj
	else {[key, cb[key](value)] for key, value of obj}


# See implementation in node.ls (Node.prototype.transform)
# See override in tester.ls
transform-rec = (obj, link, cb) ->
	# ! Depth-first implementation
	# ! Assuming the link exists
	# ! Assuming the link holds an array
	# ! Assuming this array is always present, and empty to stop the recursion
	transformedRec = [transform-rec child, link, cb for obj[link]]
	cb obj, transformedRec



exports <<< {
	override

	default: _default

	factory

	transform
}
