package poc.document;

import org.eclipse.jface.text.DocumentEvent;
import org.eclipse.jface.text.IDocumentListener;

public class POCDocumentListener implements IDocumentListener {

	private POCDocument document = null;
	
	public POCDocumentListener(POCDocument document) {
		this.document = document;
	}

	@Override
	public void documentAboutToBeChanged(DocumentEvent event) {
	}

	@Override
	public void documentChanged(DocumentEvent event) {
		
	}

}
