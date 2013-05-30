package poc.outline;

import java.util.Map;

import org.eclipse.jface.viewers.LabelProvider;

public class POCOutlineLabelProvider extends LabelProvider {
	
	private static final String LABEL_KEY = "label";

	@SuppressWarnings("unchecked")
	public String getText(Object element) {
		return ((Map<String, Object>)element).get(LABEL_KEY).toString();
	}

}
