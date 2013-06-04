Manages a document, a document being the model used to handle data that can be edited through editors.

# File system layout

* `README.md`: this current file
* `POCDocument.java`: a custom document implementation, considering the sepcificities the backend introduces with the document model
* `POCDocumentListener.java`: a class used to intercept and handle changes in a document
* `POCDocumentPartitioner.java`: a generic simple partitioner
* `POCDocumentProvider.java`: a class that is able to return a document instance given a document input

# Versioning

To version: _everything_.

# Documentation

## Document

Extends a standard document implementation.

The things it adds is related to the way a document is handled by the backend: things like document id for sessions, mode to know which mode the backend should use for it, etc.

__Note: using a session, the mode would be obsolete, as we could store this mode in the session data. Then there would be only one module used through RPC, a master mode manager, which would use the session data to call the proper mode.__

## Document provider

Is in charge to create a document instance given a document input.

For the time being, we use file documents input ( ___it might change in the future, with the concept of sessions, sharing, ...___ ), so we subclassed the `FileDocumentProvider` class, and we use the base implementation to actually create the document.

Doing this way just enables us to hook up the document creation process, so we can apply configuration on the requested document.

__For now nothing is done__: I began applying a document partitioner, but this can be done in the document setup participant class.

__In the future__: this class will be useful to implement what it's done for, that is a custom document providing.

## Document partitioner

Sets up big partitions of a document.

This is more likely to be used in order to handle multiple languages in a same document.

However, the backend implementation already handles this, so there would be only one partition per document, corresponding to the _master_ language of the file.

__For now the document always returns a unique partition for the whole document with the generic name: `MAIN`__.

# Questions

> How do we handle document changes?

By setting up a document listener on a document. This listener get notified by a document event object of changes made in the document.

> But what is the strategy to consider changes? Does any keystroke trigger an event?

__We don't know yet, it has to be checked.__ Hopefully the document implementation used concatenates quick changes and applies squashing algorithm.
