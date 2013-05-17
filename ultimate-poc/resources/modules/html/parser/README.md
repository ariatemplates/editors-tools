This modules aims at parsing HTML files.

The goal is not to recreate the wheel, but to have something available for the Proof of Concept.

However, having our own parser, even if it would need to be maintained by us, allows to nicely bring the features we want, be closer to our models, concepts, ...

# FIXME

* spaces are handled inconsistently: sometimes they are added to the children index, as an empty list, sometimes they are not added at all when they belong to a conditional group.

# TODO

## Inline nodes

Handle inline nodes without `/` before `>`

There is a current solution taking into account a static list of tag ids for inline statements

Another solution would be to drastically change the model, where we would only take a flat list of elements, tags becoming elements, and then traverse this list to build the hierarchy.

## DRY

Wee see a lot of files are unchanged between the AT module and this one for tests, and parser generation. Only the `README.md`, `grammar.pegjs` and test file content changes. Build from that a kind of small library for PEG.js based parsers, that these two modules would use. For that, first extract parameters for the test, notably the path of the test file (the extension might change, for editor support)
