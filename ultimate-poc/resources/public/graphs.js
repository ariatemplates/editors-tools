define(function() {

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
		}
	};

	cytoscape(options);
}

return {
	JIT: createJITGraph,
	cytoscape: createCytoscapeGraph
}

});
