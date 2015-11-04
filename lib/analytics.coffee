{bgRed, yellow, green, gray} = require 'chalk'
Useragent = require 'express-useragent'
Url = require 'url'

module.exports = (request, response) ->
  began = Date.now()
  analytics = {}
  hit = {}
  headers = request.headers or {}
  headers.referrer = request.headers.referrer or request.headers.referer
  analytics[key] = value for own key, value of headers
  agent = if headers['user-agent'] then Useragent.parse headers['user-agent'] else {}
  for own key, value of agent
    if typeof value is 'boolean'
      analytics[key] = hit[key] = if value then 1 else 0
    else
      analytics[key] = value
  analytics.remoteAddress = request.connection?.remoteAddress
  analytics.location = Url.parse request.url
  analytics.method = request.method
  hit["#{request.method}:#{analytics.location.pathname}"] = 1
  hit["#{request.method}:#{analytics.location.href}"] = 1
  console.log "→ #{request.method} #{headers.host}#{gray "<#{headers.origin}>"} #{request.url}".replace /\//g, "#{gray '/'}"
  response.on 'finish', ->
    color = if response.statusCode < 400 then green else if response.statusCode < 500 then yellow else bgRed
    console.log "#{color "← [#{response.statusCode}] #{Date.now() - began}ms"} #{request.method} #{headers.host}#{gray "<#{headers.origin}>"} #{color "#{request.url}"}"
  # TODO: database logging.
