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

For now the work is focused on HTML (easy for tests). The structure of the language is close to Aria Templates, which is a good thing.

You can launch a backend instance (see procedure below) and interact with it the way you want.

You can launch an Eclipse application with a plugin using this backend instance (see [procedure below](#setup)) and use it to edit `.tpl` files: __despite the name of the extension only the HTML syntax will be supported inside!__

# Introduction

Please read the [introduction](./introduction.md) if you never did it and don't know what the project is all about.

Please see the [meta-documentation](./documentation.md) __before reading or WRITING any documentation__. This helps understanding the documentation, and is required to maintain it consistent while adding content.

# File system layout

__Some of the files listed below might not appear for now, because they will be either generated or created specifically by you__

* [`.gitignore`](./.gitignore): Git related file
* `bin`: folder containing the build, which contains both the Eclipse plugin and the backend for now

Documentation:

* [`README.md`](./README.md): this current file
* [`introduction.md`](./introduction.md): an introduction to the project
* [`documentation.md`](./documentation.md): a documentation about the documentation in this project (meta-documentation)
* [`roadmap.md`](./roadmap.md): a roadmap for the project

Backend code:

* [`resources`](./resources): the sources of the backend

Eclipse code:

* [`src`](./src): the sources of the Eclipse plugin
* [`build.properties`](./build.properties), [`plugin.xml`](./plugin.xml), [`META-INF`](./META-INF): files and folders contributing to the Eclipse plugin definition
* `.project`, `.classpath`, `.settings`: files related to the Eclipse project configuration

# Versioning

What might be versioned (should be reproducible but might differ between environments - so versioning could pollute more than help):

* `.project`, `.classpath`, `.settings`

To ignore:

* `bin`: generated content (from the sources)

To version: _everything else_.

# Documentation

As mentioned, the goal is to implement a generic solution to handle source code edition, whatever the language, whatever the [UI](http://en.wikipedia.org/wiki/User_interface) used behind (i.e. the tool(s)).

## Architecture

We call the tools used to actually edit source code: [___frontends___](http://en.wikipedia.org/wiki/Backend). They provide the ([G](http://en.wikipedia.org/wiki/GUI))[UI](http://en.wikipedia.org/wiki/User_interface).

We call the application serving source edition features (processing): the [___backend___](http://en.wikipedia.org/wiki/Backend).

A frontend is a client of this backend (then acting as a server application), and they communicate through standard means.

Here is a quick description of the stack:

* [__backend__](http://en.wikipedia.org/wiki/Backend): a Node.js based application, providing services used by editors and IDEs
* [__API__](http://en.wikipedia.org/wiki/API): a classical programming interface for the backend, used by the JSON-RPC (Remote Procedure Call protocol using JSON) layer (which is the end point of the _communication interface_ - see below - for the backend)
* __communication interface__: [JSON](http://en.wikipedia.org/wiki/JSON)-[RPC](http://en.wikipedia.org/wiki/Remote_procedure_call) through [HTTP](http://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol) (default listening port: 3000)
* [__frontend__](http://en.wikipedia.org/wiki/Backend): any [IDE](http://en.wikipedia.org/wiki/Integrated_development_environment) or [editor](http://en.wikipedia.org/wiki/Source_code_editor) with extension capability, using the backend through the communication interface

This project aims at providing everything __except__ the last part: indeed, a frontend is a consumer of the project.

However, as this project is still a work in progress, and for some prioritary requirements, the reversed approach has been taken: everything is integrated into a __single__ frontend project, an Eclipse plugin.

Later on, we could consider extending other tools to use the backend, like: [Sublime Text](http://www.sublimetext.com/), [Notepad++](http://notepad-plus-plus.org/), [Cloud9](https://c9.io/), a custom IDE, ... or even any other specific tools not even doing edition (analysis for instance).


# Contribute

I would first give an advice to apply everywhere: __READ CAREFULLY THE DOCS__.

## Environment

To be able to develop the project or even use the product you need to:

* Install [Node.js](http://nodejs.org/download/) - tested with latest version ([0.10.12](http://nodejs.org/dist/v0.10.12/node.exe) at the time of writing)
	* the `node` binary must in in the `PATH` environment variable
* Install Eclipse IDE - tested with latest version (Kepler at the time of writing)
	* Preferably choose [Java EE bundle](http://www.eclipse.org/downloads/packages/eclipse-ide-java-ee-developers/keplerr)
	* Install the plugin [Google GSON](http://code.google.com/p/google-gson/) from [Orbit repository](http://download.eclipse.org/tools/orbit/downloads/) ([latest](http://download.eclipse.org/tools/orbit/downloads/drops/R20130517111416/repository/) at the time of writing)
* Have a [Java SE](http://www.oracle.com/technetwork/java/javase/downloads/index.html) installation available - tested with latest version (7 at the time of writing)

Tested on Microsoft Windows 7 Enterprise 64-bit SP1.

## Setup

After cloning the [repository](https://github.com/ymeine/editors-tools.git), you will have to do some setup.

There are two items to setup: the backend and the Eclipse project.

### Backend

Please follow the [backend specific directions](resources/README.md#setup).

Also, after that, [build the HTML parser](resources/app/node_modules/modes/html/parser/README.md#setup).

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
	* Go to the directory [`resources`](./resources)
	* launch `npm` with argument `start` (command: `npm start`)
	* (you can check it works if [this](http://localhost:3000/ping) sends `OK`)
* Launch the Eclipse application
	* Open the Eclipse project
	* Launch the project as an Eclipse application
		* Select the project and select menu `Run>Run`, or use the contextual menu of the project and select `Run As`
		* Choose `Eclipse Application`

Then you can start editing files with the `.tpl` extension under a new project.

## Development

Please refer to the subfolders of the project for details about corresponding modules specific development: every folder containing a documentation like this contains a section talking about contributions you can make to it.

Sections below discuss about development at the whole project scale.

__Please have a look at the [roadmap](./roadmap.md) too for a prioritization of what has to be done.__ It will link to specific documentations' sections (including some of below ones).

### Backend packaging

__The Eclipse plugin must be able to embed the code of the backend server and to launch and manage an instance of it properly.__

For now it's easier for the Eclipse plugin to communicate with an already running backend instance, that is launched externally.

There is still some work to do to enable the plugin to launch a backend packaged with it.

There are two kinds of environments to consider:

* __development__: just have a quick and dirty solution to make it work in development mode
* __production__: make it work in the context of a packaged plugin

__For development__, the sources of the server are available, and are located inside the project. Therefore to launch it ( __without hardcoding paths!!__ ), there is just a need to __resolve the relative paths inside the project__ (i.e. equivalent to programatically find the path of the project).

__For production__, the problem is different.

First, once installed, the plugin will reside in the Eclipse installation, among every other bundles. The thing would be - as it is for development - to __resolve the path of the plugin__ (but in this case it's not in the context of the project but the one of the Eclipse installation). Have a look at [`FileLocator.find`](http://help.eclipse.org/kepler/index.jsp?topic=%2Forg.eclipse.platform.doc.isv%2Freference%2Fapi%2Forg%2Feclipse%2Fcore%2Fruntime%2FFileLocator.html&anchor=find%28org.osgi.framework.Bundle,%20org.eclipse.core.runtime.IPath,%20java.util.Map%29): the `Bundle` required in this method can be taken from the [`Activator`](src/poc/Activator.java) class of this project.

But then there is a problem due to the fact a plugin is __packaged in an archive by default__. If the Java system works fine with binaries contained in archives, it is not the case of the _externally made_ server. It __relies on a standard file system access__.

For that there are two solutions:

* either finding a solution to execute the server in a virtual file system - personally I don't know how
* or finding a solution to extract the files of the archive for the server. See this [thread on stackoverflow](http://stackoverflow.com/questions/5622789/how-to-refer-a-file-from-jar-file-in-eclipse-plugin#answer-5660242) talking about plugin packaging: an option to avoid archiving would be available in case we wrap the plugin in an Eclipse feature.

NB: to bring files from the backend project into the Eclipse Plugin project without versioning issues, [Git Submodules](http://git-scm.com/book/en/Git-Tools-Submodules) can be used

### Projects architecture

__The Eclipse plugin sources and the backend sources should be part of two respective different projects.__

For now it's simple to have everything in the same place, for the Proof of Concept, and since the first real implementation of using the backend is made with the Eclipse plugin.

However, since the backend is intended to be something completely decoupled from any client, will be used by many of them, and above all because we will not be supposed to have any knowledge of these clients, the backend should be in a separate project.

This means taking the content of the `resources` folders and to make it root of a new project.

Then, this brings another challenge: bringing the sources of the backend contained in an external project for packaging phase of the Eclipse plugin.

### Eclipse plugin

__Clean Eclipse extension points.__

> Do we use the `org.eclipse.ui.editors.documentProviders` extension point or not?

We can manage without, as it is done for now, but maybe it's better for design purposes to use it.

### Performances of process interactions

__Reduce the overhead introduced by HTTP, JSON serialization and also RPC.__

Maybe the use of JSON-RPC through HTTP can be too heavy for very frequent and simple operations done while editing. I'm mainly thinking about the frequent update of the models (source, AST (graph) and so on) concerning content, positions, etc., while the user enters text.

Think about using a custom protocol built on top of lower-level ones (TCP for instance).

The following aspects can be improved:

* connection setup: keeping connected state (contrary to basic HTTP)
* protocol overhead: limit amount of data used only for the information transmission. HTTP is pure text and thus easy to read, debug, but it can be too much. Prefer binary, and a minimum amount of required data.
* serialization: limit verbosity, prefer binary over text (JSON is already better than XML), ...
* _bonus_ - two ways sockets: rather than a client-server model, simply make the two entities communicate both ways

There are also other standard solutions like [CORBA](http://en.wikipedia.org/wiki/Common_Object_Request_Broker_Architecture) (but I'm not sure there is an available mapping for JavaScript in this case).

I ([ymeine](https://github.com/ymeine)) found recently (05 Jul 2013) an [article](http://dailyjs.com/2013/07/04/hbase/?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+dailyjs+%28DailyJS%29) talking about [Thrift](https://thrift.apache.org/). The description at least corresponds exactly to what we want to do: provide services to clients whatever the system they use, and automatically deal with remote procedure calls and so on.

### Documentation

__Review the documentation of the documentation (the meta-documentation), written in [`documentation.md`](./documentation.md) for now.__

#### `Contribute` section

Check how to structure the `Contribute` section.

Two things can be distinguished:

* content talking about how to setup the project, configure the environment, and also how to _try_ the project, to manually/visually test it: all of this is optional
* content talking about what can be done to actually develop the project

For the second one, it's harder to see how to structure it. At least we can bring out two aspects: development for the code, and work on the documentation. One last thing is the section about fixes to be done: it must appear first and be concise, since this concerns urgent tasks.

So here are the main parts in order in this section:

1. Setup: optional
1. Try/Test: optional
1. Develop
	1. FIXMEs
	1. Code
	1. Documentation

Inside the _code_ section, theer can be many things, from little tasks to more complex ones, requiring detailed paragraphs.

I would put everything in a dedicated section with a meaningful name, followed by a single emphased line summarizing the nature of the task, and then possibly a description paragraph.

#### `Guidelines`

__Complete the guidelines section.__

#### `Documentation` / `Contribute` order

__Choose wether to put the `Documentation` section before the `Contribute` one or vice versa.__

Seems like the first one is the one mostly used.

#### Wiki

__Determine content with a general purpose trait and consider putting it in a wiki.__

Think about putting documentation files other than `README.md` ones into the wiki. Indeed, they seem to be more general files.

The `README.md` files are specific, and there can be only one per folder. A folder often being a module, this is logical to use them to describe the module specifically.

Other files might be for more general purposes, so consider putting them into the wiki.
