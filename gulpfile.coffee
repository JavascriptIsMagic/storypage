###
npm uninstall gulp -g
npm uninstall gulp
npm install --global gulpjs/gulp-cli#4.0
npm install --save-dev gulpjs/gulp.git#4.0 coffee-script yargs browserify watchify vinyl-source-stream cjsxify babelify
###

gulp = require 'gulp'

require './tasks/clean.task.coffee'
require './tasks/bundle.task.coffee'
require './tasks/public.task.coffee'
require './tasks/less.task.coffee'
require './tasks/server.task.coffee'
require './tasks/update.task.coffee'
require './tasks/run.task.coffee'

gulp.task 'default', gulp.parallel 'update:project',
  gulp.series 'clean', (
    gulp.parallel 'bundle', 'less', 'public', 'update:server'
  ), 'run'
