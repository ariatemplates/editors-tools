This project aims at providing a solution for source code edition services, decoupled from any user interface, with an effort of abstraction of the underlying models.

__This is a work in progress and only at a state of proof of concept.__

Thus this is for now concretely applied to specific things:

* Edition services modules (called _modes_):
	* JavaScript
	* HTML
	* [Aria Templates](http://ariatemplates.com), using the two above
* Clients implementations:
	* [Eclipse IDE](http://eclipse.org/)

# Current development state

For now the work is focused on HTML (easy for tests).

You can launch a backend instance (see procedure below) and interact with how you want.

You can launch an Eclipse application with a plugin using this backend instance (see procedure below) and use it to edit `.tpl` files: __despite the name only the HTML syntax will be handled inside!__

# Introduction

Please read the `introduction.md` file if you never did it and don't know what the project is all about.

Please see the `documentation.md` file __before reading or WRITING any documentation__. This helps understanding the documentation, and is required to maintain it consistent while adding content.

# File system layout

__Some of the files listed below might not appear for now, because they will be either generated or created specifically by you__

* `.gitignore`: Git related file
* `bin`: folder containing the build, that contains both the Eclipse plugin and the backend for now

Documentation:

* `README.md`: this current file
* `introduction.md`: an introduction to the project
* `documentation.md`: a documentation about the documentation in this project

Backend code:

* `resources`: the sources of the backend

Eclipse code:

* `src`: the sources of the Eclipse plugin
* `build.properties`, `plugin.xml`, `META-INF`: files and folders contributing to the Eclipse plugin definition
* `.project`, `.classpath`, `.settings`: files related to the Eclipse project configuration

# Versioning

To version:

* Documentation
* `.gitignore`
* `build.properties`, `plugin.xml`, `META-INF`
* `src`
* `resources`

What might be versioned (should be reproducible but might differ between environments - so versioning could pollute more than help):

* `.project`, `.classpath`, `.settings`

To ignore:

* `bin`: generated content (from the sources)

# Documentation

As mentioned, the goal is to implement a generic solution to handle source code edition, whatever the language, whatever the UI used behind (i.e. the tool(s)).

## Architecture

We call the tools used to actually edit source code: ___frontends___. They provide the (G)UI.

We call the application serving source edition features (processing): the ___backend___.

A frontend is a client of this backend (then acting as a server application), and they communicate through standard means.

Here is a quick description of the stack:

* __backend__: a Node.js based application, providing services used by editors and IDEs
* __API__: a classical programming interface for the backend, used by the JSON-RPC (Remote Procedure Call protocol using JSON) layer (which is the end point of the _communication interface_ - see below - for the backend)
* __communication interface__: [JSON](http://en.wikipedia.org/wiki/JSON)-[RPC](http://en.wikipedia.org/wiki/Remote_procedure_call) through [HTTP](http://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol) (default listening port: 3000)
* __frontend__: any IDE or Editor with extension capability, using the backend through the communication interface

This project aims at providing everything __except__ the last part: indeed, a frontend is a consumer of the project.

However, as this project is still a work in progress, and for some prioritary requirements, the reversed approach has been taken: everything is integrated into a __single__ frontend project, an Eclipse plugin.

Later on, we could consider extending other tools to use the backend, like: [Sublime Text](http://www.sublimetext.com/), [Notepad++](http://notepad-plus-plus.org/), [Cloud9](https://c9.io/), a custom IDE, ... or even any other specific tools not even doing edition (analysis for instance).


# Contribute

I would first give an advice to apply everywhere: __READ CAREFULLY THE DOCS__.

## Environment

* Install [Node.js](http://nodejs.org/download/) - tested with latest version ([0.10.12](http://nodejs.org/dist/v0.10.12/node.exe) at the time of writing)
	* the `node` binary must in in the `PATH` environment variable
* Install Eclipse IDE - tested with latest version (Kepler at the time of writing)
	* Preferably choose [Java EE bundle](http://www.eclipse.org/downloads/packages/eclipse-ide-java-ee-developers/keplerr)
	* Install the plugin [Google GSON](http://code.google.com/p/google-gson/) from [Orbit repository](http://download.eclipse.org/tools/orbit/downloads/) ([latest](http://download.eclipse.org/tools/orbit/downloads/drops/R20130517111416/repository/) at the time of writing)
* Have a [Java SE](http://www.oracle.com/technetwork/java/javase/downloads/index.html) installation available - tested with latest version (7 at the time of writing)

Tested on Microsoft Windows 7 Enterprise 64-bit SP1.

## Setup

After cloning the repository, you will have to do some setup.

There are two items to setup: the backend and the Eclipse project.

### Backend

Please follow the instructions written in the `resources` subfolder.

Also, after that, build the HTML parser following the setup instructions in `resources\app\node_modules\modes\html\parser` submodule.

### Eclipse

Here is the full __detailed__ procedure to create the Eclipse project from the sources:

* Create a new project __inside this current folder__:
	* From the main menu `File>New>Other...`, select `Project` under category `General`
	* Give it any name you want
	* Uncheck the checkbox `Use default location`
	* Browse the file system to select this current folder
	* Click on `Finish`
* Add natures to the project:
	* open the generated `.project` file under the root folder of the project (i.e. this current folder): this file is in XML format
	* under the XML element `natures`, add natures by adding `nature` elements (example: `<natures><nature>org.eclipse.pde.PluginNature</nature></natures>`)
	* add the following natures:
		* `org.eclipse.pde.PluginNature`
		* `org.eclipse.jdt.core.javanature`
* Edit properties of the project:
	* Open properties of the project by choosing menu `Project>Properties` (or `Properties` from contextual menu of the project with right-click on it in)
	* Configure build path
		* Select `Java Build Path` on the left
		* Select tab `Source` on the right
			* Click on `Add Folder...`
			* Check:
				* `resources`
				* `src` (if not already selected)
			* Note that the file `plugin.xml` and the folder `META-INF` don't have to be explicitely added
		* Select tab `Libraries`
			* Click on `Add Library...`
			* Select `Plug-in Dependencies`
			* Click `Next` then `Finish`
	* Add builders
		* open the `.project` file
		* under the element `buildSpec`, add builders by adding `buildCommand` elements, each of them containing two elements: `name` and `arguments` (example: `<buildSpec><buildCommand><name>org.eclipse.jdt.core.javabuilder</name><arguments></arguments></buildCommand></buildSpec>`)
		* add the following builders (just put the following in `name` elements):
			* `org.eclipse.jdt.core.javabuilder`
			* `org.eclipse.pde.ManifestBuilder`
			* `org.eclipse.pde.SchemaBuilder`

For simplicity, here is for the `.project` file the XML snippet resulting from the above procedure ( __this is not the whole file!!__ ):

```xml
<buildSpec>
	<buildCommand>
		<name>org.eclipse.jdt.core.javabuilder</name>
		<arguments>
		</arguments>
	</buildCommand>
	<buildCommand>
		<name>org.eclipse.pde.ManifestBuilder</name>
		<arguments>
		</arguments>
	</buildCommand>
	<buildCommand>
		<name>org.eclipse.pde.SchemaBuilder</name>
		<arguments>
		</arguments>
	</buildCommand>
</buildSpec>
<natures>
	<nature>org.eclipse.pde.PluginNature</nature>
	<nature>org.eclipse.jdt.core.javanature</nature>
</natures>
```

For the following, default values should be fine:

* the build target should go in a `bin` folder, to be compliant with the versioning - ignoring patterns.
* the Java compliance should be set to the Java version corresponding to the one used (see previous section).

## Try

* Launch the backend
	* Make sure the port 3000 is free on your system
	* Open a terminal emulator executing a system shell
	* Go to the directory `resources`
	* launch `npm` with argument `start` (command: `npm start`)
* Launch the Eclipse application
	* Open the Eclipse project
	* Launch the project as an Eclipse application
		* Select the project and select menu `Run>Run`, or use the contextual menu of the project and select `Run As`
		* Choose `Eclipse Application`

Then you can start editing files with the `.tpl` extension under a new project.

## Development

Please refer to the sub-folders for more details about specific development.

At this current level, you can work on the global architecture, as described in the documentation.

### FIXME

#### Backend packaging

For now it's easier for the Eclipse plugin to communicate with an already running backend instance (launched externally).

There is still some work to do to enable the plugin launching a backend packaged with it.

There are two kind of environements to consider:

* development: just have a quick and dirty solution to make it work in development mode
* production: make it work in the context of a packaged plugin

For development, the sources of the server are available, and are located inside the project. Therefore to launch it (without hardcoding paths), there is just a need to resolve the relatives paths inside the project (i.e. to programatically find the path of the project).

For production, the problem is different.

First, the plugin will reside in the Eclipse installation, among other bundles. The thing would be - as it is for development - to resolve the path of the plugin. Have a look at [FileLocator](http://help.eclipse.org/kepler/index.jsp?topic=%2Forg.eclipse.platform.doc.isv%2Freference%2Fapi%2Forg%2Feclipse%2Fcore%2Fruntime%2FFileLocator.html&anchor=find%28org.osgi.framework.Bundle,%20org.eclipse.core.runtime.IPath,%20java.util.Map%29).

But then there is a problem due to the fact a plugin is packaged in an archive by default. If the Java system works fine with binaries contained in archives, it is not the case of the _externally made_ server. It relies on a standard file system access.

For that there are two solutions:

* either finding a solution to execute the server in a virtual file system - personnaly I don't know how
* or we find a solution to extract the file of the archive for the server. See [thread on stackoverflow](http://stackoverflow.com/questions/5622789/how-to-refer-a-file-from-jar-file-in-eclipse-plugin).

### Backlog

1. Review the architecture to externalize the backend
	* create separate projects or at least separate folders for the frontend and the backend
	* find a way to package the Eclipse frontend plugin with an embedded backend (remember that for test purposes, you can use the detection feature of the frontend, which finds an already running backend)
1. Clean Eclipse extension points
	* Use the `org.eclipse.ui.editors.documentProviders` extension point or not?

### Documentation

1. Complete the procedure to recreate the Eclipse Project in section `Contribute > Setup`
1. Review documentation
	* Documentation of the documentation (meta)
		* I would prefer using a `Backlog` section inside the `Contribute` one (as I'm doing here) instead of a `TODO` section. I don't know about the `FIXME`, probably keep it.
		* finish writing it, especially the guidelines section
	* Choose wether to put the `Documentation` section before the `Contribute` one or vice versa? Seems like the first one is the one mostly used.
	* Check the `Contribute` section: do we put a `Development` section (like here) then a nested `Backlog` section for _non-classified_ stuff and any other section for the rest?

#### Wiki

Think about putting documentation files other than `README.md` ones into the wiki. Indeed, they seem to be more general files.

The `README.md` files are specific, and there can be only one per folder. A folder often being a module, this is logical to use them to describe the module specifically.

Other files might be for more general purposes, so consider putting them into the wiki.

### Performances of process interactions

Maybe the use of JSON-RPC through HTTP can be too heavy for very frequent and simple operations done while editing. I'm mainly thinking about the frequent update of the models (source, AST (graph) and so on) concerning content, positions, etc. while the user enters text.

Think about using a custom protocol built on top of lower-level ones (TCP for instance).

The following aspects can be improved:

* connection setup: keeping connected state (contrary to basic HTTP)
* protocol overhead: limit amount of data used only for the information transmission. HTTP is pure text and thus easy to read, debug, but it can be too much. Prefer binary, and a minimum amount of required data.
* serialization: limit verbosity, prefer binary over text (JSON is already better than XML), ...
* two ways sockets: rather than a client-server model, simply make the two entities communicate both ways

There are also other standard solutions like [CORBA](http://en.wikipedia.org/wiki/Common_Object_Request_Broker_Architecture) (but I'm not sure there is an available mapping for JavaScript in this case).

I ([ymeine](https://github.com/ymeine)) found recently (05 Jul 2013) an [article](http://dailyjs.com/2013/07/04/hbase/?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+dailyjs+%28DailyJS%29) talking about [Thrift](https://thrift.apache.org/). The description at least corresponds exactly to what we want to do: provide services to clients whatever the system they use, and automatically deal with remote procedure calls and so on.
