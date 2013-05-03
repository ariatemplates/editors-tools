package poc.editors;

import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.eclipse.jface.text.BadLocationException;
import org.eclipse.jface.text.IDocument;
import org.eclipse.jface.text.TextAttribute;
import org.eclipse.jface.text.rules.IToken;
import org.eclipse.jface.text.rules.ITokenScanner;
import org.eclipse.jface.text.rules.Token;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.widgets.Display;

import poc.Backend;

public class POCTokenScanner implements ITokenScanner {

	private List<Map<String, Object>> tokens = null;
	private Iterator<Map<String, Object>> tokensIterator = null;
	private Map<String, Object> currentToken = null;
	
	private Map<String, Object> stylesheet = null;
	
	
	@SuppressWarnings("unchecked")
	public POCTokenScanner() {
		try {
			stylesheet = (Map<String, Object>) Backend.get().rpc("js", "stylesheet", null).get("stylesheet");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@Override
	@SuppressWarnings("unchecked")
	public void setRange(IDocument document, int offset, int length) {
		try {
			Map<String, Object> argument = new HashMap<String, Object>();
			argument.put("source", document.get(offset, length));
			tokens = (List<Map<String, Object>>) Backend.get().rpc("js", "tokenize", argument).get("tokens");
			
			tokensIterator = tokens.iterator();
		} catch (BadLocationException | IOException e) {
			e.printStackTrace();
		}
	}

	@Override
	public IToken nextToken() {
		currentToken = tokensIterator.next();
	
		return new Token(getAttribute((String) currentToken.get("type")));
	}
	
	@SuppressWarnings("unchecked")
	private TextAttribute getAttribute(String type) {
		Map<String, Object> style = (Map<String, Object>) stylesheet.get(type);

		Map<String, Object> rgb = (Map<String, Object>) style.get("color");
		return new TextAttribute(new Color(
			Display.getCurrent(),
			(int)rgb.get("r"),
			(int)rgb.get("g"),
			(int)rgb.get("b")
		));
	}

	@Override
	public int getTokenOffset() {
		return (int) currentToken.get("start");
	}

	@Override
	public int getTokenLength() {
		return ((int)currentToken.get("end")) - ((int)currentToken.get("start"));
	}

}
