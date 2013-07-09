module.exports = [
	{
		type: 'rpc',
		modules: [
			'modes/js',
			'modes/at',
			'modes/html'
		]
	},

	// Standard routes

	'shutdown',
	'ping',
	'info',

	// GUID identification pairs
	{
		url: '/80d007698d534c3d9355667f462af2b0',
		log: {
			pre: 'GUID identification'
		},
		handler: function() {
			return this.send('e531ebf04fad4e17b890c0ac72789956');
		}
	}
];
