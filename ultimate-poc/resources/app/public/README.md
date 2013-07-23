Root of the client-side application using the backend.

This can gather different things, either for _administration_, or even for development.

# File system layout

* `README.md`: this current file
* `index.html`: the entry point of the application

# Versioning

To version: _everything_.

# Documentation

This application uses Bootstrap for basic frontend, Ace for code edition, and Cytoscape.js or JavaScript InfoVis Toolkit for graph display. Soon Require.js for modules management. Also JQuery for basic operations.

# Contribute

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