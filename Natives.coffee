
@extend = (o, e) ->
	o[k] = v for k, v of e
	o

extend Number,
	E: 2.718281828459045
	LN2: 0.6931471805599453
	LN10: 2.302585092994046
	LOG2E: 1.4426950408889634
	LOG10E: 0.4342944819032518
	HALFSQRT2: 0.7071067811865476
	SQRT2: 1.4142135623730951
	TAU: 6.283185307179586
	
Array::last = -> @[@length - 1]

Array::pack = ->
	results = []
	for n in this
		if !!n
			results.push(n)
	results

String::times = (n) ->
	r = ''
	r += this while n--
	
String::splice = (index, replace, what) ->
	@substr(0, index) + what + @substr(index + replace)


String::pretty = ->
	regexp = /({|}|\[|\]|;|:|,)/g
	result = this
	depth = 0
	match = undefined
	while match = regexp.exec(result)
		index = match.index
		full = match[0]
		value = match[1]
		if /\]|}/.test(value)
			value = "\n" + " ".times(--depth * 4) + value
		else if /\[|{/.test(value)
			value += "\n" + " ".times(++depth * 4)
		else if value is ":"
			value += " "
		else value += "\n" + " ".times(depth * 4) if value is ","
		result = result.splice(index, full.length, value)
		regexp.lastIndex += value.length - full.length
	result

@Frame = 
	@requestAnimationFrame or
	@webkitRequestAnimationFrame or
	@mozRequestAnimationFrame or
	@oRequestAnimationFrame or
	@msRequestAnimationFrame or
	(f) -> setTimeout(f, 20)

@Mouse =
	x: 0
	y: 0
	
@Time = Date.now

@Keyboard = {}

@Key = (code) -> {
	37: "left"
	38: "up"
	39: "right"
	40: "down"
	88: "/"
	90: "."
	91: ","
	186: ";"
	219: "["
	221: "]"
	222: "'"
}[code] or String.fromCharCode(code).toLowerCase()

