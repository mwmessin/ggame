class @Level
	constructor: ({name, grid, beings, items}) ->
		@name = name
		@grid = grid

		element = @element = $("<div>", class: "level")
		tilespace = @tilespace = $("<div>").addClass("tilespace").appendTo(element)
		beingspace = @beingspace = $("<div>").addClass("beingspace").appendTo(element)
		infospace = @infospace = $("<div>").addClass("infospace").appendTo(element)

		rows = grid.length
		for row, i in grid
			y = rows - i - 1
			for tile, x in row
				continue unless tile?
				extend tile, game.tiles[tile.name]
				extend tile, 
					parent: tilespace
					location: [x * 24, y * 24]
				row[x] = new Tile(tile)
				@orientTile(x, y)
		
		for being in beings
			game.engine.add(
				new Being(union being, game.beings[being.kind], parent: beingspace)
			)

		for item in items
			game.engine.add(
				new Item(union item, game.items[item.kind], parent: beingspace)
			)
	
	save: ->
		beings = []
		items = []
		for body in game.engine.system
			if body.isBeing then beings.push body.save()
			else if body.isItem then items.push body.save()

		name: @name
		grid: ((tile?.save() for tile in row) for row in @grid)
		beings: beings
		items: items
	
	collide: (object, width = 24, height = 24) ->
		{x1, x2, y1, y2} = object
		for y in [(y1 / height | 0)..(y2 / height | 0)]
			row = @grid[@grid.length - y - 1]
			if row then for x in [(x1 / width | 0)..(x2 / width | 0)]
				if row[x]?.z > object.z
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
		return null if x < 0 or y < 0
		grid = @grid
		row = grid[grid.length - y - 1]
		tile = (if row then row[x] else null)
		(if tile and tile.isTile then tile else null)

	elevation: (x, y, z) ->
		tile = @tile(x, y)

		return tile.z if z is null

		tile.z = z
		
		[
			tl,  t,    tr
			l,   tile, r
			bl,  b,    br
		] = [
			@tile(x - 1, y + 1) or {}, @tile(x, y + 1) or {}, @tile(x + 1, y + 1) or {}
			@tile(x - 1, y) or {},     tile,                  @tile(x + 1, y) or {}
			@tile(x - 1, y - 1) or {}, @tile(x, y - 1) or {}, @tile(x + 1, y - 1) or {}
		]

		#@elevation(x - 1, y + 1, z - 1) if tl.z < z - 1
		#@elevation(x - 1, y + 1, z + 1) if tl.z > z + 1

		#@elevation(x, y + 1, z - 1) if t.z < z - 1
		#@elevation(x, y + 1, z + 1) if t.z > z + 1

		#@elevation(x + 1, y + 1, z - 1) if tr.z < z - 1
		#@elevation(x + 1, y + 1, z + 1) if tr.z > z + 1

		@elevation(x - 1, y, z - 1) if l.z < z - 1
		@elevation(x - 1, y, z + 1) if l.z > z + 1

		@elevation(x + 1, y, z - 1) if r.z < z - 1
		@elevation(x + 1, y, z + 1) if r.z > z + 1

		@elevation(x - 1, y - 1, z - 1) if bl.z < z - 1
		@elevation(x - 1, y - 1, z + 1) if bl.z > z + 1

		@elevation(x, y - 1, z - 1) if b.z < z - 1
		@elevation(x, y - 1, z + 1) if b.z > z + 1

		@elevation(x + 1, y - 1, z - 1) if br.z < z - 1
		@elevation(x + 1, y - 1, z + 1) if br.z > z + 1

		@orientTile(x, y)

	removeTile: (x, y) ->
		tile = @tile(x, y)
		game.engine.remove(tile)
		@grid[y][x] = null
	
	orientTile: (x, y, noRecurse) ->
		tile = @tile(x, y)
		return if !tile?
		{name, z} = tile
		
		[
			ttl, tt,   ttr
			tl,  t,    tr
			l,   tile, r
			bl,  b,    br
		] = [
			@tile(x - 1, y + 2) or {}, @tile(x, y + 2) or {}, @tile(x + 1, y + 2) or {}
			@tile(x - 1, y + 1) or {}, @tile(x, y + 1) or {}, @tile(x + 1, y + 1) or {}
			@tile(x - 1, y) or {},     tile,                  @tile(x + 1, y) or {}
			@tile(x - 1, y - 1) or {}, @tile(x, y - 1) or {}, @tile(x + 1, y - 1) or {}
		]

		top = t.z >= z and t.name is name
		left = l.z >= z and l.name is name
		right = r.z >= z and r.name is name
		bottom = b.z >= z and b.name is name

		orientation = "normal"
		orientation = "normal" if top and left and bottom and right
		orientation = "right" if top and left and bottom and !right
		orientation = "bottom" if top and left and !bottom and right
		orientation = "left" if top and !left and bottom and right
		orientation = "normal" if !top and !left and bottom and right
		orientation = "normal" if !top and left and bottom and !right
		orientation = "bottomright" if top and left and !bottom and !right
		orientation = "bottomleft" if top and !left and !bottom and right
		orientation = "vertical" if top and !left and bottom and !right
		orientation = "tipbottom" if top and !left and !bottom and !right
		orientation = "normal" if !top and !left and bottom and !right
		orientation = "normal" if !top and !left and !bottom and right
		orientation = "normal" if !top and left and !bottom and !right
		orientation = "normal" if !top and !left and !bottom and !right

		orientation += " column" if t.z > z and tt.z <= z and tl.z <= z and tr.z <= z
		orientation += " columnleft" if t.z > z and tt.z <= z and tr.z > z and tl.z <= z
		orientation += " columnright" if t.z > z and tt.z <= z and tl.z > z and tr.z <= z
		orientation += " wall" if tl.z > z and t.z > z and tr.z > z or tt.z > z and tl.z <= z and t.z > z and tr.z <= z
		orientation += " wallleft" if tt.z > z and tl.z <= z and t.z > z and tr.z > z
		orientation += " wallright" if tt.z > z and tl.z > z and t.z > z and tr.z <= z
		orientation += " wallbottomleft" if ttr.z > t.z and tr.z > t.z and (tl.z <= t.z or ttl.z <= t.z)
		orientation += " wallbottomright" if ttl.z > t.z and tl.z > t.z and (tr.z <= t.z or ttr.z <= t.z)
		orientation += " cheeks" if ttl.z > t.z and ttr.z > t.z and tl.z > t.z and tr.z > t.z
		orientation += " slopeleft" if tr.z > z and r.z > z and (l.z <= z or tl.z <= z)
		orientation += " sloperight" if tl.z > z and l.z > z and (r.z <= z or tr.z <= z)
		orientation += " twinpeaks" if tl.z > z and tr.z > z and l.z > z and r.z > z

		orientation += " top"		if t.z < z and l.z > t.z and b.z > t.z and r.z > t.z
		orientation += " horizontal" if !top and left and !bottom and right
		orientation += " topleft"	if !top and !left and bottom and right
		orientation += " topright"	if !top and left and bottom and !right
		orientation += " tipleft"	if !top and !left and !bottom and right
		orientation += " tipright"	if !top and left and !bottom and !right
		orientation += " tiptop"	if !top and !left and bottom and !right
		orientation += " island"	if !top and !left and !bottom and !right

		tile.orient(orientation)

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


	generateTerrain: (order = 1) ->
		segments = Math.pow(2, order)

		grid = []
		for x in [0..segments]
			col = grid[x] = []
			for y in [0..segments]
				col[y] = 0.0

		random = (factor) -> (Math.random() - 0.5) * 2 * factor

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
					grid[y + half][x + half] = average + random(factor)
					x += length
				y += length	

			#diamond step
			y = half
			while y < segments
				x = half
				while x < segments
					#top
					if y is half 
						average = (
							grid[(y - length + segments) % segments][x] + 
							grid[y - half][x + half] + 
							grid[y][x] + 
							grid[y - half][x - half]
						) / 4
						grid[y - half][x] = average + random(factor)

					#right
					average = (
						grid[y - half][x + half] + 
						grid[y][(x + length + segments) % segments] + 
						grid[y + half][x + half] + 
						grid[y][x]
					) / 4
					grid[y][x + half] = average + random(factor)

					#bottom
					average = (
						grid[y][x] + 
						grid[y + half][x + half] + 
						grid[(y + length + segments) % segments][x] + 
						grid[y + half][x - half]
					) / 4
					grid[y + half][x] = average + random(factor)

					#left
					if x is half
						average = (
							grid[y - half][x - half] + 
							grid[y][x] + 
							grid[y + half][x - half] + 
							grid[y][(x - length + segments) % segments]
						) / 4
						grid[y][x - half] = average + random(factor)

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

	canvasTerrain: (terrain) ->
		width = terrain.length

		$("body").append(
			canvas = $("<canvas>"
				css:
					border: "1px solid green"
			)
			.attr(
				width: width
				height: width
			)
		)
		
		context = canvas[0].getContext("2d")
		frame = {data} = context.getImageData(0, 0, width, width)
		
		setPixel = (x, y, r, g, b, a) ->
			index = (x + y * width) * 4
			data[index + 0] = r
			data[index + 1] = g
			data[index + 2] = b
			data[index + 3] = a

		for x in [0...width]
			for y in [0...width]
				v = (terrain[x][y].z + 1) / 2 * 255 | 0
				setPixel(x, y, v, v, v, 255)

		context.putImageData(frame, 0, 0)

	logTerrain: (terrain) ->
		for x in terrain
			msg = ""
			for y in x
				msg += y.z.toFixed(2) + " "
			console.log msg
			