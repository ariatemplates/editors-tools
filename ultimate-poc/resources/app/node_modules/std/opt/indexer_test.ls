require! {
# -------------------------------------------------------------------------- App
	'std/test/logger'
# ------------------------------------------------------------------------ Input
	'./indexer'
}
# ------------------------------------------------------------------ Extractions
{Logger} = logger
{MemoryIndexer} = indexer





$logger = Logger!
logFunctions = -> $logger.overrides = {
	'getter': (.toString!)
	'arrayGetter': (.toString!)
}
hideFunctions = -> $logger.overrides = {
	'getter': -> '[Function]'
	'arrayGetter': -> '[Function]'
}




# ------------------------------------------------------------------------------

$logger.separator 'Construction'
# $logger.on!
logFunctions!

$logger.log MemoryIndexer!
$logger.log MemoryIndexer {'id'}
$logger.log MemoryIndexer {'id': 'value'}
$logger.log MemoryIndexer {'id': (.id.value), aliases: {+array}}
indexer = MemoryIndexer {'id': (.id.value), 'aliases': {+multiple, getter: -> [i.value for i in it.aliases]}}
$logger.log indexer

hideFunctions!


# ------------------------------------------------------------------------------
# FIXME Remove that!!

# $logger.separator 'Building: simple entry'
# # $logger.on!

# indexer.build!
# $logger.log indexer.indexes

# indexer.build []
# $logger.log indexer.indexes

# $logger.fail -> indexer.build [{'other'}]

# indexer.build [{id: 'undefinedEntry'}]
# $logger.log indexer.indexes

# indexer.build [{id: value: 'workingEntry'}]
# $logger.log indexer.indexes

# indexer.build [{i: 1, id: value: 'works'}, {i: 1, id: value: 'works2'} {i: 2, id: value: 'works'}]
# $logger.log indexer.indexes



# ------------------------------------------------------------------------------
# FIXME Remove that too!!

# $logger.separator 'FIXME Building: array entry'
# # $logger.on!

# indexer.build [{id: value: 1, aliases: ['alias1', 'alias2']}]
# $logger.log indexer.indexes



# ------------------------------------------------------------------------------

$logger.separator 'Updating: simple entry'
# $logger.on!

indexer.add {i: 1, id: value: 'works'}
$logger.log indexer.indexes

indexer.add {i: 1, id: value: 'works2'}
$logger.log indexer.indexes

indexer.add {i: 2, id: value: 'works'}
$logger.log indexer.indexes

value = {i: 2, id: value: 'works2'}
indexer.add value
$logger.log indexer.indexes

indexer.remove value
$logger.log indexer.indexes



# ------------------------------------------------------------------------------

$logger.separator 'Updating: multiple entries'
# $logger.on!
indexer.addIndex 'refs' {+multiple}

# XXX Skip undefined entry for arrays, or use just one occurrence. This is now a problem of data transform/extract, in case of arrays.

indexer.add {id: {value: 1}, refs: ['alias1', 'alias2']}
$logger.log indexer.indexes

indexer.add {id: {value: 2}, aliases: [{value: 'alias1'}, {value: 'alias2'}]}
$logger.log indexer.indexes

indexer.add {id: {value: 3}, aliases: [{value: 'alias1'}, {value: 'alias2'}]}
$logger.log indexer.indexes



# ------------------------------------------------------------------------------

$logger.separator 'Getting'
# $logger.on!

$logger.log indexer.get {id: 'works'}
$logger.log indexer.get {id: 'works'} no
$logger.log indexer.get {id: 'unexisting'}
$logger.log indexer.get {aliases: 'alias1'}
$logger.log indexer.get {aliases: 'alias1'} no
$logger.log indexer.get {aliases: 'alias2'}
$logger.log indexer.get {aliases: 'alias2'} no



# ------------------------------------------------------------------------------

$logger.separator 'Key removal'
# $logger.on!


$logger.log indexer.indexes

indexer.remove (indexer.get {id: 'works'} no)[*-1] # Removes last
$logger.log indexer.indexes

last = indexer.get {id: 'works'}
indexer.remove last
$logger.log indexer.indexes

indexer.remove last
$logger.log indexer.indexes

indexer.add last
$logger.log indexer.indexes



# ------------------------------------------------------------------------------
# FIXME
# Maybe implement a cache, like when adding a value:
# {
# 	value
# 	indexes:
# 		field: entry
# }
# to be able to check where the value was before, since the object identity doesn't change!! (runtime feature)
# But is this worth it? ...

# $logger.separator 'Fixing'
# # $logger.on!

# last.id.value = 'newvalue'
# indexer.fix last
# $logger.log indexer.indexes

