class @Game
	constructor: ({beings, tiles, items, levels}) ->
		window.game = this
		
		$('body').append(
			@view = $('<div>', class: 'view')
		)
		
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

		#levels[0].grid = @generateTerrain()
		
		@engine = new Engine()
		@level = new Level(levels[0])
		@control = new Control()
	
	save: ->
		beings: @beings
		tiles: @tiles
		items: @items
		levels: [@level.save()]

	generateTerrain: (order = 1) ->
		segments = Math.pow(2, order)

		grid = []
		for x in [0..segments]
			col = grid[x] = []
			for y in [0..segments]
				col[y] = 0.0

		factor = 1
		length = segments
		while length >= 2
			half = length / 2

			#square step
			y = 0
			while y < segments
				x = 0
				while x < segments
					average = (
						grid[y][x] + 
						grid[y + length][x] + 
						grid[y][x + length] + 
						grid[y + length][x + length]
					) / 4
					grid[y + half][x + half] = average + Math.random() * factor
					x += length
				y += length	

			#diamond step
			y = 0
			while y < segments
				x = (y + half) % length
				while x < segments
					average = (
						grid[(y - half + segments) % segments][x] + 
						grid[(y + half) % segments][x] + 
						grid[y][(x + half) % segments] + 
						grid[y][(x - half + segments) % segments]
					) / 4
					grid[y][x] = average + Math.random() * factor
					grid[segments][x] = average + Math.random() * factor if y is 0
					grid[y][segments] = average + Math.random() * factor if x is 0
					x += length
				y += length	

			length /= 2
			factor /= 2

		terrain = []
		for col, x in grid
			terrain[x] = []
			for z, y in col
				terrain[x][y] = {name: 'dirt', z: z}

		terrain

class @Engine
	constructor: (options) ->
		@system = []
		@t0 = Time()
		Frame(@cycle)

	cycle: =>
		Frame(@cycle)
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
		hero = game.players[0].heroes[0]
		center = if hero then hero.center() else {x: 0, y: 0}
		game.level.element.css(
			left: $(window).width() / 2 - center.x
			bottom: $(window).height() / 2 - center.y
		)

	at: (point) ->
		result = []
		for object in @system
			result.push(object) if object.contains(point)
		result

	add: (object) ->
		@system.push object

	remove: (object) ->
		@system.remove object

