Promise   = require 'bluebird'
supertest = require("supertest")
chai      = require('chai')
cfg       = require('./cfg')
randstr   = require 'randomstring'

expect    = chai.expect

server = supertest.agent('http://localhost:'+cfg.port)

describe 'zone-koa', ->
  it 'should get session correctly', ->
    count = 200
    tests = for i in [1..count]
      '/' + randstr.generate
        # length: 6
        charset: 'alphabetic'
    Promise.map tests, (item)->
      server.get(item)
      .expect(200)
      .then (res)->
        expect(res.body.url).to.be.equal item
