define(function() {

// Templates definition --------------------------------------------------------

var templates = {
	message: '<div class="alert alert-{{type}} fade in" id="{{id}}-{{type}}"><button type="button" class="close" data-dismiss="alert">&times; close</button><span>{{text}}</span></div>',

	jumbotron: '<div class="jumbotron"><h1>{{header}}</h1><p>{{&content}}</p></div>',

	'page-header': '<div class="page-header"><h1>{{text}}{{#small}} <small>{{small}}</small>{{/small}}</h1></div>',

	action: '<div class="row"><div class="col-lg-12 btn btn-large btn-block btn-{{type}}" {{#loading}}data-loading-text="{{loading}}"{{/loading}} {{#href}}href="#{{href}}" role="button" data-toggle="modal"{{/href}} {{#onclick}}onclick="{{onclick}}"{{/onclick}}>{{label}}</div></div>',

	breadcrumb: '<ul class="col-lg-12 breadcrumb">{{#head}}<li><a>{{&label}}</a></li>{{/head}}{{#active}}<li class="active">{{&label}}</li>{{/active}}{{#tail}}<li><a>{{&label}}</a></li>{{/tail}}</ul>'
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
