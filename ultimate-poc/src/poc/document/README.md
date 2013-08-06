Manages a document, a document being the model used to handle data that can be edited through editors.

# File system layout

* [`README.md`](./README.md): this current file
* [`POCDocument.java`](./POCDocument.java): a custom document implementation, considering the specificities the backend introduces with the document model
* [`POCDocumentListener.java`](./POCDocumentListener.java): a class used to intercept and handle changes in a document
* [`POCDocumentPartitioner.java`](./POCDocumentPartitioner.java): a generic simple partitioner
* [`POCDocumentProvider.java`](./POCDocumentProvider.java): a class that is able to return a document instance given a document input

# Versioning

To version: _everything_.

# Documentation

## Document

__Extends a standard document implementation.__

The things this class adds compared to the standard document implementation it inherits from is related to the way a document is handled by the backend.

For now, the essential addition is the storage of the id of the document, returned by the backend when it has been registered. This is the only required data to be able to process a document on the backend.

## Document provider

__Is in charge to create a document instance given a document input.__

For the time being, we use file documents input ( ___it might change in the future, with the concept of sessions, sharing - that is editing a same document through multiple frontends - , ...___ ), so we subclassed the `FileDocumentProvider` class, and we use the base implementation to actually create the document.

Doing this way just enables us to hook up the document creation process, so we can apply configuration on the requested document.

For now the document partitioner is applied that way, but this could also be done with a document setup participant class.

__In the future__: this class will be useful to implement what it's done for, that is a custom document providing.

## Document partitioner

__Sets up _big_ partitions of a document.__

__For now the document always returns a unique partition for the whole document with the generic name:__ `MAIN`.

This is more likely to be used in order to handle multiple languages in a same document.

However, the backend implementation already handles this, so here there would be only one partition per document, corresponding to the _master_ language of the file.


# Contribute

## Alignment with the latest backend implementation

__The backend changed a lot, and the plugin needs to use differently.__

### Document

The only thing needed to work with a document - on the backend side - is its id/guid/token. This is what is returned by the backend when the document is registered. So the `mode` property must be removed from the [`POCDocument`](./POCDocument.java) class.

### Document provider

Chnage the way the document is initialized.

First, the mode property must not be set anymore on the document instance on the plugin side, but must be sent to the backend as an argument for the procedure of initialization.

Then, the procedure of initialization changed. Basically this JSON has to be sent:

```json
{
	"module": "editor",
	"method": "init",
	"argument": {
		"mode": ...
	}
}
```

This still returns the same result (a document id wrapped in an object - `{guid: ...}`)

__You should use the suggested method `Backend.editor()`__ ([see](ultimate-poc/src/poc/README.md#alignment-with-the-latest-backend-implementation))

For now, the code would be changed to:

```java
document.setGUID((String) Backend.get().rpc("editor", "init", argument).get("guid"));
```

where `argument` is an object containing the property `mode`.

And using the advised method of the `Backend`:

```java
document.setGUID((String) Backend.get().editor("init", argument).get("guid"));
```

### Document listener

Idem, the classical RPC changed, so don't use the `Backend.rpc` method, don't target a module named after the mode, but target the `editor` module. See above for more examples.

## Update

__Implement document updates (see [questions](#questions) below).__

When the user modifies the content of the document, send the changes to the backend.

There are two problematics linked to this subject:

* the content: what should be sent for a document change
* the performance/timing: when should the changes be sent

### Content

For the content, the easiest solution would be to send the whole document content everytime you want to update it. This can be used but only for small document and should be reserved for development purposes.

The best solution is to send a diff. A diff represents only the difference between the last document state and the new document state. This can express things like: something has been inserted, or replaced, or removed, or moved, ...

To know how to use a diff and to actually update a document, please refer to the [corresponding section](resources/app/node_modules/modes/node_modules/README.md#update) in the backend documentation.

### Frequency/timing

Now, the frequency of the update is important for both performances, user experience, and also content.

The unit of a change can be a keystroke: entering a character or removing. Remember that changes can occur fast: with one keystroke on a selection a whole document can be erased for instance.

So we could think that we should update on each keystroke. However, we have to consider the user too: he can type in very fast. And though this doesn't necessarily mean introducing big changes! Imagine typing 5 characters and removing them with backspace in one second: nothing changed, but you would have made 10 updates in 1 second! And i didn't even talked about undo/redo commands...

### Conclusion

Without any further details (the reflection on this subject could go far), here is an idea of solution: on the clinet side, changes should be concatenated for some amount of time, and then updates sent at the corresponding frequency.

Example: send updates every 250ms, time during which the client should do itself a concatenation of changes.

## Document registering & mode detection

__Make the document provider infer the mode of the document at registration.__

The registration of a document requires a mode (language) to be set for the document.

To know the mode of a document, there can be two solution:

* the simple one: look at the filename, and particularly the extension (or a special file name)
* the complex one: analysing the content of the document (makes sense if not empty) to try to guess the mode

The second solution involves semantics and should be handled by the backend. For now it doesn't support this feature, so we should take the first one.

# Questions

> How do we handle document changes?

By setting up a document listener on a document. This listener get notified by a document event object of changes made in the document.

> But what is the strategy to consider changes? Does any keystroke trigger an event?

__We don't know yet, it has to be checked.__ Hopefully the used document implementation concatenates quick changes and applies squashing algorithms.
