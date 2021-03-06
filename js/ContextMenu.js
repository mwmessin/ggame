// Generated by CoffeeScript 1.3.1
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.oncontextmenu = function() {
    return false;
  };

  this.ContextMenu = (function() {

    ContextMenu.name = 'ContextMenu';

    function ContextMenu(_arg) {
      var name, option, options;
      options = _arg.options;
      this.element = $('<div>').css('display', 'none').addClass('contextmenu').appendTo(game.level.infospace);
      for (name in options) {
        option = options[name];
        new Option(union(option, {
          name: name,
          parent: this.element
        }));
      }
    }

    ContextMenu.prototype.location = function(_arg) {
      this.x = _arg.x, this.y = _arg.y;
      if (arguments.length === 0) {
        return {
          x: this.x,
          y: this.y
        };
      } else {
        this.element.css({
          left: this.x + 'px',
          bottom: this.y + 'px'
        });
      }
      return this;
    };

    ContextMenu.prototype.hidden = function(what) {
      if (arguments.length === 0) {
        return this.element.css('display') === 'none';
      } else {
        this.element.css('display', what ? 'none' : 'block');
      }
      return this;
    };

    ContextMenu.main = {
      beings: {
        icon: "imgs/tree.png",
        action: function() {
          var being, name, _i, _len, _ref, _results;
          _ref = game.beings;
          _results = [];
          for (being = _i = 0, _len = _ref.length; _i < _len; being = ++_i) {
            name = _ref[being];
            _results.push(new Option({
              name: name,
              parent: this.element
            }));
          }
          return _results;
        }
      },
      terrain: {
        icon: "imgs/tree.png",
        action: function() {
          return new Animation.Editor;
        }
      },
      items: {
        icon: "imgs/tree.png",
        action: function() {}
      },
      abilities: {
        icon: "imgs/rock.png",
        action: function() {}
      }
    };

    return ContextMenu;

  })();

  this.Option = (function() {

    Option.name = 'Option';

    function Option(_arg) {
      var icon;
      icon = _arg.icon, this.name = _arg.name, this.action = _arg.action, this.parent = _arg.parent;
      this.mousedown = __bind(this.mousedown, this);

      $('<div>').addClass('option glossy').append($('<img>').attr('src', icon)).append($('<span>').text(this.name)).mousedown(this.mousedown).appendTo(this.parent);
    }

    Option.prototype.mousedown = function(_arg) {
      var which;
      which = _arg.which;
      if (which === 1) {
        return this.action();
      }
    };

    return Option;

  })();

}).call(this);
