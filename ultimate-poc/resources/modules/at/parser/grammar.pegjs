// TODO Reorganize the code

// Initializer -----------------------------------------------------------------

{
	var lib = require('pegjs-parser/initializer');

	var instancier = lib.NodeInstancier('at');
	var Node = function() {return instancier.create(arguments)}

	var ignored = [];
}



// Grammar ---------------------------------------------------------------------

// ------------------------------------------------------------------------ Root

start = ws0:__ elements:(elementList __)? {
	var node = Node('root', line, column, offset);
	node.addList('spaces.0', ws0);
	node.addList('elements', lib.valueFromList(elements));
	if (elements !== "") {
		node.addList('spaces.1', elements[1]);
	}
	// node.ignored = ignored;
	return node;
}

// -------------------------------------------------------------------- Elements
// FIXME Is it always relevant to tell there can be some spaces between elements? I mean, these spaces could be part of the elment itself: think for instance of free text immediately following an opening tag, but think also that sometimes in some languages you consider this prepended spaces as an initial indent, for output formatting purposes. In this case, add the comment as an alternative element, and just consider whitespaces as free text.

element =
	text
	/ statement

elementList = head:element tail:(__ element)* {
	return [head].concat(lib.arrayFromSequence(tail, 1));
}

// ------------------------------------------------------------------------ Text
// The particularity of the text element, is that it is not delimited as other elements, it's just everything that is not an element. So to detect the end of a text, we need to check if another element starts.

text = content:(!statementStart .)+ {
	var node = Node(null, line, column, offset, null);
	node.set('value', lib.valueFromGuardedSequence(content));
	return node;
}

statementStart = "${" / "{" / "/*" / "//"

// ------------------------------------------------------------------ Statements
// WARNING the precedence in alternatives is important!

statement =
	expression
	/ inline
	/ cdata
	/ block

// ------------------------------------------------------------------ Expression
// TODO Really parse the content of the expression: "expr(|arg(:value)?)*"
// TODO Add this start

expression = "${" ws0:__ param:blockStatementParam? ws1:__ "}" {
	var node = Node('expression', line, column, offset);
	node.addList('spaces.0', ws0);
	node.set('param', param);
	node.addList('spaces.1', ws1);
	return node;
}

// TODO Handle escaped pipes
expressionContent = value:expressionValue? parameters:(expressionParameter)* {

}
expressionValue = content:(!"|" .)+ {return lib.valueFromGuardedSequence(content)}
expressionParameter = value:expressionParameterValue args:(":" expressionParameterArg)? {

}
expressionParameterValue = content:(!":" .)+ {return lib.valueFromGuardedSequence(content)}
// TODO Split args with commas?
expressionParameterArg = content:(!"|" .)+ {return lib.valueFromGuardedSequence(content)}

// ---------------------------------------------------------------------- Inline

inline = "{" __ id:tagId param:(ws inlineStatementParam)? "/}" {
	var node = Node('inline', line, column, offset);
	node.add('id', id);
	node.set('param', param[1] || "");
	return node;
}

inlineStatementParam = content:(!"/}" bracedContent)* {
	return lib.valueFromGuardedSequence(content);
}

// ----------------------------------------------------------------------- CDATA

cdata = "{" ws0:__ "CDATA" ws1:__ "}" content:(!endOfCdata .)* endOfCdata {
	var node = Node('cdata', line, column, offset)
	node.addList('spaces.0', ws0);
	node.addList('spaces.1', ws1);
	node.set('content', lib.valueFromGuardedSequence(content));
	return node;
}

endOfCdata = "{/" __ "CDATA" __"}"

// ----------------------------------------------------------------------- Block

block = open:opening ws0:__ elements:(elementList __)? close:closing {
	var node = Node('block', line, column, offset);
	node.add('openTag', open);
	node.addList('spaces.0', ws0);
	node.addList('elements', lib.valueFromList(elements));
	if (elements !== "") {
		node.addList('spaces.1', elements[1]);
	}
	node.add('closeTag', close);
	return node;
}

