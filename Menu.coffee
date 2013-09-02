
class @Menu
	constructor: ({options}) ->
		@element = $('<div>')
		.css('display', 'none')
		.addClass('contextmenu')
		.appendTo(game.level.infospace)
		
		for name, option of options
			new Option(union option, 
				name: name
				parent: @element
			)
		
	location: ({@x, @y}) ->
		if arguments.length == 0
			return {x: @x, y: @y}
		else
			@element.css(
				left: @x + 'px'
				bottom: @y + 'px'
			)
		this
		
	hidden: (what) ->
		if arguments.length == 0
			return @element.css('display') is 'none'
		else
			@element.css('display', if what then 'none' else 'block')
		this

	@main:
		beings:
			icon: "imgs/unit.png"
			action: -> 
				for name, being in game.beings
					new Option(
						name: name
						parent: @element
					)
		terrain:
			icon: "imgs/sprites.png"
			action: -> new Animation.Editor
		items:
			icon: "imgs/tree.png"
			action: -> 
		abilities:
			icon: "imgs/rock.png"
			action: -> 


class @Option
	constructor: ({icon, @name, @action, @parent}) ->
		$('<div>')
		.addClass('option glossy')
		.append($('<img>').attr('src', icon))
		.append($('<span>').text(@name))
		.mousedown(@mousedown)
		.appendTo(@parent)
		
	mousedown: ({which}) =>
		if which is 1
			@action()
