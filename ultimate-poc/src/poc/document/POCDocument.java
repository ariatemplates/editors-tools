package poc.document;

import org.eclipse.jface.text.Document;

public class POCDocument extends Document {

	private String mode = null;
	private String GUID = null; 
	
	public String getGUID() {
		return GUID;
	}

	public void setGUID(String gUID) {
		GUID = gUID;
	}

	public String getMode() {
		return mode;
	}

	public void setMode(String mode) {
		this.mode = mode;
	}
}