opening = "{" __ id:tagId param:(ws blockStatementParam)? "}" {
	var node = Node('opening', line, column, offset);
	node.add('id', id);
	node.set('param', param[1] || "");
	return node;
}

blockStatementParam = content:(!"}" bracedContent)* {
	return lib.valueFromGuardedSequence(content);
}

closing = "{/" ws0:__ id:tagId ws1:__ "}" {
	var node = Node('closing', line, column, offset);
	node.addList('spaces.0', ws0);
	node.add('id', id);
	node.addList('spaces.1', ws1);
	return node;
}


// ------------------------------------------------------------------------- Tag
// FIXME Check the id specification
// FIXME Check the widget id

tagId =
	widgetId
	/ standardId

widgetId = "@" ws0:__ ns:id ws1:__ ":" ws2:__ widget:id {
	var node = Node('widgetId', line, column, offset);
	node.addList('spaces.0', ws0);
	node.set('namespace', ns);
	node.addList('spaces.1', ws1);
	node.addList('spaces.2', ws2);
	node.set('widget', widget);
	return node;
}

standardId = id:id {
	var node = Node('id', line, column, offset);
	node.set('value', id);
	return node;
}

// ----------------------------------------------------------------------- Param
// FIXME There can be some }, depending on the context: JS Object, string, comment, ...
// FIXME Handle escaped braces

braced = "{" content:bracedContent* "}" {
	return "{" + content.join('') + "}"
}

bracedContent = braced / nonbraced

nonbraced = [^{}] / "\\{" / "\\}"

// -------------------------------------------------------------------- Comments

comment =
	multiLineComment
	/ singleLineComment

multiLineComment = "/*" content:(!"*/" .)* "*/" {
	var node = Node('multi-line-comment', line, column, offset);
	node.set('value', lib.valueFromGuardedSequence(content));
	return node;
}

singleLineComment = "//" content:(!eol .)* eol {
	var node = Node('single-line-comment', line, column, offset);
	node.set('value', lib.valueFromGuardedSequence(content));
	return node;
}

// --------------------------------------------------------------------- Various

__ = elements:(wsSequence / comment)* {
	ignored = ignored.concat(elements);
	return elements;
}

// Primitives ------------------------------------------------------------------

// -------------------------------------------------------------------------- ID

id = start:idstart rest:idrest* {return start + rest.join('')}
special = [$_]
idchars = alpha / special
idstart = idchars
idrest = idchars / digit

// ---------------------------------------------------------------- White spaces

ws = [ \r\n\t]

wsSequence =
	spaces
	/ tabs
	/ eol

spaces = content:" "+ {
	var node = Node('spaces', line, column, offset);
	node.set('size', content.length);
	return node;
}

tabs = content:"\t"+ {
	var node = Node('tabs', line, column, offset);
	node.set('size', content.length);
	return node;
}

eol = value:("\r" / "\n" / "\r\n") {
	var node = Node('eol', line, column, offset);
	node.set('value', value);
	return node;
}

// --------------------------------------------------------------------- Various

alpha = [a-zA-Z]
digit = [0-9]

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// ----------------------------------------------------------------------- Tests

// XXX Add a semantic dimension, like:
// - it's the opening of a tag
// - ...
// In fact, only __ between terminals avoids computing the position of elements.

openingCurlyBracket = "{" {
	var node = Node('token.bracket.curly.opening', line, column, offset);
	node.set('char', lib.openingCurlyBracket); // Hack to conform to PEG.js syntax
	return node;
}


closingCurlyBracket = "}" {
	var node = Node('token.bracket.curly.closing', line, column, offset);
	node.set('char', lib.closingCurlyBracket); // Hack to conform to PEG.js syntax
	return node;
}

