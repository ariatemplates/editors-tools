This project aims at providing a solution for source code edition services, decoupled from any user interface, with an effort on abstraction of the underlying models.

__This is a work in progress and a proof of concept.__

For now it is concretely applied to specific things:

* Edition services modules (called _modes_):
	* JavaScript
	* HTML
	* [Aria Templates](http://ariatemplates.com), using the both above
* Clients implementations:
	* [Eclipse IDE](http://eclipse.org/)

# Introduction

Please read the `introduction.md` file if you never did it and don't know what the project is all about.

# Documentation

Please see the `documentation.md` file __before reading any more documentation__.

# File system layout

* `.gitignore`: Git related file
* `bin`: folder containing the build, that is both Eclipse plugin and Backend for now

## Documentation

* `README.md`: this current file
* `introduction.md`: an introduction to the project
* `documentation.md`: a documentation about the documentation in this project

## Eclipse code

* `build.properties`, `plugin.xml`, `META-INF`: files and folders contributing to the Eclipse plugin definition
* `src`: the sources of the Eclipse plugin
* `.project`, `.classpath`, `.settings`: files related to the Eclipse project configuration

## Backend code

* `resources`: the sources of the backend

# Versioning

To version:

* __Documentation__
* `.gitignore`
* `build.properties`, `plugin.xml`, `META-INF`
* `src`
* `resources`

What might be versioned (should be reproducible and might differ between environments - so versioning would more pollute than help):

* `.project`, `.classpath`, `.settings`

What MUST NOT be versioned:

* `bin`: this is a content generated from the sources

# Contribute

 I would first give an advice to apply everywhere: __READ CAREFULLY THE DOCS__.

## Setup

1. Install Node.js
1. Install the package `livescript` with npm
1. Clone the repository
1. Import the Eclipse project from the existing `plugin.xml` file

## Test it

1. Open the Eclipse project
1. Launch the project as an `Eclipse application`

You can start editing files with the `.tpl` extension.

# Documentation

## Architecture

A frontend/client communicates with a backend through standard means.

* backend: a Node.js based application, providing services used by editors and IDEs
* communication interface: JSON-RPC through HTTP (default port 3000)
* API: a classical programming interface, used by the JSON-RPC layer
* frontend: any IDE or Editor with extension capability, using the backend through the communication interface

This project should bring everything except the last part: a frontend is a consumer of the project.

However, as this is a work in progress, and for some prioritary requirements, everything is integrated into a frontend project: an Eclipse plugin.

Later on, we could consider doing it for [Sublime Text](http://www.sublimetext.com/), [Notepad++](http://notepad-plus-plus.org/), [Cloud9](https://c9.io/), ...

## Thoughts

### Performances of process interactions

Maybe the use of JSON-RPC through HTTP can be too heavy for very frequent and simple operations done while editing. I'm mainly thinking about the frequent update of the model (source, AST and so on) with content, positions, etc. while the user enters text.

Think about using a custom protocol built on top of lower-level ones (TCP for instance).

There are also other standard solutions like [CORBA](http://en.wikipedia.org/wiki/Common_Object_Request_Broker_Architecture), but I'm not sure there is an available mapping for JavaScript.
