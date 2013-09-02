class @Vector2
	constructor: (args...) ->
		if args.length is 1
			if args[0].x
				{@x, @y} = args[0]
			else
				[@x, @y] = args[0]
		else
			[@x, @y] = args

	toString: ->
		"[object Vector2]"

	toJSON: ->
		[ @x, @y ]

	length: (value) ->
		length = Math.sqrt(@x * @x + @y * @y)
		return length unless value?
		@scale value / length if length > 0
		this

	normalize: ->
		length = @length()
		if length > 0
			@x /= length
			@y /= length
		else
			@x = 0
			@y = 0
		this

	normal: ->
		length = @length()
		if length > 0
			new Vector2(@x / length, @y / length)
		else
			new Vector2(0, 0)

	add: (another) ->
		@x += another.x
		@y += another.y
		this

	plus: (another) ->
		new Vector2(@x + another.x, @y + another.y)

	sub: (another) ->
		@x -= another.x
		@y -= another.y
		this

	minus: (another) ->
		new Vector2(@x - another.x, @y - another.y)

	scale: (scalar) ->
		@x *= scalar
		@y *= scalar
		this

	times: (scalar) ->
		new Vector2(@x * scalar, @y * scalar)

	dot: (another) ->
		@x * another.x + @y * another.y

	angle: ->
		angle = Math.acos(@x / @length())
		(if @y < 0 then Number.TAU - angle else angle)

	angleTo: (another) ->
		magnitudes = @length() * another.length()
		Math.acos(@dot(another) / magnitudes)

	reflection: (another) ->
		normal = another.normal()
		@minus(normal.scale(2 * @dot(normal)))

	projection: (another) ->
		normal = another.normal()
		normal.scale(@dot(normal))

	morton: ->
		result = 0
		i = 0
		while i < 32
			result |= (@x & 1 << i) << i | (@y & 1 << i) << (i + 1)
			++i
		result

	hilbert: (order = 16) ->
		result = 0
		i = order - 1
		while i >= 0
			result <<= 2
			quadX = (if @x & (1 << i) then 1 else 0)
			quadY = (if @y & (1 << i) then 1 else 0)
			quad = @hilbertMap[form][2 * quadX + quadY]
			form = quad[1]
			result |= quad[0]
			--i
		result
		
	@hilbertMap: [
		[ [ 0, 3 ], [ 1, 0 ], [ 3, 1 ], [ 2, 0 ] ]
		[ [ 2, 1 ], [ 1, 1 ], [ 3, 0 ], [ 0, 2 ] ]
		[ [ 2, 2 ], [ 3, 3 ], [ 1, 2 ], [ 0, 1 ] ]
		[ [ 0, 0 ], [ 3, 2 ], [ 1, 3 ], [ 2, 3 ] ]
	]

class @Vector3
	constructor: (args...) ->
		if args.length is 1
			if args[0].x
				{@x, @y, @z} = args[0]
			else
				[@x, @y, @z] = args[0]
		else
			[@x, @y, @z] = args

	toString: ->
		"[object Vector3]"

	normalize: ->
		length = @length()
		@x /= length
		@y /= length
		@z /= length
		this

	add: (another) ->
		@x += another.x
		@y += another.y
		@z += another.z
		this

	sub: (another) ->
		@x -= another.x
		@y -= another.y
		@z -= another.z
		this

	scale: (scalar) ->
		@x *= scalar
		@y *= scalar
		@z *= scalar
		this

	plus: (another) ->
		new Vector3(@x + another.x, @y + another.y, @z + another.z)

	minus: (another) ->
		new Vector3(@x - another.x, @y - another.y, @z - another.z)

	times: (scalar) ->
		new Vector3(@x * scalar, @y * scalar, @z * scalar)

	cross: (another) ->
		new Vector3(
			@y * another.z - @z * another.y,
			@z * another.x - @x * another.z,
			@x * another.y - @y * another.x
		)

	dot: (another) ->
		@x * another.x + @y * another.y + @z * another.z

	angleTo: (another) ->
		Math.acos(@dot(another) / @length() / another.length())

	lerp: (another, t) ->
		new Vector3(
			@x + t * (another.x - @x),
			@y + t * (another.y - @y),
			@z + t * (another.z - @z)
		)

	length: (value) ->
		length = Math.sqrt(@x * @x + @y * @y + @z * @z)
		return length unless value?
		@scale(value / length) if length > 0
		this

