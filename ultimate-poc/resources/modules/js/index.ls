require! {
# -------------------------------------------------------------------------- 3rd
	winston

	# Parsing
	reflect
	'./builder'

	esprima

	# Validation
	jshint

	# Formatting
	beautify: 'js-beautify'
# -------------------------------------------------------------------------- App
	# Outline
	outlineNode: './outline_visitors'
}
# ------------------------------------------------------------------ Extractions
jshint .= JSHINT


logger = new winston.Logger {
	transports: [
		new winston.transports.Console {
			+colorize
			-silent
			-timestamp
		}
		new winston.transports.File {
			filename: 'log.log'
			-colorize
			+timestamp
			-json
		}
	]
}


module.exports = class JS
	~>



	# Parsing ------------------------------------------------------------------

	/**
	 * Returns an unmodified AST, compliant to the Parse API Mozilla specification.
	 */
	esprimaParse = esprima.parse _, {
		# +loc
		# +range
		+raw
		# +tokens
		# +comment
		+tolerant
	}
	/**
	 * Returns a modfied AST, converted to a graph...
	 */
	reflectParse = reflect.parse _, {builder}
	/** Internal parse functions, for use in internal processings */
	::_parse = reflectParse

	/** Exposed parse function */
	::parse = esprimaParse



	# Highlighting -------------------------------------------------------------

	/**
	 * Returns a list of ranges associated to styling information.
	 *
	 * Implementing
	 */
	highlight: (source) ~> {parts: [
		{
			start: 0
			end: source.length - 1
			style: 'program'
		}
	]}
	stylesheet: ~> {
		program:
			color: 'blue'
	}



	# Formatting ---------------------------------------------------------------

	format: (source) ~> {source: beautify source}



	# Validation ---------------------------------------------------------------

	validate: (source) ~>
		passed = jshint source
		if passed => {} else jshint.data!



	# Completion ---------------------------------------------------------------

	/**
	 * Returns completion description for the current selection.
	 */
	complete: (range) ~>
		...
		{start, end} = range
		# TODO Retrieve the node in the Graph
		# ...

	# TODO Update completion



	# Outline ------------------------------------------------------------------

	_outlineNode: (node) ->
		switch node.type
		| 'Program' => {
			label: 'Program'
			children: node.body
		}
		| 'VariableDeclaration' => {
			label: "Declarations (#{node.kind})"
			children: node.declarations
		}
		| 'VariableDeclarator' => {
			label: "#{node.id.name}#{if node.init? => " = " else ''}"
			children: [node.init]
		}
		| 'BinaryExpression' => {
			label: "Binary expression (#{node.operator})"
			children: [node.left, node.right]
		}
		| 'Literal' => {
			label: node.value
		}
		| _ => {label: '...'}


	/**
	 * Attach outline information to each node.
	 */
	_outlineTree: (node) ->
		children = node?links?children?list ? []
		for child in children => @_outlineTree child

		outline = outlineNode node
		node.outline = outline

	/**
	 * Returns an outline view description.
	 *
	 * An outline is a tree describing the source code.
	 *
	 * For simplicity of use, the actual content of the tree, how the nodes are built and so on is internal, even if it can be customized.
	 *
	 * Therefore the output format of this function is low-level, and semantic-less: this is a tree, meaning a set of nodes, each containing a required label, and an optional ordered list of children nodes.
	 *
	 * See developer documentation for details about how to build this tree.
	 */
	outline: ({source, options}) ~>
		options ?= {}
			..simple ?= yes
			..debug ?= on

		ast = @_parse source
		# root = ast.body

		if not options.simple => @_outlineTree ast

		# ast.outline

		simplify = (node) -> {
			label: node.type
			children: [{label: "#key = #value"} for key, value of node.properties ? {}] ++ [simplify child for child in node?links?children?list ? []]
			node.outline
		}
		# TODO When an array has only one element, remove the array
		debug = (node) -> {(node.label): [debug .. for node.children ? []]}
		# TODO Sort nodes to put nodes with children at bottom

		ast = simplify ast
		if options.debug => ast = debug ast

		return ast

	/** Last-minute change, for demo purpose, a complete override */
	::outline = ({source, options}) ->
		AST = esprimaParse source
		logger.log source

		# FIXME Open an LS issue for (in this context):
		# - implicitely returned object literals assign to `prototype`
		# - implicitely returned arrays return only the last element, but multiple times (instead of having as expected x different elements, we have x times the last element)
		# It looks like it wants to apply the function to modify the prototype (come from `::outline`)
		simplifyTree = (node) ->
			switch typeof! node
			| 'Object' =>
				array = for key, value of node
					processed = simplifyTree value
					switch typeof! processed
					| 'String' => label = "#{key}: #value"; children = []
					| 'Array' => label = "#key"; children = processed
					| _ => throw 'Unexpected returned value'
					obj = {label, children}
				console.log array
				return array
			| 'Array' =>
				array = for value, index in node
					processed = simplifyTree value
					switch typeof! processed
					| 'String' => label = "#{index}: #value"; children = []
					| 'Array' => label = "#index"; children = processed
					| _ => throw 'Unexpected returned value'
					obj = {label, children}
				console.log array
				return array
			| _ => "#node"

		logger.log ast
		result = {ast: simplifyTree AST}
		logger.log result
		result


	@instance = JS!
