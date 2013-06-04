# Brainstorming

## Cache

A cache is something that stores one data that can be requested.

The first time the data is requested, the data does't exist and is computed (this is the model, as in practice it can be static data already processed by the runtime).

Then, it is put in the cache with a unique ID.

When the data will be requested in the future, it will be taken from the cache.

Now, there are two problems:

* handling the two cases in a nice way: first request and following ones
* handling the case where the data should be re-computed

For the first issue, the cache should just detect that for a given ID there has never been any value, so it will ask the new data to be computed and put into the cache.

For the second one, it's more or less the same thing, except the complex part: detecting that the data should be RE-computed.

A first simple approach can be to let the user detect itself when the data is obsolete and to let the cache know that a data under a given ID is obsolete. That way, when the data will be requested, it will ask the data to be recomputed.

### Model

A cache is for one data.

It takes:

* a callback that is able to compute the data

It allows:

* creating a cache
* requesting a value
* making a value obsolete


# TODO

* clean the code of the indexer
* design a cache utility
