gulp = require 'gulp'
{exec} = require 'child_process'

config = require '../config.coffee'


gulp.task 'update:project', -> new Promise (resolve, reject) ->
  exec 'npm update --save-dev --no-bin-links', {
    cwd: "#{config.projectPath}"
  }, (error, stdout, stderr) ->
    if error
      reject error
    else
      resolve console.log "\nnpm update --save-dev\n#{stdout}\n#{stderr}"

watching = no
gulp.task 'update:server', gulp.series 'server', -> new Promise (resolve, reject) ->
  exec 'npm update --save --production', {
    cwd: "#{config.buildPath}"
  }, (error, stdout, stderr) ->
    if config.watch and not watching
      gulp.watch ["#{config.projectPath}/package.json"], gulp.parallel 'update:project', gulp.series 'update:server', 'run'
    if error
      reject error
    else
      resolve console.log "\nnpm update --save --production\n#{stdout}\n#{stderr}"
