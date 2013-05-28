package poc.editors;

import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;

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
	
	private static final String mode = "js";

	private List<Map<String, Object>> tokens = null;
	private Iterator<Map<String, Object>> tokensIterator = null;
	private Map<String, Object> currentToken = null;
	
	private Map<String, Object> defaultStyle = null;
	private Map<String, Object> styles = null;
	
	
	@SuppressWarnings("unchecked")
	public POCTokenScanner() {
		try {
			Map<String, Object> stylesheet = (Map<String, Object>) Backend.get().rpc(mode, "stylesheet", null).get("stylesheet");
			defaultStyle = (Map<String, Object>) stylesheet.get("default");
			styles = (Map<String, Object>) stylesheet.get("tokens");
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
			argument.put("index", offset);
			tokens = (List<Map<String, Object>>) Backend.get().rpc(mode, "tokenize", argument).get("tokens");
			
			tokensIterator = tokens.iterator();
		} catch (BadLocationException | IOException e) {
			e.printStackTrace();
		}
	}

	@Override
	public IToken nextToken() {
		try {
			currentToken = tokensIterator.next();
			String type = (String) currentToken.get("type");
			if (type == "ws") {
				return Token.WHITESPACE;
			}
			return new Token(getAttribute(type));
		} catch (NoSuchElementException exception) {			
			return Token.EOF;
		}
	}
	
	@SuppressWarnings("unchecked")
	private TextAttribute getAttribute(String type) {
  		Map<String, Object> style = (Map<String, Object>) styles.get(type);
		if (style == null) {
			style = defaultStyle;
		}

		Map<String, Object> rgb = (Map<String, Object>) style.get("color");
		if (rgb == null) {
			rgb = (Map<String, Object>) defaultStyle.get("color");
		}
		return new TextAttribute(new Color(
			Display.getCurrent(),
			((Number)rgb.get("r")).intValue(),
			((Number)rgb.get("g")).intValue(),
			((Number)rgb.get("b")).intValue()
		));
	}

	@Override
	public int getTokenOffset() {
		return ((Number) currentToken.get("start")).intValue();
	}

	@Override
	public int getTokenLength() {
		return (((Number)currentToken.get("end")).intValue()) - (((Number)currentToken.get("start")).intValue());
	}

}
