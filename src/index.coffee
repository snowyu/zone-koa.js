debug     = require('debug')('koa:application:inject')

module.exports = Koa = require('koa')

Koa::handleRequest = ((handleRequest)->
  (ctx, fnMiddleware)->
    res = ctx.res
    req = ctx.req
    vSessionName = req.socket.remoteFamily + '|' + req.socket.remoteAddress + '|'+ req.socket.remotePort
    Zone.current.fork({properties: {session: ctx}, name: vSessionName}).run =>
      handleRequest.call(this, ctx, fnMiddleware)
)(Koa::handleRequest)
