
class @Tile extends Sprite
	isTile: true
	
	constructor: (options) ->
		super options
		{@name, @orientations, @z, @walkable, @swimable, @flyable} = options

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
