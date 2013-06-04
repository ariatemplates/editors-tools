package poc.outline;


import java.util.List;
import java.util.Map;

import org.eclipse.jface.viewers.ITreeContentProvider;
import org.eclipse.jface.viewers.Viewer;

public class POCOutlineContentProvider implements ITreeContentProvider {

	private static final String ROOT_KEY = "ast";
	private static final String CHILDREN_KEY = "children";

	////////////////////////////////////////////////////////////////////////////
	// Overrides
	////////////////////////////////////////////////////////////////////////////

	@Override
	public Object[] getElements(Object inputElement) {
		return this.getList(inputElement, POCOutlineContentProvider.ROOT_KEY);
	}

	@Override
	public Object[] getChildren(Object parentElement) {
		return this.getList(parentElement, POCOutlineContentProvider.CHILDREN_KEY);
	}

	@Override
	public boolean hasChildren(Object element) {
		return this.getChildren(element).length > 0;
	}

	@SuppressWarnings("unchecked")
	private Object[] getList(Object element, String key) {
		return ((List<Map<String, Object>>)((Map<String, Object>)element).get(key)).toArray();
	}

	////////////////////////////////////////////////////////////////////////////
	// Unused
	////////////////////////////////////////////////////////////////////////////

	@Override
	public void dispose() {
	}

	@Override
	public void inputChanged(Viewer viewer, Object oldInput, Object newInput) {
	}

	@Override
	public Object getParent(Object element) {
		return null;
	}

}
