This module handles the JavaScript languages.

# Notes

For now, all features are implemented considering only on entire source code.

In the future, for better consistency, simplicity, performances and logic, everything should be working with the graph model, built from the AST.

For instance, a node could be attached the `foldable` property, the `type` property being already present and used for highlighting.

However, the algorithms already implemented will be useful to handle whole changes: these changes modify portions of graphs, it's like an entire source code, but nested in another.

One big thing will be handling slight changes in the graph, and updating the model in a minimum time.

# Work in progress

## Formatting

The concept of formatting code is simple: you receive a source code, you return the same source code, but formatted. Semantically they are the same, syntactically they are close (only a difference is whitespaces generally): what changes the most is the information of positions (and length).

Formatting transforms the code, thus it impacts almost all other features relying on positions:

* highlight: highlighting is implemented with ranges of text styles
* outline: the outline should remain the same, since the semantic should remain the same. However, if the outline either displays positions information or is linked to the editor (when you sleect a node in outline you jump to the corresponding position in the editor), it relies on positions
* ...

For now, the API only allow you to pass in a source code, and to receive the new source code.

It's up to the client (frontend) to compute lengths difference.

However, you can in the same request ask for other information to be sent, like highlighting and outlining (to avoid the overhead of making those requests by yourself after).

Future of the API:

* session management: the method will act on a model stored in a session, this way you will be able to pass a range (or a list of ranges) to format instead of a source code.
* _partial_ code formatting: sometimes when you ask for formatting, you ask it for a selected text, but the formatting can only be applied on a wider portion of text, to form a valid code. This could be handled only with sessions and ranges input. The method would receive a range to format, and send back the formatted source code, and the actual range that has been formatted (considering the original text as reference).

## Parsing

## Folding

The model for folding is rather simple.

A fold happens on a set of consecutive lines. Thus the output model of folding is a set of line ranges, possibly overlapping by the way.

How to compute these ranges is another story...

### Internal

A foldable portion of source code is linked to semantics. In general, block statements are foldable.

After obtaining the AST of the source code, all nodes must be traversed. Only nodes corresponding to blocks will be processed.

Such a node should contain location information in the form of `line`, `column` (this feature is provided by the parsers I use). Just take the range of lines it spans and return it.

### TODO

Think about the case where there are multiple multi-lines blocks on the same line: they overlap while one is ending and the other one is starting. This would have some weird behavior folding them.

## Highlighting


# 3rd party libraries

## Outline

None, we use a pure custom implementation, are this is something rather opiniated.

## Validation

* [JSHint](http://jshint.com/)

## Highlighting

* Custom?

## Format

* [js-beautify](https://npmjs.org/package/js-beautify)

## Parsers

All parsers are compliant to the [Mozilla Parser API specification](https://developer.mozilla.org/en-US/docs/SpiderMonkey/Parser_API)

* [Esprima](http://esprima.org/): maybe the fastest and most famous JavaScript parser implemented for JavaScript
* [reflect.js](https://github.com/zaach/reflect.js): supports the [_builder objects_](https://developer.mozilla.org/en-US/docs/SpiderMonkey/Parser_API#Builder_objects) defined in the specification, so that we can directly build our custom model from the parser
