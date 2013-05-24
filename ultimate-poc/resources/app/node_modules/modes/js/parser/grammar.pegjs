// JavaScript ------------------------------------------------------------------

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
