module.exports = class Api
  constructor: (dirname) ->

  @route = (request, response) ->
    

class Api.Controller
  namespace: ''
  @route = (controller, request, response) ->
    "#{@namespace}#{request.url}"
  constructor: (request, response) ->
