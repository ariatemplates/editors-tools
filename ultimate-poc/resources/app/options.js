module.exports = {
	log: true,
	network: {
		hostname: 'localhost',
		ports: {
			prefered: 3000,
			min: 49152,
			max: 65535
		}
	},
	encoding: 'utf-8',
	statics: {
		// Remember precedence is important! For resolution in case of conflicting names: first found used.
		relative: [
			'public/lib',
			'public/bower_components'
		]
	}
};