class @Vector4
	constructor: (args...) ->
		if args.length is 1
			if args[0].x
				{@x, @y, @z, @w} = args[0]
			else
				[@x, @y, @z, @w] = args[0]
		else
			[@x, @y, @z, @w] = args

	toString: ->
		"[object Vector4]"

	normalize: ->
		length = @length()
		@x /= length
		@y /= length
		@z /= length
		@w /= length
		this

	sub: (another) ->
		@x -= another.x
		@y -= another.y
		@z -= another.z
		@w -= another.w
		this

	scale: (scalar) ->
		@x *= scalar
		@y *= scalar
		@z *= scalar
		@w *= scalar
		this

	dot: (another) ->
		@x * another.x + @y * another.y + @z * another.z + @w * another.w

	lerp: (another, t) ->
		new Vector4(
			@x + t * (another.x - @x),
			@y + t * (another.y - @y),
			@z + t * (another.z - @z),
			@w + t * (another.w - @w)
		)

	slerp: (another, t) ->
		{x, y, z, w} = another
		cosHalfTheta = @dot(another)
		if Math.abs(cosHalfTheta) >= 1.0
			return new Vector4(this)
		halfTheta = Math.acos(cosHalfTheta)
		sinHalfTheta = Math.sqrt(1.0 - cosHalfTheta * cosHalfTheta)
		if Math.abs(sinHalfTheta) < 0.001
			return new Vector4(
				0.5 * (@x + x),
				0.5 * (@y + y),
				0.5 * (@z + z),
				0.5 * (@w + w)
			)
		ratioA = Math.sin((1 - t) * halfTheta) / sinHalfTheta
		ratioB = Math.sin(t * halfTheta) / sinHalfTheta
		new Vector4(
			@x * ratioA + x * ratioB,
			@y * ratioA + y * ratioB,
			@z * ratioA + z * ratioB,
			@w * ratioA + w * ratioB
		)

	length: (value) ->
		length = Math.sqrt(@x * @x + @y * @y + @z * @z + @w * @w)
		return length unless value?
		@scale(value / length) if length > 0
		this

class @Matrix3
	constructor: (args...) ->
		if args.length is 1
			if args[0].a?
				{@a, @b, @c,
				 @d, @e, @f,
				 @g, @h, @i} = args[0]
			else
				[@a, @b, @c,
				 @d, @e, @f,
				 @g, @h, @i] = args[0]
		else
			[@a, @b, @c,
			 @d, @e, @f,
			 @g, @h, @i] = args

	equals: ({
		a, b, c,
		d, e, f,
		g, h, i
	}) ->
		@a is a and @b is b and @c is c and
		@d is d and @e is e and @f is f and
		@g is g and @h is h and @i is i

	trans: ({x, y, z}) ->
		new Vector3(
			@a * x + @b * y + @c * z,
			@d * x + @e * y + @f * z,
			@g * x + @h * y + @i * z
		)

	mult: ({
		a, b, c,
		d, e, f,
		g, h, i
	}) ->
		@a = @a * a + @b * d + @c * g
		@b = @a * b + @b * e + @c * h
		@c = @a * c + @b * f + @c * i
		@d = @d * a + @e * d + @f * g
		@e = @d * b + @e * e + @f * h
		@f = @d * c + @e * f + @f * i
		@g = @g * a + @h * d + @i * g
		@h = @g * b + @h * e + @i * h
		@i = @g * c + @h * f + @i * i
		
	@IDENTITY: new Matrix3(
		1, 0, 0,
		0, 1, 0,
		0, 0, 1
	)
	
	@BERNSTEIN: new Matrix3(
		 1,  0,  0,
		-2,  2,  0,
		 1, -2,  1
	)
	
	@rotateX: (theta) ->
		sinT = Math.sin(theta)
		cosT = Math.cos(theta)
		new Matrix3(
			1,    0,     0,
			0,    cosT, -sinT,
			0,    sinT,  cosT
		)

	@rotateY: (theta) ->
		sinT = Math.sin(theta)
		cosT = Math.cos(theta)
		new Matrix3(
			 cosT, 0,    sinT,
			 0,    1,    0,
			-sinT, 0,    cosT
		)

	@rotateZ: (theta) ->
		sinT = Math.sin(theta)
		cosT = Math.cos(theta)
		new Matrix3(
			cosT, -sinT,  0,
			sinT,  cosT,  0,
			0,     0,     1
		)

	@rotate: ({x, y, z}, theta) ->
		sinT = Math.sin(theta)
		cosT = Math.cos(theta)
		minCosT = 1 - cosT
		new Matrix3(
			cosT + x * x * minCosT,     x * y * minCosT - z * sinT, x * z * minCosT + y * sinT,
			y * x * minCosT + z * sinT, cosT + y * y * minCosT,     y * z * minCosT - x * sinT,
			z * x * minCosT - y * sinT, z * y * minCosT + x * sinT, cosT + z * z * minCosT
		)

