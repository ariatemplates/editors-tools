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
		return this.getList(inputElement, ROOT_KEY);
	}

	@Override
	public Object[] getChildren(Object parentElement) {
		return this.getList(parentElement, CHILDREN_KEY);
	}
	
	@Override
	public boolean hasChildren(Object element) {
		return this.getChildren(element).length > 0;
	}
	
	@SuppressWarnings("unchecked")
	private Object[] getList(Object element, String key) {
		Map<String, Object> node = (Map<String, Object>) element;
		
		List<Map<String, Object>> elements = (List<Map<String, Object>>) node.get(key);
		
		return elements.toArray();
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
