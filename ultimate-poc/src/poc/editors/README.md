# File system layout

* `README.md`: thsi current file
* `POCEditor.java`: a class to implement the editor itself
* `POCSourceViewerConfig.java`: a class to configure the editor
* `POCTokenScanner.java`: a class in charge to return a list of tokens given a portion of source code

# Versioning

To version: _everything_.

# Documentation

## Editor

The editor is a kind of a hub class, it centralizes the services related to edition, but delegates a lot to other classes.

The main work of configuration, setup of services like highlighting and so on is delegated to a source viewer configurator, which configures the source viewer embedded in the editor.

Services more _external_ are implemented through _adapters_.

A generic method `getAdapter` is called multiple times by the editor itself. This method receives a type specification (`Class`) corresponding to the required service. It's free to the user to return or not an implementation as a response.

Currently used adapters:

* outline view

### FIXME

* See how to hook editor events, notably changes of the document (maybe it's rather inside the document class itself)
* Some services have a beginning of implementation in the editor class itself, but it would rather go in other classes, like the source viewer configuration or the document

## Source viewer configuration

The source viewer configuration sets the following services up:

* Highlighting: ___IMPLEMENTING___ using the token scanner
* Formatting: ___PENDING___
* Content assist: ___PENDING___

## Token scanner

As for almost everything in Eclipse, you can implement custom behavior if you achieve to find the proper interface. Here it is.

The token scanner basically receives a document and a range, and must be able then to return corresponding tokens until it receives a new _update request_.

For the time being, the token scanner is used only for highlighting, so it will return tokens with styling data.

Paths for optimization:

* cache styles
* pre-process entirely the stylesheet
* change the tokenizing format (backend) to accept shorter token style specification (with color names for instance)

### Notes

__Be careful!__

This is not obvious, but the process for highlighting expects the token scanner to return tokens __for the whole input__, I mean that if you _concatenate_ every range of each token, you will get a continuous range equaling the whole input. In clearer words: every whitespace must be taken into account.

This is not obvious since the interface of the token scanner is able to return both an offset (index) and a length for a token, so that the client can know the triple: `start`, `length`, `end`, and can do everything with that.

This is even how highlithing works, it asks for each encountered token the offset and the length, and applies styling on the corresponding range, using the data embedded in the token (text presentation data).

However, this is not consistent since it tries to optimize it when consecutive tokens return the same text presentation data: in this case it just adds the lengths of the tokens, and uses the offset of the first token, in order to apply the text presentation only once.

It will be easier to understand with an example. Imagine this source code:

`a() ;`

and the correponding tokens:

* `identifier, 0, 1`: `black`
* `punctuator, 1, 2`: `blue`
* `punctuator, 2, 3`: `blue`
* `punctuator, 4, 5`: `blue`

Eclipse will first apply the `black` style for range `0, 1`. Then, it will _concatenate_ the ranges for the three punctuators which have the same style, `blue`. In the end, it applies the style `blue` on range `1, 1+(1+1+1)` = `1, 4`, which is wrong.

To avoid this, ensure that you have a token for every portion of the source code, like this:

* `identifier, 0, 1`: `black`
* `punctuator, 1, 2`: `blue`
* `punctuator, 2, 3`: `blue`
* `whitespace, 3, 4`: `...`
* `punctuator, 4, 5`: `blue`

Have a look at the `createPresentation` method of the `org.eclipse.jface.text.rules.DefaultDamagerRepairer` class for more information.

# FIXME

* For now the RPC has some hardcoded values, notably the name of the module to call - which is in our case the name of the mode to use. Find a way to know in which mode a class is running (for JavaScript, HTML, ...). If we have a look at the TokenScanner class, the only contextual information it can get is the Document instance. And this sounds logical anyway to put it in the document!! Now the question is how do we do that, is there a pool of custom properties, or we need to subclass and then to cast...?
