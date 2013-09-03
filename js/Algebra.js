// Generated by CoffeeScript 1.3.1
(function() {
  var __slice = [].slice;

  this.Vector2 = (function() {

    Vector2.name = 'Vector2';

    function Vector2() {
      var args, _ref, _ref1;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (args.length === 1) {
        if (args[0].x) {
          _ref = args[0], this.x = _ref.x, this.y = _ref.y;
        } else {
          _ref1 = args[0], this.x = _ref1[0], this.y = _ref1[1];
        }
      } else {
        this.x = args[0], this.y = args[1];
      }
    }

    Vector2.prototype.toString = function() {
      return "[object Vector2]";
    };

    Vector2.prototype.toJSON = function() {
      return [this.x, this.y];
    };

    Vector2.prototype.length = function(value) {
      var length;
      length = Math.sqrt(this.x * this.x + this.y * this.y);
      if (value == null) {
        return length;
      }
      if (length > 0) {
        this.scale(value / length);
      }
      return this;
    };

    Vector2.prototype.normalize = function() {
      var length;
      length = this.length();
      if (length > 0) {
        this.x /= length;
        this.y /= length;
      } else {
        this.x = 0;
        this.y = 0;
      }
      return this;
    };

    Vector2.prototype.normal = function() {
      var length;
      length = this.length();
      if (length > 0) {
        return new Vector2(this.x / length, this.y / length);
      } else {
        return new Vector2(0, 0);
      }
    };

    Vector2.prototype.add = function(another) {
      this.x += another.x;
      this.y += another.y;
      return this;
    };

    Vector2.prototype.plus = function(another) {
      return new Vector2(this.x + another.x, this.y + another.y);
    };

    Vector2.prototype.sub = function(another) {
      this.x -= another.x;
      this.y -= another.y;
      return this;
    };

    Vector2.prototype.minus = function(another) {
      return new Vector2(this.x - another.x, this.y - another.y);
    };

    Vector2.prototype.scale = function(scalar) {
      this.x *= scalar;
      this.y *= scalar;
      return this;
    };

    Vector2.prototype.times = function(scalar) {
      return new Vector2(this.x * scalar, this.y * scalar);
    };

    Vector2.prototype.dot = function(another) {
      return this.x * another.x + this.y * another.y;
    };

    Vector2.prototype.angle = function() {
      var angle;
      angle = Math.acos(this.x / this.length());
      if (this.y < 0) {
        return Number.TAU - angle;
      } else {
        return angle;
      }
    };

    Vector2.prototype.angleTo = function(another) {
      var magnitudes;
      magnitudes = this.length() * another.length();
      return Math.acos(this.dot(another) / magnitudes);
    };

    Vector2.prototype.reflection = function(another) {
      var normal;
      normal = another.normal();
      return this.minus(normal.scale(2 * this.dot(normal)));
    };

    Vector2.prototype.projection = function(another) {
      var normal;
      normal = another.normal();
      return normal.scale(this.dot(normal));
    };

    Vector2.prototype.morton = function() {
      var i, result;
      result = 0;
      i = 0;
      while (i < 32) {
        result |= (this.x & 1 << i) << i | (this.y & 1 << i) << (i + 1);
        ++i;
      }
      return result;
    };

    Vector2.prototype.hilbert = function(order) {
      var form, i, quad, quadX, quadY, result;
      if (order == null) {
        order = 16;
      }
      result = 0;
      i = order - 1;
      while (i >= 0) {
        result <<= 2;
        quadX = (this.x & (1 << i) ? 1 : 0);
        quadY = (this.y & (1 << i) ? 1 : 0);
        quad = this.hilbertMap[form][2 * quadX + quadY];
        form = quad[1];
        result |= quad[0];
        --i;
      }
      return result;
    };

    Vector2.hilbertMap = [[[0, 3], [1, 0], [3, 1], [2, 0]], [[2, 1], [1, 1], [3, 0], [0, 2]], [[2, 2], [3, 3], [1, 2], [0, 1]], [[0, 0], [3, 2], [1, 3], [2, 3]]];

    return Vector2;

  })();

  this.Vector3 = (function() {

    Vector3.name = 'Vector3';

    function Vector3() {
      var args, _ref, _ref1;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (args.length === 1) {
        if (args[0].x) {
          _ref = args[0], this.x = _ref.x, this.y = _ref.y, this.z = _ref.z;
        } else {
          _ref1 = args[0], this.x = _ref1[0], this.y = _ref1[1], this.z = _ref1[2];
        }
      } else {
        this.x = args[0], this.y = args[1], this.z = args[2];
      }
    }

    Vector3.prototype.toString = function() {
      return "[object Vector3]";
    };

    Vector3.prototype.normalize = function() {
      var length;
      length = this.length();
      this.x /= length;
      this.y /= length;
      this.z /= length;
      return this;
    };

    Vector3.prototype.add = function(another) {
      this.x += another.x;
      this.y += another.y;
      this.z += another.z;
      return this;
    };

    Vector3.prototype.sub = function(another) {
      this.x -= another.x;
      this.y -= another.y;
      this.z -= another.z;
      return this;
    };

    Vector3.prototype.scale = function(scalar) {
      this.x *= scalar;
      this.y *= scalar;
      this.z *= scalar;
      return this;
    };

    Vector3.prototype.plus = function(another) {
      return new Vector3(this.x + another.x, this.y + another.y, this.z + another.z);
    };

    Vector3.prototype.minus = function(another) {
      return new Vector3(this.x - another.x, this.y - another.y, this.z - another.z);
    };

    Vector3.prototype.times = function(scalar) {
      return new Vector3(this.x * scalar, this.y * scalar, this.z * scalar);
    };

    Vector3.prototype.cross = function(another) {
      return new Vector3(this.y * another.z - this.z * another.y, this.z * another.x - this.x * another.z, this.x * another.y - this.y * another.x);
    };

    Vector3.prototype.dot = function(another) {
      return this.x * another.x + this.y * another.y + this.z * another.z;
    };

    Vector3.prototype.angleTo = function(another) {
      return Math.acos(this.dot(another) / this.length() / another.length());
    };

    Vector3.prototype.lerp = function(another, t) {
      return new Vector3(this.x + t * (another.x - this.x), this.y + t * (another.y - this.y), this.z + t * (another.z - this.z));
    };

    Vector3.prototype.length = function(value) {
      var length;
      length = Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
      if (value == null) {
        return length;
      }
      if (length > 0) {
        this.scale(value / length);
      }
      return this;
    };

    return Vector3;

  })();

  this.Vector4 = (function() {

    Vector4.name = 'Vector4';

    function Vector4() {
      var args, _ref, _ref1;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (args.length === 1) {
        if (args[0].x) {
          _ref = args[0], this.x = _ref.x, this.y = _ref.y, this.z = _ref.z, this.w = _ref.w;
        } else {
          _ref1 = args[0], this.x = _ref1[0], this.y = _ref1[1], this.z = _ref1[2], this.w = _ref1[3];
        }
      } else {
        this.x = args[0], this.y = args[1], this.z = args[2], this.w = args[3];
      }
    }

    Vector4.prototype.toString = function() {
      return "[object Vector4]";
    };

    Vector4.prototype.normalize = function() {
      var length;
      length = this.length();
      this.x /= length;
      this.y /= length;
      this.z /= length;
      this.w /= length;
      return this;
    };

    Vector4.prototype.sub = function(another) {
      this.x -= another.x;
      this.y -= another.y;
      this.z -= another.z;
      this.w -= another.w;
      return this;
    };

    Vector4.prototype.scale = function(scalar) {
      this.x *= scalar;
      this.y *= scalar;
      this.z *= scalar;
      this.w *= scalar;
      return this;
    };

    Vector4.prototype.dot = function(another) {
      return this.x * another.x + this.y * another.y + this.z * another.z + this.w * another.w;
    };

    Vector4.prototype.lerp = function(another, t) {
      return new Vector4(this.x + t * (another.x - this.x), this.y + t * (another.y - this.y), this.z + t * (another.z - this.z), this.w + t * (another.w - this.w));
    };

    Vector4.prototype.slerp = function(another, t) {
      var cosHalfTheta, halfTheta, ratioA, ratioB, sinHalfTheta, w, x, y, z;
      x = another.x, y = another.y, z = another.z, w = another.w;
      cosHalfTheta = this.dot(another);
      if (Math.abs(cosHalfTheta) >= 1.0) {
        return new Vector4(this);
      }
      halfTheta = Math.acos(cosHalfTheta);
      sinHalfTheta = Math.sqrt(1.0 - cosHalfTheta * cosHalfTheta);
      if (Math.abs(sinHalfTheta) < 0.001) {
        return new Vector4(0.5 * (this.x + x), 0.5 * (this.y + y), 0.5 * (this.z + z), 0.5 * (this.w + w));
      }
      ratioA = Math.sin((1 - t) * halfTheta) / sinHalfTheta;
      ratioB = Math.sin(t * halfTheta) / sinHalfTheta;
      return new Vector4(this.x * ratioA + x * ratioB, this.y * ratioA + y * ratioB, this.z * ratioA + z * ratioB, this.w * ratioA + w * ratioB);
    };

    Vector4.prototype.length = function(value) {
      var length;
      length = Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);
      if (value == null) {
        return length;
      }
      if (length > 0) {
        this.scale(value / length);
      }
      return this;
    };

    return Vector4;

  })();

  this.Matrix3 = (function() {

    Matrix3.name = 'Matrix3';

    function Matrix3() {
      var args, _ref, _ref1;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (args.length === 1) {
        if (args[0].a != null) {
          _ref = args[0], this.a = _ref.a, this.b = _ref.b, this.c = _ref.c, this.d = _ref.d, this.e = _ref.e, this.f = _ref.f, this.g = _ref.g, this.h = _ref.h, this.i = _ref.i;
        } else {
          _ref1 = args[0], this.a = _ref1[0], this.b = _ref1[1], this.c = _ref1[2], this.d = _ref1[3], this.e = _ref1[4], this.f = _ref1[5], this.g = _ref1[6], this.h = _ref1[7], this.i = _ref1[8];
        }
      } else {
        this.a = args[0], this.b = args[1], this.c = args[2], this.d = args[3], this.e = args[4], this.f = args[5], this.g = args[6], this.h = args[7], this.i = args[8];
      }
    }

    Matrix3.prototype.equals = function(_arg) {
      var a, b, c, d, e, f, g, h, i;
      a = _arg.a, b = _arg.b, c = _arg.c, d = _arg.d, e = _arg.e, f = _arg.f, g = _arg.g, h = _arg.h, i = _arg.i;
      return this.a === a && this.b === b && this.c === c && this.d === d && this.e === e && this.f === f && this.g === g && this.h === h && this.i === i;
    };

    Matrix3.prototype.trans = function(_arg) {
      var x, y, z;
      x = _arg.x, y = _arg.y, z = _arg.z;
      return new Vector3(this.a * x + this.b * y + this.c * z, this.d * x + this.e * y + this.f * z, this.g * x + this.h * y + this.i * z);
    };

    Matrix3.prototype.mult = function(_arg) {
      var a, b, c, d, e, f, g, h, i;
      a = _arg.a, b = _arg.b, c = _arg.c, d = _arg.d, e = _arg.e, f = _arg.f, g = _arg.g, h = _arg.h, i = _arg.i;
      this.a = this.a * a + this.b * d + this.c * g;
      this.b = this.a * b + this.b * e + this.c * h;
      this.c = this.a * c + this.b * f + this.c * i;
      this.d = this.d * a + this.e * d + this.f * g;
      this.e = this.d * b + this.e * e + this.f * h;
      this.f = this.d * c + this.e * f + this.f * i;
      this.g = this.g * a + this.h * d + this.i * g;
      this.h = this.g * b + this.h * e + this.i * h;
      return this.i = this.g * c + this.h * f + this.i * i;
    };

    Matrix3.IDENTITY = new Matrix3(1, 0, 0, 0, 1, 0, 0, 0, 1);

    Matrix3.BERNSTEIN = new Matrix3(1, 0, 0, -2, 2, 0, 1, -2, 1);

    Matrix3.rotateX = function(theta) {
      var cosT, sinT;
      sinT = Math.sin(theta);
      cosT = Math.cos(theta);
      return new Matrix3(1, 0, 0, 0, cosT, -sinT, 0, sinT, cosT);
    };

    Matrix3.rotateY = function(theta) {
      var cosT, sinT;
      sinT = Math.sin(theta);
      cosT = Math.cos(theta);
      return new Matrix3(cosT, 0, sinT, 0, 1, 0, -sinT, 0, cosT);
    };

    Matrix3.rotateZ = function(theta) {
      var cosT, sinT;
      sinT = Math.sin(theta);
      cosT = Math.cos(theta);
      return new Matrix3(cosT, -sinT, 0, sinT, cosT, 0, 0, 0, 1);
    };

    Matrix3.rotate = function(_arg, theta) {
      var cosT, minCosT, sinT, x, y, z;
      x = _arg.x, y = _arg.y, z = _arg.z;
      sinT = Math.sin(theta);
      cosT = Math.cos(theta);
      minCosT = 1 - cosT;
      return new Matrix3(cosT + x * x * minCosT, x * y * minCosT - z * sinT, x * z * minCosT + y * sinT, y * x * minCosT + z * sinT, cosT + y * y * minCosT, y * z * minCosT - x * sinT, z * x * minCosT - y * sinT, z * y * minCosT + x * sinT, cosT + z * z * minCosT);
    };

    return Matrix3;

  })();

  this.Matrix4 = (function() {

    Matrix4.name = 'Matrix4';

    function Matrix4() {
      var args, _ref, _ref1;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (args.length === 1) {
        if (args[0].a != null) {
          _ref = args[0], this.a = _ref.a, this.b = _ref.b, this.c = _ref.c, this.d = _ref.d, this.e = _ref.e, this.f = _ref.f, this.g = _ref.g, this.h = _ref.h, this.i = _ref.i, this.j = _ref.j, this.k = _ref.k, this.l = _ref.l, this.m = _ref.m, this.n = _ref.n, this.o = _ref.o, this.p = _ref.p;
        } else {
          _ref1 = args[0], this.a = _ref1[0], this.b = _ref1[1], this.c = _ref1[2], this.d = _ref1[3], this.e = _ref1[4], this.f = _ref1[5], this.g = _ref1[6], this.h = _ref1[7], this.i = _ref1[8], this.j = _ref1[9], this.k = _ref1[10], this.l = _ref1[11], this.m = _ref1[12], this.n = _ref1[13], this.o = _ref1[14], this.p = _ref1[15];
        }
      } else {
        this.a = args[0], this.b = args[1], this.c = args[2], this.d = args[3], this.e = args[4], this.f = args[5], this.g = args[6], this.h = args[7], this.i = args[8], this.j = args[9], this.k = args[10], this.l = args[11], this.m = args[12], this.n = args[13], this.o = args[14], this.p = args[15];
      }
    }

    Matrix4.prototype.equals = function(_arg) {
      var a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p;
      a = _arg.a, b = _arg.b, c = _arg.c, d = _arg.d, e = _arg.e, f = _arg.f, g = _arg.g, h = _arg.h, i = _arg.i, j = _arg.j, k = _arg.k, l = _arg.l, m = _arg.m, n = _arg.n, o = _arg.o, p = _arg.p;
      return this.a === a && this.b === b && this.c === c && this.d === d && this.e === e && this.f === f && this.g === g && this.h === h && this.i === i && this.j === j && this.k === k && this.l === l && this.m === m && this.n === n && this.o === o && this.p === p;
    };

    Matrix4.prototype.trans = function(_arg) {
      var w, x, y, z;
      x = _arg.x, y = _arg.y, z = _arg.z, w = _arg.w;
      return new Vector4(this.a * x + this.b * y + this.c * z + this.d * w, this.e * x + this.f * y + this.g * z + this.h * w, this.i * x + this.j * y + this.k * z + this.l * w, this.m * x + this.n * y + this.o * z + this.p * w);
    };

    Matrix4.prototype.mult = function(_arg) {
      var a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p;
      a = _arg.a, b = _arg.b, c = _arg.c, d = _arg.d, e = _arg.e, f = _arg.f, g = _arg.g, h = _arg.h, i = _arg.i, j = _arg.j, k = _arg.k, l = _arg.l, m = _arg.m, n = _arg.n, o = _arg.o, p = _arg.p;
      this.a = this.a * a + this.b * e + this.c * i + this.d * m;
      this.b = this.a * b + this.b * f + this.c * j + this.d * n;
      this.c = this.a * c + this.b * g + this.c * k + this.d * o;
      this.d = this.a * d + this.b * h + this.c * l + this.d * p;
      this.e = this.e * a + this.f * e + this.g * i + this.h * m;
      this.f = this.e * b + this.f * f + this.g * j + this.h * n;
      this.g = this.e * c + this.f * g + this.g * k + this.h * o;
      this.h = this.e * d + this.f * h + this.g * l + this.h * p;
      this.i = this.i * a + this.j * e + this.k * i + this.l * m;
      this.j = this.i * b + this.j * f + this.k * j + this.l * n;
      this.k = this.i * c + this.j * g + this.k * k + this.l * o;
      this.l = this.i * d + this.j * h + this.k * l + this.l * p;
      this.m = this.m * a + this.n * e + this.o * i + this.p * m;
      this.n = this.m * b + this.n * f + this.o * j + this.p * n;
      this.o = this.m * c + this.n * g + this.o * k + this.p * o;
      return this.p = this.m * d + this.n * h + this.o * l + this.p * p;
    };

    Matrix4.IDENTITY = new Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);

    Matrix4.BERNSTEIN = new Matrix4(1, 0, 0, 0, -3, 3, 0, 0, 3, -6, 3, 0, -1, 3, -3, 1);

    Matrix4.HERMITE = new Matrix4(2, -2, 1, 1, -3, 3, -2, -1, 0, 0, 1, 0, 1, 0, 0, 0);

    Matrix4.rotateX = function(theta) {
      var cosT, sinT;
      sinT = Math.sin(theta);
      cosT = Math.cos(theta);
      return new Matrix4(1, 0, 0, 0, 0, cosT, -sinT, 0, 0, sinT, cosT, 0, 0, 0, 0, 1);
    };

    Matrix4.rotateY = function(theta) {
      var cosT, sinT;
      sinT = Math.sin(theta);
      cosT = Math.cos(theta);
      return new Matrix4(cosT, 0, sinT, 0, 0, 1, 0, 0, -sinT, 0, cosT, 0, 0, 0, 0, 1);
    };

    Matrix4.rotateZ = function(theta) {
      var cosT, sinT;
      sinT = Math.sin(theta);
      cosT = Math.cos(theta);
      return new Matrix4(cosT, -sinT, 0, 0, sinT, cosT, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
    };

    Matrix4.rotate = function(_arg, theta) {
      var cosT, minCosT, sinT, x, y, z;
      x = _arg.x, y = _arg.y, z = _arg.z;
      sinT = Math.sin(theta);
      cosT = Math.cos(theta);
      minCosT = 1 - cosT;
      return new Matrix4(cosT + x * x * minCosT, x * y * minCosT - z * sinT, x * z * minCosT + y * sinT, 0, y * x * minCosT + z * sinT, cosT + y * y * minCosT, y * z * minCosT - x * sinT, 0, z * x * minCosT - y * sinT, z * y * minCosT + x * sinT, cosT + z * z * minCosT, 0, 0, 0, 0, 1);
    };

    return Matrix4;

  })();

}).call(this);