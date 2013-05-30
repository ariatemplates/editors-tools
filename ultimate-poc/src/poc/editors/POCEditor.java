package poc.editors;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.Position;
import org.eclipse.jface.text.source.Annotation;
import org.eclipse.jface.text.source.ISourceViewer;
import org.eclipse.jface.text.source.IVerticalRuler;
import org.eclipse.jface.text.source.projection.ProjectionAnnotation;
import org.eclipse.jface.text.source.projection.ProjectionAnnotationModel;
import org.eclipse.jface.text.source.projection.ProjectionSupport;
import org.eclipse.jface.text.source.projection.ProjectionViewer;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.ui.editors.text.TextEditor;
import org.eclipse.ui.views.contentoutline.IContentOutlinePage;

import poc.Backend;
import poc.document.POCDocument;
import poc.document.POCDocumentProvider;
import poc.outline.POCOutline;

public class POCEditor extends TextEditor {

	// FIXME Make it customizable, and in fact related to the document type 
	private static final String mode = "js";
	
	private POCOutline contentOutlinePage = null;

	private ProjectionAnnotationModel annotationModel;
	private ProjectionSupport projectionSupport; 

	
	
	////////////////////////////////////////////////////////////////////////////
	// Building
	////////////////////////////////////////////////////////////////////////////
	
	public POCEditor() {
		super();
		setDocumentProvider(new POCDocumentProvider());
	}
	
	@Override
	protected ISourceViewer createSourceViewer(Composite parent,
			IVerticalRuler ruler, int styles) {
		ISourceViewer viewer = new ProjectionViewer(parent, ruler, this.getOverviewRuler(), this.isOverviewRulerVisible(), styles);
		// Ensures decoration support has been created and configured
		this.getSourceViewerDecorationSupport(viewer);
		return viewer;
	}
	
	@Override
	public void createPartControl(Composite parent) {
		super.createPartControl(parent);
		
		ProjectionViewer viewer = (ProjectionViewer)this.getSourceViewer();

	    this.projectionSupport = new ProjectionSupport(viewer, this.getAnnotationAccess(), this.getSharedColors());
	    this.projectionSupport.install();

	    // Turns projection mode on
	    viewer.doOperation(ProjectionViewer.TOGGLE);

	    this.annotationModel = viewer.getProjectionAnnotationModel();
		
	}
	
	@Override
	protected void initializeEditor() {
		super.initializeEditor();
		setSourceViewerConfiguration(new POCSourceViewerConfiguration());
	}

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


	
	////////////////////////////////////////////////////////////////////////////
	// Folding
	////////////////////////////////////////////////////////////////////////////
	
	private static final String FOLD_METHOD = "fold"; 
	private static final String FOLDS_KEY = "folds";
	private static final String START_KEY = "start";
	private static final String END_KEY = "end";
	
	@SuppressWarnings("unchecked")
	private void fold() throws IOException {
		POCDocument document = (POCDocument) this.getDocumentProvider().getDocument(this.getEditorInput());
		
		Map<String, Object> argument = new HashMap<String, Object>();
		argument.put("source", document.get());
		List<Map<String, Object>> folds = (List<Map<String, Object>>) Backend.get().rpc(document.getMode(), FOLD_METHOD, argument).get(FOLDS_KEY);
		
		System.out.println(folds);
		List<Position> positions = new ArrayList<Position>(folds.size());
		for (Map<String, Object> range: folds) {
			int start = ((Number)range.get(START_KEY)).intValue();
			int end = ((Number)range.get(END_KEY)).intValue();
			int length = end - start + 1;
			
			positions.add(new Position(start, length));
		}
		this.updateFoldingStructure(positions);
	}
	
	
	
	private List<Annotation> oldAnnotations = new ArrayList<Annotation>();
	
	public void updateFoldingStructure(List<Position> positions)
	{
		// This will hold the new annotations along with their corresponding positions
		HashMap<ProjectionAnnotation, Position> newAnnotations = new HashMap<ProjectionAnnotation, Position>();
		
		List<Annotation> annotations = new ArrayList<Annotation>();
		for (Position position: positions) {
			ProjectionAnnotation annotation = new ProjectionAnnotation();
			newAnnotations.put(annotation, position);
			annotations.add(annotation);
		}

		annotationModel.modifyAnnotations(oldAnnotations.toArray(new Annotation[oldAnnotations.size()]), newAnnotations, null);
		   
		oldAnnotations = annotations;
	}
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// Events
	////////////////////////////////////////////////////////////////////////////
	
	@Override
	protected void editorSaved() {
		super.editorSaved();
		try {
			//format();
			//highlight();
			this.fold();
			//validate();
			this.outline();
			
		} catch (IOException e) {
			e.printStackTrace();
		}		
	}


	
	
	
	// TODO Process input on initialization

	private void format() throws IOException {
		POCDocument document = (POCDocument) this.getDocumentProvider().getDocument(this.getEditorInput());
		
		Map<String, Object> argument = new HashMap<String, Object>();
		argument.put("source", document.get());
		Map<String, Object> formatted = Backend.get().rpc(document.getMode(), "format", argument);
		
		document.set(formatted.get("source").toString());
	}
	
	private void outline() throws IOException {
		POCDocument document = (POCDocument) this.getDocumentProvider().getDocument(this.getEditorInput());
		
		Map<String, Object> argument = new HashMap<String, Object>();
		argument.put("source", document.get());
		Map<String, Object> outline = Backend.get().rpc(document.getMode(), "outline", argument);
		
		contentOutlinePage.setInput(outline);
	}
	
	private void validate() throws IOException {
		Map<String, Object> argument = new HashMap<String, Object>();
		argument.put("source", this.getDocumentProvider().getDocument(this.getEditorInput()).get());
		
		System.out.println(Backend.get().rpc(mode, "validate", argument));
	}
	
}
