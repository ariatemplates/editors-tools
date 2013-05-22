module-exports = (node) -> switch node.type
| 'Program'
	label = 'Program'
	children = node.links.children.index.body.outline.children

	{label, children}



| 'EmptyStatement'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'BlockStatement'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'ExpressionStatement'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'LabeledStatement'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'IfStatement'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'SwitchStatement'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'WhileStatement'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'DoWhileStatement'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'ForStatement'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'ForInStatement'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'BreakStatement'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'ContinueStatement'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'WithStatement'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'ReturnStatement'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'TryStatement'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'ThrowStatement'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'DebuggerStatement'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'LetStatement'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'FunctionDeclaration'
	label = node.type
	children = node.links.children.list

	{label, children}


# Implemented
| 'VariableDeclaration'
	children = node.links.children.list
	if children.length is 1
		firstChild = children.0.outline
		if not firstChild.children?
			{firstChild.label}
	else {label: 'Declarations', children}



# Implemented
| 'VariableDeclarator'
	# var/let/... identifier
	label = "#{node.links.parent.properties.kind} #{children.index.id.outline.label}"
	init = children.index.init
	if init?
		# var/let/... identifier =
		label += " = "
		initOutline = initOutline
		if not initOutline.children?
		# var/let/... identifier = simpleExpression
			label += initOutline.label
		else children = initOutline.children

	{label, children}



| 'SequenceExpression'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'ConditionalExpression'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'UnaryExpression'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'BinaryExpression'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'AssignmentExpression'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'LogicalExpression'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'UpdateExpression'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'NewExpression'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'CallExpression'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'MemberExpression'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'FunctionExpression'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'ArrayExpression'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'ObjectExpression'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'ThisExpression'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'GraphExpression'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'GraphIndexExpression'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'ComprehensionExpression'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'GeneratorExpression'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'YieldExpression'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'LetExpression'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'ArrayPattern'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'ObjectPattern'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'PropertyPattern'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'SwitchCase'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'CatchClause'
	label = node.type
	children = node.links.children.list

	{label, children}



| 'ComprehensionBlock'
	label = node.type
	children = node.links.children.list

	{label, children}


# Implemented
| 'Identifier' => {label: node.properties.name}
| 'Literal' => {label: node.properties.value}




| 'Property'
	label = node.type
	children = node.links.children.list

	{label, children}


