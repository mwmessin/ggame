Server = require('express').createServer()

Server.get('/', (request, response) -> response.send('!!!'))

Server.listen 1337 
