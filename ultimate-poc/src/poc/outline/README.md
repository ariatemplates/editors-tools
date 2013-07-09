Outline view of a document.

# File system layout

* `README.md`: this current file
* `POCOutline.java`: handles the outline page
* `POCOutlineContentProvider.java`: provides the nodes for the outline tree
* `POCOutlineLabelProvider.java`: provides labels for the nodes of the outline tree

## TODO

* Rename the files for more conciseness and proper naming (like `POCOutline` to `Outline` and `POCOutlineLabelProvider` to `LabelProvider`, moreover this won't be a PoC anymore in the future)

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

## Partial update

In the future all the models will be incrementally updated, considering only changes to update. This is a huge work because it means detecting side-effects, finding insertion points and so on.

In the case of the outline, this would be good too to cache the outline model in the frontend, and to request only the changes from the backend.

## Performances

When the outline model has been updated on the frontend side, it's not necessarily requested by the user. If he never unfolds the nodes of the outline tree view for instance.

In this case it is useless to convert the JSON representation to a Java representation, so maybe a lazy JSON parsing should be put in place.

Further, we could even imagine asking the backend for chunks of outline data, only when the user requests it on frontend side. In this case, lazy parsing should not help, as we would be requesting only what the user wants.

The latter might imply some changes in the specifications of the service provided by the backend.
