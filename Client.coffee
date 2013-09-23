class @Client
	constructor: ({beings, tiles, items, levels}) ->
		window.game = this
		
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
		
		@beings = beings
		@tiles = tiles
		@items = items

		@engine = new Engine()
		@control = new Control()
		@level = new Level(levels[0])
		
		@view = $('<div>', class: 'view').append(@level.element)
		$('body').append(@view)

	fin: ->
		@view.remove()
		
		@control.fin()

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
		Frame(@cycle)
		t = Time()
		dt = t - @t0
		for body in @system
			body.cycle?(dt)
		for body in @system
			for subject in @system when subject isnt body
				if body.overlaps?(subject)
					body.collide?(subject)
			game.level.collide(body)
		for body in @system
			body.draw?(t)
		@t0 = t
		hero = game.players[0].heroes[0]
		center = if hero then hero.center() else {x: 0, y: 0}
		game.level.element.css(
			left: $(window).width() / 2 - center.x
			bottom: $(window).height() / 2 - center.y
		)

	at: (point) ->
		result = []
		for body in @system
			result.push(body) if body.contains(point)
		result

	add: (body) ->
		@system.push body

	remove: (body) ->
		@system.remove body

