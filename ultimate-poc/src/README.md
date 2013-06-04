Eclipse plugin code, making use of the backend to provide source code edition tools.

# File system layout

* `README.md`: this current file
* `poc`: the root package of the Eclipse plugin code

# Versioning

To version: _everything_.

# References

## Tutorials

* [Building an Eclipse Text Editor with JFace Text](http://www.realsolve.co.uk/site/tech/jface-text.php)
* [`Create commercial-quality eclipse ide`](http://www.ibm.com/developerworks/views/opensource/libraryview.jsp?search_by=Create+commercial-quality+eclipse+ide) on _IBM developerWorks : Open source :  Technical library_
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
