We want to create a parser for the Aria Templates language, and the generated parser should target JavaScript.

# Introduction

There are always several solutions to a problem. Here are a few concerning parsing:

* create from scratch our own parser, coding everything
* use a grammar and a tool to generate the parser

If we put aside possible performance issues or very specific things, the second one is obviuosly the best.

Why?

A language, as everything, corresponds to a model. A grammar is a way to define an instance of this model. If we can have a fully working parser generated from a grammar, this means two things:

* our language is conform to the model, and thus every theory around it is available, along with tools and so on
* we can save time by generating something complex instead of writing it ourselves, thanks to a tool (as mentionned in the previous point)

So, what's next?

1. Determine which model our languages corresponds to, then we'll be able to know which kind of grammar we can use to define it.
1. Choose a flexible enough tool to generate a parser for this language in JavaScript

# Requirements

Here are the requirements of the parser:

* generate at least a tree
* keep location information, both as ranges (indexes in the full string of code) and coordinates (line/column model)
* ...

# Choice

As all the points mentionned above involve a strong knowledge of both the language we want to manage and the theory of formal languages, we won't have time to totally proces like this.

We will refer to a strong power which is the community.

One of the most famous tool to generate parsers in JavaScript is [PEG.js](http://pegjs.majda.cz/). It uses the [parsing expression grammar](http://en.wikipedia.org/wiki/Parsing_expression_grammar) model, which is apparentlt more powerful than other more traditional ones.

# Model of a template

Here are some important general rules:

* a template is contained in a unique file
* every template is completely wrapped by a unique root statement
* a template is a set of hierarchically structured statements between which there can be any text. It's a complete mixing of it, agnostic of what the text is. Think about XML, it's the same kind of things (however JSON is not).
* template statements delegates to JavaScript statements as much as possible (to express loops, object literals, ...)

Here is a crucial thing we want to change in these rules: **we want the template system to be aware of what text is inside it, to formalize it, and to put contrainsts with/on it.**

In our case, we want a template to be a set of templates statements intended for outputting HTML, and we want to have valid HTML, possibly forbidding the use of statements at some locations inside this HTML (these are some of the constraints mentionned above).

## TODO

1. Use a graphical representation for the following, [Graphviz](http://www.graphviz.org/) or whatever

## FIXME

1. `...` are things to complete
1. when a same class appears at two locations with different subclasses (genericity?). Especially when it appears under two parented classes (see next section). For instance, `opening` inside `block` and `widget`
1. I put some terminal elements, like `for`, but not all, as whitespaces or any ponctuators.

## Compositions ( _class model_ )

* template file
	* template
* block
	* opening
		* statement id
		* js
	* (element)*
	* closing
		* statement id
* widget
	* opening
		* widget id
		* js object
	* (element)*
	* closing
		* widget id
* for
	* opening
		* `for`
		* partial for expression
	* (element)*
	* closing
		* `for`
* ...
* non-block
	* self-closing
		* statement id
		* js

## Alternatives ( _classes hierarchy_ )

* element
	* statement
		* block
			* template
			* if
			* for
			* widget
			* ...
		* non-block
			* var
			* ...
	* text
* js
	* js expression
		* partial expression
			* partial for expression
			* ...
		* ...
	* js object
* tag
	* self-closing
	* opening
	* closing
