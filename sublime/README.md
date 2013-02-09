How to install AT syntax highlight for Sublime Text 2
=====================================================
1. Download "Aria Templates.tmLanguage"
2. Go to your packages (in Sublime : Preferences > Browse Packages...)
3. Create a folder named "Aria Templates"
4. Copy "Aria Templates.tmLanguage" in this folder

Done. *.tpl and *.tml files should automatically be recognized by Sublime as Aria Templates. For tpl.css files, you will have to set it manually.

Developed with Monokai theme. Should be compatible with other themes nicely.

How to improve/change it ?
==========================

1. Go read this http://docs.sublimetext.info/en/latest/extensibility/syntaxdefs.html 
2. Install AAAPackageDev if not done already
3. Reuse the existing "Aria Templates.JSON-tmLanguage"

AAAPackageDev takes care of translating the JSON version of the syntax definition to the much harder to read XML format.

Screenshots
===========

![Preview template](https://raw.github.com/ariatemplates/editors-tools/master/sublime/preview-1.png "Preview template")
![Preview css-template](https://raw.github.com/ariatemplates/editors-tools/master/sublime/preview-2.png "Preview css-template")
