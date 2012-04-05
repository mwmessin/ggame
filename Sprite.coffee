
class @Animation
	constructor: ({@frames, @extrap}) ->

	frame: (t) ->
		frames = @frames
		current = @current
		tFinal = frames.last()[2] or 0
		extrap = @extrap
		if extrap is 'loop'
			t = t % tFinal
		else if extrap is 'mirror'
			tDirection = (t / tFinal | 0) % 2
			tLoop = t % tFinal
			t = tDirection * (tFinal - tLoop) + tLoop * (1 - tDirection)
		else if extrap is 'reset'
			t = (if t > tFinal then 0 else t)
		else
			t = (if t > tFinal then tFinal else t)
		frame = undefined
		if frames[1] and t < frames[1][2]
			@current = 0
			frame = frames[0]
		else if frames[current + 1] and t >= frames[current + 1][2]
			@current = current + 1
			frame = frames[current + 1]
		frame
		
class @Animation.Editor
	constructor: ->
		

class @Sprite
	constructor: ({location, width, height, spritemap, animations, parent}) ->
		@location = location = new Vector2(location or [ 0, 0 ])
		@element = $('<div>',
			'class': 'sprite'
			css: 
				width: width + 'px'
				height: height + 'px'
				left: location.x|0 + 'px'
				bottom: location.y|0 + 'px'
				zIndex: $(window).height() - location.y | 0
				background: 'url(' + spritemap + ')'
		)
		.appendTo(parent)
		
		@animations = animations
		@spritemap = spritemap

	fin: ->
		@element.remove()

	animate: (time) ->
		animation = @animation
		if animation
			t = time - @animStart
			frame = animation.frame(t)
			if frame
				@element.css(
					backgroundPosition: -frame[0] + 'px ' + -frame[1] + 'px'
				)
		this

	play: (name) ->
		animation = @animation = new Animation(@animations[name])
		@animate(@animStart = Time())
		this

	draw: (time) ->
		location = @location
		@element.css(
			left: (location.x | 0) + 'px'
			bottom: (location.y | 0) + 'px'
			zIndex: $(window).height() - location.y | 0
		)
		@animate(time)
		this

class @Body extends Sprite
	constructor: (options) ->
		super options
		@direction = new Vector2(options.direction or [ 0, 0 ])
		@dimensions = new Vector2(options.dimensions or [ 0, 0 ])
		@offset = new Vector2(options.offset or [ 0, 0 ])
		@velocity = new Vector2(options.velocity or [ 0, 0 ])
		@put @location
	
	put: (point) ->
		@location = point
		@x1 = point.x + @offset.x
		@x2 = @x1 + @dimensions.x
		@y1 = point.y + @offset.y
		@y2 = @y1 + @dimensions.y
	
	move: (vector) ->
		@put(@location.plus(vector))
	
	cycle: (dt) ->
		v = @velocity = @direction
		dx = v.x * dt
		dy = v.y * dt
		@location.x += dx
		@x1 += dx
		@x2 += dx
		@location.y += dy
		@y1 += dy
		@y2 += dy
		this
	
	center: ->
		@location.plus(@offset).plus(@dimensions.times(0.50))
	
	contains: (point) ->
		@x1 < point.x and @x2 > point.x and @y1 < point.y and @y2 > point.y
	
	overlaps: (another) ->
		@x1 < another.x2 and @x2 > another.x1 and @y1 < another.y2 and @y2 > another.y1
	
	collide: (another) ->
		{x1, x2, y1, y2} = another
		dx1 = x1 - @x2
		dx2 = x2 - @x1
		dy1 = y1 - @y2
		dy2 = y2 - @y1
		dx = (if Math.abs(dx1) < Math.abs(dx2) then dx1 else dx2)
		dy = (if Math.abs(dy1) < Math.abs(dy2) then dy1 else dy2)
		if Math.abs(dx) < Math.abs(dy)
			@put @location.plus(new Vector2(dx / 2, 0))
			another.move(new Vector2(-dx / 2, 0))
		else
			@put @location.plus(new Vector2(0, dy / 2))
			another.move(new Vector2(0, -dy / 2))

class @Being extends Body
	constructor: (options) ->
		super options
		@kind = options.kind
		@owner = options.owner
		@orders = options.orders or 'none'
		@experience = options.experience or [ 1, 1 ]
		@life = options.life or [ 1, 1 ]
		@energy = options.energy or [ 1, 1 ]
		@shields = options.shields or [ 1, 1 ]
		@strength = options.strength or [ 1, 1 ]
		@agility = options.agility or [ 1, 1 ]
		@intelligence = options.intelligence or [ 1, 1 ]
		@fortitude = options.fortitude or [ 1, 1 ]
		@charisma = options.charisma or [ 1, 1 ]
		@speed = options.speed or [ 0.05, 0.05 ]
		@abilities = options.abilities or []

	save: ->
		kind: @kind
		owner: @owner
		location: @location

class @Tile extends Sprite
	isTile: true
	
	constructor: (options) ->
		super options
		{@name, @orientations, @z} = options

	save: ->
		name: @name
		z: @z

	orient: (orientations) ->
		layers = []
		backgrounds = []
		names = orientations.split(' ').reverse()
		i = 0
		name = undefined

		for name in names
			orientation = @orientations[name]
			x = orientation[0]
			y = orientation[1]
			backgrounds.push('url(' + @spritemap + ') ' + -x + 'px ' + -y + 'px')
		@element.css('background', backgrounds.join(', '))
