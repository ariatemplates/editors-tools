package poc.document;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.jface.text.IDocument;
import org.eclipse.ui.editors.text.FileDocumentProvider;

public class POCDocumentProvider extends FileDocumentProvider {

	@Override
	public void changed(Object element) {
		super.changed(element);
	}

	@Override
	protected IDocument createDocument(Object element) throws CoreException {
		IDocument document = super.createDocument(element);
		
		if (document != null) {
			//IDocumentPartitioner partitioner = new POCPartitioner();
		}
		
		return document;
	}

	@Override
	protected IDocument createEmptyDocument() {
		return new POCDocument();
	}
	
	

}
