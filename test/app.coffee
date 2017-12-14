chai      = require('chai')

Koa       = require('koa')
cfg       = require('./cfg')

app       = new Koa()
expect    = chai.expect

app.use (ctx, next)->
  req = ctx.req
  vSessionName = req.socket.remoteFamily + '|' + req.socket.remoteAddress + '|'+ req.socket.remotePort
  expect(global.Zone).to.be.exist
  expect(Zone.current.name).to.be.equal vSessionName
  vSession = Zone.current.get 'session'
  expect(vSession).to.be.equal ctx
  start = new Date()
  await next()
  ms = new Date() - start
  # console.log("#{ctx.method} #{ctx.url} - #{ms}ms")

app.use (ctx)->
  result = url: ctx.request.url
  result.session = Zone.current.name if global.Zone
  ctx.body = result

module.exports = app

# app.listen cfg.port
