It would be cumbersome to explain in details the meaning of this project, so let's illustrate it with a scenario: a developer willing to write JavaScript programs.

> I want to edit my JavaScript file with some assistance, what can I use?

For that you can use either an editor or an IDE (the latter is better if you work on projects instead of single files) embedding support for JavaScript (or extensible enough so that you can add this support).

These tools will implement the usual features we expect them to provide, like syntax highlighting, outline and so on. (By the way, the balance between features can determine the nature of the tool: more _IDE_ or more _simple editor_)

> Which IDE or editor is the best?

The common features are expected to be the same between tools, since they are all based on a common thing: the JavaScript standard. This standard is what drives the features.

The possible differences should depend only on the capabilities of the tools in terms of UI, or maybe the way they chose to implement a feature (but the semantics behind must be the same).

> Do you have a concrete example of such feature?

Yes, highlighting.

When you edit your JavaScript file, you want to see some parts of the text displayed in different styles to reflect the semantic of the program.

An example of differing behavior between two tools could be one supporting display of colors in its text viewer, while the other doesn't (in this case there wouldn't be any highlighting support).

However, for all tools supporting highlighting, you expect them to highlight the code the same way, since it's the same program behind, thus the same semantics.

> Another example?

Yes, outline.

This is a feature which aims at _summarizing_ your program, by showing the hierarchical structure of your program (concept closely tight to the [AST](http://en.wikipedia.org/wiki/Abstract_syntax_tree)).

For that, the tool needs to be able to display trees or graphs in a dedicated view (more likely the case in an IDE). Then the interaction with the graph can differ (selecting a node could make the text viewer jump to the corresponding line of code - source and trees being both representations of the same model).

> So why choosing one tool instead of another?

The choice of a tool can depend on a lot of criteria.

However, in this case, if we consider they all have the same capabilitie of (G)UI, any whould be ok.

The difference resides in __how far the features are implemented for JavaScript__.

> What do you mean?

Every project re-implements with its own technologies stack the same features!

__It's the well known issue of re-inventing the wheel!!__

> Any example?

* Eclipse IDE: Java and PDE (its plugin development environment, for its OSGi-based plugin system)
* Sublime Text: Python and its own plugin system
* Notepad++: C++ and once again its own plugin system

Each plugin system has more or less capabilities.

> Is that entirely true?

Indeed, we can moderate this statement. We can imagine that they may use common libraries for JavaScript analysis for instance, no matter how they achieve doing it (bindings, IPC, ...)

However, we don't know yet any library handling generically features like highlighting or outline. They often implement it tying too much the GUI and the processing behind.

> Back to your project, what do you want to do then?

This project aims at fixing that issue.

It should provide a way to let the IDE and editors handle only the UI part, which is only a matter of display and interaction, not analysis.

The analysis part should always return the same information for a same content, that IDE and editors can use how they want.

> How can you do that?

By setting up a set of standards in this domain, about how to represent data for highlighting, outline, and so on.

Then, once everyone has agreed on the models, it's just a matter of establishing a communication between the entity which computes these data and the one which wants to use it (IDE and editors).

This is also a good thing to establish the conventions for this communication, to avoid another field of perpetuous re-implementation, and also to be able to optimize it for the use case.

> What are the benefits?

The main benefit is to be able to have only one implementation for each specific thing, the main one being the program processing the language (JavaScript in our example) to return analysis results.

Also, this way anyone can implement analysis tools for any language in any system - JavaScript for JavaScript, Java for Java, or whatever - since what matters is only data, and the transmission of data between different systems should be made through standard means supported by any of those.
