package poc.document;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.apache.http.ParseException;
import org.eclipse.jface.text.DocumentEvent;
import org.eclipse.jface.text.IDocumentListener;

import com.google.gson.JsonSyntaxException;

import poc.Backend;

public class POCDocumentListener implements IDocumentListener {

	private POCDocument document = null;

	public POCDocumentListener(POCDocument document) {
		this.document = document;
	}

	@Override
	public void documentAboutToBeChanged(DocumentEvent event) {
	}

	private final static String UPDATE_METHOD = "update";

	private final static String ID_KEY = "guid";
	private final static String START_KEY = "start";
	private final static String END_KEY = "end";
	private final static String SOURCE_KEY = "source";

	@Override
	public void documentChanged(DocumentEvent event) {
		Map<String, Object> argument = new HashMap<String, Object>();
		argument.put(POCDocumentListener.ID_KEY, this.document.getGUID());
		argument.put(POCDocumentListener.START_KEY, event.getOffset());
		argument.put(POCDocumentListener.END_KEY, event.getOffset() + event.getLength());
		argument.put(POCDocumentListener.SOURCE_KEY, event.getText());

		try {
			Backend.get().rpc(this.document.getMode(), POCDocumentListener.UPDATE_METHOD, argument);
		} catch (JsonSyntaxException | ParseException | IOException e) {
			e.printStackTrace();
		}
	}

}
