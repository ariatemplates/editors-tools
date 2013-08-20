define([
	'backend',
	'gui',
	'graphs'
], function(
	Backend,
	GUI,
	Graphs
) {

var initialSource = '<html></html>';

function JSONToHTML(json) {
	return hljs.highlight('json', JSON.stringify(json, null, 4)).value;
}

serverAccessErrorAlert = {
	type: 'danger',
	id: 'server-access',
	text: 'Oops! Server is not responding...'
}

var poc = {
	ping: function() {
		var res = Backend.ping();

		if (res.status != 200) {
			GUI.alert(serverAccessErrorAlert);
		} else {
			GUI.alert({
				type: 'success',
				id: 'server-access',
				text: 'Congrats! Server responding.'
			});
		}
	},

	guid: function() {
		var res = Backend.guid();

		if (res.status != 200) {
			GUI.alert(serverAccessErrorAlert);
		} else {
			if (res.responseText != "e531ebf04fad4e17b890c0ac72789956") {
				GUI.alert({
					type: 'danger',
					id: 'server-guid',
					text: 'Server identification error'
				});
			} else {
				GUI.alert({
					type: 'success',
					id: 'server-guid',
					text: 'Congrats! Server identified properly.'
				});
			}
		}
	},

	shutdown: function() {
		var res = Backend.shutdown();

		if (res.status != 200) {
			GUI.alert({
				type: 'danger',
				id: 'server-shutdown',
				text: 'Error while trying to shut down server! Please do it manually...'
			});
		} else {
			GUI.alert({
				type: 'success',
				id: 'server-shutdown',
				text: 'Congrats! Server shut down properly.'
			});
		}
	},

// Parsing & tree display ------------------------------------------------------

	source: initialSource,

	init: function() {
		poc.doc = Backend.init('html', poc.source);

		GUI.alert({
			type: 'info',
			id: 'document-init',
			text: 'New document created!'
		});

		this.clear();
	},

	update: function() {
		this.source = this.editor.getSession().getDocument().getValue();
		Backend.updateAll(poc.doc, this.source);

		this.parse();
		this.highlight();
		this.fold();
	},

	clear: function() {
		this.editor.getSession().getDocument().setValue(initialSource);

		this.update();
	},

	parse: function() {
		// Request -------------------------------------------------------------

		var library = "cytoscape";

		var ast = Backend.service(poc.doc, "parse");
		var viewData = Backend.service(poc.doc, "graph", {library: library});

		// Output --------------------------------------------------------------

		window.ast = ast;
		window.viewData = viewData;

		$("#ast-content").html(JSONToHTML(ast));

		$("#total-nodes").text(viewData.nodes);
		$("#total-leaves").text(viewData.leaves);

		var container = "graph-display";

		if (library === "jit") {
			Graphs.JIT(container, {
				leaves: 2,
				nodes: 3,
				json: {
					id: "0",
					name: "0",
					children: [
						{
							id: "0.0",
							name: "0.0",
							adjacencies: []
						},
						{
							id: "0.1",
							name: "0.1",
							adjacencies: []
						}
					]
				}
			});
		} else if (library === "cytoscape") {
			Graphs.cytoscape(container, {
				nodes: viewData.graph.nodes,
				edges: viewData.graph.edges
			});
		}
	},

	highlight: function() {
		var ranges = Backend.service(poc.doc, "highlight");
		console.log(ranges);

		var html = Backend.service(poc.doc, "html");
		var css = Backend.service(poc.doc, "css");

		$('#highlight-stylesheet').html(css);
		$('#highlight-content').html(html);

		$('#highlighting-data-content').html(JSONToHTML(ranges));
	},

	fold: function() {
		var ranges = Backend.service(poc.doc, "fold");

		$('#folding-data-content').html(JSONToHTML(ranges));
	}
};

window.poc = poc;
return poc;

});
