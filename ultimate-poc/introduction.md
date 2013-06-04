It would be cumbersome to explain in details the meaning of this project, so let's illustrate it with a scenario: a developer willing to write JavaScript programs.

> I want to edit my JavaScript file with some support, what do I use?

For that you can use either an editor or an IDE (better if you work on projects instead of single files).

These tools will implement the usual features we expect them to provide, like syntax highlighting, outlining and so on. (By the way, the balance between features determines the nature of the tool: more IDE or more simple editor)

> Which one is the best?

The common features are expected to be the same between tools, since they are all based on a common thing: the JavaScript standard. This standard is what drives the feature.

The possible differences should depend only on the capabilities of the tools in terms of UI, or the way it implements a feature.

> Do you have a concrete example?

Yes, highlighting.

When you edit your JavaScript file, you want to see some parts of text to be displayed in different styles to reflect the semantic of the program.

An example of differing behavior between two tools could be one supporting display of colors in its text viewer, while the other doesn't (in this case there wouldn't be any highlighting support)

However, for all tools suuporting highlighting, you expect them to highlight the code the same way, since it's the same program, this the same semantics behind.

> Another example?

Yes, outlining.

This is a feature that aims at _summarizing_ your program, by showing the hierarchical structure of your program (concept closely tight to the AST).

For that, the tool needs to be able to display trees or graphs. Then the interaction with the graph can differ (selecting a node could make the text viewer jump to the corresponding line of code - source and trees are both representations of the same model).

> So why choose one instead of another?

The choice of a tool can depend on a lot of criteria.

However, in this case, if we consider they all have the same capabilitie of (G)UI, any whould be ok.

The difference resides in __how far the features are implemented for JavaScript__.

> You mean?

Every project re-implement with its own technologies stack the same features.

__It's the well known issue of re-inventing the wheel!!__

> Example?

* Eclipse IDE: Java and PDE
* Sublime Text: Python and its own plugin system
* Notepad++: C++ and one again its own plugin system

They are all using their own plugin system, with more or less capabilities.

> Is that entirely true?

Indeed, we can imagine that they may use common libraries for JavaScript analysis for instance, no matter how they achieve doing it (bindings, IPC, ...)

However, we don't know yet any library handling generically features like highlighting or outlining.

> Back to your project, what do you want to do?

This project aims at fixing that issue.

It should provide a way to let the IDE and editors handle only the UI part, which is only a matter of display and interaction, not analysis.

> How?

For that we need to provide a __standard__ way for these tools to use common services, implemented only once.

This is related to common issues:

* process communication
* data-centric design: models

> What are the benefits?

In general:

* Maintain one code base: with separation of (G)UI and processing, instead of reimplementing the logic for any editor/IDE solution
* Benefit from an open architecture: the most we can support different kind of frontends, the more we will increase quality of our design
* ...

Specific:

* Re-use our knowledge: we prefer dealing with the JavaScript world we know well, instead of having to deal with different technologies (Java for Eclipse IDE, Python for Sublime Text, C++ for Notepad++)
* ...
