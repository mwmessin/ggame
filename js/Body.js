// Generated by CoffeeScript 1.3.1
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.Body = (function(_super) {

    __extends(Body, _super);

    Body.name = 'Body';

    function Body(options) {
      Body.__super__.constructor.call(this, options);
      this.direction = new Vector2(options.direction || [0, 0]);
      this.dimensions = new Vector2(options.dimensions || [0, 0]);
      this.offset = new Vector2(options.offset || [0, 0]);
      this.velocity = new Vector2(options.velocity || [0, 0]);
      if (options.center) {
        this.center(new Vector2(options.center));
      } else {
        this.put(this.location);
      }
      this.z = options.z || 0;
    }

    Body.prototype.put = function(point) {
      this.location = point;
      this.x1 = point.x + this.offset.x;
      this.x2 = this.x1 + this.dimensions.x;
      this.y1 = point.y + this.offset.y;
      return this.y2 = this.y1 + this.dimensions.y;
    };

    Body.prototype.move = function(vector) {
      return this.put(this.location.plus(vector));
    };

    Body.prototype.cycle = function(dt) {
      var dx, dy, v;
      v = this.velocity = this.direction;
      dx = v.x * dt;
      dy = v.y * dt;
      this.location.x += dx;
      this.x1 += dx;
      this.x2 += dx;
      this.location.y += dy;
      this.y1 += dy;
      this.y2 += dy;
      return this;
    };

    Body.prototype.center = function(point) {
      if (point != null) {
        return this.put(point.minus(this.offset).minus(this.dimensions.times(0.50)));
      } else {
        return this.location.plus(this.offset).plus(this.dimensions.times(0.50));
      }
    };

    Body.prototype.contains = function(point) {
      return this.x1 < point.x && this.x2 > point.x && this.y1 < point.y && this.y2 > point.y;
    };

    Body.prototype.overlaps = function(another) {
      return this.x1 < another.x2 && this.x2 > another.x1 && this.y1 < another.y2 && this.y2 > another.y1;
    };

    Body.prototype.collide = function(another) {
      var dx, dx1, dx2, dy, dy1, dy2, x1, x2, y1, y2;
      x1 = another.x1, x2 = another.x2, y1 = another.y1, y2 = another.y2;
      dx1 = x1 - this.x2;
      dx2 = x2 - this.x1;
      dy1 = y1 - this.y2;
      dy2 = y2 - this.y1;
      dx = (Math.abs(dx1) < Math.abs(dx2) ? dx1 : dx2);
      dy = (Math.abs(dy1) < Math.abs(dy2) ? dy1 : dy2);
      if (Math.abs(dx) < Math.abs(dy)) {
        this.put(this.location.plus(new Vector2(dx / 2, 0)));
        return another.move(new Vector2(-dx / 2, 0));
      } else {
        this.put(this.location.plus(new Vector2(0, dy / 2)));
        return another.move(new Vector2(0, -dy / 2));
      }
    };

    return Body;

  })(Sprite);

}).call(this);
