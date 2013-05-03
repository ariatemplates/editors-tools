Here stand the modules used through RPC.

Each module corresponds to a different language.

There's no constraint about these modules, even if they should follow more or less the same API:

* parsing
* outlining
* formatting
* validating
* ...

# TODO

## Sessions

Add a concept of _session_.

A module should be able to work on any instance of a model. Imagine you have only one instance of the module, used by several editors, for different files. If the module needs to store information about the models, to gain performances or whatever, it should be able to know on which model the client wants to work.

A session could be only linked to a file (content in general), not an editor (the client editing the file). This way, we could imagine sharing the state of a file between several editors modifying it.
