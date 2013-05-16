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
	node.addList('spaces.1', elements[1]); // FIXME No check is done in case there is none
	// node.ignored = ignored;
	return node;
}

// -------------------------------------------------------------------- Elements
// FIXME Is it always relevant to consider spaces/comments between elements? Sometimes I would like to include whitespaces only as an element. In this case, add the comment as an alternative element, and just consider whitespaces as free text.

element =
	text
	/ statement

elementList = head:element tail:(__ element)* {
	return [head].concat(lib.arrayFromSequence(tail, 1));
}

// ------------------------------------------------------------------------ Text
// The particularity of the text element, is that it is not delimited as other elements, it's just everything that is not an element. So to detect the end of a text, we need to check if another element starts.

text = content:(!elementStart .)+ {
	var node = Node(null, line, column, offset, null);
	node.set('value', lib.valueFromGuardedSequence(content));
	return node;
}

elementStart = "{" / "/*" / "//"

// ------------------------------------------------------------------ Statements
// WARNING the precedence in alternatives is important!

statement =
	inline
	/ cdata
	/ block

// ---------------------------------------------------------------------- Inline
// FIXME

/*inline = "{" id:tagId " /}" {
	var node = Node('inline', line, column, offset);
	node.id = id;
	return node;
}*/
inline = "{" tag:tagContent "/}" {
	var node = Node('inline', line, column, offset);
	node.set('id', tag.id);
	node.set('param', tag.param);
	return node;
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
	node.addList('spaces.1', elements[1]); // FIXME Check existence
	node.add('closeTag', close);
	return node;
}

opening = "{" content:tagContent "}" {
	var node = Node('opening', line, column, offset);
	node.add('id', content.id);
	node.set('param', content.param);
	return node;
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

tagContent = __ id:tagId param:(ws statementParam)? {
	return {
		id: id,
		param: param[1] || ""
	}
}

// FIXME This won't work for inline statements, as this will eat the "/" of "/}"
// FIXME There can be some }, depending on the context: JS Object, string, comment, ...

statementParam = contentWithCurlyEnclosed

contentWithCurlyEnclosed = chars:([^\{\}] / enclosedWithCurly)* {
	return chars.join('');
}

enclosedWithCurly = "{" content:contentWithCurlyEnclosed "}" {
	return "{" + content + "}"
}

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

