___CLEAN THIS___

Issues:

* needs review: might contain grammatical and semantics mistakes
* needs refactoring: the format of this documentaion file is different from the other, define it and stick to it

----

This project aims at providing source code edition services, decoupled from any user interface, with an effort on abstraction of the underlying models.

__This is a work in progress and a proof of concept.__

For now it is concretely applied to specific things:

* Edition services modules:
	* JavaScript
	* HTML
	* [Aria Templates](http://ariatemplates.com)
* Clients implementations:
	* [Eclipse IDE](http://eclipse.org/)

# Introduction

It would be cumbersome to explain in details the meaning of this project, so let's do it with an example.

Imagine you want to edit a JavaScript source file (or a full project).

For that, you'll use either an IDE or an editor of your choice. These tools will implement the usual features we expect them to provide, like syntax highlighting, outlining. By the way, the balance between features determines the nature of the tool: more IDE or editor.

These features are expected to behave the same way, since they are based on a common thing: the JavaScript standard. The only differences can occur depending on the capabilities of the tool in terms of UI.

However, while these services do the same for the user, and work with the same input data (source code), they are often re-implemented for every platform (platform = tool = client):

* in Java using PDE for the Eclipse IDE
* in Python for Sublime Text
* in C++ for notepad++
* ...

This is the theory, as there is maybe a use of common libraries with bindings for different languages, this way the three environments mentioned above would be able to use for instance a parser written in Perl.

However, this is quite limited and still requires some parts to be implemented in a duplicated way.

This project aims at fixing that.

> How?

By tackling these (generic) issues:

* process communication
* data-centric design

Interfaces in general.

# Goal

General:

* Maintain one code base: with separation of (G)UI and processing, instead of reimplementing the logic for any editor/IDE solution
* Benefit from an open architecture: the most we can support different kind of frontends, the more we will increase quality of our design
* ...

Specific:

* Re-use our knowledge: we prefer dealing with the JavaScript world we know well, instead of having to deal with different technologies (Java for Eclipse IDE, Python for Sublime Text, C++ for Notepad++)
* ...

# Try it

1. Install Node.js
1. Install the package `livescript` with npm
1. Clone the repository
1. Import the Eclipse project from the existing `plugin.xml` file
1. Open the Eclipse project
1. Launch the project as an `Eclipse application`

You can start editing files with the `.tpl` extension.

# Contribute

Instead of reminding all the usual and obvious tasks as cloning the current repository, I would give an advice to apply everywhere: __READ CAREFULLY THE DOCS__.

See section below to know how to understand and navigate through the documentation.

## File system layout

* `README.md`: this current file
* `.gitignore`: Git related file
* `bin`: folder containing the build, that is both Eclipse plugin and Backend for now

### Eclipse code

* `build.properties`, `plugin.xml`, `META-INF`: files and folders contributing to the Eclipse plugin definition
* `src`: the sources of the Eclipse plugin
* `.project`, `.classpath`, `.settings`: files related to the Eclipse project configuration

### Backend code

* `resources`: the sources of the backend

## Versioning

To version:

* `README.md`
* `.gitignore`
* `build.properties`, `plugin.xml`, `META-INF`
* `src`
* `resources`

What might be versioned (should be reproducible and might differ between environments - so versioning would more pollute than help):

* `.project`, `.classpath`, `.settings`

What MUST NOT be versioned:

* `bin`

## Documentation

I'll decribe here where the documentation stands and which pattern it follows.

Every folder in this project will contain a documentation file when relevant.

An example of irrelevant documentation would be a documentation about external or standard modules, for which the documentation stands elsewhere. However, it's stringly encouraged to write documentation bringing an added-value on top of that, like your quick understanding of the modules, or a description of the way you use it.

So, each folder contains a `README.md` file, to be consistent with GitHub. However, when needed, other Markdown files with proper names can be added, but they __MUST__ be referenced in the `README.md` file.

### Format

#### Disclaimer

A disclaimer can be put at the very top of file, before any content, with an emphased first line describing the problem of the documentation, followed by a short explanation paragraph.

A separating line must be inserted then.

#### Catcher

A documentation file begins with a single paragraph which must do its best to sum up the content of the documentation: this is the __catcher__.

An effort of scaling the point of view must be made, as a documentation file residing at the root of a project will need to sum up the idea of the project, leaving details for modules.

The catcher is also an occasion to warn the user about things he could quickly wonder before reading any documentation. In this case, you can describe it in more details in a section you would reference form the catcher.

#### File system layout

This section should be the first of the document.

It is intended to describe each file and folder contained in the current folder.

Each node can be described in a dedicated subsection or as an item of a list.

If you use both subsections and a list, put the list first.

Node names are put in `code style`. This is an important thing to mention, as some entries (sections or list items) can be written in plain style: in this case this is often a grouping of different nodes, for which a global explanation is enough.

### Guidelines

* The average length of a documentation should exceed __200 lines__
* Don't hesitate to use emphasis when necessary


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
