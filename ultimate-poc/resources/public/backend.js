define([
	'gui'
], function(
	GUI
) {

function ping() {
	return $.ajax({
		url: "ping",
		async: false,
		type: "GET"
	});
}

function guid() {
	return $.ajax({
		url: "80d007698d534c3d9355667f462af2b0",
		async: false,
		type: "GET"
	});
}

function shutdown() {
	return $.ajax({
		url: "shutdown",
		async: false,
		type: "GET"
	});
}

function rpc(module, method, argument) {
	var response = $.ajax({
		url: "rpc",
		async: false,
		type: "POST",
		contentType: "application/json",
		dataType: 'json',
		data: JSON.stringify({
			module: module,
			method: method,
			argument: argument
		})
	});

	if (response.status === 200) {
		if (response.responseText != "") {
			return JSON.parse(response.responseText);
		}
		return;
	}

	GUI.alert({
		type: 'danger',
		id: 'server',
		text: 'Server error: ' + response.responseText
	});

	throw(response);
}

function editor(method, argument) {
	return rpc("editor", method, argument);
}

function init(mode, source) {
	return editor("init", {
		mode: mode,
		source: source
	})
}

function service(doc, svc, arg) {
	var argument = {
		guid: doc.guid,
		svc: svc,
		arg: arg
	};

	if (arg != null) {
		argument.arg = arg;
	}

	return editor("exec", argument);
}

function updateAll(guid, source) {
	return service(guid, "update", {replace: true, source: source});
}

return {
	ping: ping,
	guid: guid,
	shutdown: shutdown,
	rpc: rpc,
	editor: editor,
	init: init,
	service: service,
	updateAll: updateAll
};

});
