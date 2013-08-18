pushover = require 'pushover'
path = require 'path'
os = require 'os'
repodir = path.resolve './repos'
repos = pushover repodir
model = require '../lib/model.coffee'
cavalry = require '../lib/cavalry.coffee'
host = process.env.HOSTNAME or os.hostname()
port = process.env.WEBSERVERPORT or 4001
secret = process.env.SECRET or 'testingpass'

repos.on 'push', (push) ->
  opts =
    name: push.repo
    url: "http://git:#{secret}@#{host}:#{port}/#{push.repo}"
  for slave of model.slaves
    do (slave) ->
      cavalry.fetch slave, opts, (err, body) ->
        cavalry.deploy slave, opts, (err, body) ->
          console.error err if err?
          console.error err if body?

module.exports =
  handle: (req, res) ->
    repos.handle req, res
  repos: repos