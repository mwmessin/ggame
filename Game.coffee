class @Game
	constructor: ({beings, tiles, items, levels}) ->
		window.game = this
		window.oncontextmenu = -> false
		
		
		@view = $('<div>',
			class: 'view'
		)
		.appendTo('body')
		
		@players = [
			new Player(
				name: '13lur'
				id: 0
			)
			new Player(
				name: 'Penny'
				id: 1
			) 
		]
		
		@engine = new Engine()
		@beings = beings
		@tiles = tiles
		@items = items
		@level = new Level(levels[0])
		@control = new Control()
	
	save: ->
		beings: @beings
		tiles: @tiles
		items: @items
		levels: [@level.save()]
		
class @Engine
	constructor: (options) ->
		@system = []
		@t0 = Time()
		Frame(@cycle)

	cycle: =>
		t = Time()
		dt = t - @t0
		for object in @system
			object.cycle?(dt)
		for object in @system
			for subject in @system when subject isnt object
				if object.overlaps?(subject)
					object.collide?(subject)
			game.level.collide(object)
		for object in @system
			object.draw?(t)
		@t0 = t
		Frame(@cycle)

	at: (point) ->
		result = []
		for object in @system
			result.push(object) if object.contains(point)
		result

	add: (object) ->
		@system.push object

	remove: (object) ->
		@system.remove object
