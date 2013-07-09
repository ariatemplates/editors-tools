Editor view of a document.

# File system layout

* `README.md`: this current file
* `POCEditor.java`: a class to implement the editor itself
* `POCSourceViewerConfig.java`: a class to configure the editor
* `POCTokenScanner.java`: a class in charge to return a list of tokens given a portion of source code

# Versioning

To version: _everything_.

# Documentation

## Editor

The editor is a kind of a hub class, it centralizes the services related to edition, but delegates a lot to other classes.

The main work of configuration, setup of services like highlighting and so on is delegated to a source viewer configurator, which configures the source viewer embedded in the editor.

Services more _external_ are implemented through _adapters_. A generic method named `getAdapter` is called multiple times by the editor itself. This method receives a type specification (`Class`) corresponding to the required service. It's free to the user to return or not an implementation as a response.

Currently used adapters:

* outline view

## Source viewer configuration

The source viewer configuration sets the following services up:

* Highlighting: ___IMPLEMENTING___ using the token scanner
* Formatting: ___PENDING___
* Content assist: ___PENDING___

## Token scanner

As for almost everything in Eclipse, you can implement custom behavior if you achieve to find the proper interface. Here it is.

The token scanner basically receives a document and a range, and must be able then to return corresponding tokens until it receives a new _update request_.

For the time being, the token scanner is used only for highlighting, so it will return tokens with styling data.

### Notes

__Be careful!__

This is not obvious, but the process for highlighting expects the token scanner to return tokens __for the whole input__, I mean that if you _concatenate_ every range of each token, you must get a continuous range equaling the whole input. In clearer words: every whitespace must be taken into account.

This is not obvious since the interface of the token scanner is able to return both an offset (index) and a length for a token, so that the client can know the properties `start`, `length`, and `end` and can do everything with that.

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

## Folding

Folding is currently a work in progress, and as for highlighting (at the time of writing), it works statically (doesn't support dynamic updates).

Folding is implemented in Eclipse using a _complex_ system. It has a concept of views on data.

Here, the graphical view, that the user sees, uses a model which is a view on the actual document behind. They rather call that a projection. This projection takes into account folded parts: some lines are removed, and that's why they are not displayed. However the line numbers are kept consistent, and some additional GUI components are added: that is handled by a specific text viewer.

To sum it up, folding requires both:

* having a projection document coming above the actual document: this is a document with some lines removed but with some folding information
* using a specific viewer, able to use this information

In fact, folding handles for instance use a genric feature of the text editors: annotations.

# Contribute

1. Finish the first implementation of highlighting (it can consider reparsing the whole source everytime)
1. Move some services from the editor to the source viewer configuration class or the document package
1. Fix the mode resolution in the source viewer configuration (refer to the class itself for more information)
1. Clean the code
1. Complete folding implementation
1. Implement formatting
1. Implement content assist

## Performances

### Highlighting

1. Cache styles
1. Pre-process entirely the stylesheet
1. Change the tokenizing format (backend) to accept shorter token style specification (with color names for instance)

## Documentation

1. Complete the documentation the work that has been done for folding
	* review what has been written already
	* put the references of the resources I used ([I](https://github.com/ymeine) mainly copied and arranged code from a tutorial)
