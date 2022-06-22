import akane
import tg
import gen

var server = newServer("127.0.0.1", 5000)
server.pages:
  equals("/tg", HttpGet):
    await request.send(generate(tg.tg()))

server.start()