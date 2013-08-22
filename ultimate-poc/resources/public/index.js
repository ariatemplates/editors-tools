define([
	'backend',
	'actions',
	'gui'
], function(
	Backend,
	Actions,
	GUI
) {



GUI.jumbotron({
	header: 'Ultimate editor!',
	content: 'Try the features of the ultimate editor, which funnily doesn\'t have a frontend...'
});

GUI.pageHeader({
	text: 'Graph visualization',
	small: 'Parse and play'
});



// Actions ---------------------------------------------------------------------

GUI.addAction({
	label: 'Init',
	type: 'danger',
	onclick: 'poc.init()'
});

GUI.addAction({
	label: 'Parse',
	type: 'primary',
	loading: 'Parsing...',
	onclick: 'poc.parse()'
});

GUI.addAction({
	label: 'Highlight',
	type: 'primary',
	loading: 'Highlighting...',
	onclick: 'poc.highlight()'
});

GUI.addAction({
	label: 'Fold',
	type: 'primary',
	loading: 'Folding...',
	onclick: 'poc.fold()'
});

GUI.addAction({
	label: 'Update all',
	type: 'primary',
	loading: 'Updating...',
	onclick: 'poc.update()'
});

GUI.addAction({
	label: 'Clear',
	type: 'danger',
	onclick: 'poc.clear()'
});

GUI.addAction({
	label: 'Help',
	type: 'info',
	href: 'help'
});

GUI.addAction({
	label: 'Ping',
	onclick: 'poc.ping()'
});

GUI.addAction({
	label: 'Identify',
	onclick: 'poc.guid()'
});

GUI.addAction({
	label: 'Shutdown',
	type: 'danger',
	onclick: 'poc.shutdown()'
});

// Graph -----------------------------------------------------------------------

GUI.setNodePath({
	head: [
		{label: 'path'},
		{label: 'to'}
	],
	active: {label: 'node'}
});

// Editor creation -------------------------------------------------------------

function createEditor(id) {
	var editorElmt = $("#" + id);
	var editorParent = editorElmt.parent();

	editorElmt.css({
		position: "absolute",
		top: editorParent.css("top"),
		bottom: editorParent.css("bottom"),
		left: editorParent.css("left"),
		right: editorParent.css("right")
	});

	var editor = ace.edit(id);
	editor.setTheme("ace/theme/monokai");
	editor.getSession().setMode("ace/mode/html");
	editor.setHighlightActiveLine(true);
	editor.setHighlightGutterLine(true);
	editor.setHighlightSelectedWord(true);
	editor.setPrintMarginColumn(80);
	editor.setShowPrintMargin(true);
	editor.setShowInvisibles(true);
	editor.setWrapBehavioursEnabled(false);

	return editor;
}

var editor = poc.editor = createEditor('editor');

editor.on('blur', poc.update.bind(poc));
editor.on('change', poc.preview.bind(poc));

// Initialization --------------------------------------------------------------

Actions.ping();
Actions.init();

// Parsing progress bar --------------------------------------------------------

// var el = $("#parsing-progress");
// console.log(el);
// el.animate({
// 	"width": "100%"
// }, {
// 	duration: 1000,
// 	easing: 'linear'
// });


});
