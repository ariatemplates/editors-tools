Eclipse plugin client for source code edition tools.

# File system layout

* `README.md`: this current file
* `document`: package to handle a document
* `editors`: package to handle edition of a document
* `outline`: package to handle the outline view of a document
* `Activator.java`: file related to the Eclipse plugin lifecycle management
* `Backend.java`: a class to manage a backend instance

# Versioning

To version: _everything_.

# Documentation

## Activator

When the plugin starts, the activator is used. It can do some setup and tear down job.

Here when the plugin starts, the activator launches a unique backend, using a singleton managed by the `Backend` class itself. When it is released, it stops the backend.

## Backend

The `Backend` class has the role to ease management of a backend as well as generic communication with it.

Every service the backend will provide will have a bridge implemented in this class. For instance, from basic HTTP requests to RPC.

Please refer to the JavaDoc of the class itself for more information on what has been implemented, and also to the documentation of the real backend.

### Re-use

If a backend is already available on port 3000, we should be able to re-use it (for now we do).

For that, we need to know if there is a server listening on port 3000, and if it looks like a backend.

For that, the server provides a GUID identification system, and answer with a specific GUID as response to a GET request on a path built with another specific GUID key.

Concretely, if a HTTP GET Request on port 3000 with ther URL path `80d007698d534c3d9355667f462af2b0` receives a response with content `e531ebf04fad4e17b890c0ac72789956`, it's considered to be a backend.

__REFER TO THE BACKEND DOCUMENTATION TO BE SURE TO HAVE THE REAL VALUES__

### Launch

The plugin needs to wait for the backend to be completely launched, as this is an asynchronous process. Solutions:

* _CURRENT SOLUTION_ polling with a simple ping (until some timeout is reached - to avoid infinite try)
* by waiting for a request from the backend: this is too cumbersome, as this means choosing another convention for the port number, creating several connections, etc.

# TODO

* configure the JSON library if possible in order not to create Double for numbers but integers instead
	* registering a type-adapter
	* defining explicit classes with proper field types and use it for deserializing
	* ...

