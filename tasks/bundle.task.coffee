gulp = require 'gulp'
sourcemaps = require 'gulp-sourcemaps'
size = require 'gulp-size'
rename = require 'gulp-rename'
uglify = require 'gulp-uglify'
gzip = require 'gulp-gzip'
buffer = require 'vinyl-buffer'
source = require 'vinyl-source-stream'

config = require '../config.coffee'

browserify = require 'browserify'
watchify = require 'watchify'

cjsxify = require 'cjsxify'
babelify = require 'babelify'

bundler = null
gulp.task 'bundle', ->
  unless bundler
    args = {}
    args[key] = value for own key, value of config.browserify
    if config.watch
      args[key] = value for own key, value of watchify.args when not key of args
    bundler = if config.watch then watchify browserify args else browserify args
    bundler.transform cjsxify
    bundler.transform babelify.configure extensions: ['.cjsx', '.coffee']
    if config.watch
      bundler.on 'update', gulp.series 'bundle'
    bundler.on 'log', console.log.bind console, 'browserify'
  bundler
    .bundle()
    .on 'error', console.error.bind console
    .pipe source "#{config.package.name}.bundle.js"
    .pipe gulp.dest "#{config.publicPath}"
    .pipe buffer()
    .pipe sourcemaps.init loadMaps: yes
      .pipe uglify()
      .pipe rename "#{config.package.name}.bundle.min.js"
    .pipe sourcemaps.write '.'
    .pipe size title: 'bundled', showFiles: yes, gzip: yes
    .pipe gulp.dest "#{config.publicPath}"
    .pipe gzip()
    .pipe gulp.dest "#{config.publicPath}"
