/**
 * These are functions called by the parser to build nodes of the graph. They follow the Mozilla Parser API specification.
 *
 * In fact these are not the actual functions, they only properly store the data the parser gives them. Each is then wrapped in another function performing some computations and adding other properties.
 *
 * WARNING: the wrapping function uses the length propertie of these functions to work properly, so you need to declare explicitely the formal parameters!!
 *
 * The optional loc parameter is handled implicitely by the wrapping function, so is the raw parameter for some very specific types of nodes.
 *
 * Some functions are put under properties of the object: these are grouping properties and their names must be appended to the names of the functions when creating the builder.
 */

 # TODO: there could be even more automated management of this, with declarative function parameters (we get the name of children properties, along with the position and number of actual arguments)
 # maybe for each parameter: position, resulting name, destination object (children, property, ...)

exports <<< {

program: (body) -> @links.children = index: {body}


Statement:
	empty: ->
	block: (body) -> @links.children = index: {body}
	expression: (expr) -> @links.children = index: {expression: expr}
	labeled: (label, body) -> @links.children = index: {label, body}
	if: (test, cons, alt) -> @links.children = index: {test, consequence: cons, alternative: alt}
	switch: (disc, cases, isLexical) ->
		@links.children = index: {disc, cases}
		@properties = {isLexical}
	while: (test, body) -> @links.children = index: {test, body}
	doWhile: (body, test) -> @links.children = index: {body, test}
	for: (init, test, update, body) -> @links.children = index: {init, test, update, body}
	forIn: (left, right, body, isForEach) ->
		@links.children = index: {receiver: left, container: right, body}
		@properties = {isForEach}
	break: (label) -> @links.children = index: {label}
	continue: (label) -> @links.children = index: {label}
	with: (obj, body) -> @links.children = index: {obj, body}
	return: (arg) -> @links.children = index: {arg}
	try: (body, handlers, fin) -> @links.children = index: {body, handlers, final: fin}
	throw: (arg) -> @links.children = index: {arg}
	debugger: ->
	let: (head, body) -> @links.children = index: {head, body}


Declaration:
	function: (name, args, body, isGenerator, isExpression) ->
		@links.children = index: {args, body}
		@properties = {name, isGenerator, isExpression}
	variable: (kind, dtors) ->
		@links.children = index: {declarators: dtors}
		@properties = {kind}
Declarator:
	variable: (patt, init) ->	@links.children = index: {receiver: patt, initializer: init}


Expression:
	sequence: (exprs) -> @links.children = index: {expressions: exprs}
	conditional: (test, cons, alt) -> @links.children = index: {test, consequence: cons, alternative: alt}
	unary: (op, arg, isPrefix) ->
		@links.children = index: {operande: arg}
		@properties = {isPrefix}
	binary: (op, left, right) ->
		@links.children = index: {left, right}
		@properties = {operator: op}
	assignment: (op, left, right) ->
		@links.children = index: {receiver: left, value: right}
		@properties = {operator: op}
	logical: (op, left, right) ->
		@links.children = index: {left, right}
		@properties = {operator: op}
	update: (op, arg, isPrefix) ->
		@links.children = index: {operande: arg}
		@properties = {operator: op, isPrefix}
	new: (callee, args) -> @links.children = index: {callee, args}
	call: (callee, args) -> @links.children = index: {callee, args}
	member: (obj, prop, isComputed) ->
		@links.children = index: {obj, property: prop}
		@properties = {isComputed}
	function: (name, args, body, isGenerator, isExpression) ->
		@links.children = index: {args, body}
		@properties = {name, isGenerator, isExpression}
	array: (elts) -> @links.children = index: {elements: elts ? []}
	object: (props) -> @links.children = index: {properties: props}
	this: ->
	graph: (index, expr) ->
		@links.children = index: {expression: expr}
		@properties = {index}
	graphIndex: (index) -> @properties = {index}
	comprehension: (body, blocks, filter) -> @links.children = index: {expression: body, comprehensions: blocks, filter}
	generator: (body, blocks, filter) -> @links.children = index: {expression: body, comprehensions: blocks, filter}
	yield: (arg) -> @links.children = index: {arg}
	let: (head, body) -> @links.children = index: {declarators: head, body}


Pattern:
	array: (elts) -> @links.children = index: {elements: elts ? []}
	object: (props) -> @links.children = index: {properties: props}
	property: (key, patt) -> @links.children = index: {key, value: patt}




switchCase: (test, cons) ->
	@links.children = index: {consequence: cons}
	if test? => @links.children.test = test
	else @properties = {+isDefault}
catchClause: (arg, guard, body) -> @links.children = index: {arg, guard, body}
comprehensionBlock: (left, right, isForEach) ->
	@links.children = index: {receiver: left, container: right}
	@properties = {isForEach}



identifier: (name) -> @properties = {name}
literal: (val) -> @properties = {value: val}
property: (kind, key, val) ->
	@links.children = index: {key, value: val}
	@properties = {kind}

}
