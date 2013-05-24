require! {
# -------------------------------------------------------------------------- 3rd
	winston
}



logger = new winston.Logger {
	transports: [
		new winston.transports.Console {
			+colorize
			-silent
			-timestamp
		}
		new winston.transports.File {
			filename: 'log.log'
			-colorize
			+timestamp
			-json
		}
	]
}





module.exports = logger
