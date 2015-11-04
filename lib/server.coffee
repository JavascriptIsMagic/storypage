config = require '../config.coffee'

analytics = require './analytics.coffee'
async = require './async.coffee'
Api = require './api/index.controller.coffee'
send = require 'send'
url = require 'url'

parseBodyJson = (request, {maxBytes}) ->
  new Promise (resolve, reject) ->
    maxBytes or= 1e6
    buffers = []
    request.bodySize = 0
    request.on 'data', (chunk) ->
      buffers.push chunk
      request.bodySize += chunk.length
      if request.bodySize > maxBytes
        request.removeListener 'end', end
        reject new Error "Request body too large: Maximum request body json size of #{maxBytes} bytes reached."
        request.connection.destroy()
      return
    request.on 'end', end = ->
      try resolve request.body = JSON.parse buffers.join '' catch error then reject error
      return

require 'http'
  .createServer (request, response) ->
    # TODO: use require 'zone'

    analytics request, response

    headers = request.headers or {}

    response.setHeader 'Application-Version', config.package.version
    if headers.origin
      response.setHeader 'Access-Control-Allow-Origin', headers.origin
      response.setHeader 'Access-Control-Request-Method', '*'
      response.setHeader 'Access-Control-Allow-Methods', 'OPTIONS, POST'
      response.setHeader 'Access-Control-Allow-Headers', '*'

    switch request.method
      when 'GET'
        pathname = url.parse(request.url).pathname
        unless /\.\w+$/.test pathname
          #pathname = pathname.replace /\/?[^\/]*$/, '/index.html'
          pathname = '/index.html'
        send request, pathname, root: config.publicPath
          .on 'error', (error) ->
            response.statusCode = error.status or 500
            response.end error.message
          .pipe response
      when 'POST'
        async ->
          controller = new Api request.url, request.headers, yield parseBodyJson request
          {returns} = yield controller.execute()
          response.setHeader 'Content-Type', 'application/json'
          response.end JSON.stringify returns
        .catch (error) ->
          response.statusCode = error.status or 500
          response.setHeader 'Content-Type', 'application/json'
          response.end JSON.stringify ["#{error.type or error}", "#{error.message or error}", "#{error.stack}"]
      when 'OPTIONS'
        response.writeHead 200
        response.end()
      else
        response.writeHead 403
        request.connection.destroy()
  .on 'error', (error) ->
    console.log "#{error?.stack or error}"
    process.exit 1
  .listen config.serverPort, ->
    console.log "#{config.package.name} is listen on port #{config.serverPort}"
