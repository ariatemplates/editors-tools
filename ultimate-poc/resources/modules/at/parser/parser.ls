require! {
# -------------------------------------------------------------------------- STD
	fs
# -------------------------------------------------------------------------- 3rd
	PEG: pegjs
# ------------------------------------------------------------------------ Input
	'./options'
}



grammar = fs.readFileSync 'grammar.pegjs' 'utf-8'

module.exports = PEG.buildParser grammar, options
