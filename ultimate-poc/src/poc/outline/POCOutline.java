package poc.outline;

import org.eclipse.jface.viewers.TreeViewer;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.ui.views.contentoutline.ContentOutlinePage;

public class POCOutline extends ContentOutlinePage {

	private Object input = null;

	@Override
	public void createControl(Composite parent) {
		super.createControl(parent);

		TreeViewer viewer = this.getTreeViewer();
		viewer.setContentProvider(new POCOutlineContentProvider());
		viewer.setLabelProvider(new POCOutlineLabelProvider());
	}



	public void setInput(Object input) {
		this.input = input;
		update();
	}

	public void update() {
		if (input != null) {
			TreeViewer viewer = this.getTreeViewer();
			if (viewer != null) {
				viewer.setInput(input);
			}
		}
	}



}
