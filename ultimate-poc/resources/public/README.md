Root of the client-side application using the backend.

This can gather different things, either for _administration_, or even for development.

# File system layout

* [`README.md`](./README.md): this current file
* [`index.html`](./index.html): the entry point of the application
* `lib`: folder for manually installed 3rd party libraries
* `bower_components`: folder for 3rd party libraries installed through [Bower](http://bower.io/)
*

# Versioning

To ignore:

* `lib`: 3rd party libraries
* `bower_components`: 3rd party libraries

To version: _everything else_.

# Documentation

## 3rd party libraries

I always use the latests releases expect specified otherwise.

* [Require.js](http://requirejs.org/): modules management
* [JQuery](http://jquery.com/): basic operations
* [Bootstrap 3](http://getbootstrap.com/): GUI
* [Hogan.js](http://twitter.github.io/hogan.js/): GUI
* [Ace](http://ace.c9.io/#nav=about): code edition
* [Highlight.js](http://softwaremaniacs.org/soft/highlight/en/): static code highlighting
* [JavaScript InfoVis Toolkit](http://philogb.github.io/jit/): graph display
* [Cytoscape.js](http://cytoscape.github.io/cytoscape.js/): graph display

# Contribute

## Setup

Considering the files have already been cloned from the repository, the only thing you need to do is to install the third party libraries.

To have a list of these libraries, have a look at [this documentation](#3rd-party-libraries), but also at the [`index.html`](./index.html), at the bottom of the file where scripts are included, but also at the top, for third-party stylesheets.

You can put these libraries in two folders, which have been configured to be served statically by the server, in the following precedence:

1. lib
1. bower_components

Just take care of following the same path conventions (look at [`index.html`](./index.html) code), and to use the [proper versions](#3rd-party-libraries).

See [here](#3rd-party-libraries) for downloads.

## Try

Just go to the [root of the backend project](ultimate-poc/resources/README.md#try) and follow the intructions to launch the backend.

The application is served on two [routes](ultimate-poc/resources/app/routes.js):

* `/` (no path)
* `/app`

## FIXME

* static locations specified in the options of the server are served considering the current working directory, which is a too weak convention (might change easily): change the use of the server library by specifying explicitely a root, resolved from a deterministic property (like the path of the module file)

## Documentation

* Write documentration

## Backlog

### JIT

Implement a graph display using JavaScript InfoVis Toolkit

### Modularity

Use Require.js.

Modules to create:

* RPC: a module to send RPC requests to the server
* Graph builders: a module able to build graph displays for several libraries, with a common input model

### Layout

Find how to

### Cytoscape

Improve the use of the Cytoscape library.

* Adapt width of nodes to its content
* Add scrolling features, more convenient than moving (by selecting all or pressing an edge) and playing with zoom
* See how to choose the children orientation with the current layout (from left to right instead of right to left - for now the order is reversed on server-side to fix that)

### Bootstrap

Maybe find an alternative.

What is missing now:

* easy layout management

# References

* [Cytoscape](http://cytoscape.github.io/cytoscape.js/)
* [JIT](http://philogb.github.io/jit/)
* [Bootstrap](http://twitter.github.io/bootstrap)