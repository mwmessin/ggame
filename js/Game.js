// Generated by CoffeeScript 1.3.1
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.Game = (function() {

    Game.name = 'Game';

    function Game(_arg) {
      var beings, items, levels, tiles;
      beings = _arg.beings, tiles = _arg.tiles, items = _arg.items, levels = _arg.levels;
      window.game = this;
      $('body').append(this.view = $('<div>', {
        "class": 'view'
      }));
      this.players = [
        new Player({
          name: '13lur',
          id: 0
        }), new Player({
          name: 'Penny',
          id: 1
        })
      ];
      this.beings = beings;
      this.tiles = tiles;
      this.items = items;
      this.engine = new Engine();
      this.level = new Level(levels[0]);
      this.control = new Control();
    }

    Game.prototype.save = function() {
      return {
        beings: this.beings,
        tiles: this.tiles,
        items: this.items,
        levels: [this.level.save()]
      };
    };

    Game.prototype.generateTerrain = function(order) {
      var average, col, factor, grid, half, length, random, segments, terrain, x, y, z, _i, _j, _k, _l, _len, _len1;
      if (order == null) {
        order = 1;
      }
      segments = Math.pow(2, order);
      grid = [];
      for (x = _i = 0; 0 <= segments ? _i <= segments : _i >= segments; x = 0 <= segments ? ++_i : --_i) {
        col = grid[x] = [];
        for (y = _j = 0; 0 <= segments ? _j <= segments : _j >= segments; y = 0 <= segments ? ++_j : --_j) {
          col[y] = 0.0;
        }
      }
      random = function(factor) {
        return (Math.random() - 0.5) * 2 * factor;
      };
      factor = 1;
      length = segments;
      while (length >= 2) {
        half = length / 2;
        y = 0;
        while (y < segments) {
          x = 0;
          while (x < segments) {
            average = (grid[y][x] + grid[y + length][x] + grid[y][x + length] + grid[y + length][x + length]) / 4;
            grid[y + half][x + half] = average + random(factor);
            x += length;
          }
          y += length;
        }
        y = half;
        while (y < segments) {
          x = half;
          while (x < segments) {
            if (y === half) {
              average = (grid[(y - length + segments) % segments][x] + grid[y - half][x + half] + grid[y][x] + grid[y - half][x - half]) / 4;
              grid[y - half][x] = average + random(factor);
            }
            average = (grid[y - half][x + half] + grid[y][(x + length + segments) % segments] + grid[y + half][x + half] + grid[y][x]) / 4;
            grid[y][x + half] = average + random(factor);
            average = (grid[y][x] + grid[y + half][x + half] + grid[(y + length + segments) % segments][x] + grid[y + half][x - half]) / 4;
            grid[y + half][x] = average + random(factor);
            if (x === half) {
              average = (grid[y - half][x - half] + grid[y][x] + grid[y + half][x - half] + grid[y][(x - length + segments) % segments]) / 4;
              grid[y][x - half] = average + random(factor);
            }
            x += length;
          }
          y += length;
        }
        length /= 2;
        factor /= 2;
      }
      terrain = [];
      for (x = _k = 0, _len = grid.length; _k < _len; x = ++_k) {
        col = grid[x];
        terrain[x] = [];
        for (y = _l = 0, _len1 = col.length; _l < _len1; y = ++_l) {
          z = col[y];
          terrain[x][y] = {
            name: 'dirt',
            z: z
          };
        }
      }
      return terrain;
    };

    Game.prototype.canvasTerrain = function(terrain) {
      var canvas, context, data, frame, setPixel, v, width, x, y, _i, _j, _ref;
      width = terrain.length;
      $("body").append(canvas = $("<canvas>", {
        css: {
          border: "1px solid green"
        }
      }).attr({
        width: width,
        height: width
      }));
      context = canvas[0].getContext("2d");
      frame = (_ref = context.getImageData(0, 0, width, width), data = _ref.data, _ref);
      setPixel = function(x, y, r, g, b, a) {
        var index;
        index = (x + y * width) * 4;
        data[index + 0] = r;
        data[index + 1] = g;
        data[index + 2] = b;
        return data[index + 3] = a;
      };
      for (x = _i = 0; 0 <= width ? _i < width : _i > width; x = 0 <= width ? ++_i : --_i) {
        for (y = _j = 0; 0 <= width ? _j < width : _j > width; y = 0 <= width ? ++_j : --_j) {
          v = (terrain[x][y].z + 1) / 2 * 255 | 0;
          setPixel(x, y, v, v, v, 255);
        }
      }
      return context.putImageData(frame, 0, 0);
    };

    Game.prototype.logTerrain = function(terrain) {
      var msg, x, y, _i, _j, _len, _len1, _results;
      _results = [];
      for (_i = 0, _len = terrain.length; _i < _len; _i++) {
        x = terrain[_i];
        msg = "";
        for (_j = 0, _len1 = x.length; _j < _len1; _j++) {
          y = x[_j];
          msg += y.z.toFixed(2) + " ";
        }
        _results.push(console.log(msg));
      }
      return _results;
    };

    return Game;

  })();

  this.Engine = (function() {

    Engine.name = 'Engine';

    function Engine(options) {
      this.cycle = __bind(this.cycle, this);
      this.system = [];
      this.t0 = Time();
      Frame(this.cycle);
    }

    Engine.prototype.cycle = function() {
      var center, dt, hero, object, subject, t, _i, _j, _k, _l, _len, _len1, _len2, _len3, _ref, _ref1, _ref2, _ref3;
      Frame(this.cycle);
      t = Time();
      dt = t - this.t0;
      _ref = this.system;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        object = _ref[_i];
        if (typeof object.cycle === "function") {
          object.cycle(dt);
        }
      }
      _ref1 = this.system;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        object = _ref1[_j];
        _ref2 = this.system;
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          subject = _ref2[_k];
          if (subject !== object) {
            if (typeof object.overlaps === "function" ? object.overlaps(subject) : void 0) {
              if (typeof object.collide === "function") {
                object.collide(subject);
              }
            }
          }
        }
        game.level.collide(object);
      }
      _ref3 = this.system;
      for (_l = 0, _len3 = _ref3.length; _l < _len3; _l++) {
        object = _ref3[_l];
        if (typeof object.draw === "function") {
          object.draw(t);
        }
      }
      this.t0 = t;
      hero = game.players[0].heroes[0];
      center = hero ? hero.center() : {
        x: 0,
        y: 0
      };
      return game.level.element.css({
        left: $(window).width() / 2 - center.x,
        bottom: $(window).height() / 2 - center.y
      });
    };

    Engine.prototype.at = function(point) {
      var object, result, _i, _len, _ref;
      result = [];
      _ref = this.system;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        object = _ref[_i];
        if (object.contains(point)) {
          result.push(object);
        }
      }
      return result;
    };

    Engine.prototype.add = function(object) {
      return this.system.push(object);
    };

    Engine.prototype.remove = function(object) {
      return this.system.remove(object);
    };

    return Engine;

  })();

}).call(this);
