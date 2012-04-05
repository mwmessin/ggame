class @Level
	constructor: ({name, grid, beings}) ->
		engine = game.engine
		tileset = game.tiles
		beingset = game.beings
		@name = name
		@grid = grid
		element = @element = $("<div>")
		tilespace = @tilespace = $("<div>")
		beingspace = @beingspace = $("<div>")
		infospace = @infospace = $("<div>")
		tilespace.addClass("tilespace").appendTo element
		beingspace.addClass("beingspace").appendTo element
		infospace.addClass("infospace").appendTo element
		element.addClass("level").appendTo game.view
		rows = grid.length
		
		for row, i in grid
			y = rows - i - 1
			for tile, x in row
				continue unless tile?
				extend tile, tileset[tile.name] 
				extend tile, 
					parent: tilespace
					location: [x * 24, y * 24]
				row[x] = new Tile(tile)
				@orientTile(x, y)
		
		for being in beings
			owner = being.owner
			extend being, beingset[being.kind]
			extend being,
				parent: beingspace
			being = new Being(being)
			game.players[owner]?.heroes.push(being)
			engine.add(being)
	
	save: ->
		name: @name
		grid: ((tile?.save() for tile in row) for row in @grid)
		beings: (being.save() for being in game.engine.system)
	
	collide: (object, width = 24, height = 24) ->
		{x1, x2, y1, y2} = object
		for y in [(y1 / height | 0)..(y2 / height | 0)]
			row = @grid[@grid.length - y - 1]
			if row then for x in [(x1 / width | 0)..(x2 / width | 0)]
				if row[x]?.z
					dx1 = x1 - (x + 1) * width
					dx2 = x2 - x * width
					dy1 = y1 - (y + 1) * height
					dy2 = y2 - y * height
					dx = (if Math.abs(dx1) < Math.abs(dx2) then dx1 else dx2)
					dy = (if Math.abs(dy1) < Math.abs(dy2) then dy1 else dy2)
					if Math.abs(dx) < Math.abs(dy)
						object.move(new Vector2(-dx, 0))
					else
						object.move(new Vector2(0, -dy))
	
	tile: (x, y) ->
		return null	if x < 0 or y < 0
		grid = @grid
		row = grid[grid.length - y - 1]
		tile = (if row then row[x] else null)
		(if tile and tile.isTile then tile else null)
	
	removeTile: (x, y) ->
		tile = @tile(x, y)
		game.engine.remove(tile)
		@grid[y][x] = null
	
	readtile: (x, y) ->
		tile = @tile(x, y)
		return null	unless tile?
		tile.name
	
	height: (x, y) ->
		tile = @tile(x, y)
		return null	unless tile?
		tile.z
	
	orientTile: (x, y, noRecurse) ->
		tileheight = @height(x, y)
		return	unless tileheight?
		toptopleftheight = @height(x - 1, y + 2)
		toptopheight = @height(x, y + 2)
		toptoprightheight = @height(x + 1, y + 2)
		topleftheight = @height(x - 1, y + 1)
		topheight = @height(x, y + 1)
		bottomheight = @height(x, y - 1)
		toprightheight = @height(x + 1, y + 1)
		leftheight = @height(x - 1, y)
		rightheight = @height(x + 1, y)
		tilename = @readtile(x, y)
		topname = @readtile(x, y + 1)
		rightname = @readtile(x + 1, y)
		bottomname = @readtile(x, y - 1)
		leftname = @readtile(x - 1, y)
		bottomleft = @readtile(x - 1, y - 1)
		bottomright = @readtile(x + 1, y - 1)
		t = topname is tilename and tileheight is topheight
		r = rightname is tilename and tileheight <= rightheight
		b = bottomname is tilename and tileheight <= bottomheight
		l = leftname is tilename and tileheight <= leftheight
		orientation = "normal"
		orientation = "normal"	if t and l and b and r
		orientation = "top"	if not t and l and b and r
		orientation = "right"	if t and l and b and not r
		orientation = "bottom"	if t and l and not b and r
		orientation = "left"	if t and not l and b and r
		orientation = "normal"	if not t and not l and b and r
		orientation = "normal"	if not t and l and b and not r
		orientation = "bottomright"	if t and l and not b and not r
		orientation = "bottomleft"	if t and not l and not b and r
		orientation = "normal"	if not t and not l and not b and not r
		orientation = "vertical"	if t and not l and b and not r
		orientation = "horizontal"	if not t and l and not b and r
		orientation = "tipbottom"	if t and not l and not b and not r
		orientation = "normal"	if not t and not l and not b and r
		orientation = "normal"	if not t and not l and b and not r
		orientation = "normal"	if not t and l and not b and not r
		ttlh = toptopleftheight is 1
		tth = toptopheight is 1
		ttrh = toptoprightheight is 1
		tlh = topleftheight is 1
		th = topheight is 1 and tileheight < topheight
		trh = toprightheight is 1
		lh = leftheight is 1
		h = tileheight is 1
		rh = rightheight is 1
		if tileheight is 0 or not t and not l and b and r or not t and l and b and not r or not t and not l and b and not r or not t and not l and not b and not r
			orientation += " columnleft"	if not tlh and th and trh
			orientation += " column"	if not tth and not tlh and th and not trh
			orientation += " columnright"	if tlh and th and not trh
			orientation += " wallleft"	if tth and not tlh and th and trh
			orientation += " wall"	if tlh and th and trh or tth and not tlh and th and not trh
			orientation += " wallright"	if tth and tlh and th and not trh
			orientation += " wallbottomleft"	if ttrh and not th and trh and (not tlh or not ttlh)
			orientation += " wallbottomright"	if ttlh and tlh and not th and (not trh or not ttrh)
			orientation += " cheeks"	if ttlh and ttrh and tlh and not th and trh
			orientation += " slopeleft"	if trh and rh and (not lh or not tlh)
			orientation += " sloperight"	if tlh and lh and (not rh or not trh)
			orientation += " twinpeaks"	if tlh and trh and lh and rh
		orientation += " topleft"	if not t and not l and b and r
		orientation += " topright"	if not t and l and b and not r
		orientation += " tiptop"	if not t and not l and b and not r
		orientation += " tipleft"	if not t and not l and not b and r
		orientation += " tipright"	if not t and l and not b and not r
		orientation += " island"	if not t and not l and not b and not r
		@tile(x, y).orient orientation
		unless noRecurse
			@orientTile x, y + 1, true
			@orientTile x + 1, y, true
			@orientTile x, y - 1, true
			@orientTile x - 1, y, true
			@orientTile x - 1, y - 1, true
			@orientTile x + 1, y - 1, true
			@orientTile x - 1, y - 2, true
			@orientTile x, y - 2, true
			@orientTile x + 1, y - 2, true
			