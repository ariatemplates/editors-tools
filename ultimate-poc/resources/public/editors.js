define([], function() {

function createAceEditor(id, height) {
	var editorElmt = $("#" + id);
	var editorParent = editorElmt.parent();

	var css = {
		position: "absolute",
		top: editorParent.css("top"),
		bottom: editorParent.css("bottom"),
		left: editorParent.css("left"),
		right: editorParent.css("right")
	};

	if (height != null) {
		css.height = height;
	}

	editorElmt.css(css);

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

function createCMEditor(id) {
	var editorElmt = $("#" + id)[0];

	var editor = CodeMirror(editorElmt, {
		value: '<html></html>',
		mode: 'htmlmixed',
		theme: 'solarized',
		indentUnit: 4,
		smartIndent: true,
		tabSize: 4,
		indentWithTabs: true,
		electricChars: true,
		lineWrapping: false,
		lineNumbers: true,
		firstLineNumber: 1,
		fixedGutter: true,
		showCursorWhenSelecting: true
	});

	return editor;
}

return {
	createAceEditor: createAceEditor,
	createCMEditor: createCMEditor
}

});
