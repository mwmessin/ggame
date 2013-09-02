(function() {

  this.Net = (function() {

    function Net(_arg) {
      this.nodes = _arg.nodes, this.edges = _arg.edges;
      null;
    }

    Net.prototype.depth = function(s) {
      return null;
    };

    Net.prototype.breadth = function(s) {
      return null;
    };

    Net.prototype.minSpan = function() {
      var edge, results, source, target, _i, _len, _ref;
      results = [];
      _ref = this.edges.sort(function(a, b) {
        return a[2] - b[2];
      });
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        edge = _ref[_i];
        source = this.nodes[edge[0]];
        target = this.nodes[edge[1]];
        if (!source.visited || !target.visited) {
          source.visited = target.visited = true;
          results.push(edge);
        }
      }
      return results;
    };

    Net.prototype.shortest = function(s) {};

    Net.prototype.maxflow = function(s, t) {
      return null;
    };

    return Net;

  })();

  this.n = new Net({
    nodes: [
      {
        name: "a"
      }, {
        name: "b"
      }, {
        name: "c"
      }, {
        name: "d"
      }
    ],
    edges: [[0, 1, 1.13], [1, 2, 1.14], [2, 3, 1.13], [3, 0, 1.6]]
  });

  $(function() {
    return console.log(n.minSpan());
  });

}).call(this);
