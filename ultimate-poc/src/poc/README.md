Root package of the Eclipse plugin code.

# File system layout

Documentation:

* [`README.md`](./README.md): this current file

Packages:

* [`document`](document): to handle a document, that is what represents a whole source code (somehow analogous to what is usually inside a file)
* [`editors`](editors): editor view of a document
* [`outline`](outline): outline view of a document
* [`data`](data): for global data management for the plugin

Classes:

* [`Activator.java`](./Activator.java): manages the Eclipse plugin lifecycle
* [`Backend.java`](./Backend.java): manages a backend instance

# Versioning

To version: _everything_.

# Documentation

## Activator

__The activator is used for the plugin lifecycle management.__

It is basically called on startup, where it can do some setup, and on shutdown where it can finally do some tear down job.

Concretely:

* __on start__: it uses the [`Backend`](./Backend.java) class to ensure an actual backend will be available
* __on stop__: it asks the [`Backend`](./Backend.java) class to stop activity

## Backend

__The [`Backend`](./Backend.java) class has the role to ease management of a backend as well as generic communication with it.__ It acts like a __bridge__.

Every service the backend will provide will have a bridge implemented in this class. For instance, from basic HTTP requests to RPC over it.

Please refer to the JavaDoc of the class itself for more information on what has been implemented, and also to the documentation of the backend project.

### Re-use

__If a backend is already available on port `3000`, the frontend is able to re-use it.__

That means we need to know if there is a server listening on port `3000` and _looking like_ a backend.

For that, the server provides a GUID identification system: on a GET request with a path built with a specific GUID, the backend sends another specific GUID as a response. So if the GUIDs match on the request, a backend instance has been found.

Concretely: if a HTTP GET Request on port 3000 with the URL path [`80d007698d534c3d9355667f462af2b0`](http://localhost:3000/80d007698d534c3d9355667f462af2b0) receives a response with content `e531ebf04fad4e17b890c0ac72789956`, the server is considered to be a backend.

__REFER TO THE [BACKEND DOCUMENTATION](ultimate-poc/resources/app/README.md#guid-identification) TO BE SURE TO HAVE THE REAL (UP-TO-DATE) VALUES__

### Launch

The plugin needs to wait for the backend to be completely launched before starting using it. However, this is an asynchronous process. Here are some solutions:

* ___CURRENT SOLUTION___: polling with a simple ping request (until some timeout is reached , to avoid infinite try)
* by waiting for a request from the backend: this is too cumbersome, as this means choosing another convention for the port number, creating several connections, etc.

# Contribute

## Alignment with the latest backend implementation

__The backend changed a lot, and the plugin needs to use it differently.__

As the bakend changed, the [`Backend`](./Backend.java) class which makes the bridge with it must change.

RPC is still in place, and the way it is used didn't change. However, the actual modules and methods did.

First, in practice every RPC call used to target a specific mode to be used to process a document, because this is the main feature of both the plugin and the backend: processing documents.

However, now processing documents goes through a single module on the backend, called `editor`. So every RPC call in this project will now use as the `module` argument the value `editor`, instead of a specifc mode name.

This should be wrapped in a method of the [`Backend`](./Backend.java), like `Backend.editor()`, which would call the RPC method always specifying `editor` as module name.

Then, most of services used to process documents uses the same method of the `editor` module: `exec`. In the same idea, this should be wrapped in a method like `Backend.execSvc()`, which would call the previous `Backend.editor()` method, always passing `exec` as the method name. Moreover in this case an additional thing should be made: `execSvc()` should take the name of the service to call and automatically inject it into the arguments object (which is the third parameter of a RPC request). It should also do the same for the document ID (it could even take a `Document` instance).

Example of content for a service request:

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

Signature of the suggested methods:

```java
Backend.editor(String method, Object argument) {
	...
	this.rpc("editor", method, argument);
}

Backend.execSvc(String service, Document document, Object arg) {
	...
	argument.put("guid", document.getGUID());
	argument.put("svc", service);
	...
	this.editor("exec", argument);
}
```

## Degraded mode

__Editing a document should always be possible in reasonable time, with or without backend support.__

Ensure it is always possible to fallback to a basic raw text editor when something fails with the backend, or fails in general.

## Communication

__Handle every type of return values.__

From JSON requests, we should be able to handle return values other than objects too (like strings for errors), or at least if we consider we should only receive objects in case of success, use the status to check if there is an error instead.

However, the backend makes an effort to always return objects, even in case of errors (but for instance if you try a non-existing route, I guess the third-party server library used behind will not).

## Data management

__Externalize some data as user preferences.__

You can easily find most of them (for what has already been implemented) by looking at all the `private final static` definitions in the source code.

Backend:

* External backend re-use
	* port for external backend
	* GUID identification pair
	* enable external backend re-use or not
* Backend program management
	* use embedded backend or external installation
	* path of the external installation
	* use system Node.js installation or not (migth require a specific version)
	* custom Node.js path
	* port to use when launching a backend
	* enable to find and use first available port (some additional data might be required for that, like a range, ...)
	* launch timeout

__Complete this list!__

## Performances

__General performances issues have been discussed in the main documentation file of this project.__

This mainly concerns the communication part, which is all wrapped in the [`Backend`](./Backend.java) class.

If possible configure the JSON library used - here Google GSON - in order not to create Double for numbers but integers instead:

* register a type-adapter
* define explicit classes with proper field types and use it for deserialization
* ...

Otherwise study other libraries.
