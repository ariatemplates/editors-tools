This document explains how to use the backend services in order to write a client.

# Introduction

If you read this documentation it means you are ready to implement a client, or more generally you want to use the backend services.

First, we will recap you how the communication with the backend is implemented.

Then, after knowing how to communicate, we will tell you what to communicate, what kind of information you can request, and receive.

# Communication interface

The backend runs as a server: therefore it uses network concepts.

To be able to use a server, a few information is needed:

* network address
* protocol(s) used, and what is built on top

## Network address

__For now__, the backend is served on __localhost__, and listening to connections on port __3000__.

## Protocol

It uses the HTTP protocol.

On top of it is implemented a RPC protocol, using JSON.

However, there are other small services available through pure HTTP, please refer to the main documentation for more details on available _routes_.

### RPC

RPC stands for _Remote Procedure Call_, and JSON is the famous JavaScript Object Notation format used for serialization.

RPC requests go through the route `/rpc` which reacts to POST HTTP method.

RPC is used to expose the API of a system, in a standard way. Like this, as long as there is a way to communicate the RPC request, the API of any system is accessible for any other system, provided that both systems implement the protocol.

JSON is just the way to transport the information used for RPC.

As RPC is used to access an API, here are the information to be provided for a RPC request:

* `module`: the name of the module containing the property to access or method to call. Available modules are discussed below.
* `method`: the name of the property to access or method to call inside the previous module
* `argument`: __a single object__ used to pass arguments

Example of a RPC request:

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

The first step is to start the server, but this is beyond the scope of this article. We consider a server is running on `http://localhost:3000`

However you can check the existence of a server using a ping method: `http://localhost:3000/ping`.

If you want to be sure however that this is not another server also responding a success status code on this path, you can use the identification pair system: on `http://localhost:3000/80d007698d534c3d9355667f462af2b0` it should send `e531ebf04fad4e17b890c0ac72789956`.

## RPC modules

For now the only available modeule is `editor`. So all your RPC request should use the following base JSON:

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

or with initial content:

```json
{
	"module": "editor",
	"method": "init",
	"argument": {
		"mode": "html",
		"source": "<html></html>"
	}
}
```

You will receive the token for the document, a unique id __to keep!!__ You will provide it for future requests on it. Like this:

```json
{
	"guid": 0
}
```

## Update the content of the document

While the document is updated in your client, you should tell the backend about changes you made inside. This way it will update the models it uses behind for other services.

Imagine you simply inserted a `div` inside the `html` node (`<html><div></div></html>`):

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

or you replaced the node, by another (`<head></head>` instead of `<html></html>`):

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

## Requets highlighting

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
