function serveApp() {
	return this.res.sendfile('public/index.html');
}

module.exports = [
	{
		type: 'rpc',
		modules: {
			// js: 'modes/js',
			// at: 'modes/at',
			// !!! Hack to avoid changing to much of the clients code, to be able to test with HTML instead of at for now
			at: 'modes/html'
		}
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
	},

	// Client-side application
	{
		url: '/app',
		handler: serveApp
	},
	// TODO Be able to serve automatically 'index.html' files when hitting a static location
	{
		url: '/',
		handler: serveApp
	}
];
