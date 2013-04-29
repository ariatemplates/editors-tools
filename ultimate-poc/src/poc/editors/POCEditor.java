package poc.editors;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.eclipse.jface.text.IDocument;
import org.eclipse.ui.editors.text.TextEditor;
import org.eclipse.ui.views.contentoutline.IContentOutlinePage;

import poc.Backend;
import poc.outline.POCOutline;

public class POCEditor extends TextEditor {

	private POCOutline contentOutlinePage = null; 

	// Setup
	@Override
	public Object getAdapter(@SuppressWarnings("rawtypes") Class required) {
		// Outline
		if (required.equals(IContentOutlinePage.class)) {
			if (contentOutlinePage == null) {
				contentOutlinePage = new POCOutline();
				contentOutlinePage.setInput(getEditorInput());
			}
			return contentOutlinePage;
		}
		
		return super.getAdapter(required);
	}

	// On save
	@Override
	protected void editorSaved() {
		super.editorSaved();
		try {
			format();
			outline();
		} catch (IOException e) {
			e.printStackTrace();
		}		
	}


	// TODO Process input on initialization
	// FIXME This is too early to communicate, the backend is not totally setup

	private void outline() throws IOException {
		Map<String, Object> argument = new HashMap<String, Object>();
		argument.put("source", this.getDocumentProvider().getDocument(this.getEditorInput()).get());
		
		contentOutlinePage.setInput(Backend.get().rpc("js", "outline", argument));
	}
	
	private void format() throws IOException {
		IDocument document = this.getDocumentProvider()
				.getDocument(this.getEditorInput());
		String argument = document.get();
		
		document.set(Backend.get().rpc("js", "format", argument).get("source").toString());
		;
	}
}
