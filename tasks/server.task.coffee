gulp = require 'gulp'
size = require 'gulp-size'

config = require '../config.coffee'

# watching = no
gulp.task 'server', ->
  # if config.watch and not watching
  #   watching = yes
  #   gulp.watch config.files.server, gulp.series 'server'
  gulp.src config.files.server, since: gulp.lastRun 'server'
    .pipe size title: 'server', showFiles: yes
    .pipe gulp.dest "#{__dirname}/../build"
