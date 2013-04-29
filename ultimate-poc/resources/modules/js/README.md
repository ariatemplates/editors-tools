This module handles the JavaScript languages.

Supported features:

* ...

# 3rd party libraries

## Outline

None, we use a pure custom implementation, are this is something rather opiniated.

## Validation

* [JSHint](http://jshint.com/)

## Highlighting

* Custom?

## Parsers

All parsers are compliant to the [Mozilla Parser API specification](https://developer.mozilla.org/en-US/docs/SpiderMonkey/Parser_API)

* [Esprima](http://esprima.org/): maybe the fastest and most famous JavaScript parser implemented for JavaScript
* [reflect.js](https://github.com/zaach/reflect.js): supports the [_builder objects_](https://developer.mozilla.org/en-US/docs/SpiderMonkey/Parser_API#Builder_objects) defined in the specification, so that we can directly build our custom model from the parser
