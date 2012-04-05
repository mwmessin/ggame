
class @Player
	constructor: ({name, heroes, gold, diplomacy}) ->
		@name = name
		@heroes = heroes or []
		@gold = gold or 0
		@diplomacy = diplomacy or {}

	ally: (id) ->
		delete @diplomacy[id]

	unally: (id) ->
		@diplomacy[id] = true

	hero: (id) ->
		@heroes[id or 0]

class @Control
	constructor: (options) ->
		$(window)
		.keydown(@keydown)
		.keyup(@keyup)
		.mousedown(@mousedown)
		.mouseup(@mouseup)
		.mousemove(@mousemove)
		
		@menu = new Menu(
			items: Control.tools
		)
		
		@use("ground")
	
	mousedown: ({which}) =>
		if which is 1
			Mouse.left = true
			if @menu.hidden()
				@tool.paint(Mouse.x, $(window).height() - Mouse.y)
			else
				@menu.hidden(true)
		else if which is 3
			if @menu.hidden()
				@menu
				.location({x: Mouse.x, y: $(window).height() - Mouse.y})
				.hidden(false)
			else
				@menu.hidden(true)
	
	mouseup: ({which}) =>
		if which is 1
			Mouse.left = false
	
	mousemove: ({pageX, pageY}) =>
		Mouse.x = pageX
		Mouse.y = pageY
		if Mouse.left
			@tool.paint(pageX, $(window).height() - pageY)
		false
	
	keydown: ({which}) =>
		key = Key(which)
		console.log(key)
		if Keyboard[key] is true
			return false
		Keyboard[key] = true
		switch key
			when "1"
				@use "ground"
			when "2"
				@use "raise"
			when "3"
				@use "move"
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
		hero.direction = direction.length(hero.speed[0])
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
		move:
			cursor: "crosshair"
			paint: (x, y) ->
				game.players[0].hero().put new Vector2(x, y)
		unit:
			cursor: "crosshair"
			paint: (x, y) ->
				console.log(x, y)
		ground:
			icon: "imgs/c1.cur"
			cursor: "url('imgs/c1.cur') 8 4, crosshair"
			paint: (x, y) ->
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
			icon: "imgs/c2.cur"
			cursor: "url('imgs/c2.cur') 8 8, crosshair"
			paint: (x, y) ->
				x = x / 24 | 0
				y = y / 24 | 0
				level = game.level
				grid = level.grid
				return if x < 0 or y < 0
				level.tile(x, y).z = 1
				level.orientTile x, y

