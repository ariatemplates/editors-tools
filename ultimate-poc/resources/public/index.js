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
	label: 'Edit',
	type: 'primary',
	href: 'edit'
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
