package poc.editors;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.eclipse.jface.text.IDocument;
import org.eclipse.ui.editors.text.TextEditor;
import org.eclipse.ui.views.contentoutline.IContentOutlinePage;

import poc.Backend;
import poc.document.POCDocumentProvider;
import poc.outline.POCOutline;

public class POCEditor extends TextEditor {

	private POCOutline contentOutlinePage = null; 

	public POCEditor() {
		super();
		//setDocumentProvider(new POCDocumentProvider());
	}
	
	

	@Override
	protected void initializeEditor() {
		super.initializeEditor();
		setSourceViewerConfiguration(new POCSourceViewerConfiguration());
	}



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
			//format();
			//highlight();
			//fold();
			//validate();
			outline();
		} catch (IOException e) {
			e.printStackTrace();
		}		
	}


	
	
	
	// TODO Process input on initialization
	// FIXME This is too early to communicate, the backend is not totally setup

	private void format() throws IOException {
		IDocument document = this.getDocumentProvider()
				.getDocument(this.getEditorInput());
		Map<String, Object> argument = new HashMap<String, Object>();
		argument.put("source", document.get());
		
		document.set(Backend.get().rpc("at", "format", argument).get("source").toString());
		;
	}
	
	private void outline() throws IOException {
		Map<String, Object> argument = new HashMap<String, Object>();
		argument.put("source", this.getDocumentProvider().getDocument(this.getEditorInput()).get());
		
		contentOutlinePage.setInput(Backend.get().rpc("at", "outline", argument));
	}
	
	private void highlight() throws IOException {
		Map<String, Object> argument = new HashMap<String, Object>();
		argument.put("source", this.getDocumentProvider().getDocument(this.getEditorInput()).get());
		
		System.out.println(Backend.get().rpc("at", "highlight", argument));
	}
	
	private void fold() throws IOException {
		Map<String, Object> argument = new HashMap<String, Object>();
		argument.put("source", this.getDocumentProvider().getDocument(this.getEditorInput()).get());
		
		System.out.println(Backend.get().rpc("at", "fold", argument));
	}
	
	private void validate() throws IOException {
		Map<String, Object> argument = new HashMap<String, Object>();
		argument.put("source", this.getDocumentProvider().getDocument(this.getEditorInput()).get());
		
		System.out.println(Backend.get().rpc("at", "validate", argument));
	}
	
}
