class Cache
	(input) ~>

		spec = switch typeof! input
		| 'Object' => input
		| _ => {}

		# compute --------------------------------------------------------------

		{compute, computecb, update, updatecb} = spec

		compute? ?= computecb
		update? ?= updatecb
		compute? ?= update

		if not compute? => throw {
			msg: 'Missing argument'
			name: <[ compute computecb update updatecb ]>
		}

		if typeof! compute isnt 'Function' => throw {
			msg: 'Wrong argument type'
			arg: 'compute'
			type: typeof! compute
			value: compute
		}

		@ <<< {compute}

		# obsolete -------------------------------------------------------------

		{obsolete, isObsolete} = spec

		obsolete? ?= isObsolete

		if not obsolete? => throw {
			msg: 'Missing argument'
			name: <[ obsolete isObsolete ]>
		}

		if typeof! obsolete isnt 'Function' => throw {
			msg: 'Wrong argument type'
			arg: 'obsolete'
			type: typeof! obsolete
			value: obsolete
		}

		@ <<< {obsolete}

		# internal -------------------------------------------------------------

		@_initiated = no


	store: ->
		value = @compute!
		@ <<< {value}
		@_initiated = yes
		value

	get: ->
		if @_initiated and not @obsolete! => @value
		else @store!

	check: (get) ->
		get ?= no

		result = if not @_initiated => {+obsolete}
		else if not @obsolete! => {-obsolete}
		else {+obsolete}

		if result.obsolete
			value = @store!
			if get => result <<< {value}

		result



exports <<< {
	Cache
}
