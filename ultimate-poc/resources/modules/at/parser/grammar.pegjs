start = ws* template ws*

template = block

block = open:opening elements:(element)* close:closing {return {type: 'block', open: open, elements: elements, close: close}}

opening = "{" ws* id:statementid param:(ws+ jsobject )? ws* "}" {return {id: id, param: param[1]}}
closing = "{/" ws* id:statementid ws* "}" {return {id: id}}

statementid = widgetid / id
widgetid = "@" ns:id ":" widget:id {return {type: 'widget', namespace: ns, widget: widget}}

// FIXME This has been simplified for tests
element = ws





// JavaScript ------------------------------------------------------------------
// TODO Import existing JS rules

jsobject = "{" ws* first:jspair? rest:(ws* "," ws* jspair)* ws* "}" {
	var properties = [];
	if (first != null) {
		properties = [first];
		for (var i = 0; i < rest.length; i++) {
			properties.push(rest[i][3]);
		}
	}
	return {properties: properties};
}

jspair = key:jskey ws* ":" ws* expr:jsexpression {return {key: key, expr: expr}}
jskey = id / jsstring



// FIXME This has been simplified for tests
jsexpression = jskey

// TODO Add the simple quote handling
// TODO Add escaping feature
jsstring = "\"" raw:[^"]* "\"" {return {quote: '"', raw: raw.join('')}}





// Primitives -------------------------------------------------------------------

id = start:idstart rest:idrest* {return start + rest.join('')}
idstart = [$a-zA-Z_]
idrest = idstart / [0-9]

ws = [ \r\n\t]
