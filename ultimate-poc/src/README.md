Eclipse frontend plugin code, making use of the backend to provide source code edition tools.

# File system layout

* [`README.md`](./README.md): this current file
* [`poc`](./poc): the root package of the Eclipse plugin code

# Versioning

To version: _everything_.

# Documentation

There is nothing particular in this folder, as the Java conventions require a somehow deeply nested file system structure to organize packages: this is the concept of classpath.

The classpath of the root package is: `poc`.

# Contribute

## FIXME

### Fallback when backend launch failed

__The fallback to launch a raw text editor when the backend server could not be launched or reused is way too long.__

Normally a basic timeout implementation is used in `Backend.start()` which should not exceed 1000 ms (`Backend.POLLING_TIME_OUT`). Here this is weird because it seems to be like one minute in practice.

Debug this to see if time values are properly updated, and try to figure out what's happening.

## Refactoring

__Change the root package classpath.__

The root package is named `poc` for now. This is fine only while the project is actually at a stage of Proof of Concept. However this will have to change to something more standard (following Java conventions) and related to the context of the project.

This could be something more like `com.ariatemplates.tools.editors`.

## Documentation

__Enhance the knowledge base about the Eclipse Rich Client Platform.__ Probably this would go in a wiki page referenced here instead.

Here is a non-exhaustive list of topics to tackle:

* how to create plugins
* more specific knowledge about Text Editors
* ...

# References

## Tutorials

* [Building an Eclipse Text Editor with JFace Text](http://www.realsolve.co.uk/site/tech/jface-text.php)
* [Create commercial-quality eclipse ide](http://www.ibm.com/developerworks/views/opensource/libraryview.jsp?search_by=Create+commercial-quality+eclipse+ide) on _IBM developerWorks : Open source :  Technical library_
	* [Create a commercial-quality Eclipse IDE, Part 2: The user interface](http://www.ibm.com/developerworks/opensource/tutorials/os-ecl-commplgin2/index.html)
		* [Section 2](http://www.ibm.com/developerworks/opensource/tutorials/os-ecl-commplgin2/section2.html)
	* ...

## Eclipse documentation

[Juno documentation](http://help.eclipse.org/juno/index.jsp)

* `org.eclipse.ui.texteditor.AbstractTextEditor`, `createPartControl`, `getAdapter`
* `org.eclipse.ui.editors.text.FileDocumentProvider`
* `org.eclipse.ui.views.contentoutline.ContentOutlinePage`, `getTreeViewer`
* `org.eclipse.jface.viewers.StructuredViewer`, `setInput`
* `org.eclipse.jface.viewers.TreeNodeContentProvider`, `getElements`
* `org.eclipse.jface.viewers.TreeNode`
