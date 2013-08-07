Handles global data for the whole plugin.

# File system layout

* [`README.md`](./README.md): this current file
* [`POCWorkbenchPreferencePage.java`](./POCWorkbenchPreferencePage.java): the view handling the plugin preferences page (integrated to the preferences system of Eclipse RCP)

# Versioning

To version: _everything_.

# Contribute

## Data management

__Handle data management for the plugin.__

Related to the concept of stores (of data), or global data (something perceived bad).

At least, there should be something available to manage data, share it for the whole plugin, a kind of central hub.

This might be used essentially for configuration, and user preferences.

## Preference page

__Implement a preferences page, to enable the end user configuring the whole plugin.__

At least build the scaffolding, a placeholder for GUI components the user will have access to to configure the plugin.

To find what can be configurable, you can browse multiple things in this plugin project:

* packages specific documentations, telling about some chosen values or behavior that might change
* source code, notably with constants - most of them being extracted to private static properties
* ...
