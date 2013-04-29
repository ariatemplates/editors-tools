package poc.outline;

import java.util.Map;

import org.eclipse.jface.viewers.LabelProvider;

public class POCOutlineLabelProvider extends LabelProvider {

	@SuppressWarnings("unchecked")
	public String getText(Object element) {
		return ((Map<String, Object>)element).get("label").toString();
	}

}
