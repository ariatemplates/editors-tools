require! {
# -------------------------------------------------------------------------- 3rd
	_: lodash

# Parsing
	reflect
	'./parser/builder'

	esprima

# Validation
	jshint

# Formatting
	beautify: 'js-beautify'
# -------------------------------------------------------------------------- App
# Outline
	outlineNode: './outline/outline_visitors'
}
# ------------------------------------------------------------------ Extractions
jshint .= JSHINT



module.exports = class JS
	~>


	# Session ------------------------------------------------------------------

	@sessionId = 0
	@sessions = {}

	init: ({contentId, source}) ~>
		sessionId = JS.sessionId++

		session = {
			contentId
			sessionId
		}

		JS.sessions[sessionId] = {
			models: {
				source
				ast: @parse source
			}
		} <<< session

		session



	# Parsing ------------------------------------------------------------------

	/**
	 * Returns a modified AST, converted to a graph.
	 *
	 * The model design is still a work in progress.
	 */
	::_parse = reflect.parse _, {builder}

	/**
	 * Returns an unmodified AST, compliant to the Parser API Mozilla specification.
	 *
	 * This function is partially applied and activates all options.
	 */
	::parse = esprima.parse _, {
		+loc
		+range
		+raw
		+tokens
		+comment
		+tolerant
	}



	# Highlighting -------------------------------------------------------------

	rangeToLoc = -> {start: it.0, end: it.1}
	/**
	 * Returns a list of ranges associated to a style.
	 *
	 * Implementing
	 */
	highlight: ({source}) ~>
		{tokens ? [], comments ? []} = esprima.parse source, {+tokens, +range, +comment, +tolerant}

		tokens = [{style: token.type} <<< rangeToLoc token.range for token in tokens]
		comments = [{style: 'Comment'} <<< rangeToLoc comment.range for comment in comments]

		{highlights: _.sortBy (tokens ++ comments), (.start)}

	tokenize: ({source}) ~>
		{tokens ? [], comments ? []} = esprima.parse source, {+tokens, +range, +comment, +tolerant}

		tokens = [{token.type} <<< rangeToLoc token.range for token in tokens]
		comments = [{type: 'Comment'} <<< rangeToLoc comment.range for comment in comments]

		{tokens: _.sortBy (tokens ++ comments), (.start)}

	/**
	 * Returns a stylesheet for highlighting.
	 *
	 * This avoids the need to return styling information everytime highlights is required, as this will not change often.
	 */
	stylesheet: ~>
		def = {
			bgcolor: r: 255 g: 255 b: 255
			font:
				name: 'Consolas'
				height: 12
				style: 'normal'
		}

		stylesheet:
			Keyword: def with {color: r: 0 g: 0 b: 255}
			Comment: def with {color: r: 128 g: 128 b: 128}



	# Formatting ---------------------------------------------------------------

	format: ({source, options ? {}}) ~>
		beautified = beautify source

		getRange = -> {start: 0, end: it.length}
		result = {
			source: beautified
			ranges:
				input:
					passed: getRange source
					actual: getRange source
				output: getRange beautified
		}

		if options.outline? => result.outline = @outline {source: beautified, options: options.outline}
		if options.highlight? => result.highlight = @highlight {source: beautified}
		if options.fold? => result.fold = @fold {source: beautified}
		if options.validate? => result.validate = @validate {source: beautified}

		result


	# Validation ---------------------------------------------------------------

	validate: ({source}) ~>
		passed = jshint source
		if passed => {} else jshint.data!



	# Folding ------------------------------------------------------------------

	fold: ({source}) ~>
		ast = esprima.parse source, {+loc, +comment, +tolerant}

		# Extracts block statements nodes --------------------------------------
		blockStatements = ["#{statement}Statement".toLowerCase! for statement in <[
			if
			block
			switch
			while
			dowhile
			for
			forin
			try
			let
		]>]
		getBlocks = (node) ->
			result = []
			switch typeof! node
			| 'Object' => if node.type?
				if node.type.toLowerCase! in blockStatements => result.push node
				for key, value of node | key not in <[type loc range raw]> => result ++= getBlocks value
			| 'Array' => for child in node => result ++= getBlocks child

			result

		nodes = getBlocks ast.body

		# Adds comments --------------------------------------------------------
		nodes ++= _.select ast.comments, (.type is 'Block')

		# Extracts ranges ------------------------------------------------------
		ranges = [{start: ..loc.start.line, end: ..loc.end.line} for nodes]

		# Rejects single line blocks -------------------------------------------
		ranges = _.reject ranges, -> it.start is it.end

		# Removes duplicates ---------------------------------------------------
		uniqueRanges = []
		inUniqueRanges = (range) ->
			for uniqueRanges => if ..start is range.start and ..end is range.end => return yes
			no
		for range in ranges => if not inUniqueRanges range => uniqueRanges.push range
		ranges = uniqueRanges

		# For a same line, sorts by end (descending) ---------------------------
		# Then sorts by start line ---------------------------------------------
		ranges = _.sortBy (_.flatten [(_.sortBy value, (.end)).reverse! for key, value of _.groupBy ranges, (.start)]), (.start)

		{folds: ranges}



	# Completion ---------------------------------------------------------------

	/**
	 * Returns completion description for the current selection.
	 */
	complete: ({range, options}) ~> ...



	# Outline ------------------------------------------------------------------
	# CLEAN THIS

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
		AST = esprima.parse source, {+raw, +tolerant}

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
				return array
			| 'Array' =>
				array = for value, index in node
					processed = simplifyTree value
					switch typeof! processed
					| 'String' => label = "#{index}: #value"; children = []
					| 'Array' => label = "#index"; children = processed
					| _ => throw 'Unexpected returned value'
					obj = {label, children}
				return array
			| _ => "#node"

		result = {ast: simplifyTree AST}


	@instance = JS!
