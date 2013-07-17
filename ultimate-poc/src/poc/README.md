Root package of the Eclipse plugin code.

# File system layout

Documentation:

* `README.md`: this current file

Packages:

* `document`: to handle a document, that is what represents a whole source code (somehow analogous to what is usually inside a file)
* `editors`: editor view of a document
* `outline`: outline view of a document
* `data`: for global data management for the plugin

Classes:

* `Activator.java`: manages the Eclipse plugin lifecycle
* `Backend.java`: manages a backend instance

# Versioning

To version: _everything_.

# Documentation

## Activator

The activator is used for the plugin lifecycle management. It is basically called on startup, where it can do some setup, and on shutdown where it can finally do some tear down job.

Concretely:

* __on start__: it uses the `Backend` class to ensure an actual backend will be available
* __on stop__: it asks the `Backend` class to stop activity

## Backend

The `Backend` class has the role to ease management of a backend as well as generic communication with it. It acts like a __bridge__.

Every service the backend will provide will have a bridge implemented in this class. For instance, from basic HTTP requests to RPC over it.

Please refer to the JavaDoc of the class itself for more information on what has been implemented, and also to the documentation of the backend project.

### Re-use

If a backend is already available on port `3000`, the frontend is able to re-use it.

That means we need to know if there is a server listening on port `3000` and _looking like_ a backend.

For that, the server provides a GUID identification system: on a GET request with a path built with a specific GUID, the backend sends another specific GUID as a response. So if the GUIDs match on the request, a backend instance has been found.

Concretely: if a HTTP GET Request on port `3000` with the URL path `80d007698d534c3d9355667f462af2b0` receives a response with content `e531ebf04fad4e17b890c0ac72789956`, the server is considered to be a backend.

__REFER TO THE BACKEND DOCUMENTATION TO BE SURE TO HAVE THE REAL (UP-TO-DATE) VALUES__

### Launch

The plugin needs to wait for the backend to be completely launched before starting using it. However, this is an asynchronous process. Here are some solutions:

* ___CURRENT SOLUTION___: polling with a simple ping request (until some timeout is reached , to avoid infinite try)
* by waiting for a request from the backend: this is too cumbersome, as this means choosing another convention for the port number, creating several connections, etc.

# Contribute

1. From JSON requests, handle return values other than objects (like strings for errors), or use the status!! (different from 200 is bad)

## Degraded mode

1. Ensure it is always possible to fallback to a basic raw text editor when something fails with the backend, or fails in general

## Data management

Externalize some data as user preferences. You can easily find most of them (for what has already been implemented) by looking at all the `private final static` definitions in the source code.

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

General performances issues have been discussed in the main documentation file of this project. This mainly concerns the communication part, which is all wrapped in the `Backend` class.

* if possible configure the JSON library used - here Google GSON - in order not to create Double for numbers but integers instead
	* register a type-adapter
	* define explicit classes with proper field types and use it for deserialization
	* ...
* otherwise study other libraries
