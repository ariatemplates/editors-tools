# Model

## Schema

An indexer works with a unique schema, describing how to handle the values it will index, and to put it in proper indexes.

So a schema begins with the list of indexes, with for each one:

* the name (see below)
* the entries provider

## Entries provider

An entries provider describes how to get a list of entries from a given value.

Generally you'll use only one property to choose the entry into which the input value will go for a given index.

However, this way you can get multiple entries for the same index, for one input value.

## Index

An index has:

* a name: generally you'll choose one corresponding to the name of the property upon which you index he value
* a set of entries (the keys)

## Entry

An entry has an ordered list of values, whose order corresponds to the one the values have been added to the index.

# API

Here are the operations available for an indexer:

* standard construction, with the schema as input
* updating the indexes with an action and a value:
	* adding a value
	* removing a value
	* updating following the changing of a value

# TODO

* be able to do actions with multiple values at once (optimizing method preprocessing)
* emit events, notably on:
	* adding mlultiple values to the same index entry
* be able to have an entries provider from objects: instead of a single property holding an array, the array would be built from several properties of an object

# Notes

## Data model

For a given index, values under an entry are stored in arrays. Because there can be multiple items with the same value for a given field.

The question is: what do we do when we switch between:

* at least 2 values for an entry
* only 1 value for an entry
* no more value for an entry

?

One logical thing could be respectively:

1. Have an array: no choice
1. Remove the array, hold the value directly. But what about if values themselves are arrays?
1. Delete the entry in the index, possibly re-creating it later on

This has several problems:

* impossible or hard to determine if there is only one value or multiple values in case the values themselves are arrays
* overhead to test and switch between single value and array
* overhead to test and add a remove an entry in the index

Optimizations targets:

* always keeping an array: essentially memory consuming, only 1 index dereference overhead for a single value
* always keeping the entry: simpler algorithm, but maybe hurts the benefits of indexing!
* not keeping an array: harder algorithm, uncertainty, CPU consuming to maintain the index, poor gain in memory

### Conclusion

(a bit hasty)

* keep arrays for sure
* keep keys for now, but remove them in the future
