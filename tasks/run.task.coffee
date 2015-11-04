gulp = require 'gulp'
send = require 'send'
{fork} = require 'child_process'

config = require '../config.coffee'

child = null
watching = no
gulp.task 'run', (callback) ->
  if config.watch
    restart = ->
      console.log if child then 'RESTARTing Server...' else 'STARTing Server...'
      if child then try child.kill()
      child = fork 'server.js', {
        cwd: "#{config.buildPath}"
        env:
          config: config.config
          projectPath: config.projectPath
          buildPath: config.buildPath
          publicPath: config.publicPath
      }
      child.on 'error', ->
        child = null
        setTimeout.bind null, (gulp.series 'server'), 3141
    restart()
    unless watching
      watching = yes
      gulp.watch config.files.server, gulp.series 'server', 'run'
  callback()
