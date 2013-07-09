package poc.document;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.IDocumentPartitioner;
import org.eclipse.ui.editors.text.FileDocumentProvider;

import poc.Backend;

public class POCDocumentProvider extends FileDocumentProvider {
	// FIXME Should be inferred from extension or something like that
	private static final String mode = "at";

	@Override
	protected IDocument createDocument(Object element) throws CoreException {
		// In practice `element` is a FileDocumentInput
		POCDocument document = (POCDocument) super.createDocument(element);

		if (document != null) {
			IDocumentPartitioner partitioner = new POCDocumentPartitioner();
			document.setDocumentPartitioner(partitioner);
		}

		document.setMode(mode);
		try {
			document.setGUID((String) Backend.get().rpc(mode, "init").get("guid"));
			document.addDocumentListener(new POCDocumentListener(document));
		} catch (Exception e) {
			e.printStackTrace();
		}

		return document;
	}

	@Override
	protected IDocument createEmptyDocument() {
		return new POCDocument();
	}
}
