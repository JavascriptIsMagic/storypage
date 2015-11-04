gulp = require 'gulp'
gzip = require 'gulp-gzip'
size = require 'gulp-size'

config = require '../config.coffee'

watching = no
gulp.task 'public', ->
  if config.watch and not watching
    watching = yes
    gulp.watch config.files.static, gulp.series 'public'
  gulp.src config.files.static, since: gulp.lastRun 'public'
    .pipe gulp.dest "#{__dirname}/../build/public"
    .pipe size title: 'public static file', showFiles: yes, gzip: yes
    .pipe gzip()
    .pipe gulp.dest "#{__dirname}/../build/public"
