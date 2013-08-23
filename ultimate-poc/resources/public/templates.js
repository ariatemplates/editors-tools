define(function() {

// Templates definition --------------------------------------------------------

var templates = {
	element: '<{{tag}}{{#id}} id="{{id}}{{/id}}">{{text}}</{{tag}}>',

	message: '<div class="alert alert-{{type}} fade in" id="{{id}}-{{type}}"><button type="button" class="close" data-dismiss="alert">&times; close</button><span>{{text}}</span></div>',

	jumbotron: '<div class="jumbotron"><h1>{{header}}</h1><p>{{&content}}</p></div>',

	'page-header': '<div class="page-header"><h1>{{text}}{{#small}} <small>{{small}}</small>{{/small}}</h1></div>',

	action: '<div class="btn btn-large btn-{{type}}" {{#loading}}data-loading-text="{{loading}}"{{/loading}} {{#href}}href="#{{href}}" role="button" data-toggle="modal"{{/href}} {{#onclick}}onclick="{{onclick}}"{{/onclick}}>{{#icon}}<span class="glyphicon glyphicon-{{icon}}"></span> {{/icon}}{{label}}</div>',

	breadcrumb: '<ul class="col-lg-12 breadcrumb">{{#head}}<li><a>{{&label}}</a></li>{{/head}}{{#active}}<li class="active">{{&label}}</li>{{/active}}{{#tail}}<li><a>{{&label}}</a></li>{{/tail}}</ul>',

	dialog: '<div id="{{id}}" class="modal fade"><div class="modal-dialog"><div class="modal-content"><div class="modal-header"><h4 class="modal-title">{{title}}</h4><button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button></div><div class="modal-body"></div><div class="modal-footer"><button class="btn btn-primary" data-dismiss="modal" aria-hidden="true">{{closeLabel}}</button></div></div></div></div>',

	tab: '<li {{#active}}class="active"{{/active}} {{#disabled}}class="disabled"{{/disabled}}><a href="#tab-{{id}}" {{^disabled}}data-toggle="{{type}}"{{/disabled}}>{{label}}</a></li>',

	'tab-content': '<div id="tab-{{id}}" class="tab-pane fade {{#active}}active in{{/active}}"></div>'
}

// Templates compilation -------------------------------------------------------

for (var id in templates) {
	templates[id] = Hogan.compile(templates[id]);
}

// Templates rendering ---------------------------------------------------------

function render(template, input) {
	return templates[template].render(input);
}

return {
	render: render
}

});
