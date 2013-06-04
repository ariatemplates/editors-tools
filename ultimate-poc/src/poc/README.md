Eclipse plugin client for source code edition tools.

# File system layout

Documentation

* `README.md`: this current file

Packages:

* `document`: to handle a document, that is a whole source code
* `editors`: to handle edition of a document
* `outline`: to handle the outline view of a document
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

* __on start__: it launches a unique backend, using a singleton managed by the `Backend` class itself
* __on stop__: it stops the backend, using the same singleton

## Backend

The `Backend` class has the role to ease management of a backend as well as generic communication with it.

Every service the backend will provide will have a bridge implemented in this class. For instance, from basic HTTP requests to RPC.

Please refer to the JavaDoc of the class itself for more information on what has been implemented, and also to the documentation of the real backend.

### Re-use

If a backend is already available on port `3000`, we should be able to re-use it.

___For now we do.___

That means we need to know if there is a server looking like a backend listening on port `3000`.

For that, the server provides a GUID identification system: on a GET request with a path built with a specific GUID, the backend sends another specific GUID as a response.

Concretely: if a HTTP GET Request on port `3000` with the URL path `80d007698d534c3d9355667f462af2b0` receives a response with content `e531ebf04fad4e17b890c0ac72789956`, the server is considered to be a backend.

__REFER TO THE BACKEND DOCUMENTATION TO BE SURE TO HAVE THE REAL VALUES__

### Launch

The plugin needs to wait for the backend to be completely launched before starting using it. However, this is an asynchronous process. Here are some solutions:

* ___CURRENT SOLUTION___: polling with a simple ping request (until some timeout is reached , to avoid infinite try)
* by waiting for a request from the backend: this is too cumbersome, as this means choosing another convention for the port number, creating several connections, etc.

# FIXME

* From JSON requests, handle return values different from object (like strings for errors), or use the status!! (different from 200 is bad)

# TODO

* Be able to always fallback to a standard text editor when the backend failed
* if possible configure the JSON library used - here Google GSON - in order not to create Double for numbers but integers instead
	* register a type-adapter
	* define explicit classes with proper field types and use it for deserialization
	* ...
