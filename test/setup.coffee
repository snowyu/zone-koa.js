require('zone.js/dist/zone-node.js')
require('zone.js/dist/long-stack-trace-zone')
require('zone.js/dist/zone-bluebird')
require('../src')

app     = require './app'
cfg     = require './cfg'

server          = null
waitToCallbacks = []

before 'start server', (done)->
  srv = app.listen cfg.port, (err)->
    return done(err) if err
    server = srv
    while waitToCallbacks.length
      callback = waitToCallbacks.pop()
      callback(server)
    done()

after 'close server', (done)->
  server.close() if server
  done()

module.exports = (callback)->

  if server
    callback(server)
  else
    waitToCallbacks.push callback
