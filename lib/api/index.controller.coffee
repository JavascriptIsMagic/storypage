module.exports = class RootController extends require '../controller.coffee'
  '/': @action ->
    "Ohya!"
  '/accounts': require './accounts.controller.coffee'
