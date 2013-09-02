
class @Item extends Body
	constructor: (options) ->
		super options

		{
			@name
			@kind
			@rarity
			@requiredStrength
			@requiredDexterity
			@requiredIntelligence
			@life
			@lifeRegen
			@lifeLeech
			@energy
			@energyRegen
			@energyLeech
			@speed
			@armor
			@dodge
			@critChance
			@critBonus
			@stunChance
			@stunDuration
			@strength
			@dexterity
			@intelligence 
			@vitality
			@greed
			@luck
			@prospecting
		} = options

	@rarityToColor:
		common: "#ffffff"
		uncommon: "#0e82ee"
		set: "#12c227"
		rare: "#7d0eee"
		legendary: "#dfba62"

	save: ->
		kind: @kind
		owner: @owner
		location: @location