class @Control
	constructor: (options) ->
		$(window)
		.keydown(@keydown)
		.keyup(@keyup)
		.mousedown(@mousedown)
		.mouseup(@mouseup)
		.mousemove(@mousemove)
		
		window.oncontextmenu = -> false
		
		@menu = new Menu(
			options: Menu.main
		)
		
		@use('default')
	
	mousedown: ({which}) =>
		if which is 1
			Mouse.left = true
			if @menu.hidden()
				@tool.mousedown(Mouse.x, $(window).height() - Mouse.y) if @tool.mousedown
				@tool.paint(Mouse.x, $(window).height() - Mouse.y) if @tool.paint
			else
				@menu.hidden(true)
		else if which is 3
			Mouse.right = true
			if @menu.hidden()
				level = game.level
				x = Mouse.x - parseInt(level.element.css('left'))
				y = $(window).height() - Mouse.y - parseInt(level.element.css('bottom'))
				@menu
				.location({x: x, y: y})
				.hidden(false)
			else
				@menu.hidden(true)
	
	mouseup: ({which}) =>
		if which is 1
			if not @dragging
				@tool.click(Mouse.x, $(window).height() - Mouse.y) if @tool.click
			@dragging = false
			Mouse.left = false
	
	mousemove: ({pageX, pageY}) =>
		Mouse.x = pageX
		Mouse.y = pageY
		if Mouse.left
			@dragging = true
			@tool.paint(pageX, $(window).height() - pageY) if @tool.paint
		false
	
	keydown: ({which}) =>
		key = Key(which)
		if Keyboard[key] is true
			return false
		Keyboard[key] = true
		console.log which
		switch key
			when "z"
				console.log "undo" if Keyboard["ctrl"]
			when "1"
				@use "ground"
			when "2"
				@use "raise"
			when "3"
				@use "lower"
			when "4"
				@use "forest"
			when "0"
				input = $("textarea")
				if input.length
					json = input.text()
					input.remove()
					$(".view").remove()
					new Game(JSON.parse(json))
				else
					$(".view").empty()
					$("<textarea>")
					.text(JSON.stringify(game.save()).pretty())
					.appendTo(".view")
			when "w", "d", "s", "a", "p", "'", ";", "l"
				@arrows()
	
	keyup: ({which}) =>
		key = Key(which)
		Keyboard[key] = false
		switch key
			when "w", "d", "s", "a", "p", "'", ";", "l"
				@arrows()
	
	use: (toolName) ->
		console.log toolName
		tool = @tool = Control.tools[toolName]
		$("#tool").text(toolName)
		$("body").css("cursor", tool.cursor)
	
	arrows: ->
		{w, d, s, a} = Keyboard
		@command game.players[0].hero(), new Vector2(
			(if a then -1 else 0) + (if d then 1 else 0),
			(if w then 1 else 0) + (if s then -1 else 0)
		)
	
	command: (hero, direction) ->
		hero.direction = direction.normalize().times(hero.speed / 100)
		if direction.length() > 0
			angle = direction.angle() / Math.PI * 180
			if angle < 45 or angle > 315
				anim = "walkRight"
			else if 45 < angle < 135
				anim = "walkUp"
			else if 135 < angle < 225
				anim = "walkLeft"
			else
				anim = "walkDown"
			hero.play(anim)
	
	@tools:
		'default':
			cursor: "crosshair"
			click: (x, y) ->
				console.log x, y
			paint: (x, y) ->
				x -= parseInt(game.level.element.css('left'))
				y -= parseInt(game.level.element.css('bottom'))
				game.players[0].hero().center(new Vector2(x, y))
		unit:
			cursor: "crosshair"
			paint: (x, y) ->
				new Being(
					kind: 'z'
					owner: 0
					location: [x, y]
				)
		ground:
			icon: "imgs/tile.cur"
			cursor: "url('imgs/tile.cur') 8 4, crosshair"
			paint: (x, y) ->
				x -= parseInt(game.level.element.css('left'))
				y -= parseInt(game.level.element.css('bottom'))
				x = x / 24 | 0
				y = y / 24 | 0
				tileset = game.tiles
				level = game.level
				grid = level.grid
				return if x < 0 or y < 0
				index = grid.length - y - 1
				if index < 0
					grid.unshift(([] for num in [0...-index])...)
					index = 0
				grid[index] = [] unless grid[index]
				return if grid[index][x]
				tile =
					name: "dirt"
					z: 0
				extend tile, tileset["dirt"]
				extend tile,
					parent: level.tilespace
					location: [ x * 24, y * 24 ]
				grid[index][x] = new Tile(tile)
				level.orientTile(x, y)
		raise:
			icon: "imgs/raise.cur"
			cursor: "url('imgs/raise.cur') 8 8, crosshair"
			mousedown: (x, y) ->
				level = game.level
				x -= parseInt(level.element.css('left'))
				y -= parseInt(level.element.css('bottom'))
				x = x / 24 | 0
				y = y / 24 | 0
				return if x < 0 or y < 0
				@z = level.tile(x, y).z + 1
			paint: (x, y) ->
				level = game.level
				x -= parseInt(level.element.css('left'))
				y -= parseInt(level.element.css('bottom'))
				x = x / 24 | 0
				y = y / 24 | 0
				return if x < 0 or y < 0
				level.elevation(x, y, @z)
		lower:
			icon: "imgs/lower.cur"
			cursor: "url('imgs/lower.cur') 8 8, crosshair"
			mousedown: (x, y) ->
				level = game.level
				x -= parseInt(level.element.css('left'))
				y -= parseInt(level.element.css('bottom'))
				x = x / 24 | 0
				y = y / 24 | 0
				return if x < 0 or y < 0
				@z = level.tile(x, y).z - 1
			paint: (x, y) ->
				level = game.level
				x -= parseInt(level.element.css('left'))
				y -= parseInt(level.element.css('bottom'))
				x = x / 24 | 0
				y = y / 24 | 0
				return if x < 0 or y < 0
				level.elevation(x, y, @z)
		forest:
			icon: "imgs/tree.cur"
			cursor: "url('imgs/tree.cur') 8 8, crosshair"
			mousedown: (x, y) ->
				level = game.level
				x -= parseInt(level.element.css('left'))
				y -= parseInt(level.element.css('bottom'))
				return if x < 0 or y < 0
				being = new Being(extend {
					parent: $(".beingspace")
					kind: 'bigtree'
					z: 1
					center: [x,y]
				}, game.beings['bigtree'])
				game.engine.add(being)

@Mouse =
	x: 0
	y: 0

@Keyboard = {}

@Key = (code) -> {
	17: "ctrl"
	18: "alt"
	37: "left"
	38: "up"
	39: "right"
	40: "down"
	191: "/"
	190: "."
	188: ","
	186: ";"
	219: "["
	221: "]"
	222: "'"
}[code] or String.fromCharCode(code).toLowerCase()
