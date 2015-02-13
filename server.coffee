H = require 'hapi'

server = new H.Server()
server.connection { port : 9000 }

server.route {
  method : 'GET'
  path: '/{param*}'
  handler:
    directory:
      path: './'
      index: true
  config:
    cors : true
}

server.start () -> console.log "server running at : #{server.info.uri}"
