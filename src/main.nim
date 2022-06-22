import akane
import tg
import gen

var server = newServer()
server.pages:
  equals("/tg", HttpGet):
    await request.send(generate(tg.tg()))

server.start()