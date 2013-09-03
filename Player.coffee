
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