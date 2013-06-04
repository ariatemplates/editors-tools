/**
 * Behaves like a simple store of data with auto-generated key.
 *
 * @todo Be able when initiated a session to pass a callback to init data. Or just pass initial data.
 */
class SessionManager
	~>
		@ <<< {
			sessions: {}
			sessionId: 0
		}


	init: (data) ->
		id = @_generateId data
		@sessions[id] = data
		id

	_generateId: (data) ->
		while @sessionId of @sessions => @sessionId++
		@sessionId


	update: (id, data) -> @sessions[id] = data
	get: (id) -> @sessions[id]


exports <<< {
	SessionManager
}
