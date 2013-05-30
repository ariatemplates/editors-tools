require! {
# -------------------------------------------------------------------------- 3rd
	moment
}



format = 'D-M-YYYY H:m:s.SSS Z'


_export = (.format format)

_import = ({input, format, lang, utc}) ->
	lang_backup = moment.lang!

	if lang? => moment.lang lang
	# result = if utc => moment.utc input, format else moment input, format
	result = (if utc => moment.utc else moment) input, format

	moment.lang lang_backup
	result

convert = -> _import ... |> _export



exports <<< {
	format
	fmt: format

	export: _export
	exp: _export

	import: _import
	imp: _import

	convert
}
