This is the bootstrap of the backend application.

The application is based on a generic server library, using JSON-RPC communication, and is specific in the extent that it provides source code edition services thanks to this system.

# File system layout

* [`README.md`](./README.md): this current file
* [`.gitignore`](./.gitignore): Git related file

Application:

* [`index.js`](./index.js): the main application file
* [`node_modules`](node_modules): the modules constituting the application

Server related:

* [`routes.js`](./routes.js): the list of routes to pass to the server
* [`options.js`](./options.js): the options to pass to the server
* [`logger.js`](./logger.js): defines a unique logger to be used throughout the whole application
* `log.log`: the logs of the application

# Versioning

To ignore:

* `log.log`: persistent file generated/altered at runtime, relevant only for _production_, not development

To version: _everything else_.

# Documentation

## Introduction

The application is implemented as a generic server providing services under JSON-RPC requests.

It uses the `server` module for that, please refer to [its documentation](/ultimate-poc/resources/app/node_modules/std/server/README.md).

The services it provides are all stored in the [`modes`](/ultimate-poc/resources/app/node_modules/modes) module, which contains modules for source code edition: once again, please refer to its documentation.

## Routes

The concept of routes is common in server-side technologies, and for more information about the implementation in this project, please refer to the [`server`](/ultimate-poc/resources/app/node_modules/std/server/README.md) module.

Know that you can define the list of routes that the server will setup in the [_routes_](./routes.js) module file.

This module must export a collection (array) of route specifications.

## Options

The options to run the server are defined in the [_options_](./options.js) module file, for convenience. Please refer to the `server` module for more information.

This module must return an object that follows the input format that the server module accepts.

## Logging

You can setup a unique logger for the whole application in the [_logger_](./logger.js) module file.

This module must export an instance of a logger, that is an object which must repect the following interface:

Methods:

* `info`
* `log`
* `error`
* `warn`

## Services

This section is structured the same way the services are provided by the server: there is one subsection per route, that is per service.

### Ping

The `/ping` route sends a valid HTTP code status (200). __This is a standard route provided by the server library__.

This is made for different purposes, the main idea being to tell that the server is responding.

You can use it for testing purposes, but also for functional ones, like checking there is a valid server already running on the machine - however we advise using rather the GUID identification system for that.

### GUID identification

The `/80d007698d534c3d9355667f462af2b0` route sends the content `e531ebf04fad4e17b890c0ac72789956`.

This is generally used to identify the server as being an instance of this backend. Indeed, there is a very low probability (which could be calculated) to encounter the same context with another server:

* port
* protocol handled: HTTP
* request type: POST
* route/response pair: using only one GUID introduces already a high level of collision avoidance, but using a pair of that is even FAR higher

### Shutdown

You can shutdown the server - that makes it exit, the process will be destroyed -  by sending a GET request to the route `/shutdown`.

### RPC

`/rpc` is the entry point for RPC requests. __This is a standard route provided by the server library__.

The RPC request are handled by an external module, in the standard library, please refer to its own documentation.

For quick reminder, __as the time of writing__, RPC is made through a POST HTTP request, with `application/json` content type, sending JSON formatted data with the following properties:

* `module`: the name of the module to call, this module being registered by the RPC manager
* `method`: the name of the member of the module to access; `method` is an historical name, actually you can both access properties values and call methods (but you can't get the value of a function, but this doesn't make sense in this context)
* `arguments`: a JSON object; this forces to name arguments, and avoids the confusion by making a choice on the convention (versus array, even defining an array with a single item being an object is still possible)

#### Modules

For now there is only one module registered against the RPC manager: the editor module. Please refer to the [respective documentation](/ultimate-poc/resources/app/node_modules/modes) for more information.

### Info

__To come__

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

# Contribute

## Use

Launch the [_index_](./index.js) file: `node index`.

You can tweak the [`options`](./options.js) file, but __take care about versioning issues__ behind.

## Development

### Refactoring

Make the server module from the std library official or bring it back here.

### RPC

* Check how specifying modules work, this uses a relative path, and can be interesting for other purposes
* Be able to specify a module not only by path, but directly with the module itself (in fact I think it's already possible!)
* Be able to specify multiple names for a module
* Change the way arguments are passed, accepting a real list of arguments instead of a single object.

### Logging

Improve the logging system.

* choose where to put the logs: depending on the current working directory (current solution) or more deterministic? Giving the user an option would be good too.
* Learn how to use the library `winston`, configure it more.
* Find how to use the logger more globally, in other submodules.

Remove the old logging system used in routes.
