debug     = require('debug')('koa:application:inject')
onFinished= require('on-finished')
statuses  = require('statuses')
compose   = require('koa-compose')
Stream    = require('stream')

module.exports = Koa = require('koa')

Koa::callback = ->
  fn = compose(this.middleware)

  if !this.listeners('error').length
    this.on('error', this.onerror)

  (req, res) =>
    ctx = this.createContext(req, res)
    @handleRequest(ctx, fn)

Koa::handleRequest = (ctx, fnMiddleware)->
  res = ctx.res
  req = ctx.req
  vSessionName = req.socket.remoteFamily + '|' + req.socket.remoteAddress + '|'+ req.socket.remotePort
  Zone.current.fork({properties: {session: ctx}, name: vSessionName}).run =>
    res.statusCode = 404
    onerror = (err) -> ctx.onerror(err)
    handleResponse = -> respond(ctx)
    onFinished(res, onerror);
    fnMiddleware(ctx).then(handleResponse).catch(onerror);

# from koa/application.js
`function respond(ctx) {
  // allow bypassing koa
  if (false === ctx.respond) return;

  const res = ctx.res;
  if (!ctx.writable) return;

  let body = ctx.body;
  const code = ctx.status;

  // ignore body
  if (statuses.empty[code]) {
    // strip headers
    ctx.body = null;
    return res.end();
  }

  if ('HEAD' == ctx.method) {
    if (!res.headersSent && isJSON(body)) {
      ctx.length = Buffer.byteLength(JSON.stringify(body));
    }
    return res.end();
  }

  // status body
  if (null == body) {
    body = ctx.message || String(code);
    if (!res.headersSent) {
      ctx.type = 'text';
      ctx.length = Buffer.byteLength(body);
    }
    return res.end(body);
  }

  // responses
  if (Buffer.isBuffer(body)) return res.end(body);
  if ('string' == typeof body) return res.end(body);
  if (body instanceof Stream) return body.pipe(res);

  // body: json
  body = JSON.stringify(body);
  if (!res.headersSent) {
    ctx.length = Buffer.byteLength(body);
  }
  res.end(body);
}`

