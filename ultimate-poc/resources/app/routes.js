function serveApp() {
	return this.res.sendfile('public/index.html');
}

module.exports = [
	// Standard routes ---------------------------------------------------------

	'shutdown',
	'ping',
	'info',

	// RPC ---------------------------------------------------------------------

	{
		type: 'rpc',
		modules: {
			'editor': require('modes/editor')
		}
	},


	// GUID identification pair ------------------------------------------------

	{
		url: '/80d007698d534c3d9355667f462af2b0',
		handler: function() {
			return this.send('e531ebf04fad4e17b890c0ac72789956');
		}
	},

	// Client-side application -------------------------------------------------
	// TODO Be able to serve automatically 'index.html' files when hitting a static location

	{
		url: '/app',
		handler: serveApp
	},

	{
		url: '/',
		handler: serveApp
	}
];
