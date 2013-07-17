Backend application.

The file system layout can be surprising, but comes from the way the module system works for Node.js and a will not to mix application modules and third-party modules.

# File system layout

* `README.md`: this current file
* `.gitignore`: Git related file
* `package.json`: npm `package.json`
* `node_modules`: all third-party libraries used by the application.

## `app`

Applications files.

The application follows a modular architecture, and all the module are hierarchically organized into this root folder.

Under this root, there are _pseudo-standard_ modules and modules of the application: this is described in the respective documentation.

A _pseudo-standard_ module is a module that is not installed through the package management system ( _npm_ here) since it is _home-made_. However this is a module that is not specific to this application, it could be re-used in many other ones.

# Versioning

To ignore:

* `node_modules`: can be installed from the `package.json` data with the use of npm

To version: _everything else_.

# Contribute

## Pre-requisites

* [Node.js](http://nodejs.org/)
* [npm](https://npmjs.org/)

## Setup

Install the node modules, by launching the program with the following properties:

* program name: `npm`
* program arguments (command in this case): `install`
* current working directory (context): the folder containing `package.json`

## Development

### Package definition

You can update the package by modifying the content of the `package.json` file.

For that you'll need to know the _npm_ `package.json` specifications.

What can be done among others:

* check required modules
	* remove unecessary modules
	* maybe put version constraints
* update the description, tags, ...
* work on the _packaging_: installation, generated commands, local vs. global, ...

### Application code

Please refer to the content of the `app` folder.

# References

* npm [`package.json`](https://npmjs.org/doc/json.html)
