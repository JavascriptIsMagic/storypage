extend = require './extend.cjsx'

module.exports = (options) ->
  { method, url, body, credentials, file } = options or= {}
  request = new XMLHttpRequest()
  status = {
    request
    status: 'pending'
    completed: 0
    total: Infinity
    ratio: 0.0
    percent: '0%'
  }
  Bacon.fromBinder (push) ->
    push extend request, options, status
    request.open method or 'POST', url
    (if file then request.upload else request)
      .onprogress = (event) ->
        push Bacon.Next =>
          completed = event.loaded or event.position
          total = event.total or event.totalSize
          extend request, options, status = {
            request
            status: 'pending'
            completed
            total
            ratio: completed / total
            percent: "#{Math.round ((completed / total) * 100)}%"
          }, { event }
    request.onload = (event) ->
      if request.status < 300
        push Bacon.Next =>
          extend request, options, status = {
            request
            status: @status < 300 then 'complete' else 'error'
            completed: status.total
            ratio: 1.0
            percent: '100%'
          }, {
            event
            data: try JSON.parse @responseText
          }
        push new Bacon.End()
    request.onerror = request.onabort = (error) ->
      push new Bacon.Next =>
        extend request, options, status, { status: 'error', error }
      push new Bacon.End()
    if file
      form = new FormData()
      for own key, value of credentials
        form.append key, value
      form.append 'file', file
    request.send form or JSON.stringify body
    -> request.abort()
