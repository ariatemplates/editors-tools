This document explains how to use the backend services in order to write a client.

# Introduction

If you read this documentation it means you are ready to implement a client, or more generally you want to use the backend services.

First, we will recap you how the communication with the backend works.

Then, after knowing how to communicate, we will tell you ___what___ to communicate, what kind of information you can request and receive.

# Communication interface

The backend runs as a server: therefore it uses network concepts.

To be able to use a server, a few information is needed:

* network address
* protocol(s) used, and what is built on top

## Network address

__For now__, the backend is served on [__localhost__](http://localhost), and listening to connections on port [__3000__](http://localhost:3000).

## Protocol

It uses the [__HTTP__](http://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol) protocol.

On top of it is implemented a [__RPC__](http://en.wikipedia.org/wiki/Remote_procedure_call) protocol, using [__JSON__](http://en.wikipedia.org/wiki/JSON).

However, there are other small services available through pure [__HTTP__](http://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol), please refer to the main documentation for more details on available _routes_.

### RPC

[RPC](http://en.wikipedia.org/wiki/Remote_procedure_call) stands for _Remote Procedure Call_, and JSON is the famous _JavaScript Object Notation_ format used for serialization.

[RPC](http://en.wikipedia.org/wiki/Remote_procedure_call) requests go through the route `/rpc` and use the POST HTTP method.

[RPC](http://en.wikipedia.org/wiki/Remote_procedure_call) is used to expose the API of a system, in a standard way (system agnostic). Like this, as long as there is a way to communicate the [RPC](http://en.wikipedia.org/wiki/Remote_procedure_call) request, the API of any system is accessible for any other system, provided that both systems implement the protocol.

JSON is just the way to transport the information used for [RPC](http://en.wikipedia.org/wiki/Remote_procedure_call).

As [RPC](http://en.wikipedia.org/wiki/Remote_procedure_call) is used to access an API, here are the information to be provided for a [RPC](http://en.wikipedia.org/wiki/Remote_procedure_call) request:

* `module`: the name of the module containing the property to access or method to call. Available modules are discussed below.
* `method`: the name of the property to access or method to call inside the previous module
* `argument`: __a single object__ used to pass arguments

Example of a [RPC](http://en.wikipedia.org/wiki/Remote_procedure_call) request:

```http
POST /rpc HTTP/1.1
Host: localhost:3000
Content-Type: application/json

{
	"module": "editor",
	"method": "init",
	"argument": {
		"mode": "html"
	}
}
```

# Application

Now that you know how to communicate with the backend, it's time to know how to use it for the application it serves, that is providing source code edition services!

## Start

The first step is to start the server, but this is beyond the scope of this article. We consider a server is running on [http://localhost:3000](http://localhost:3000).

However you can check the existence of a server using a ping method: [http://localhost:3000/ping](http://localhost:3000/ping).

If you want to be sure however that this is not another server also responding a success status code on this path, you can use the identification pair system: on [http://localhost:3000/80d007698d534c3d9355667f462af2b0](http://localhost:3000/80d007698d534c3d9355667f462af2b0) it should send `e531ebf04fad4e17b890c0ac72789956`.

## RPC modules

For now the only available module is `editor`. So all your [RPC](http://en.wikipedia.org/wiki/Remote_procedure_call) request should use the following base JSON:

```json
{
	"module": "editor",
	...
}
```

## Associate a document to the backend

To be able to use the backend services for a document, you need to tell about it.

For that, register this document in the backend by initiating a session. Example for an empty HTML document:

```json
{
	"module": "editor",
	"method": "init",
	"argument": {
		"mode": "html"
	}
}
```

or with initial content, and custom properties:

```json
{
	"module": "editor",
	"method": "init",
	"argument": {
		"mode": "html",
		"source": "<html></html>",
		"properties": {
			"filename": "index.html",
			...
		}
	}
}
```

You will receive the token for the document, a unique id __to keep!!__ You will provide it for future requests for this document. Like this:

```json
{
	"guid": 0
}
```

## Update the content of the document

While the document is updated in your client, you should tell the backend about changes you made inside. This way it will update the models it uses behind for other services.

Imagine you simply __inserted__ a `div` inside the `html` node (`<html><div></div></html>`):

```json
{
	"module": "editor",
	"method": "exec",
	"argument": {
		"guid": "0",
		"svc": "update",
		"arg": {
			"src": "<div></div>",
			"start": 6
		}
	}
}
```

or you __replaced__ the node, by another (`<head></head>` instead of `<html></html>`):

```json
{
	"module": "editor",
	"method": "exec",
	"argument": {
		"guid": "0",
		"svc": "update",
		"arg": {
			"src": "<div></div>",
			"start": 0,
			"end": 13
		}
	}
}
```

Other example just for convenience, you __removed__ a portion of text:

```json
{
	"module": "editor",
	"method": "exec",
	"argument": {
		"guid": "0",
		"svc": "update",
		"arg": {
			"src": "",
			"start": 0,
			"end": 13
		}
	}
}
```

You can see that everything this can be generelized to a __replace__, with the end offset equal to the start offset of omitted.

Later on, we will implement more advanced features like __moving__ text:

```json
{
	"module": "editor",
	"method": "exec",
	"argument": {
		"guid": "0",
		"svc": "update",
		"arg": {
			"start": 0,
			"end": 6,
			"newStart": 6
		}
	}
}
```

that would represents the change from `<html></html>` to `</html><html>`.

## Request highlighting

For highlighting, you will first need to use a stylesheet, that associates ids (tokens, elements, types, styles, call it whatever you want) to text presentation data. For that, send:

```json
{
	"module": "editor",
	"method": "exec",
	"argument": {
		"id": "0",
		"svc": "stylesheet"
	}
}
```

It returns a stylesheet for the mode the corresponding document uses. It looks like this:

```json
{
	"styles": {
		"comment": {
			"color": {"r": 0, "g": 255, "b": 0},
			"font": {"italic": true}
		},
		"string": {
			"color": {"r": 255, "g": 0, "b": 0},
			"font": {}
		},
		...
	},
	"default": {
		"color": {"r": 255, "g": 255, "b": 255},
		"background": {"r": 0, "g": 0, "b": 0},
		"font": {
			"family": "Consolas",
			"height": 12,
			"bold": false,
			"italic": false,
			"strike": false,
			"underline": false
		}
	}
}
```

Then, to get __highlighting data__ for the __whole document__:

```json
{
	"module": "editor",
	"method": "exec",
	"argument": {
		"id": "0",
		"svc": "highlight"
	}
}
```

or a __specific region__:

```json
{
	"module": "editor",
	"method": "exec",
	"argument": {
		"id": "0",
		"svc": "highlight",
		"arg": {
			"start": 5,
			"end": 10
		}
	}
}
```

The __result__ being like this (for `<html></html>` here):

```json
{
	"ranges": [
		{
			"start": 0,
			"end": 6,
			"style": "opening"
		},
		{
			"start": 6,
			"end": 13,
			"style": "closing"
		}
	]
}
```

This is a list of ranges associated to the styles defined in the stylesheet.

__It's up to you to make the link between ranges and actual text presentation data__!

Notice that in case no style is available for a given range, you will have to use the default style specified in the stylesheet.

It is strongly advised that you __cache the stylesheet__ instead of requesting it everytime - indeed our design of separating the two requests has been made for performance gain. However, in case the stylesheet has changed between two highlightings, an additional flag will be added to the results of the second highlighting request:

```json
{
	"ranges": [...],
	"stylesheetChanged": true
}
```

Then you should request the stylesheet again before applying the new highlighting, and depending on your implementation on the client side, maybe you will have to ask for highlighting data for the whole document too.

## Going further

You are know familiar with the concept of communicating with the backend.

Every other service are implemented the same way. To execute a service on an already registered document, you need to provide the basic JSON:

```json
{
	"module": "editor",
	"method": "exec",
	"argument": {
		"id": ...,
		"svc": ...,
		"arg": ...
	}
}
```

taking care of passing the proper `id` for the document.

Just fill in the name of the service you want in `svc`, and pass it arguments if necessary in `arg`. Arguments change between services, some don't even take any for now.

### Services using ranges

Usually services have in common that they give information about the source code, or any portion of it (except things like the stylesheet for instance, which is a special case). Indeed a document is just a full text, combination of smaller text parts, until you reach the unit of a text: the character.

Thus, to simplify, these services __always work on ranges of text__. The thing is that you can avoid defining explicitely this range.

Here is how to define a range:

```json
{
	"start": 0,
	"end": 13
}
```

Note that __you can also pass a length instead of an offset__, in which case you will need to pass at least an offset, or if none is passed the defaukt value for the start offset will be considered. In this case, __proper offsets will be computed, and then the rules below apply normally__.

Examples:

```json
{"start": 5, "length": 5}
```

is

```json
{"start": 5, "end": 10}
```

Also:

```json
{"length": 10}
```

is

```json
{"start": 0, "end": 10}
```

And in this case:

```json
{"start": 5, "end": 10, "length": 15}
```

is

```json
{"start": 5, "end": 10}
```

because `length` is omitted.

__And here are the rules__:

* offsets are __0-based__
* an __offset__ is equivalent to the __caret position__ is the editor and matches the __character on its right__
* the `start` offset is __inclusive__ while the `end` offset is __exlusive__
* `start` __defaults__ to `0`, that is the beginning of the document
* `end` __defaults__ to the end of the document, that is the length of the source text
* if an offset is out of the boundaries of the document, it is cropped. So negative values will be transformed to `0`, and values further than the length of the document it will be changed to this length
* if the `end` offset is inferior to the `start` one, it will be made equal to `start`

So now, here are some examples:

* whole document: `{}`, `{"start": 0}`, `{"end": Infinity}`, `{"start": 0, "end": Infinity}` (`Infinity` is just a simple way to explicitely tell we want everything)
* position: `{"start": 5, "end": 5}` (`start == end`)
* simple range: `{"start": 5, "end": 10}`
* from beginning until ...: `{"end": 10}`
* from ... until the end `{"start": 5}`

Last but not least: it is possible that the service you're asking cannot work with the range you specified, because it is too small. In this case it would find the immediately bigger range it can work with, and consider you passed this. An additional property is added to the response in this case:

```json
{
	...
	"computedRange": {
		"start": 5,
		"end": 10
	}
}
```

### Summary of services

This list is not exhaustive:

* `init`: special service not executed with `exec` (not document related but documentS related)
* `update`: to update changes made to a document
* `parse`: returns a full [AST](http://en.wikipedia.org/wiki/Abstract_syntax_tree), for development purposes or more advanced processings on client-side
* `stylesheet`: used for the highlighting service, returns an assoiaction of ids and text styles
* `highlight`: returns a list of ranges associated to styles defined in the stylesheet
* `outline`: returns a summary of the code in the form of a tree
* `fold`: returns foldable ranges
* `validate`: ___to come___
* `complete`: ___to come___
* ...

### What would come in the future

The ability for a client to configure services globally or specifically, in order to adapt them to the client.

For instance, there might be a clinet-level configuration to ask the services to return the range given in input or not: this could help for automatically inferred ranges.