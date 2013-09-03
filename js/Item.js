// Generated by CoffeeScript 1.3.1
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.Item = (function(_super) {

    __extends(Item, _super);

    Item.name = 'Item';

    function Item(options) {
      Item.__super__.constructor.call(this, options);
      this.name = options.name, this.kind = options.kind, this.rarity = options.rarity, this.requiredStrength = options.requiredStrength, this.requiredDexterity = options.requiredDexterity, this.requiredIntelligence = options.requiredIntelligence, this.life = options.life, this.lifeRegen = options.lifeRegen, this.lifeLeech = options.lifeLeech, this.energy = options.energy, this.energyRegen = options.energyRegen, this.energyLeech = options.energyLeech, this.speed = options.speed, this.armor = options.armor, this.dodge = options.dodge, this.critChance = options.critChance, this.critBonus = options.critBonus, this.stunChance = options.stunChance, this.stunDuration = options.stunDuration, this.strength = options.strength, this.dexterity = options.dexterity, this.intelligence = options.intelligence, this.vitality = options.vitality, this.greed = options.greed, this.luck = options.luck, this.prospecting = options.prospecting;
    }

    Item.rarityToColor = {
      common: "#ffffff",
      uncommon: "#0e82ee",
      set: "#12c227",
      rare: "#7d0eee",
      legendary: "#dfba62"
    };

    Item.prototype.save = function() {
      return {
        kind: this.kind,
        owner: this.owner,
        location: this.location
      };
    };

    return Item;

  })(Body);

}).call(this);