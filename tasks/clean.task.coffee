gulp = require 'gulp'
del = require 'del'
{argv} = require 'yargs'

config = require '../config.coffee'

gulp.task 'clean', (callback) ->
  if config.clean or 'clean' in argv._
    del ["#{__dirname}/../build/**"]
      .then (files) ->
        console.log files
        console.log "`gulp clean` deleted #{files.length} files."
  else
    callback console.log "Skipping `gulp clean`"
