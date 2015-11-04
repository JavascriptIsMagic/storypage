gulp = require 'gulp'
less = require 'gulp-less'
size = require 'gulp-size'

config = require '../config.coffee'

watching = no
gulp.task 'less', ->
  if config.watch and not watching
    watching = yes
    gulp.watch config.files.less, gulp.series 'less'
  gulp.src config.files.less, since: gulp.lastRun 'less'
    .pipe less()
    .pipe gulp.dest "#{config.publicPath}"
    .pipe size showFiles: yes
