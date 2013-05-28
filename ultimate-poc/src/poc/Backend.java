package poc;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.ParseException;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

public class Backend {
	
	////////////////////////////////////////////////////////////////////////////
	// Constants
	////////////////////////////////////////////////////////////////////////////
	
	// FIXME Don't make it hard-coded and absolute!
	// Use Eclipse preferences system
	// Otherwise use PATH
	// Otherwise use packaged node version, with a relative path
	private static final String launcherPath = "C:\\Documents and Settings\\ymeine\\Application Data\\npm\\node_modules\\LiveScript\\bin\\lsc";
	// FIXME Make it relative!
	private static final String programPath = "G:/dev/git/editors-tools/ultimate-poc/resources/app/";
	private static final String[] command = {
		"node",
		"\"" + launcherPath + "\"",
		"index"
	};
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// Singleton part
	////////////////////////////////////////////////////////////////////////////
	
	private static Backend singleton = null;
	
	/**
	 * Returns a singleton object, for convenience. Indeed, nothing prevents you from creating and managing your own instances.
	 * 
	 * @return A singleton.
	 */
	public static Backend get() {
		if (singleton == null) {
			singleton = new Backend();
		}
		return singleton;
	}
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// Backend class
	////////////////////////////////////////////////////////////////////////////
	
	private Process process = null;
	
	private DefaultHttpClient httpclient = null;
	private String domain = null;
	private HttpPost rpc = null;
	private HttpGet shutdown = null;
	private HttpGet ping = null;
	
	private Gson gson = null;
	
	////////////////////////////////////////////////////////////////////////////
	// Construction
	////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Builds a new backend instance.
	 */
	public Backend() {
		httpclient = new DefaultHttpClient();
		
		domain = "http://localhost:3000/";
		
		rpc = new HttpPost(domain + "rpc");
		rpc.setHeader("Content-Type", "application/json");
		
		shutdown = new HttpGet(domain + "shutdown");
		ping = new HttpGet(domain + "ping");
		
		gson = new Gson();
	}
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// Runtime
	////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Tells whether the backend is running or not.
	 * 
	 * @return true if the backedn is running, false otherwise.
	 */
	public Boolean isRunning() {
		if (process == null) return false;
		try {
			process.exitValue();
			return false;
		} catch (IllegalThreadStateException e) {
			return true;
		}
	}
	
	/**
	 * If not running, starts the backend.
	 * 
	 * @return the created Process instance behind 
	 */
	public Process start() throws IOException {
		if (!isRunning()) {
			ProcessBuilder processBuilder = new ProcessBuilder(command);
			processBuilder.directory(new File(programPath));
			
			process = processBuilder.start();
		}
		
		boolean started = false; 
		while (!started) {
			try {
				this.get(ping);
				started = true;
			} catch (IOException ex) {}
		}
		
		return process;
	}
	
	/**
	 * If running, stops the backend by sending a specific request, and ensures the process is stopped with process utilities.
	 * 
	 * @return If the backend properly stopped under the request, returns its response (see <code>get</code>), otherwise returns <code>null</code>.
	 * 
	 * @see get
	 * 
	 * @throws IOException
	 */
	public String stop() throws IOException {
		if (isRunning()) {
			String response = get(shutdown);
			process.destroy();
			process = null;
			return response;
		}
		process = null;
		return null;
	}
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// Communication
	////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Builds a JSON RPC request (compatible with the implementation of the backend) and executes it. 
	 * 
	 * @param module The name of the remote module
	 * @param member The name of the member to access inside the remote module
	 * @param argument If the member is expected to be a function, it will be called with the given argument
	 * 
	 * FIXME The backend should allow to pass a list of arguments, instead of forcing to use an object.
	 * TODO When the backend will implement fields aliasing, change the names of the field: mod, member, arg
	 * 
	 * @return The JSON result of the RPC.
	 * 
	 * @see postJson
	 * 
	 * @throws IOException
	 */
	public Map<String, Object> rpc(String module, String member, Object argument) throws IOException {
		Map<String, Object> object = new HashMap<String, Object>();
		object.put("module", module);
		object.put("method", member);
		object.put("argument", argument);
		
		String json = gson.toJson(object);
		
		StringEntity content = new StringEntity(json);
		rpc.setEntity(content);
		
		return postJson(rpc);
	}
	
	/**
	 * Sends the given HTTP Get request and returns the response content as a String.
	 * 
	 * @param request A HTTP Get request.
	 * 
	 * @return the response content as a string
	 * 
	 * @throws IOException
	 */
	private String get(HttpGet request) throws IOException {
		HttpEntity entity = httpclient.execute(request).getEntity();
		String response = EntityUtils.toString(entity);
		return response;
	}
	
	// TODO Maybe return "primitive" types too? (not necessarily a key/value collection)
	/**
	 * Sends the given HTTP Postrequest and returns the response content as a JSON object.
	 *  
	 * @param request A HTTP Post request.
	 * 
	 * @return the response content as a JSON object, that is a Map of Strings/Objects in the Java system.
	 * 
	 * @throws ParseException
	 * @throws IOException
	 * @throws JsonSyntaxException
	 */
	@SuppressWarnings("unchecked")
	private Map<String, Object> postJson(HttpPost request) throws ParseException, IOException, JsonSyntaxException {
		HttpEntity entity = httpclient.execute(request).getEntity();
		String response = EntityUtils.toString(entity);

		Map<String, Object> result = new HashMap<String, Object>();
		result = gson.fromJson(response, result.getClass());
		return result;

	}
}
