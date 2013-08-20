define([
	'templates'
], function(
	Templates
) {

function alert(input) {
	var content = Templates.render('message', input);
	return $('#messages-section').append(content);
}

function addStyle(css, id) {
	var idAttr = '';
	if (id != null) {
		idAttr = ' id="highlight-stylesheet"'
	}
	return $('head').append('<style' + idAttr + '>' + css + '</style>');
}

function addAction(input) {
	if (input.type == null) {
		input.type = 'default';
	}
	input.type = input.type.toLowerCase();

	return $('#sidebar-section').append(Templates.render('action', input));
}

function setNodePath(input) {
	return $('#breadcrumb-section').html(Templates.render('breadcrumb', input));
}

function jumbotron(input) {
	return $('#jumbotron-section').html(Templates.render('jumbotron', input));
}

function pageHeader(input) {
	return $('#page-header-section').html(Templates.render('page-header', input));
}

return {
	alert: alert,
	addStyle: addStyle,

	jumbotron: jumbotron,
	pageHeader: pageHeader,
	addAction: addAction,

	setNodePath: setNodePath
}

});
