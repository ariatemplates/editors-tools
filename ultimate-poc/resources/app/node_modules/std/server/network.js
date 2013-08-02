var portscanner = require('portscanner');
var oop = require('oop');





var PortsSpec = oop.Class({
	name: 'Ports specifications',

	schema: {
		properties: [
			{name: 'prefered', type: oop.types.Number, 'default': 3000},
			{name: 'min', type: oop.types.Number, 'default': 0},
			{name: 'max', type: oop.types.Number, 'default': 65535 /* 2^16 - 1 */}
		]
	}
});



/**
 * @todo Just return the port, don't use a callback
 * @todo Check validity of the hostname with a regexp or url module
 * @todo Externalize default values, in a conf file for instance
 */
var findAvailablePort = oop.methodFactory({
	input: {
		properties: [
			{names: ['hostname', 'host', 'ip'], type: oop.types.String, default: 'localhost'},
			{names: ['ports'], mixed: true, type: PortsSpec},
			{names: ['cb', 'fn'], type: oop.types.Function},
			{
				names: ['errorcb'], type: oop.types.Function,
				default: function() {
					return function() {
						console.log('No port found, exiting application...');
						return process.exit(1);
					};
				}
			}
		]
	},

	exec: function(spec) {
		if (spec.cb == null) {
			throw {
				msg: 'Missing argument',
				names: ['cb', 'fn']
			};
		}

		portscanner.checkPortStatus(spec.ports.prefered, spec.hostname, function(error, status) {
			if (status === 'closed') {
				spec.cb(spec.ports.prefered);
			} else {
				portscanner.findAPortNotInUse(
					spec.ports.min,
					spec.ports.max,
					spec.hostname,
					function(error, availableport) {
						if (error != null) {
							spec.errorcb(error);
						} else {
							spec.cb(availableport);
						}
					}
				);
			}
		});
	}
});





exports.findAvailablePort = exports.execOnAvailablePort = findAvailablePort;
