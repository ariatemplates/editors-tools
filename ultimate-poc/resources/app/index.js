var server, logger, routes, options;

server = require('std/server');

logger = require('./logger');
routes = require('./routes');
options = require('./options');

server(routes, options, logger);
