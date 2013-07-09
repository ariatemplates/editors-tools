This is the bootstrap of the backend application.

The application is based on a generic server library, using JSON-RPC communication, and is specific in the extent that it provides source code edition services thanks to this system.

# File system layout

Files:

* `index.js`: the main application file
* `README.md`: this current file
* `.gitignore`: Git related file
* `routes.js`: the list of routes to pass to the server
* `options.js`: the options to pass to the server
* `logger.js`: defines a unique logger to be used throughout the whole application
* `log.log`: the logs of the application

Folders:

* `node_modules`: the modules constituting the application

# Versioning

To version:

* `index.js`
* `README.md`
* `.gitignore`
* `routes.js`
* `options.js`
* `logger.js`
* `node_modules`

To ignore:

* `log.log`: persistent file generated/altered at runtime, relevant only for _production_, not development

# Documentation

Services.

## RPC

The path `/rpc` is the entry point for RPC requests.

## Ping

On path `/ping` sends a valid HTTP code status.

## GUID identification

On path `/80d007698d534c3d9355667f462af2b0` sends the content `e531ebf04fad4e17b890c0ac72789956`

This is generally used to identify the server as being an instance of this backend.

## Info

__To come__


# Contribute

## Introduction

The application is implemented as a generic server providing services under JSON-RPC requests.

It uses the `server` module for that, please refer to its documentation.

The services it provides are all stored in the `modes` module, which contains modules for source code edition: once again, please refer to its documentation.

## Use

Launch the _index_ file: `node index`.

## Development

### Routes

The concept of routes is common in server-side technologies, and for more information about the implementation in this project, please refer to the `server` module.

Know that you can define the list of routes that the server will setup in the _routes_ module file.

This module must export a collection (array) of route specifications.

### Options

The options to run the server are defined in the _options_ module file, for convenience. Please refer to the `server` module for more information.

This module must return an object that follows the input format that the server module accepts.

### Logging

You can setup a unique logger for the whole application in the _logger_ module file.

This module must export an instance of a logger, that is an object which must repect the following interface:

Methods:

* `info`
* `log`
* `error`
* `warn`
