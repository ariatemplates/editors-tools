This is the bootstrap of the backend application.

The backend application is a server exposing the API of the editor library, by using JSON-RPC communication.

The files in this folder are used only to launch the server, while [`node_modules`](./node_modules) contains the whole editor library - which for now is split in two: a custom _standard_ library and the editor library itself.

# File system layout

* [`README.md`](./README.md): this current file
* [`.gitignore`](./.gitignore): [Git](http://git-scm.com/) related [file](http://git-scm.com/docs/gitignore)

Application:

* [`index.js`](./index.js): server bootstrap
* [`node_modules`](./node_modules): the editor library

Server related:

* [`routes.js`](./routes.js): the list of routes for the server
* [`options.js`](./options.js): the options to pass to the server
* [`logger.js`](./logger.js): defines a unique logger to be used throughout the whole application
* `log.log`: the logs of the application

# Versioning

To ignore:

* `log.log`: persistent file generated/altered at runtime, relevant only for _production_, not development

To version: _everything else_.

# Documentation

__The application aims at providing source code edition services, independent of any user interface.__

As all the actual functionalities are implemented in the [`editor library`](./node_modules), we'll describe here only what is done to serve its API.

In short, a custom RPC protocol is used, over HTTP, using JSON for data serialization.

The modules behind the API exposed by the server are all stored in the [`modes`](/ultimate-poc/resources/app/node_modules/modes) module: once again, please refer to its documentation.

All of this is implemented by simply using a standard server library, currently directly embedded and developed in the editor library itself. Please refer to [its documentation](/ultimate-poc/resources/app/node_modules/std/server/README.md) for any information on how to use it.

## Routes

__The _Route_ is a common concept in HTTP servers: they define actions to be performed by the server based on some criteria concerning the requests it receives (like the URL path, the HTTP method, ...)__

For more information about the implementation of the routes in the standard library, please refer to the [`server`](/ultimate-poc/resources/app/node_modules/std/server) module.

The server instance accepts a list of routes as inputs: these are defined in the [_routes_](./routes.js) module file, which exports an array collection of route specifications.

## Options

__General options for the server.__

Please refer to the [`server`](/ultimate-poc/resources/app/node_modules/std/server) module for more information on available options.

Options used here are defined in the [_options_](./options.js) module file (for convenience), which directly an object that follows the input format that the server library expects.

## Logging

__DISCLAIMER: section to be reviewed__

You can setup a unique logger for the whole application in the [_logger_](./logger.js) module file.

This module must export an instance of a logger, that is an object which must repect the following interface:

Methods:

* `info`
* `log`
* `error`
* `warn`

## Services

__Services are actions performed on requests.__

As previously stated, requests are handled by routes, and here we'll consider one service per request, so per route.

### Ping

__Standard service provided by the server library__: [documentation](/ultimate-poc/resources/app/node_modules/std/server#ping)

### Shutdown

__Standard service provided by the server library__: [documentation](/ultimate-poc/resources/app/node_modules/std/server#shutdown)

### GUID identification

___DISCLAIMER: make it a standard service of the server library___

The `/80d007698d534c3d9355667f462af2b0` route sends the content `e531ebf04fad4e17b890c0ac72789956`.

This is generally used to identify the server as being an instance of this backend. Indeed, there is a very low probability (which could be calculated) to encounter the same context with another server:

* port
* protocol handled: HTTP
* request type: POST
* route/response pair: using only one GUID introduces already a high level of collision avoidance, but using a pair of that is even FAR higher


### RPC

__Standard service provided by the server library__: [documentation](/ultimate-poc/resources/app/node_modules/std/server#rpc)

For now there is only one module registered for exposition through RPC: the editor module. Please refer to the [respective documentation](/ultimate-poc/resources/app/node_modules/modes) for more information.

### Info

___DISCLAIMER: not implemented by the library yet.___

__Standard service provided by the server library__: [documentation](/ultimate-poc/resources/app/node_modules/std/server#info)

# Contribute

## Try

With Node.js installed globally, launch the [`index`](./index.js) file with the following command:

```dos
node index
```

You can tweak the [`options`](./options.js) file, but __take care about versioning issues__ behind.

## Development

### Logging

__Improve the logging system.__

* choose where to put the logs: depending on the current working directory (current solution) or more deterministic? Giving the user an option would be good too.
* Learn how to use the library [winston](https://github.com/flatiron/winston), configure it more.
* Find how to use the logger more globally, in other submodules.

Remove the old logging system used in routes.
