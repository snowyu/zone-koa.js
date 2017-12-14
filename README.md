# zone-koa

Each request as a zone session patch to Koa.

### Installation

* Nodejs v7.6.0 above
* zone.js v0.8.5 above
* koa v2.4.1 above
* (optional) coffeescript v2.0

install npm package:

```bash
npm install zone.js koa zone-koa coffeescript
```

### Usage

```coffee
require('zone.js/dist/zone-node.js')
require('zone.js/dist/long-stack-trace-zone')
require('zone-koa')

Koa = require('koa')

app       = new Koa()
expect    = chai.expect

app.use (ctx, next)->
  req = ctx.req
  vSessionName = req.socket.remoteFamily + '|' + req.socket.remoteAddress + '|'+ req.socket.remotePort
  expect(Zone.current.name).to.be.equal vSessionName
  vSession = Zone.current.get 'session'
  expect(vSession).to.be.equal ctx
  start = new Date()
  await next()
  ms = new Date() - start
  console.log("#{ctx.method} #{ctx.url} - #{ms}ms")

app.use (ctx)->
  ctx.body = ctx.request.url
```

## History

## refs

*  issue using async/await with [target ES2017](https://github.com/angular/zone.js/issues/740). with target ES2016 works good.
* [async_hooks](https://github.com/nodejs/node/blob/master/doc/api/async_hooks.md) API on above Node@8.2.1
  * [cls-hooked](https://github.com/jeff-lewis/cls-hooked) Continuation-Local Storage ( Hooked )
  * [node-async-context](https://github.com/gms1/node-async-context)(based on typescript) a continuation local storage / asynchronous execution context for node.js via async_hooks
