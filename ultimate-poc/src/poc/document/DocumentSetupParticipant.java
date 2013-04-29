package poc.document;

import org.eclipse.core.filebuffers.IDocumentSetupParticipant;
import org.eclipse.jface.text.IDocument;

public class DocumentSetupParticipant implements IDocumentSetupParticipant {

	@Override
	public void setup(IDocument document) {
		document.setDocumentPartitioner(new POCDocumentPartitioner());
		//document.
	}

}
