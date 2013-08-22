Editor view of a document.

# File system layout

* [`README.md`](./README.md): this current file
* [`POCEditor.java`](./POCEditor.java): a class to implement the editor itself
* [`POCSourceViewerConfiguration.java`](./POCSourceViewerConfiguration.java): a class to configure the editor
* [`POCTokenScanner.java`](./POCTokenScanner.java): a class in charge to return a list of tokens given a portion of source code

# Versioning

To version: _everything_.

# Documentation

## Editor

__The editor is a kind of a hub class, it centralizes the services related to edition, but delegates a lot to other classes.__

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

## Alignment with the latest backend implementation

__The backend changed a lot, and the plugin needs to use differently.__ See [this](/ultimate-poc/src/poc#alignment-with-the-latest-backend-implementation) for a recap.

Occurences of RPC calls to be adapted:

* [`POCEditor`](./POCEditor.java)`.outline`
* [`POCEditor`](./POCEditor.java)`.fold`
* [`POCSourceViewerConfiguration`](./POCSourceViewerConfiguration.java)`()`
* [`POCTokenScanner`](./POCTokenScanner.java)`.setRange`
* [`POCTokenScanner`](./POCTokenScanner.java)`.getStylesheet`

An additional things is the change of the name of the method used to get tokens in `POCTokenScanner.setRange()`: from `tokenize` to `highlight` (change `POCTokenScanner.TOKENIZE_MEMBER_KEY`). Probably there are also other changes in the format of this method, please refer to the documentation of the backend concerning [highlighting](/ultimate-poc/resources/app/node_modules/modes/node_modules#highlighting).

## Highlighting

__Finish the first implementation of highlighting.__

Hihlighting is a huge topic, because Eclipse RCP tries to provide a lot of support with efficiency in mind.

It involves things like:

* damager/repairer protocol
* token scanner

The second one, __the token scanner__, is explained [above](#token-scanner) and is something that must be able to return tokens for some range of code.

It is rather simple, because it takes as input a range that it must store, and then is queried for tokens inside this range. The only _hard_ thing to handle is returning the set of tokens for a given range, but the backend takes care of sending the proper list of tokens.

The first thing, the __damager/repairer__ is something more complicated that has to be investigated.

It basically tries to identify which part of a document has been impacted by a change, and then asks some services to repair this part.

An example will be simple. Let's take a piece of javascript code that is going to be commented:

```javascript
function foo() {
	var bar = baz;
}
```

With only one insertion at one position, the highlighting changes from this position to the end of the line:

```javascript
function foo() {
	//var bar = baz;
}
```

The damager will detect that the full line has to be repaired, and then the token scanner will be invoked with the corresponding range.

__However, we need to take care that the proper range is always detected.__ For instance: with an opening multi-line comment, the whole rest of the document (until the end) must be re-highlighted.

__It would be good if for a first implementation the whole document was re-highlighted everytime.__

### Synchronization with updates

__Another important issue is to check that highlighting update is made after the doucment has been updated in the backend.__

Indeed, document updates are handled by the POCDocument class, and synchronization with the backend by the POCDocumentListener one.

So when the document is changed due to an input of the user, the latter will send the change to the backend, and then it's up to the client to call all necessary services to update the views.

However, we don't know when the repairer is trying to update the highlighting afetr a document change: before or after the document listener is called? And will the backend have the time to update it too? (this is an issue of the backend to synchronize properly the requests)

### Handle more text presentation data

The backend returns text presentation data in the stylesheet. There is information about the color of the text but also its _style_: italic, bold, etc.

For now, only the color is taken into account, so process the other information.

The method `POCTokenScanner.getAttribute()` returns the [`TextAttribute`](http://help.eclipse.org/kepler/index.jsp?topic=%2Forg.eclipse.platform.doc.isv%2Freference%2Fapi%2Forg%2Feclipse%2Fjface%2Ftext%2FTextAttribute.html) instance which should take more data: use the third constructor with color, background, style and font.

Use the [`Font`](http://help.eclipse.org/kepler/index.jsp?topic=%2Forg.eclipse.platform.doc.isv%2Freference%2Fapi%2Forg%2Feclipse%2Fswt%2Fgraphics%2FFont.html) class to handle: bold, italic and family.

Be careful of properly handling default style (the stylesheet provides default attributes for styles skipping some of them).

## Editor, Source viewer configuration or document package?

Move some services from the editor to the source viewer configuration class or the document package.

## Editor configuration at initialization

Fix the mode resolution in the source viewer configuration (refer to the class itself for more information).

## Other services

__Implement other services.__

There are two parts in implementing a service:

* communicating with the backend to get required data for the service
* using this data and apply specific processings with it on the clinet to _complete_ the service

Services to be set up:

1. Folding
1. Formatting
1. Content assist

## Performances

### Highlighting

1. Cache styles
1. Pre-process entirely the stylesheet: it changes rarely (if it's not never) so it won't have to be done too often

## Documentation

### Folding

__Complete the documentation the work that has been done for folding.__

* review what has been written already
* [ymeine](https://github.com/ymeine): put the references of the resources I used (I mainly copied and arranged code from a tutorial)
