Outline view of a document.

# File system layout

* [`README.md`](./README.md): this current file
* [`POCOutline.java`](./POCOutline.java): handles the outline page
* [`POCOutlineContentProvider.java`](./POCOutlineContentProvider.java): provides the nodes for the outline tree
* [`POCOutlineLabelProvider.java`](./POCOutlineLabelProvider.java): provides labels for the nodes of the outline tree


# Versioning

To version: _everything_.

# Documentation

Eclipse RCP provides the basis to have an outline view on data. An outline is a sort of summary of something.

In our case, the outline is a view on a document, therefore it summarizes a program. This is what the base class we implement is made for. Usually a tree view is used to show the hierarchical structure of the program.

The concept behind is simple:

* an outline view is instanciated by the editor
* we pass to the outline view a reference to the document, which contains the outlined data
* any time the input changes, the data for outline is requested from the backend
* a tree provider mechanism is used to display the tree

# Contribute

## File system layout

__Consistency in naming.__

Rename the files for more conciseness and proper naming.

Like [`POCOutline`](./POCOutline.java) to `Outline` and [`POCOutlineLabelProvider`](./POCOutlineLabelProvider.java) to `LabelProvider`.

Moreover this won't be a PoC anymore in the future, so this makes even more sense.

## Partial update

__Be able to update partial parts of the outline tree.__

In the future, all the models will be incrementally updated, considering only changes to update. So instead of parsing again a whole source text when only one line changes, this line will be parsed and the corresponding model _injected_ into the previous one.

The model for outline should be the same. While it is up to the backend server to be able to update partially the outline model, the client should have the ability to perform partial update of the UI too.

In this case, we mean that only the new part of the outline tree should be fetched from the backend.

In idea is:

* there is an update of the code: the update is sent to the backend, and all services on the clients side are warned that there is a need to _refresh_
* for outline: to _refresh_, the client asks the backend which part of the outline changed. Something like a node id (so we should have node ids along with outline data). With that node id, the new subtree should be sent.

## Performances

__Lazy request and display processing of the outline tree.__

When the model of the code changes, the model of the ouline too. Whether this model is updated incrementally/partially on the client side is the issue of the previous point.

Another thing is that the outline model is not necessary if the user doesn't use the outline view. And more precisely, the __entire__ outline model is not necessary while the user __doesn't interact__ with the outline view.

Indeed, if a node in the outline view is not expanded, it is not necessary to have the data for it.

This means several thing:

* having the data is not necessary: when the user expands a node we should then request the corresponding data to the server
* processing the data is not necessary: whether we already have the data or not, we should process it for display only when required

The second point has an issue which is that processing the data means only parsing the JSON. Or, it is not possible with the JSON library in use to parse lazily, that is leaving some raw parts for later. So if we have all the data from the beginning, it is nesecarilly parsed. Therefore, this lazy data processing - i.e. JSON parsing - can be done only along with the first point, when data is grabbed incrementally.

The first point requires changes in the way data is requested from the backend server (see backend documentation).
