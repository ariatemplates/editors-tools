// Initializer -----------------------------------------------------------------

{
	var lib = require('pegjs-parser/initializer');

	var instancier = lib.NodeInstancier('html');
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

element =
	text
	/ node

elementList = head:element tail:(__ element)* {
	return [head].concat(lib.arrayFromSequence(tail, 1));
}

// ------------------------------------------------------------------------ Text
// The particularity of the text element, is that it is not delimited as other elements, it's just everything that is not an element. So to detect the end of a text, we need to check if another element starts.

text = content:(!elementStart .)+ {
	var node = Node('text', line, column, offset);
	node.set('value', lib.valueFromGuardedSequence(content));
	return node;
}

elementStart = "<"

// ----------------------------------------------------------------------- Nodes
// WARNING the precedence in alternatives is important!

node =
	directive
	/ inline
	/ cdata
	/ block

// ------------------------------------------------------------------- Directive

directive = "<!" __ id:id __ content:(!">" .)* ">" {
	var node = Node('directive', line, column, offset)
	node.set('id', id);
	node.set('content', lib.valueFromGuardedSequence(content));
	return node;
}

// ---------------------------------------------------------------------- Inline

// inline = "<" tag:tagContent "/>" {
// 	var node = Node('inline', line, column, offset);
// 	node.set('tag', tag.id);
// 	node.addList('attributes', tag.attributes);
// 	return node;
// }

inline = "<" __ id:inlineIds __ attributes:(attributeList __)? slash:"/"? ">" {
	var node = Node('inline', line, column, offset);
	node.set('tag', id);
	node.addList('attributes', lib.valueFromList(attributes));
	node.set('slash', slash != "");
	return node;
}

inlineIds =
	"br"
	/ "link"
	/ "meta"

// ----------------------------------------------------------------------- CDATA
// XXX Does HTML should recognize CDATA? XHTML I guess... http://en.wikipedia.org/wiki/CDATA

cdata = "<![CDATA[" content:(!endOfCdata .)* endOfCdata {
	var node = Node('cdata', line, column, offset)
	node.set('content', lib.valueFromGuardedSequence(content));
	return node;
}

endOfCdata = "]]>"

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

opening = "<" content:tagContent ">" {
	var node = Node('opening', line, column, offset);
	node.set('id', content.id);
	node.addList('attributes', content.attributes);
	return node;
}

closing = "</" ws0:__ id:id ws1:__ ">" {
	var node = Node('closing', line, column, offset);
	node.addList('spaces.0', ws0);
	node.set('id', id);
	node.addList('spaces.1', ws1);
	return node;
}

// ------------------------------------------------------------------------- Tag

tagContent = __ id:id __ attributes:(attributeList __)? {
	return {
		id: id,
		attributes: lib.valueFromList(attributes)
	};
}

// ------------------------------------------------------------------- Attribute

attribute = key:id value:(__ "=" __ attrvalue)? {
	var node = Node('attribute', line, column, offset);
	node.set('key', key);
	if (value !== "") {
		node.addList('spaces.0', value[0]);
		node.addList('spaces.1', value[2]);
		node.add('value', value[3]);
	}
	return node;
}

// TODO handle white spaces
attributeList = head:attribute tail:(__ attribute)* {
	return [head].concat(lib.arrayFromSequence(tail, 1));
}

attrvalue =
	string
	/ word

// --------------------------------------------------------------------- Strings

string =
	doubleQuoteString
	/ simpleQuoteString

doubleQuoteString = '"' raw:(!'"' .)* '"' {
	var node = Node('string', line, column, offset);
	node.set('quote', '"');
	node.set('value', lib.valueFromGuardedSequence(raw));
	return node;
}

simpleQuoteString = "'" raw:(!"'" .)* "'" {
	var node = Node('string', line, column, offset);
	node.set('quote', "'");
	node.set('value', lib.valueFromGuardedSequence(raw));
	return node;
}

// -------------------------------------------------------------------- Comments

comment = "<!--" content:(!"-->" .)* "-->" {
	var node = Node('comment', line, column, offset);
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

word = content:(!ws .)* {return lib.valueFromGuardedSequence(content);}

alpha = [a-zA-Z]
digit = [0-9]
