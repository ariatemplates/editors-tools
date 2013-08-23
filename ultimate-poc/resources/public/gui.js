define([
	'templates'
], function(
	Templates
) {

function alert(input) {
	var element = $(Templates.render('message', input));
	$('#messages-section').append(element);
	return element;
}

function addStyle(css, id) {
	var element = $('<style>', {id: id, text: css});
	$('head').append(element);
	return element;
}

function addAction(input) {
	input.type == null && (input.type = 'default');
	input.type = input.type.toLowerCase();

	var element = $(Templates.render('action', input));
	$('#sidebar-section').append(element);
	return element;
}

function addTab(input) {
	input.active == null && (input.active = false);
	input.disabled == null && (input.disabled = false);

	$('#' + input.tabbar + ' .nav').append(Templates.render('tab', input));
	$('#' + input.tabbar + ' .tab-content').append(Templates.render('tab-content', input));

	var content = $('#tab-content-' + input.id)[0];
	return $('#tab-' + input.id).append(content);
}

function addDialog(input) {
	var element = $(Templates.render('dialog', input));
	$('#dialogs-section').append(element);

	var content = $('#dialog-content-' + input.id)[0];
	$('#' + input.id + ' .modal-body').append(content);

	return element;
}

function setNodePath(input) {
	var element = $(Templates.render('breadcrumb', input));
	$('#breadcrumb-section').html(element);
	return element;
}

function jumbotron(input) {
	var element = $(Templates.render('jumbotron', input));
	$('#jumbotron-section').html(element);
	return element;
}

function pageHeader(input) {
	var element = $(Templates.render('page-header', input));
	$('#page-header-section').html(element);
	return element;
}

return {
	alert: alert,
	addStyle: addStyle,

	jumbotron: jumbotron,
	pageHeader: pageHeader,
	addAction: addAction,
	addTab: addTab,
	addDialog: addDialog,

	setNodePath: setNodePath
}

});
