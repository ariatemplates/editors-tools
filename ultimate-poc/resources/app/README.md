___TODO___

The code of the server is being refactored and migrated to a custom module. This documentation should be adapted:

* notions related to the server will be put along with the code of the server: routes, configuration, ...
* the file system layout however is just a convenient way to define data to be used with the server module, this stays here, and links to notions of the server module
* things like `package.json` stay here, completely

----

This is the code of the server.

The documentation will be written when the first item in the TODO section will be done, as it implies strong changes in the architecture, and thus in the corresponding documentation.

Nonetheless, the introduction section tells you the few things you should know for the moment.

# Introduction

## Routes

The file `routes.ls` is where you can define your routes.

The routes are put in a native JavaScript array exported by the module, and defined as native JavaScript objects.

Here is the format of a route:

* `method`: the HTTP method name (you can use any case you want)
* `url`: the path from the root of the server

Then, you can specify a handler in different ways.

The handler is the function receiving the request and handling the response. Refer to the [zappajs](http://zappajs.github.io/zappajs/) documentation for more details.

Each property will create a specific handler, and they follow precedence rules:

1. `status`: a handler sending this status will be automatically created
1. `view`: a  handling rendering this view will be automatically created
1. `handler`: a custom function

## Server configuration

The file `serverconf.ls` holds some constants used by the server as well as some options you can set. This is not ideal and will be split in two different files: _configuration_ and _options_. As a developer, you will modify the _configuration_ file, and as a user the _options_ one.

Here are the important properties:

* `network: ports: prefered` - Number: the ports you would like to use to run the server, if available
* `statics`
	* `absolute` - Array of Strings: absolute paths to use as static serving locations
	* `relative` - Array of Strings: relative paths to use as static serving locations
* `log` - Boolean: wether or not to active console logging. Of course this makes sense only if the console is available. The logging system is a work in progress (consider using [winston](https://github.com/flatiron/winston))

## Package

The `package.json.ls` file is the [LiveScript](http://livescript.net/) equivalent of the [npm](https://npmjs.org/) `package.json` [specification](https://npmjs.org/doc/json.html). It's just that I prefer LiveScript anyway.

You can use the `compile.bat` convenient script to compile this file into JSON, so that npm can use it.

# TODO

* this code has been duplicated and adapted in multiple projects: gather all the versions and build one common taking the best of each
