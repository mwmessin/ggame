
class @Being extends Body
	isBeing: true

	constructor: (options) ->
		super options

		options.speed or= 5

		{
			@name
			@kind
			@owner
			@orders
			@weapon
			@headgear
			@armor
			@boots
			@gloves
			@jewelry
			@offHand
			@life
			@lifeMax
			@lifeRegen
			@lifeLeech
			@energy
			@energyMax
			@energyRegen
			@energyLeech
			@speed
			@defense
			@dodge #ranged only
			@critChance
			@critBonus
			@stunChance
			@stunDuration
			@strength #armor, stunChance
			@dexterity #dodge, critBonus
			@intelligence #energy, energy regen
			@vitality #life, life regen
			@greed #gold find
			@luck #item find
			@geology #gem find
		} = options

		@inventory = []

		game.players[@owner]?.heroes.push(this)

	calcDamage: ->
		damage = @weapon.damageMin + Math.random() * (@weapon.damageMax - @weapon.damageMin)
		damage *= 1 + @strength / 100 if /^sword|^axe|^hammer/.test(@weapon.kind)
		damage *= 1 + @dexterity / 100 if /^bow|^knife|^spear/.test(@weapon.kind)
		damage *= 1 + @intelligence / 100 if /^wand|^staff|^tome/.test(@weapon.kind)
		if Math.chance(@critChance, 100)
			damage *= 1.25 + @critBonus / 100 
		damage


	save: ->
		kind: @kind
		owner: @owner
		location: @location
