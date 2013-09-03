
class @Sprite
	constructor: ({location, width, height, spritemap, animations, parent}) ->
		@location = location = new Vector2(location or [ 0, 0 ])
		parent.append(
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
		)
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