start = entryList

// Entries

entryList = (entry eol)+

entry = path eol propertyList? eol

// Properties

propertyList = (property eol)+

property = propId "=" propValue

// ID

propId =
	thisPropId
	/ stringPropId

thisPropId = "@"

stringPropId = doubleQuoteString

// ID

propValue =

// Primitives

doubleQuoteString = // ...
eol = // ...
