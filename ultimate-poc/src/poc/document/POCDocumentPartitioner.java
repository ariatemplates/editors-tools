package poc.document;

import org.eclipse.jface.text.DocumentEvent;
import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.IDocumentPartitioner;
import org.eclipse.jface.text.ITypedRegion;
import org.eclipse.jface.text.TypedRegion;

public class POCDocumentPartitioner implements IDocumentPartitioner {
	
	private IDocument document = null;
	private ITypedRegion region = null;
	
	@Override
	public void connect(IDocument document) {
		this.document = document;
	}

	@Override
	public void disconnect() {
		this.document = null;
	}

	@Override
	public void documentAboutToBeChanged(DocumentEvent event) {
	}

	@Override
	public boolean documentChanged(DocumentEvent event) {
		return false;
	}

	@Override
	public String[] getLegalContentTypes() {
		String[] types = {"MAIN"};
		return types;
	}

	@Override
	public String getContentType(int offset) {
		return "MAIN";
	}

	@Override
	public ITypedRegion[] computePartitioning(int offset, int length) {
		this.region = new TypedRegion(offset, length, "MAIN");
		ITypedRegion[] regions = {this.region};
		return regions;
	}

	@Override
	public ITypedRegion getPartition(int offset) {
		return this.region;
	}




}
