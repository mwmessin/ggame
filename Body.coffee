
class @Body extends Sprite
	constructor: (options) ->
		super options
		@direction = new Vector2(options.direction or [ 0, 0 ])
		@dimensions = new Vector2(options.dimensions or [ 0, 0 ])
		@offset = new Vector2(options.offset or [ 0, 0 ])
		@velocity = new Vector2(options.velocity or [ 0, 0 ])
		if options.center
			@center(new Vector2(options.center))
		else
			@put(@location)
		@z = options.z or 0
	
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
	
	center: (point) ->
		if point?
			@put(point.minus(@offset).minus(@dimensions.times(0.50)))
		else
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
			