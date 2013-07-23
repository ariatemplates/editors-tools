// Helpers ---------------------------------------------------------------------

/**
 * Calls HTML services.
 */
function rpc(method, argument) {
	var response = $.ajax({
		url: "rpc",
		async: false,
		type: "POST",
		contentType: "application/json",
		dataType: 'json',
		data: JSON.stringify({
			module: "html",
			method: method,
			argument: argument
		})
	});

	if (response.status === 200) {
		return JSON.parse(response.responseText);
	}

	console.log(response);
	var serverError = $("#server-error");
	serverError.find("#server-error-message").html(response.responseText);
	serverError.css("display", "");

	throw(response);
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

// Actions ---------------------------------------------------------------------

window.poc = {
	source: "<html></html>",

	ping: function() {
		var ping = $.ajax({
			url: "ping",
			async: false,
			type: "GET"
		});

		if (ping.status !== 200) {
			$("#server-access-error").css("display", "");
		} else {
			$("#server-success").css("display", "");
		}
	},

// Parsing & tree display ------------------------------------------------------

	parse: function() {
		// Input ---------------------------------------------------------------

		this.source = this.editor.getSession().getDocument().getValue();

		// Request -------------------------------------------------------------

		var library = "cytoscape";

		var ast = rpc("parse", {source: this.source});
		console.log(this.source);
		var viewData = rpc("graph", {source: this.source, options: {library: library}});

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
				nodes: viewData.nodes,
				edges: viewData.edges
			});
		}
	},

	clear: function() {
		this.editor.getSession().getDocument().setValue("<html></html>");
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

