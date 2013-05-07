// Initializer -----------------------------------------------------------------

{
	var Node = function(type, line, column, index) {
		return {
			type: type,
			line: line,
			column: column,
			index: index
		};
	};
}

// Template grammar ------------------------------------------------------------

// ------------------------------------------------------------------------ Root

start = __ root:block __ {
	var node = Node('template', line, column, offset);
	node.root = root;
	return node;
}

// ------------------------------------------------------------------ Statements

//

statement =
	block
	/ inline

// ------------------------------------------------------------- Block statement

block = open:opening __ elements:(element)* __ close:closing {
	var node = Node('block', line, column, offset);
	node.open = open;
	node.elements = elements;
	node.close = close;
	return node;
}

// ------------------------------------------------- Block statement opening tag

opening = "{" content:tagContent "}" {
	var node = Node('opening', line, column, offset);
	node.id = content.id;
	node.param = content.param;
	return node;
}

// ------------------------------------------------- Block statement closing tag

closing = "{/" id:statementid __ "}" {
	var node = Node('closing', line, column, offset);
	node.id = id;
	return node;
}

// ----------------------------------------- Inline statement / self-closing tag

inline = "{" content:tagContent "/}" {
	var node = Node('inline', line, column, offset);
	node.id = content.id;
	node.param = content.param;
	return node;
}

// ----------------------------------------------------------------- Tag content

tagContent = id:statementid param:(ws statementParam)? __ {
	return {
		id: id,
		param: param[1] || ""
	}
}

// --------------------------------------------------------------------- Tag ids

statementid = widgetid / id

// ------------------------------------------------------------------- Widget id

widgetid = "@" ns:id ":" widget:id {
	var node = Node('widgetid', line, column, offset);
	node.namespace = ns;
	node.widget = widget;
	return node;
}



// FIXME This has been simplified for tests
element =
	statement
	/ (!"{" .)

nonstatement = (!statement .*)


// FIXME There can be some }, depending on the context: JS Object, string, comment, ...
statementParam = contentWithCurlyEnclosed
contentWithCurlyEnclosed = chars:([^\{\}] / enclosedWithCurly)* {
	return chars.join('');
}
enclosedWithCurly = "{" content:contentWithCurlyEnclosed "}" {
	return "{" + content + "}"
}


// Primitives ------------------------------------------------------------------

id = start:idstart rest:idrest* {return start + rest.join('')}
idstart = "$" / alpha
idrest = idstart / digit

__ = (ws / comment)*

comment = "/*" chars:(!"*/" .)* "*/" {
	var value = [];
	for (var i = 0; i < chars.length; i++) {
		value.push(chars[i][1]);
	}

	var node = Node('multi-line-comment', line, column, offset);
	node.value = value.join('');
	return node;
}

ws = [ \r\n\t]
alpha = [a-zA-Z_]
digit = [0-9]
