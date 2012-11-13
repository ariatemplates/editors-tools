How to install Notepad++ syntax highlighting (UDL)
==================================================

1. Open Notepad++.
2. Chooose `View` -> `User-Defined Dialogue...` (UDL)
3. Click `Import...`
4. Navigate to choose one of the `.udl.xml` files.
5. Restart Notepad++.

There are two versions available:
- a standard one, for black-text-on-white development
- a dark one, compatible with Notepad++'s built-in "Bespin" theme

**Feel invited to offer improvements and/or to develop your own theme and contribute!**

What you gain
=============

- In the `Languages` menu, you will see `AriaTemplates` item.
- All the files with `.tpl`, `.tml`, `.cml` extensions will be automatically
  opened with AriaTemplates syntax highlighting.
- Syntax highlight will also work for `.tpl.css` files, but unfortunately,
  you'll have to change the language from `CSS` to `AriaTemplates`.
- Apart of bare syntax highlighting, you'll be able to **fold/unfold
  your macros and sections**!

Tested with Notepad++ 5.9.8.

Preview
=======

- See `standard.png` and `bespin.png` in this folder (GitHub doesn't support well
  relative paths in images / links).

Important notes
===============

- If you already have the AriaTemplates UDL installed, you should remove it
  before importing a new version. To do it:
  - open UDL dialog,
  - select `AriaTemplates` language,
  - a new button `Remove` will appear, click it to remove the old version.
- Note that files opened in Notepad++ *before installing* the UDL, **will not**
  be highlighted. You need to close & reopen them, or manually enable
  AriaTemplates language for each of the files if you don't want to close them.

Technical limitations & known issues
====================================
 
- To enable folding, `{` and `}` can't be used as operators.
- `$` can't be an operator, otherwise keywords like `$classpath` will not
  be highlighted.
- `{elseif` has to be a normal keyword instead of a folder open/close keyword,
  otherwise pairs won't match and folding will not work correctly.
- Light background color for `[` and `]` as delimiter pairs helps spotting
  obvious syntax mistakes (if whole your file get highlighted, you likely
  forgot to close an opened brace).
- For proper highlighting of the file-ending statements like `{/Template}`
  and similar, it's recommended to have trailing newline (this is also
  recommended if you use Git as VCS so it don't complain for lack of trailing
  newline). In general, syntax highlighting in many cases needs a whitespace
  after the keyword to get activated.
- Unfortunately many other things are not possible to achieve due to stiff
  precedence rules in Notepad++ that can't be changed.
- The `name` field in `UserLang` node has to be rather short, otherwise N++
  crashes due to a bug (as of 5.9.8).

Creating your own highlighter
=============================

You can use Notepad++'s User Defined Dialogue feature to edit the highlighter
to fit it to your theme. However, the export tool is a bit buggy (as of 5.9.8;
it doesn't preserve values in `UserLang.Settings.Prefix` node), so make sure
to import the created theme and see it's working correctly. The highlighter
is an XML file so you can also edit it manually.
