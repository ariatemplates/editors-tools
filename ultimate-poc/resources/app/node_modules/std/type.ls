# require! {
# 	prelude: 'prelude-ls'
# }
# _is = prelude.is-type

_is = (type, arg) --> typeof! arg is type

isNumber   = _is 'Number'
isBoolean  = _is 'Boolean'
isString   = _is 'String'
isRegExp   = _is 'RegExp'
isDate     = _is 'Date'
isArray    = _is 'Array'
isObject   = _is 'Object'
isFunction = _is 'Function'



exports <<< {
	is: _is

	isNumber
	isNb: isNumber
	isnb: isNumber

	isBoolean
	isBool: isBoolean
	isbool: isBoolean

	isString
	isStr: isString
	isstr: isString

	isRegExp
	isRegEx: isRegExp
	isRegex: isRegExp
	isRe: isRegExp
	isre: isRegExp

	isDate

	isArray
	isarray: isArray
	isArr: isArray

	isObject
	isobject: isObject
	isObj: isObject
	isobj: isObject

	isFunction
	isFn: isFunction
	isfn: isFunction
}
