This project aims at providing an abstraction and a decoupling of source code edition problematics.

This is a work in progress, and for now is concretely applied to specific things:

* JavaScript
* [Eclipse IDE](http://eclipse.org/)
* _[Aria Templates](http://ariatemplates.com) (to come)_

# Goal

General:

* Maintain one code base: with decoupling of (G)UI and processing, instead of reimplementing the logic for any editor/IDE solution
* Benefit from an open architecture: the most we can support different kind of frontends, the more we will increase quality of our design
* ...

Specific:

* Re-use our knowledge: we prefer dealing with the JavaScript world we know well, instead of having to deal with different technologies (Java for Eclipse IDE, Python for Sublime Text, C++ for Notepad++)
* ...

# Try it

1. Clone the repository
1. Create project from existing plugin.xml

# Contribute

1. Clone the current repository
1. Read the developer doc

## Versioning

Here is the list of content to be versioned:

* `build.properties`, `plugin.xml`, `META-INF`: files and folders contributing to the Eclipse plugin definition
* `README.md`: this current file
* `src`, `resources`: the sources of the project

What might be versioned (should be reproducible and might differ between environments - so versioning would more pollute than help):

* `.project`, `.classpath`, `.settings`: files related to the Eclipse project used to develop the Eclipse plugin

What MUST NOT be versioned:

* `bin`: this is the folder containing the build






# Architecture

* backend: a Node.js based application, providing services used by editors and IDEs
* communication interface: JSON-RPC through HTTP (default port 3000)
* API: a classical programming interface, used by the JSON-RPC layer
* frontend: any IDE or Editor with extension capability, using the backend through the communication interface

This project should bring everything except the last part: a frontend is a consumer of the project.

However, as this is a work in progress, and for some prioritary requirements, everything is integrated into a frontend project: an Eclipse plugin.

Later on, we could consider doing it for [Sublime Text](http://www.sublimetext.com/), [Notepad++](http://notepad-plus-plus.org/), [Cloud9](https://c9.io/), ...

# Thoughts

## Performances

Maybe the use of JSON-RPC through RPC can be too heavy for very frequent and simple operations done while editing. I mostly think about updating the model (source, AST and so on) with content, positions, etc. while the user enters text. Think about using a custom protocol built on top of lower-level ones (TCP for instance).
