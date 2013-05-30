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
	
	private static final String inputGUID = "80d007698d534c3d9355667f462af2b0";
	private static final String outputGUID = "e531ebf04fad4e17b890c0ac72789956";
	
	private static final int pollingSleepTime = 50; // ms
	private static final int pollingTimeOut = 1000; // ms
	
	
	
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
	
	private Boolean isManagedExternally = null;
	
	private Process process = null;
	
	private DefaultHttpClient httpclient = null;
	private String domain = null;
	private HttpPost rpc = null;
	private HttpGet shutdown = null;
	private HttpGet ping = null;
	private HttpGet guid = null;
	
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
		guid = new HttpGet(domain + inputGUID);
		
		gson = new Gson();
	}
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// Runtime
	////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Tells whether the backend is running or not.
	 * 
	 * @return true if the backend is running, false otherwise.
	 * @throws IOException 
	 */
	public Boolean isRunning() throws IOException {
		// We don't know if it is an external process or not yet
		if (this.isManagedExternally == null) {
			try {
				if (this.get(guid).equals(outputGUID)) {
					this.isManagedExternally = true;
					return true;
				}
			} catch (IOException exception) {
				this.isManagedExternally = false;
			}
		} 
		
		// Externally managed
		if (this.isManagedExternally) {
			// TODO Maybe we could use the ping, but this method is safer to ensure the server has not been replaced.
			return this.get(guid) == outputGUID;
		}
		
		// We manage the process ourself
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
	 * @throws InterruptedException 
	 */
	public Process start() throws IOException, InterruptedException {
		if (!isRunning()) {
			ProcessBuilder processBuilder = new ProcessBuilder(command);
			processBuilder.directory(new File(programPath));
			
			process = processBuilder.start();

			// Polling to check the backend is fully set up
			boolean started = false; 
			int time = 0; 
			while (!started && time < pollingTimeOut) {
				try {
					this.get(ping);
					started = true;
				} catch (IOException ex) {
					Thread.sleep(pollingSleepTime);
					time += pollingSleepTime;
				}
			}
		}
		
		return process;
	}
	
	/**
	 * If we manage the backend process ourself and it is running, stops it by sending a specific request, and ensures the process is stopped with process utilities.
	 * 
	 * @return If the backend properly stopped under the request, returns its response (see <code>get</code>), otherwise returns <code>null</code>.
	 * 
	 * @see isRunning
	 * @see get
	 * 
	 * @throws IOException
	 */
	public String stop() throws IOException {
		if (!this.isManagedExternally) {
			String response = null;
			if (isRunning()) {
				response = get(shutdown);
				process.destroy();
			}
			process = null;
			return response;
		} else {
			return null;
		}
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
	
	public Map<String, Object> rpc(String module, String member) throws IOException {
		return this.rpc(module, member, null);
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
