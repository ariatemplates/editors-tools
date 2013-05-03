package poc.editors;

import org.eclipse.jface.text.contentassist.IContentAssistant;
import org.eclipse.jface.text.formatter.IContentFormatter;
import org.eclipse.jface.text.presentation.IPresentationReconciler;
import org.eclipse.jface.text.presentation.PresentationReconciler;
import org.eclipse.jface.text.rules.DefaultDamagerRepairer;
import org.eclipse.jface.text.rules.ITokenScanner;
import org.eclipse.jface.text.source.ISourceViewer;
import org.eclipse.jface.text.source.SourceViewerConfiguration;

public class POCSourceViewerConfiguration extends SourceViewerConfiguration {

	public POCSourceViewerConfiguration() {
		super();
		
	}

	@Override
	public int getTabWidth(ISourceViewer sourceViewer) {
		// TODO Use the value from the backend general configuration
		return 4;
	}

	@Override
	public IPresentationReconciler getPresentationReconciler(
			ISourceViewer sourceViewer) {
		PresentationReconciler reconciler = new PresentationReconciler();
		DefaultDamagerRepairer dr = new DefaultDamagerRepairer(getTagScanner());
		reconciler.setDamager(dr, "js");
		reconciler.setRepairer(dr, "js");
		
		return reconciler;
	}

	private ITokenScanner getTagScanner() {
		return new POCTokenScanner();
	}

	@Override
	public IContentFormatter getContentFormatter(ISourceViewer sourceViewer) {
		// TODO Auto-generated method stub
		return super.getContentFormatter(sourceViewer);
	}

	@Override
	public IContentAssistant getContentAssistant(ISourceViewer sourceViewer) {
		// TODO Auto-generated method stub
		return super.getContentAssistant(sourceViewer);
	}
	
}
