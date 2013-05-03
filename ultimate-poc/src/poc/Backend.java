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
	// FIXME Don't make it hard-coded and absolute!
	// Use Eclipse preferences system
	// Otherwise use PATH
	// Otherwise use package node version, with a relative path
	private static final String launcherPath = "C:\\Documents and Settings\\ymeine\\Application Data\\npm\\node_modules\\LiveScript\\bin\\lsc";
	// FIXME Make it relative!
	private static final String programPath = "G:/dev/git/editors-tools/ultimate-poc/resources";
	
	
	
	private static Backend singleton = null;
	
	public static Backend get() {
		if (singleton == null) {
			singleton = new Backend();
		}
		return singleton;
	}
	
	
	
	private Process process = null;
	
	private DefaultHttpClient httpclient = null;
	private String domain = null;
	private HttpPost rpc = null;
	private HttpGet shutdown = null;
	
	private Gson gson = null;
	
	
	
	private Backend() {
		httpclient = new DefaultHttpClient();
		
		domain = "http://localhost:3000/";
		
		rpc = new HttpPost(domain + "rpc");
		rpc.setHeader("Content-Type", "application/json");
		
		shutdown = new HttpGet(domain + "shutdown");
		
		gson = new Gson();
	}
	
	public Boolean isRunning() {
		if (process == null) return false;
		try {
			process.exitValue();
			return false;
		} catch (IllegalThreadStateException e) {
			return true;
		}
	}
	
	public Process start() throws IOException {
		if (!isRunning()) {
			ProcessBuilder processBuilder = new ProcessBuilder(
					"node",
					"\"" + launcherPath + "\"",
					"server"
					);
			processBuilder.directory(new File(programPath));
			
			process = processBuilder.start();
		}
		
		return process;
	}
	
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
	
	public Map<String, Object> rpc(String module, String method, Object argument) throws IOException {
		Map<String, Object> object = new HashMap<String, Object>();
		object.put("module", module);
		object.put("method", method);
		object.put("argument", argument);
		
		String json = gson.toJson(object);
		
		StringEntity content = new StringEntity(json);
		rpc.setEntity(content);
		
		return postJson(rpc);
	}
	
	private String get(HttpGet request) throws IOException {
		HttpEntity entity = httpclient.execute(request).getEntity();
		String response = EntityUtils.toString(entity);
		return response;
	}
	
	// TODO Maybe return "primitive" types too? (not necessarily a key/value collection)
	@SuppressWarnings("unchecked")
	private Map<String, Object> postJson(HttpPost request) throws ParseException, IOException, JsonSyntaxException {
		HttpEntity entity = httpclient.execute(request).getEntity();
		String response = EntityUtils.toString(entity);

		Map<String, Object> result = new HashMap<String, Object>();
		result = gson.fromJson(response, result.getClass());
		return result;

	}
}
