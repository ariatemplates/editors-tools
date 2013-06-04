require! {
# -------------------------------------------------------------------------- 3rd
	_: lodash
# ---------------------------------------------------------------------- Own STD
	'std/array'
}



sum = (list) ->
	list = array.factory list

	if list.length is 0 => NaN
	else _.reduce list, (+), 0

mean = (list) ->
	list = array.factory list

	if list.length is 0 => NaN
	else (sum list) / (list.length)

isOdd = (value) ->
	if not value? => throw {
		msg: '''No value provided for function 'isOdd'.'''
	}

	(value % 2) > 0

isEven = isOdd >> (not)





exports <<< {
	sum

	mean
	average: mean

	isOdd
	isodd: isOdd
	odd: isOdd

	isEven
	iseven: isEven
	even: isEven
}
