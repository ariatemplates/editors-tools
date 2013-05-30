The goal of this is to be able to create a Windows Shell shortcut, that is a `.lnk` files, with a minimum of properties like the filename, the target, the icon maybe.

# File system layout

* `createShortcut.vbs`: Visual Basic implementation
* `createShortcut.js`: Microsoft JS implementation

# Requirements

* Create a shortcut file
* Customize it with these properties:
	1. Shortcut name
	1. Target path
	1. Icon file
	1. Startup directory
	1. Compatibility options
	1. ...

# Architecture

For simplicity, the core utility is built with Microsoft technologies. In our case, this is a Shell Script (___CHECK THAT NAME___)

The interface between this utility and the Node.js machine is a standard system process call.

# References

* name of the program being able to launch a Shell Script

# Resources

* http://msdn.microsoft.com/en-us/library/xsy6k3ys%28v=vs.84%29.aspx
* http://stackoverflow.com/questions/346107/creating-a-shortcut-for-a-exe-from-a-batch-file
* [IShellLink](http://msdn.microsoft.com/en-us/library/bb774950%28v=vs.85%29.aspx)
