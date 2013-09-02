var server, logger, routes, options;

server = require('http-server');

logger = require('./logger');
routes = require('./routes');
options = require('./options');

server.run(routes, options, logger);
