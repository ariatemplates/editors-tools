package poc;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
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
	// Constants - to be configured
	////////////////////////////////////////////////////////////////////////////

	// FIXME Don't make it hard-coded and absolute!
	// Use Eclipse preferences system
	// Otherwise use PATH
	// Otherwise use packaged node version, with a relative path

	//private static final String launcherPath = ".\\node_modules\\LiveScript\\bin\\lsc";
	private static final String launcherPath = "C:\\Documents and Settings\\ymeine\\Application Data\\npm\\node_modules\\LiveScript\\bin\\lsc";

	// FIXME Make it relative!
	//private static final String programPath = "./app/";
	private static final String programPath = "G:/dev/git/editors-tools/ultimate-poc/resources/app/";
	private static final String[] command = {
		"node",
		"\"" + launcherPath + "\"",
		"index"
		//"\"" + programPath + "index" + "\""
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
		if (Backend.singleton == null) {Backend.singleton = new Backend();}
		return Backend.singleton;
	}



	////////////////////////////////////////////////////////////////////////////
	// Backend class
	////////////////////////////////////////////////////////////////////////////

	private Boolean isManagedExternally = null;

	private Process process = null;

	private DefaultHttpClient httpclient = null;
	private HttpPost rpc = null;
	private HttpGet shutdown = null;
	private HttpGet ping = null;
	private HttpGet guid = null;

	private Gson gson = null;

	////////////////////////////////////////////////////////////////////////////
	// Construction
	////////////////////////////////////////////////////////////////////////////

	private static final String DOMAIN = "http://localhost:3000/";

	private static final String RPC_PATH = "rpc";
	private static final String SHUTDOWN_PATH = "shutdown";
	private static final String PING_PATH = "ping";

	/**
	 * Builds a new backend instance.
	 */
	public Backend() {
		this.httpclient = new DefaultHttpClient();

		this.rpc = new HttpPost(Backend.DOMAIN + Backend.RPC_PATH);
		this.rpc.setHeader("Content-Type", "application/json");

		this.shutdown = new HttpGet(Backend.DOMAIN + Backend.SHUTDOWN_PATH);
		this.ping = new HttpGet(Backend.DOMAIN + Backend.PING_PATH);
		this.guid = new HttpGet(Backend.DOMAIN + Backend.INPUT_GUID);

		this.gson = new Gson();
	}



	////////////////////////////////////////////////////////////////////////////
	// Runtime
	////////////////////////////////////////////////////////////////////////////

	private static final String INPUT_GUID = "80d007698d534c3d9355667f462af2b0";
	private static final String OUTPUT_GUID = "e531ebf04fad4e17b890c0ac72789956";

	private static final int POLLING_SLEEP_TIME = 50; // ms
	private static final int POLLING_TIME_OUT = 1000; // ms

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
				if (this.get(guid).equals(Backend.OUTPUT_GUID)) {
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
			return this.get(guid) == Backend.OUTPUT_GUID;
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
	 */
	public Process start() throws IOException, InterruptedException {
		if (!isRunning()) {
			// Launches the process
			ProcessBuilder processBuilder = new ProcessBuilder(command);
			processBuilder.directory(new File(programPath));
			this.process = processBuilder.start();

			// Polling to check the backend is fully set up
			boolean started = false;
			int time = 0;
			while (!started && (time < Backend.POLLING_TIME_OUT)) {
				try {
					this.get(this.ping);
					started = true;
				} catch (IOException ex) {
					Thread.sleep(Backend.POLLING_SLEEP_TIME);
					time += Backend.POLLING_SLEEP_TIME;
				}
			}
		}

		return this.process;
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
		String response = null;

		if (!this.isManagedExternally && this.isRunning()) {
			response = this.get(this.shutdown);
			this.process.destroy();
			this.process = null;
		}

		return response;
	}



	////////////////////////////////////////////////////////////////////////////
	// Communication
	////////////////////////////////////////////////////////////////////////////

	private static final String MODE_MANAGER_MODULE_NAME = "mode";

	private static final String GUID_KEY = "guid";

	/**
	 * To be used in the future, for every RPC related to a mode. This enforces the use of a session key.
	 */
	public Map<String, Object> call(String guid, String member, Map<String, Object> argument) throws ParseException, IOException, JsonSyntaxException {
		argument.put(Backend.GUID_KEY, guid);
		return this.rpc(Backend.MODE_MANAGER_MODULE_NAME, member);
	}



	private static final String MODULE_KEY = "module";
	private static final String MEMBER_KEY = "method";
	private static final String ARGUMENT_KEY = "argument";

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
	public Map<String, Object> rpc(String module, String member, Object argument) throws ParseException, IOException, JsonSyntaxException {
		Map<String, Object> object = new HashMap<String, Object>();
		object.put(Backend.MODULE_KEY, module);
		object.put(Backend.MEMBER_KEY, member);
		object.put(Backend.ARGUMENT_KEY, argument);

		String json = gson.toJson(object);

		StringEntity content = new StringEntity(json);
		this.rpc.setEntity(content);

		return this.postJson(this.rpc);
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
		HttpResponse response = httpclient.execute(request);
		//response.getStatusLine()
		HttpEntity entity = response.getEntity();
		String content = EntityUtils.toString(entity);

		Map<String, Object> result = new HashMap<String, Object>();
		result = gson.fromJson(content, result.getClass());
		return result;
	}
}
