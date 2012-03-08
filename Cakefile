{exec} = require 'child_process'

task 'sbuild', 'Build project from src/*.coffee to lib/*.js', ->
  exec 'coffee --compile --output lib/ src/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

task 'minify', 'Minify javascript files', ->
  exec 'uglifyjs -nc lib/jquery.lazyload.js > lib/jquery.lazyload.min.js', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr