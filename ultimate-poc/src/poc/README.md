Eclipse plugin client for source code edition tools.

# File system layout

* `README.md`: this current file
* `document`: package to handle a document
* `editors`: package to handle edition of a document
* `outline`: package to handle the outline view of a document
* `Activator.java`: file related to the Eclipse plugin lifecycle management
* `Backend.java`: a class to manage a backend instance

# Versioning

To version: _evrything_.

# Documentation

## Activator

When the plugin starts, the activator is used. It can do some setup and tear down job.

Here when the plugin starts, the activator launches a unique backend, using a singleton managed by the `Backend` class itself. When it is released, it stops the backend.

## Backend

The `Backend` class has the role to ease management of a backend and generic communication with it.

Every service the backend will provide will have a bridge implemented in this class. For instance, from basic HTTP requests to RPC.

Please refer to the JavaDoc of the class itself for more information on what has been implemented, and also to the documentation of the real backend.

### TODO

* Be able to re-use an existing process. For this, check that the running process listening on default port, if it exists, is the good process. For that, we could imagine using a pair of keys: on `GET hostname:3000/{inputkey}` it returns the proper `{outputkey}`

# FIXME

## Backend start

The plugin doesn't wait for the backend to be completely launched, as this is an asynchronous process. We should wait for it:

* by pooling with a simple ping - until some timeout is reached (to avoid infinite try)
* by waiting for a request from the backend: this is too cumbersome, as this means chossing another convention for the port number, creating several connections, ...
