var winston = require('winston');

module.exports = new winston.Logger({
	transports: [
		new winston.transports.Console({
			colorize: true,
			silent: false,
			timestamp: false
		}),
		new winston.transports.File({
			filename: 'log.log',
			colorize: false,
			timestamp: true,
			json: false
		})
	]
});
