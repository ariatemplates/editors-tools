require('LiveScript');

var zappa = require('zappajs');

var Server = require('./server').Server;



module.exports = function(routes, options, logger) {
	return Server({
		system: zappa,
		routes: routes,
		options: options
	}, logger).run();
};
