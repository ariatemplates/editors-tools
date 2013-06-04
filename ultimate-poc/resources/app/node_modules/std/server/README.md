___MOVE IT___

([ymeine](https://github.com/ymeine)): this module is part of my own standard library, and here should stand only a copy of the required files (development or production version).

----

A server library, with an _embedded_ JSON-RPC library.

__DISCLAIMER__: the JSON-RPC library does not comply to the real specifications, it simply uses JSON for RPC, hence the name.

# File system layout

* `README.md`: this current file
* `index.ls`: exports a convenient function to create and run a server

## Modules

These files return classes (see below):

* `route.ls`: `Route`
* `rpc.ls`: `RPC`
* `server.ls`: `Server`

## Utilities

___NEEDS REFACTORING___

These files return functions:

* `helpers.ls`: various
* `http.ls`: HTTP
* `network.ls`: network

# Versioning

To version: _everything_.

# Documentation

## Services

### Server

#### Routes

The server takes a list of route specifications, and use the _Route factory_ to ensure every route is properly built.

These routes are registered when the server is run.

#### Options

The server takes a set of various options to customize its behavior.

Here are the important properties:

* `network: ports: prefered` - Number: the ports you would like to use to run the server, if available
* `statics`
	* `absolute` - Array of Strings: absolute paths to use as static serving locations
	* `relative` - Array of Strings: relative paths to use as static serving locations
* `log` - Boolean: wether or not to active console logging. Of course this makes sense only if the console is available. __The logging system is a work in progress (consider using [winston](https://github.com/flatiron/winston))__

#### TODO

* Handle in the implementation and decribe all the possible options

### RPC

It acts like a proxy, being able to get properties or call functions from an object.

There is no interface restriction. It is in fact a simple bridge between a network communication and a virtual machine runtime.

#### TODO

* Be able to handle module specifications passed as relative paths. It means knowing what was the root path considered when the user defined the list of modules. I don't see a lot of solutions, from getting the path of the parent module but this can be only an intermediate, to requiring the user to specify the root in case he gives relative paths (this would change the format from an array to an object)
* Allow lazy loading of modules: however this can be made only using paths, passed module are not handled by the RPC manager

## Model

### Route

Specification object to create a route:

* `method`: the HTTP method name (you can use any case you want)
* `url`: the path from the domain

Then, you can specify a `handler` in different ways.

The handler is the function receiving the request and handling the response. Refer to the [zappajs](http://zappajs.github.io/zappajs/) documentation for more details.

Each property will create a specific handler, and they follow precedence rules:

1. `status`: a handler sending this status will be automatically created
1. `view`: a  handling rendering this view will be automatically created
1. `handler`: a custom function

## Utilities

### HTTP

### Helpers

### Network

# Contribute

## Pre-requisites

* Node.js
* LiveScript

# FIXME

* The _helpers_ module file contains only a logging function, used only by the _server_. Try to get rid of that, and use a unique external implementation of logging (I've made more or less 4/5 implementations...)
* Seems like the `execOnAvailablePort` function in network doesn't work as expected (uses the `prefered` port only)

# References

* [LiveScript](http://livescript.net/)
* [Node.js](http://nodejs.org/)
* [JSON-RPC](http://en.wikipedia.org/wiki/JSON-RPC)
