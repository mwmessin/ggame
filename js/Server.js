// Generated by CoffeeScript 1.3.1
(function() {
  var Server;

  Server = require('express').createServer();

  Server.get('/', function(request, response) {
    return response.send('!!!');
  });

  Server.listen(1337);

}).call(this);