// Helpers ---------------------------------------------------------------------

var Backend = {
	ping: function ping() {
		return $.ajax({
			url: "ping",
			async: false,
			type: "GET"
		});
	},

	rpc: function rpc(module, method, argument) {
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

		console.log(response);
		var serverError = $("#server-error");
		serverError.find("#server-error-message").html(response.responseText);
		serverError.css("display", "");

		throw(response);
	},

	editor: function editor(method, argument) {
		return Backend.rpc("editor", method, argument);
	},

	init: function init(mode, source) {
		return Backend.editor("init", {
			mode: mode,
			source: source
		})
	},

	service: function service(doc, svc, arg) {
		var argument = {
			guid: doc.guid,
			svc: svc,
			arg: arg
		};

		if (arg != null) {
			argument.arg = arg;
		}

		return Backend.editor("exec", argument);
	},

	updateAll: function updateAll(guid, source) {
		return Backend.service(guid, "update", {replace: true, source: source});
	}
}






function createJITGraph(container, data) {
	var view = new $jit.ST({
		injectInto: container,
		w: 500,
		h: 500,

		duration: 500,
		levelDistance: 50,

		Navigation: {
			enable: true,
			panning: true
		},

		Node: {
			height: 20,
			width: 60,
			type: "rectangle",
			color: "#aaa",
			overridable: true
		},

		Edge: {
			type: "bezier",
			overridable: true
		},

		onCreateLabel: function(label, node){
			label.id = node.id;
			label.innerHTML = node.name;

			// label.onclick = function() {
			// 	if(normal.checked) {
			// 		st.onClick(node.id);
			// 	} else {
			// 		st.setRoot(node.id, 'animate');
			// 	}
			// };

			//set label styles
			var style = label.style;
			style.width = 60 + 'px';
			style.height = 17 + 'px';
			style.cursor = 'pointer';
			style.color = '#333';
			style.fontSize = '0.8em';
			style.textAlign= 'center';
			style.paddingTop = '3px';
		},
	});

	view.loadJSON(viewData.json);
	view.compute();
	view.geom.translate(new $jit.Complex(-200, 0), "current");
	view.onClick(view.root);
}

function createCytoscapeGraph(container, data) {
	var options = {
		showOverlay: false,
		layout: {
			name: 'breadthfirst',
			fit: true,
			directed: true,
			circle: false,
		},
		zoom: 1,
		style: cytoscape.stylesheet().selector('node').css({
			'content': 'data(name)',
			'font-family': 'helvetica',
			'font-size': 14,
			'text-outline-width': 3,
			'text-outline-color': '#888',
			'text-valign': 'center',
			'color': '#fff',
			'border-color': '#fff',
			'shape': 'rectangle'
		}),
		elements: data,

		container: document.getElementById(container),

		ready: function() {
			console.log("Cytoscape ready");
		}
	};

	cytoscape(options);
}

// Globals ---------------------------------------------------------------------

var initialSource = "<html></html>";

var doc = Backend.init('html', initialSource);


// Actions ---------------------------------------------------------------------

window.poc = {
	source: initialSource,

	ping: function() {
		var res = Backend.ping();

		if (res.status !== 200) {
			$("#server-access-error").css("display", "");
		} else {
			$("#server-success").css("display", "");
		}
	},

// Parsing & tree display ------------------------------------------------------

	parse: function() {
		// Input ---------------------------------------------------------------

		this.source = this.editor.getSession().getDocument().getValue();
		Backend.updateAll(doc, this.source)

		// Request -------------------------------------------------------------

		var library = "cytoscape";

		var ast = Backend.service(doc, "parse");
		console.log(this.source);
		var viewData = Backend.service(doc, "graph", {library: library});

		// Output --------------------------------------------------------------

		window.ast = ast;
		window.viewData = viewData;

		// $("#total-nodes").text(ast.flatten().length);
		// $("#total-leaves").text(ast.leaves().length);
		$("#total-nodes").text(viewData.nodes.length);
		$("#total-leaves").text(viewData.leaves);

		var container = "graph-display";

		if (library === "jit") {
			createJITGraph(container, {
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
			createCytoscapeGraph(container, {
				nodes: viewData.graph.nodes,
				edges: viewData.graph.edges
			});
		}
	},

	clear: function() {
		this.editor.getSession().getDocument().setValue(initialSource);
	},


};

// Editor creation -------------------------------------------------------------

var editorElmt = $("#editor");
var editorParent = editorElmt.parent();

$("#editor").css({
	position: "absolute",
	top: editorParent.css("top"),
	bottom: editorParent.css("bottom"),
	left: editorParent.css("left"),
	right: editorParent.css("right")
});

var editor = poc.editor = ace.edit("editor");
editor.setTheme("ace/theme/monokai");
editor.getSession().setMode("ace/mode/html");

// Initialization --------------------------------------------------------------

poc.ping();
poc.clear();
poc.parse();


// Parsing progress bar --------------------------------------------------------

// var el = $("#parsing-progress");
// console.log(el);
// el.animate({
// 	"width": "100%"
// }, {
// 	duration: 1000,
// 	easing: 'linear'
// });

