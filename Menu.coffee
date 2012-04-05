
class @Item
	constructor: ({icon, @name, @parent}) ->
		$('<div>')
		.addClass('option glossy')
		.append($('<img>').attr('src', icon))
		.append($('<span>').text(@name))
		.mousedown(@mousedown)
		.appendTo(@parent)
		
	mousedown: ({which}) =>
		if which is 1
			game.control.use(@name)

class @Menu
	constructor: ({items}) ->
		@element = $('<div>').css('display', 'none').addClass('contextmenu').appendTo(game.level.infospace)
		
		for name, item of items
			new Item (
				icon: item.icon
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
