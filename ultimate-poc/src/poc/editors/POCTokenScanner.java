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
import poc.document.POCDocument;

public class POCTokenScanner implements ITokenScanner {

	// Tokens ------------------------------------------------------------------
	private List<Map<String, Object>> tokens = null;
	private Iterator<Map<String, Object>> tokensIterator = null;
	private Map<String, Object> currentToken = null;
	
	// Styles ------------------------------------------------------------------
	
	private Map<String, Object> defaultStyle = null;
	private Map<String, Object> styles = null;
	
	
	
	public POCTokenScanner() {}

	
	
	////////////////////////////////////////////////////////////////////////////
	// Data update
	////////////////////////////////////////////////////////////////////////////
	
	private static final String SOURCE_ARG_NAME = "source";
	private static final String OFFSET_ARG_NAME = "offset";
	
	
	private static final String TOKENIZE_MEMBER_KEY = "tokenize";
	private static final String TOKENS_KEY = "tokens";
	
	@Override
	@SuppressWarnings("unchecked")
	public void setRange(IDocument document, int offset, int length) {
		POCDocument doc = (POCDocument) document;
		
		try {
			// Mode ------------------------------------------------------------
			String mode = doc.getMode();

			// Styles ----------------------------------------------------------
			this.getStylesheet(mode);
			
			// Tokens ----------------------------------------------------------
			Map<String, Object> argument = new HashMap<String, Object>();
			//argument.put(SOURCE_ARG_NAME, document.get(offset, length));
			argument.put(SOURCE_ARG_NAME, document.get());
			argument.put("wholeSource", true);
			argument.put(OFFSET_ARG_NAME, offset);
			argument.put("end", offset + length);
			tokens = (List<Map<String, Object>>) Backend.get().rpc(mode, TOKENIZE_MEMBER_KEY, argument).get(TOKENS_KEY);
			
			tokensIterator = tokens.iterator();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// Stylesheet update
	////////////////////////////////////////////////////////////////////////////
	
	// Constants ---------------------------------------------------------------
	
	private static final String STYLESHEET_MEMBER_KEY = "stylesheet";
	private static final String STYLESHEET_KEY = "stylesheet";
	private static final String DEFAULT_STYLE_KEY = "default";
	private static final String STYLES_KEY = "tokens";
	
	// Cache -------------------------------------------------------------------
	
	private static boolean safeCache = true;
	private Map<String, Object> stylesheets = new HashMap<String, Object>();
	
	// TODO Create or find a generic cache utility. Integrate this cache utility in the Backend class? It would make sense!! This is not optmize communication with the backend, which should implement a generic cache system 
	@SuppressWarnings("unchecked")
	private void getStylesheet(String mode) throws IOException {
		Map<String, Object> stylesheet = null;
		
		// Cache ---------------------------------------------------------------
		if (stylesheets.containsKey(mode)) {
			if (safeCache) {
				Map<String, Object> options = new HashMap<String, Object>();
				options.put("checkCache", true);
				options.put("sendIfObsolete", true);
				
				Map<String, Object> response = Backend.get().rpc(mode, STYLESHEET_MEMBER_KEY, options);
				
				if ((Boolean)response.get("obsolete")) {
					stylesheet = (Map<String, Object>) response.get(STYLESHEET_KEY);
					stylesheets.put(mode, stylesheet);
				} else {
					stylesheet = (Map<String, Object>) stylesheets.get(mode);
				}
			} else {
				stylesheet = (Map<String, Object>) stylesheets.get(mode);
			}
		} else {
			stylesheet = (Map<String, Object>) Backend.get().rpc(mode, STYLESHEET_MEMBER_KEY).get(STYLESHEET_KEY);
			stylesheets.put(mode, stylesheet);
		}


		// Stylesheet extractions ----------------------------------------------
		defaultStyle = (Map<String, Object>) stylesheet.get(DEFAULT_STYLE_KEY);
		styles = (Map<String, Object>) stylesheet.get(STYLES_KEY);
	}

	
	
	////////////////////////////////////////////////////////////////////////////
	// Tokens management
	////////////////////////////////////////////////////////////////////////////
	
	private static final String TOKEN_TYPE_KEY = "type";
	private static final String WS_TOKEN_TYPE_NAME = "ws";
	
	@Override
	public IToken nextToken() {
		if (!this.tokensIterator.hasNext()) {
			return Token.EOF;
		}
		
		this.currentToken = this.tokensIterator.next();
		String type = (String) this.currentToken.get(TOKEN_TYPE_KEY);
		
		if (type.equals(WS_TOKEN_TYPE_NAME)) {
			return Token.WHITESPACE;
		}
		
		return new Token(this.getAttribute(type));
	}
	
	private static final String COLOR_KEY = "color";
	private static final String RED_KEY = "r";
	private static final String GREEN_KEY = "g";
	private static final String BLUE_KEY = "b";
	
	// TODO Caching?
	@SuppressWarnings("unchecked")
	private TextAttribute getAttribute(String type) {
  		Map<String, Object> style = (Map<String, Object>) this.styles.get(type);
		if (style == null) {
			style = this.defaultStyle;
		}

		Map<String, Object> rgb = (Map<String, Object>) style.get(COLOR_KEY);
		if (rgb == null) {
			rgb = (Map<String, Object>) defaultStyle.get(COLOR_KEY);
		}
		return new TextAttribute(new Color(
			Display.getCurrent(),
			((Number)rgb.get(RED_KEY)).intValue(),
			((Number)rgb.get(GREEN_KEY)).intValue(),
			((Number)rgb.get(BLUE_KEY)).intValue()
		));
	}

	private static final String START_KEY = "start";
	private static final String END_KEY = "end";
	
	// Locations ---------------------------------------------------------------
	
	@Override
	public int getTokenOffset() {
		return ((Number) currentToken.get(START_KEY)).intValue();
	}

	@Override
	public int getTokenLength() {
		return (((Number)currentToken.get(END_KEY)).intValue()) - this.getTokenOffset();
	}

}