class @Matrix4
	constructor: (args...) ->
		if args.length is 1
			if args[0].a?
				{@a, @b, @c, @d,
				 @e, @f, @g, @h,
				 @i, @j, @k, @l,
				 @m, @n, @o, @p} = args[0]
			else
				[@a, @b, @c, @d,
				 @e, @f, @g, @h,
				 @i, @j, @k, @l,
				 @m, @n, @o, @p] = args[0]
		else
			[@a, @b, @c, @d,
			 @e, @f, @g, @h,
			 @i, @j, @k, @l,
			 @m, @n, @o, @p] = args

	equals: ({
		a, b, c, d,
		e, f, g, h,
		i, j, k, l,
		m, n, o, p
	}) ->
		@a is a and @b is b and @c is c and @d is d and
		@e is e and @f is f and @g is g and @h is h and
		@i is i and @j is j and @k is k and @l is l and
		@m is m and @n is n and @o is o and @p is p

	trans: ({x, y, z, w}) ->
		new Vector4(
			@a * x + @b * y + @c * z + @d * w,
			@e * x + @f * y + @g * z + @h * w,
			@i * x + @j * y + @k * z + @l * w,
			@m * x + @n * y + @o * z + @p * w
		)

	mult: ({
		a, b, c, d,
		e, f, g, h,
		i, j, k, l,
		m, n, o, p
	}) ->
		@a = @a * a + @b * e + @c * i + @d * m
		@b = @a * b + @b * f + @c * j + @d * n
		@c = @a * c + @b * g + @c * k + @d * o
		@d = @a * d + @b * h + @c * l + @d * p
		@e = @e * a + @f * e + @g * i + @h * m
		@f = @e * b + @f * f + @g * j + @h * n
		@g = @e * c + @f * g + @g * k + @h * o
		@h = @e * d + @f * h + @g * l + @h * p
		@i = @i * a + @j * e + @k * i + @l * m
		@j = @i * b + @j * f + @k * j + @l * n
		@k = @i * c + @j * g + @k * k + @l * o
		@l = @i * d + @j * h + @k * l + @l * p
		@m = @m * a + @n * e + @o * i + @p * m
		@n = @m * b + @n * f + @o * j + @p * n
		@o = @m * c + @n * g + @o * k + @p * o
		@p = @m * d + @n * h + @o * l + @p * p
		
	@IDENTITY: new Matrix4(
		1, 0, 0, 0,
		0, 1, 0, 0,
		0, 0, 1, 0,
		0, 0, 0, 1
	)
	
	@BERNSTEIN: new Matrix4(
		 1,  0,  0,  0,
		-3,  3,  0,  0,
		 3, -6,  3,  0,
		-1,  3, -3,  1
	)
		
	@HERMITE: new Matrix4(
		 2, -2,  1,  1,
		-3,  3, -2, -1,
		 0,  0,  1,  0,
		 1,  0,  0,  0
	)
		
	@rotateX: (theta) ->
		sinT = Math.sin(theta)
		cosT = Math.cos(theta)
		new Matrix4(
			1,     0,     0,     0,
			0,     cosT, -sinT,  0,
			0,     sinT,  cosT,  0,
			0,     0,     0,     1
		)

	@rotateY: (theta) ->
		sinT = Math.sin(theta)
		cosT = Math.cos(theta)
		new Matrix4(
			 cosT, 0,    sinT, 0,
			 0,    1,    0,    0,
			-sinT, 0,    cosT, 0,
			 0,    0,    0,    1
		)

	@rotateZ: (theta) ->
		sinT = Math.sin(theta)
		cosT = Math.cos(theta)
		new Matrix4(
			cosT, -sinT,  0,     0,
			sinT,  cosT,  0,     0,
			0,     0,     1,     0,
			0,     0,     0,     1
		)

	@rotate: ({x, y, z}, theta) ->
		sinT = Math.sin(theta)
		cosT = Math.cos(theta)
		minCosT = 1 - cosT
		new Matrix4(
			cosT + x * x * minCosT,     x * y * minCosT - z * sinT, x * z * minCosT + y * sinT, 0,
			y * x * minCosT + z * sinT, cosT + y * y * minCosT,     y * z * minCosT - x * sinT, 0,
			z * x * minCosT - y * sinT, z * y * minCosT + x * sinT, cosT + z * z * minCosT,     0,
			0,                          0,                          0,                          1
		)
	