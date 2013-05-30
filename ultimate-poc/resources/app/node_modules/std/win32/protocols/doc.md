Have a list of installed protocols on a Windows OS.

# Goal

* To be able to list all protocol handlers installed on a Windows OS
* Beyond: convert a windows registry base serialization (export) to a JSON format

# TODO

## Reg2JSON

Maybe use a PEG parser!

* Split by empty line -> list of path/properties
* For each
	- first is path
	- rest are properties, one per line
* A path is enclosed by braces and fragmented by back-slashes
* Properties are key/value pairs, separated by an equal sign, the key being enclosed by double quotes
* There's an exception, the special key @, not enclosed by quotes, and which represents the value of the path itself
* Take care also of long values for properties, as they might span on pultiple lines, each ending with a backslash

# Resources

* http://code.google.com/p/parse-win32registry/
