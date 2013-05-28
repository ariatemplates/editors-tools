module.exports =


	# Header -------------------------------------------------------------------

	/**
	 * Includes a link element.
	 * This function is a shortcut to provide required attributes in a simple
	 * way.
	 * You can also pass extra attibutes.
	 */
	mylink: !(rel, href, attr ? {}) --> link attr <<< {rel, href}

	/**
	 * Creates one meta element with a simple attribute per pair
	 * (attribute: value) of the given object.
	 */
	mymeta: !-> for k, v of it => meta (k): v

	/**
	 * Creates one "name meta" element per pair (name-value: content-value) of
	 * the given object.
	 */
	namedmeta: !-> for name, content of it => meta {name, content}

	/**
	 * Inserts an icon given its path and extension.
	 */
	icon: !(ext, path) --> mylink \icon "#path.#ext" type: "image/#ext"



	# Resources ----------------------------------------------------------------

	# FIXME using mylink should work...
	stylesheet: -> link rel: \stylesheet href: "#it.css"
	jsscript: !(src, attr ? {}) ->
		attr.src = "#src.js"
		script attr
	lsscript: !-> script src: "#it.ls", type: 'ls'

	stylesheets: !(...srcs) -> for srcs => stylesheet ..
	jsscripts: !(...srcs) -> for srcs => jsscript ..
	lsscripts: !(...srcs) -> for srcs => lsscript ..
