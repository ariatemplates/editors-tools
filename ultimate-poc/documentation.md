A description of the documentation for this project. __Read it first__, and then the rest will go smoother.

# Introduction

I'll decribe here how to read the documentation for this project: where it stands and which pattern(s) it follows.

# Layout

Every folder in this project will contain a documentation file when relevant. If a one doens't contain any, the reason must be explained in the documentation file of the parent folder.

An example of irrelevant documentation would be a documentation about external or standard libraries, for which the documentation stands elsewhere. However, it is strongly encouraged to write documentation bringing an added value on top of that, like your quick understanding of the library, or a description of the way you use it (especially for flexible libraries, requiring use conventions).

Some documentation may reside in the source files (that is any file other than documentation) of the project themselves, but in that case the documentation file __SHOULD__ indicate to have a look at them for further information.

__Concretely__:

Each folder contains a `README.md` file, to be consistent with GitHub. However, when needed, other Markdown files with proper names can be added, but they __MUST__ be referenced in the `README.md` file.

Remember that usually if a documentation is not put in the README file, if it's not only a matter of size then it's probably a matter of purpose and you should maybe consider putting it into the wiki (more on that below).

# Format

Each section here will describe a standard part of a documentation file.

## Disclaimer

Position: __very top of the file__

A disclaimer can be put on a documentation file, before any content, with an emphased first line describing quickly the nature of the the problem, followed by a short explanation paragraph.

A separating line __SHOULD__ be inserted after.

## Catcher

Position: __right above the first main section__

A documentation file begins with a single paragraph which must do its best to sum up the content of the documentation: this is the __catcher__.

An effort of scaling the point of view must be made, as a documentation file residing at the root of a project will need to sum up the idea of the project, leaving details for submodules.

The catcher is also an occasion to warn the user about things he could quickly wonder about before reading any documentation. In this case, you can describe it with more details in a section you would reference form the catcher.

## File system layout

Position: __first main section__

This section should be the first of the document.

It is intended to describe each file and folder (a node in general) contained in the current folder.

Each node can be described in a dedicated subsection or as an item of a list.

If you use both subsections and a list, put the list first.

Node names are put in `code style`. This is an important thing to mention, as some entries (sections or list items) can be written in plain style: in this case this is often a grouping of different nodes, for which either a quick a global explanation is enough or a specific section is present.

## Versioning

Position: __second main section__

This section always follow the _file system layout_ section, since it uses it as a reference. Referred items are put in a `code style` when they are nodes, or plain style, in which case they refer to a group, described quickly or in a dedicated section in the `File system section`.

It must tell what to version or not, and why. The _why_ is for what is not or might not be versioned of course.

It will show three lists of files and folders with explanation:

* the list of content to version
* the list of content that might be optionnaly versioned: it also tells what choice has been made for now.
* the list of content NOT to version, telling why is mandatory

NB: be careful not to add your very custom files into this documentation (neither in the `.gitignore` file), since they make sense only for you. So in the _not to version_ section you will mostly have generated content.

## Contribute

Position: __third main section__

This section follows the sections about files and versioning, because now that the developer can understand the package, he might want to know how to work on this.

However, to be able to contribute you will need to read a section under, which is the real documentation of the package. See below for more information.

This section must decribe:

* the pre-requisites: either knowledge or general environment setup (runtimes, generic libraries, ...)
* how to fetch the project
* how to set up the working environment
* how to run it to have a demo
* what to do for code (development)
* what to do for documentation

## Documentation

Position: __fourth main section__

This comes almost last, as it can take some space and its content is not standard at all.

This section simply explains the package, and gathers any required documentation, explanations.

## References

Position: __fifth main section__

To put near the end, a list of references and resources.

# Guidelines

* Average number of lines a content should not exceed:
	* disclaimer: 10
	* catcher: 5
	* whole documentation: 200
	* ...
* Formatting:
	* don't hesitate to use emphasis when necessary
	* ...
* ...
