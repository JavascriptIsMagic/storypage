path = require 'path'
{argv} = require 'yargs'

config = try require path.resolve argv.config or process.env.config
config ?= {}

for own key, value of process.env
  config[key] = value

for own key, value of argv
  config[key] = value

config.serverPort ?= 8080
config.watch ?= config.debug

# `config.projectPath` is the directory of your source code / repository / package.json
config.projectPath = path.resolve config.projectPath or process.cwd()

# `config.paths.build` is the directory where the compiled/built server files will be output to.
# WARNING: files will be overriden/deleted here!
config.buildPath = path.resolve config.buildPath or "#{config.projectPath}/build"

# `config.paths.public` is the directory where the publicly hosted, staticly served web files will be output to.
# WARNING: files will be overriden/deleted here!
config.publicPath = path.resolve config.publicPath or "#{config.buildPath}/public"

config.package = require "#{config.projectPath}/package.json"

config.browserify ?= {}
config.browserify.entries ?= ["#{config.projectPath}/src/#{config.package.name}.bundle.cjsx"]
config.browserify.debug ?= config.debug

config.files ?= {}
config.files.less ?= ["#{config.projectPath}/src/**/*.less"]
config.files.cjsx ?= [
  "#{config.projectPath}/src/**/*.cjsx"
  "#{config.projectPath}/src/**/*.coffee"
]
config.files.static ?= ["#{config.projectPath}/src/**/*"].concat ("!#{source}" for source in config.files.less.concat config.files.cjsx)
config.files.server ?= [
  "#{config.projectPath}/**/*"
  "!#{config.buildPath}"
  "!#{config.buildPath}/**"
  "!#{config.publicPath}"
  "!#{config.publicPath}/**"
  "!#{config.projectPath}/node_modules"
  "!#{config.projectPath}/node_modules/**"
  "!#{config.projectPath}/src"
  "!#{config.projectPath}/src/**"
  "!#{config.projectPath}/semantic"
  "!#{config.projectPath}/semantic/**"
  "!#{config.projectPath}/tasks"
  "!#{config.projectPath}/tasks/**"
]

if config.logConfig then console.log cson.stringify config, null, 2

module.exports = config
