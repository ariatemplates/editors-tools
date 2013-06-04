package poc.document;

import org.eclipse.jface.text.Document;

public class POCDocument extends Document {

	private String mode = null;
	private String GUID = null;

	public String getGUID() {
		return this.GUID;
	}

	public void setGUID(String GUID) {
		this.GUID = GUID;
	}

	public String getMode() {
		return this.mode;
	}

	public void setMode(String mode) {
		this.mode = mode;
	}
}
