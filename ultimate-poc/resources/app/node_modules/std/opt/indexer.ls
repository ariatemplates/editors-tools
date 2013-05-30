require! {
# -------------------------------------------------------------------------- 3rd
	_: lodash
# ---------------------------------------------------------------------- Own Std
	'std/array'
	'std/type'
}





/**
 * Indexes values of the same type schema, with custom index schema: keys and ways to get corresponding values are custom.
 *
 * Keys must be stringifiable, standard JavaScript object objects are used.
 *
 * @todo Implement suspend and resume, multi-threading and state
 * @todo Implement a 'checkAndFix' function, to see if all values are still indide proper entries in indexes (in case their values changed). This check could also be done as warning/error, skipping, etc. of the value when trying to get it
 */
class MemoryIndexer
	/**
	 * With an instance of this indexer, you can create multiple indexes for a same schema.
	 *
	 * An index has the following properties:
	 * - a name; usually, it's the name of the property used to index the values
	 * - a provider, that is a way to access the value(s) determining the entry(ies) under which the value will go.
	 *
	 * An accesser has the following format:
	 * - getter: the function used to get the entry(ies)
	 * - multiple: a flag telling whether the getter returns a single entry or an array
	 *
	 * However, for convenience, you can use a simple string as input, in which case a getter will be created, using this string has a single property access.
	 *
	 * You can also directly give a function, which will be used as the getter.

	 * In any case, the multiple flag is false by default.
	 *
	 * @todo Be able to give a path too (see ralation with graphs ;) ), with an array to access nested properties. But for now, the LiveScript language make it simpler to use this system as it is now.
	 *
	 * @param[in] {Object>Strings:Function|String|Object} Indexes/providers.
	 */
	(indexes) ~>
		@indexesSpecs = {}
		@indexes = {}
		for name, input of indexes => @addIndex name, input

	/** Creates empty indexes */
	clear: -> @indexes = {[name, {}] for name of @indexesSpecs}

	addIndex: (name, input) ->
		if @indexesSpecs.name? => throw {
			msg: 'Trying to override an existing index'
			name
		}

		output = {}

		# Factory --------------------------------------------------------------

		spec = switch typeof! input
		| 'Object' => input
		| _ => {getter: input}

		# getter ---------------------------------------------------------------

		{getter} = spec

		getter = switch typeof! getter
		| 'Function' => getter
		| 'String'
			let str = getter => (.[str])
		| _
			let key = name => (.[key])

		if not type.isFn getter => throw 'Error'

		output <<< {getter}

		# multiple -------------------------------------------------------------

		{multiple, array} = spec

		multiple? ?= array

		multiple ?= off

		output <<< {multiple}

		# Result ---------------------------------------------------------------

		@indexesSpecs[name] = output
		@indexes[name] = {}

		# # array ----------------------------------------------------------------
		# # FIXME Weird design
		# # TODO Just keep the array property, which will be the handler holder
		# # It can be a boolean, in which case, if it's true the handler is inferred, if it's false the property is dropped
		# # It can be a string, as for the usual getter
		# # It can be a handler directly
		# # OTHERWISE Use a type property, and then different kind of import
		# # (using a type instead of a boolean seems more natural, no name conflict, ...)
		# # OTHERWISE Infer the type on the presence and validity of some parameters, as done above, where the boolean value just tells: 'the property is present', cos you want inferrence in this case.
		# # But with the addition of other method of provding, it becomes more natural to have a type property, at least for determinism

		# {array} = spec

		# array ?= no

		# # array getter ---------------------------------------------------------
		# # FIXME Weird design
		# # We could also stick to the unique "entriesProvider".
		# # Along with the name of the index, provide an entriesProvider.
		# # By default it would be a handler returning a unique entry.
		# # If a multiple or array flag is passed too, this would be returning an array

		# # Keep the concept of extraction description for future data management

		# {arrayGetter} = spec

		# arrayGetter? ?= switch typeof! array
		# | 'Boolean' => if array
		# 	let key = name => (.[key])
		# | 'Function'
		# 	fn = array
		# 	array = yes
		# 	fn

		# # FIXME Weird dependencies for checkings
		# if array and not type.isFn arrayGetter => throw 'Error'
		# if not type.isBool array => array = arrayGetter?

		# output <<< {array}
		# output.arrayGetter? = arrayGetter



	/**
	 * @fixme Maybe remove it completely, it's just calling the update with multiple values...
	 */
	# build: (array = []) ->
	# 	# FIXME Handle array indexes too
	# 	result = {}
	# 	for field, handler of @indexesSpecs
	# 		if not handler.array
	# 			try result[field] = _.groupBy array, handler.getter
	# 			catch exception => throw {
	# 				msg: 'A field cannot be accessed for a value in the array'
	# 				array
	# 				field
	# 				exception
	# 			}
	# 		else
	# 			continue
	# 			...
	# 			# No way to do a groupBy, so building would just use update...
	# 			for value in array
	# 				pool = handler.arrayGetter value
	# 	@indexes = result

	# 	# Create empty missing indexes
	# 	for field of @indexesSpecs => @indexes[field] ?= {}



	@actions = <[ add remove fix ]>

	update-pre-process: (action, value) ->
		# ---------------------------------------------------------------- value

		if not value? => throw {
			msg: 'The given value is undefined'
		}

		# --------------------------------------------------------------- action

		unsupported-action = -> throw {
			msg: 'Unsupported action type'
			input: action
			alternatives: @@actions
		}

		if action not in @@actions => unsupported-action!

		# Return ---------------------------------------------------------------

		{action, value}

	/*
	 *
	 * @todo See implementation in node.ls (addNode, remove), for childrenIndex. Take alternative implementations, with array removal and so on
	 */
	update-execute: (action, value) ->
		switch action
		| 'add' => for indexName, provider of @indexesSpecs
			index = @indexes[indexName]
			# entryHolders = if provider.array => provider.arrayGetter(value) ? [] else [value]

			# for entryHolder in entryHolders => index.[][provider.getter entryHolder].push value
			# The getter can fail in case it can't get the entries, if some properties are optional inside the value for instance. Later on, this could use type specifications to heck more thoroughly all of that...
			try
				entries = provider.getter value
				if not provider.multiple => entries = [entries]

				for entry in entries => index.[][entry].push value
			catch e

		| 'remove' => for indexName, provider of @indexesSpecs
			index = @indexes[indexName]
			# entryHolders = if provider.array => provider.arrayGetter(value) ? [] else [value]

			try
				entries = provider.getter value
				if not provider.multiple => entries = [entries]

				for entryKey in entries
				# for entryHolder in entryHolders
					# entryKey = provider.getter entryHolder
					entry = index[entryKey]
					if entry?
						array.remove entry, value
						if entry.length is 0 => delete index[entryKey]
			catch e

		| 'fix' => @remove value; @add value
		# TODO Instead of simply removing then adding, do a smarter algorithm
		# In this algorithm, we can check if values used for indexing have changed. Even if this should be one level up, by the client of the indexer, which should now too when to update trhe index or not depending on the values he indexes with, so that he can avoid unnecessary calls.
		| _ => unsupported-action!

		# IMPLEMENTATION of array switching in case of addition (from node.ls)
		# presentValue = @childrenIndex[node.id.value]
		# if presentValue?
		# 	if type.isArray that # Already 2 present, or 1
		# 		@childrenIndex[node.id.value].push node
		# 	else # Only 1 was present
		# 		@childrenIndex[node.id.value] = [presentValue, node]
		# else
		# 	@childrenIndex[node.id.value] = node

		# IMPLEMENTATION of array switching in case of removal (from node.ls)
		# id = node.id.value
		# if @childrenIndex[id]?
		# 	if type.isArray that
		# 		array.remove that, node
		# 		if that.length is 1 => @childrenIndex[id] = that.0
		# 	else delete @childrenIndex[id]
		# else console.log 'This node was not present'

	# --------------------------------------------------------------------------
	# FIXME Clean the above!!! -------------------------------------------------
	# --------------------------------------------------------------------------

	/**
	 * Updates the indexes with the action made with the given value.
	 *
	 * @param[in] action `add`, `remove` or `fix`
	 *
	 * @see @@actions
	 */
	update: (action, value) -->
		{action, value} = @update-pre-process action, value
		@update-execute action, value

	/** Update the indexes with the added value. */
	add: ::update 'add'
	/** Update the indexes from the removed value. */
	remove: ::update 'remove'
	/** Update the indexes for an object already present but modified */
	fix: ::update 'fix'


	/**
	 * Queries a value from the specified index and the given index entry.
	 *
	 * IMPORTANT: for now, the implementation only uses the first key/property pair of the object!
	 *
	 * @param[in] query {Object>String:Any} The query object
	 *
	 * @todo handle queries with multiple keys
	 */
	get: (query, first = yes) ->
		index = _.keys query .0
		entry = query[index]

		values = @indexes[index][entry]
		if not values? or values.length is 0 => return void
		if first => return values.0
		return values





exports <<< {
	MemoryIndexer
}
