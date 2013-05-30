# # requires harmony!!

# class Proxifier
# 	(@instance= {}) ~> return Proxy.create @



# 	# Object.getOwnPropertyDescriptor(proxy, name)
# 	getOwnPropertyDescriptor: (name) -> ...
# 		# PropertyDescriptor | undefined

# 	# Object.getPropertyDescriptor(proxy, name)
# 	# (not in ES5)
# 	getPropertyDescriptor: (name) -> ...
# 		# PropertyDescriptor | undefined

# 	# Object.getOwnPropertyNames(proxy)
# 	getOwnPropertyNames: -> ...
# 		# [ string ]

# 	# Object.getPropertyNames(proxy)
# 	# (not in ES5)
# 	getPropertyNames: -> ...
# 		# [ string ]

# 	# Object.defineProperty(proxy,name,pd)
# 	defineProperty: (name, propertyDescriptor) -> ...
# 		# any

# 	# delete proxy.name
# 	delete: (name) -> ...
# 		# boolean

# 	# Object.{freeze|seal|preventExtensions}(proxy)
# 	fix: -> void
# 		# { string: PropertyDescriptor } | undefined





# 	# name in proxy
# 	has: (name) -> ...
# 		# boolean

# 	# ({}).hasOwnProperty.call(proxy, name)
# 	hasOwn: (name) -> ...
# 		# boolean

# 	# receiver.name
# 	get: (receiver, name) -> ...
# 		# any

# 	# receiver.name = val
# 	set: (receiver, name, val) -> ...
# 		# boolean

# 	# for (name in proxy) (return array of enumerable own and inherited properties)
# 	enumerate: -> ...
# 		# [string]

# 	# Object.keys(proxy) (return array of enumerable own properties only)
# 	keys: -> ...
# 		# [string]


class Proxifier
	# @factory = (instance) -> Proxy.create new Proxifier instance
	(@instance = {}) ~> return Proxy.create @

	get: (proxy, name) -> if @instance[name]? => that else "UNDEFINED!"
	set: (proxy, name, value) -> @instance[name] = value
	has: (name) -> ...
	delete: (name) -> ...
	iterate: -> ...
	keys: -> ...
