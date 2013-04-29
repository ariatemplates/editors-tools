package poc.outline;


import java.util.List;
import java.util.Map;

import org.eclipse.jface.viewers.ITreeContentProvider;
import org.eclipse.jface.viewers.Viewer;

public class POCOutlineContentProvider implements ITreeContentProvider {
	
	@Override
	@SuppressWarnings("unchecked")
	public Object[] getElements(Object inputElement) {
		Map<String, Object> json = (Map<String, Object>) inputElement;
		
		List<Map<String, Object>> ast = (List<Map<String, Object>>) json.get("ast");
		
		return ast.toArray();
	}

	@SuppressWarnings("unchecked")
	@Override
	public Object[] getChildren(Object parentElement) {
		Map<String, Object> node = (Map<String, Object>) parentElement;
		
		List<Map<String, Object>> ast = (List<Map<String, Object>>) node.get("children");
		
		return ast.toArray();
	}

	@Override
	public boolean hasChildren(Object element) {
		return (this.getChildren(element).length > 0);
	}
	
	
	
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
