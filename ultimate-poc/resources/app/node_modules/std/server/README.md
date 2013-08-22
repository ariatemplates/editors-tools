A server library, with an _embedded_ JSON-RPC library.

__DISCLAIMER__: the JSON-RPC library does not comply to the real specifications, it simply uses JSON for RPC, hence the name.

# File system layout

* [`README.md`](./README.md): this current file
* [`index.js`](./index.js): exports a convenient function to create and run a server

## Modules

These files return classes (see below):

* [`route.ls`](./route.ls): `Route`
* [`rpc.ls`](./rpc.ls): `RPC`
* [`server.ls`](./server.ls): `Server`
* [`route.js.ls`](./route.js.ls): a beginning of conversion of `route` from LiveScript to JavaScript
* [`rpc.js.ls`](./rpc.js.ls): a beginning of conversion of `rpc` from LiveScript to JavaScript

## Utilities

These files return functions:

* [`helpers.ls`](./helpers.ls): various
* [`http.js`](./http.js): HTTP
* [`network.js`](./network.js): network

# Versioning

To version: _everything_.

# Documentation

## Services

### Server

#### Routes

The server takes a list of route specifications, and use the _Route factory_ to ensure every route is properly built.

These routes are registered when the server is run.

##### Standard routes

###### Ping

The `/ping` route sends a valid HTTP code status (200).

This is made for different purposes, the main idea being to tell that the server is responding.

You can use it for testing purposes, but also for functional ones, like checking there is a valid server already running on the machine - however we advise using rather the GUID identification system for that.

###### Shutdown

You can shutdown the server - that makes it exit, the process will be destroyed -  by sending a GET request to the route `/shutdown`.

###### Info

___DISCLAIMER: To come___

Route: `/info`

This should send a bunch of data to describe the properties of the server.

For instance (you can complete this list):

* port
* routes
	* path
	* HTTP verb
* stats
	* time running
	* number of request (per route)
* logs: we might keep logs of everything (handling logs persistence can cost a huge time, this should be made when the backend is not requested too much - basically when we detect that the user stopped typing text)
* ...

###### RPC

`/rpc` is the entry point for RPC requests.

It acts like a proxy, being able to get properties or call functions from an object.

There is no interface restriction. It is in fact a simple bridge between a network communication and a virtual machine runtime.

RPC is made through a POST HTTP request, with `application/json` content type, sending JSON formatted data with the following properties:

* `module`: the name of the module to call, this module being registered by the RPC manager
* `method`: the name of the member of the module to access; `method` is an historical name, actually you can both access properties values and call methods (but you can't get the value of a function, but this doesn't make sense in this context)
* `arguments`: a JSON object; this forces to name arguments, and avoids the confusion by making a choice on the convention (versus array, even defining an array with a single item being an object is still possible)

TODO:

* Be able to handle module specifications passed as relative paths. It means knowing what was the root path considered when the user defined the list of modules. I don't see a lot of solutions, from getting the path of the parent module but this can be only an intermediate, to requiring the user to specify the root in case he gives relative paths (this would change the format from an array to an object)
* Allow lazy loading of modules: however this can be made only using paths, load of passed module is not handled by the RPC manager
* Be able to specify multiple names for a module
* Change the way arguments are passed, accepting a real list of arguments instead of a single object.
* Be able to specify a module not only by path, but directly with the module itself (in fact I think it's already possible!)

#### Options

The server takes a set of various options to customize its behavior.

Here are the important properties:

* `network: ports: prefered` - Number: the ports you would like to use to run the server, if available
* `statics`
	* `absolute` - Array of Strings: absolute paths to use as static serving locations
	* `relative` - Array of Strings: relative paths to use as static serving locations
* `log` - Boolean: wether or not to active console logging. Of course this makes sense only if the console is available. __The logging system is a work in progress (consider using [winston](https://github.com/flatiron/winston))__

#### TODO

* Handle in the implementation and describe all the possible options

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

# Contribute

## FIXME

* `execOnAvailablePort` function in network doesn't work as expected: uses the `prefered` port only. This is beacsue when `zappajs` is required, the `checkPortStatus` on port 3000 returns `closed` everytime.
* The _helpers_ module file contains only a logging function, used only by the _server_. Try to get rid of that, and use a unique external implementation of logging (I've made more or less 4/5 implementations...)

# References

* [JSON-RPC](http://en.wikipedia.org/wiki/JSON-RPC)
