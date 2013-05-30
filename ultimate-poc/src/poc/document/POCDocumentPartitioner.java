package poc.document;

import org.eclipse.jface.text.DocumentEvent;
import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.IDocumentPartitioner;
import org.eclipse.jface.text.ITypedRegion;
import org.eclipse.jface.text.TypedRegion;

public class POCDocumentPartitioner implements IDocumentPartitioner {
	
	public static final String PARTITION_NAME = "MAIN" ;
	
	//private IDocument document = null;
	private ITypedRegion region = null;
	
	@Override
	public void connect(IDocument document) {
		//this.document = document;
	}

	@Override
	public void disconnect() {
		//this.document = null;
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
		String[] types = {PARTITION_NAME};
		return types;
	}

	@Override
	public String getContentType(int offset) {
		return PARTITION_NAME;
	}

	@Override
	public ITypedRegion[] computePartitioning(int offset, int length) {
		this.region = new TypedRegion(offset, length, PARTITION_NAME);
		ITypedRegion[] regions = {this.region};
		return regions;
	}

	@Override
	public ITypedRegion getPartition(int offset) {
		return this.region;
	}




}
