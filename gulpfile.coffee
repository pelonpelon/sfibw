'use strict'

gulp        = require 'gulp'
gulpif      = require 'gulp-if'
gutil       = require 'gulp-util'
cat         = require 'gulp-cat'
grep        = require 'gulp-grep-stream'
path        = require 'path'
prepend     = require 'prepend-file'
gp          = require('gulp-load-plugins')({lazy: false, camelize: true})
through     = require 'through'
src         = require 'vinyl-source-stream'
runSequence = require 'run-sequence'
rsync       = require('rsyncwrapper').rsync
bust        = require 'gulp-css-cache-bust'
browserify  = require 'browserify'
coffee      = require 'gulp-coffee'
stylus      = require 'gulp-stylus'
sprite      = require('css-sprite').stream
minifycss   = require 'gulp-minify-css'
rand        = require 'random-key'
revall      = require 'gulp-rev-all'
strip       = require 'gulp-strip-debug'
concat      = require 'gulp-concat-util'
resize      = require 'gulp-image-resize'
pngcrush    = require 'imagemin-pngcrush'
optimize    = require 'gulp-image-optimization'
log         = gutil.log

gulp.env['development'] = true
log gulp.env.development
config = require './.config'
devDir = config.devDir ? 'dev/'
tmpDir = config.tmpDir ? devDir+'tmp/'
splashDir = devDir+'splash/'
log "sd: "+splashDir
buildDir = config.buildDir ? 'build/development/'
prodDir = config.prodDir ? 'build/production/'
revDir = config.prodDir ? 'build/revisioned/'

# Splash
gulp.task 'splash-stylus', ->
  gulp.src [
      devDir+'defaults.styl'
      devDir+'splash.styl'
      ], base: devDir
    .pipe concat 'splash.styl'
    .pipe stylus
      'include css': true
      errors: true
    .pipe gp.autoprefixer '> 1%', 'last 6 version', 'ff 17', 'opera 12.1', 'ios >= 5'
    .pipe gulp.dest tmpDir

gulp.task 'splash-coffee', ->
  gulp.src devDir+'loader.coffee', base: devDir
    .pipe gp.changed tmpDir, {extension: '.js'}
    .pipe coffee
      bare:true
    .pipe gulp.dest tmpDir

gulp.task 'splash-jade', ->
  gulp.src devDir+'index.jade'
    .pipe gp.changed buildDir, {extension: '.html'}
    .pipe gp.jade
      locals:
        pageTitle: config.pageTitle || 'MyApp'
        pretty: true
    .pipe gulp.dest buildDir

gulp.task 'splash', (cb)->
  runSequence ['splash-stylus', 'splash-coffee'], 'splash-jade', cb

# stylus
gulp.task 'stylus', ->
  gulp.src [
    devDir+'defaults.styl'
    tmpDir+'_sprite.styl'
    devDir+'views/**/*.styl'
  ], base: devDir
  .pipe concat 'views.styl'
  .pipe gp.stylus
    'include css': true
    errors: true
  .pipe gp.autoprefixer '> 1%', 'last 6 version', 'ff 17', 'opera 12.1', 'ios >= 5'
  .pipe gulp.dest tmpDir

# css concat
gulp.task 'css', ['stylus'],  ->
  gulp.src [
    devDir+'lib/**/*.css'
    tmpDir+'views.css'
  ]
  .pipe gp.ignore.exclude '*.min.css'
  .pipe concat 'all.css'
  .pipe gulp.dest buildDir

# coffee
gulp.task 'coffee', ->
  gulp.src devDir+'views/**/*.coffee', base: devDir
    .pipe gp.changed buildDir, {extension: '.js'}
    .pipe coffee(
      bare: true
    ).on 'error', gutil.log
    .pipe gulp.dest buildDir

# jade
gulp.task 'jade', ->
  gulp.src devDir+'views/**/*.jade', base: devDir
    .pipe gp.changed buildDir, {extension: '.html'}
    .pipe gp.plumber()
    .pipe gp.jade
      locals:
        pageTitle: config.pageTitle || 'MyApp'
      pretty: true
    .pipe gulp.dest buildDir

# index
gulp.task 'index', ->
  gulp.src devDir+'index.jade', base: devDir
    .pipe gp.plumber()
    .pipe gp.jade
      locals:
        pageTitle: config.pageTitle || 'MyApp'
      pretty: true
    .pipe gulp.dest buildDir

# React
gulp.task 'react', ->
  gulp.src devDir+'components/**/*.coffee', base: devDir
    .pipe coffee(
      bare: true
    ).on 'error', gutil.log
    .pipe gp.rename
      extname: ".jsx"
    .pipe gulp.dest devDir
  gulp.src devDir+'components/**/*.jsx', base: devDir
    .pipe gp.changed buildDir, {extension: '.js'}
    .pipe gp.react()
    .pipe gulp.dest buildDir

# resizeIcons
gulp.task 'resizeIcons', (cb) ->
  gulp.src [devDir+'content/icons/*.{png,jpg,jpeg,gif}']
  .pipe gp.changed tmpDir+'icons'
  .pipe resize
    format: 'png'
    width: 50
    height: 50
    crop: true
    upscale: false
  .pipe gulp.dest tmpDir+'icons'
  cb()

# compressImages
gulp.task 'compressImages', ->
  stream = gulp.src [devDir+'content/images/*.{png,jpg,jpeg,gif,svg}']
    .pipe gp.changed tmpDir+'compressed'
    .pipe optimize
      optimizationLevel: 3
      cache: true
      progressive: true
      interlaced: true
      use: [pngcrush()]
    .pipe gulp.dest tmpDir+'compressed'
  return stream


# resizeThumbs
gulp.task 'resizeThumbs', ->
  stream = gulp.src [tmpDir+'compressed/*.{png,jpg,jpeg,gif,svg}']
    .pipe gp.changed tmpDir+'thumbs'
    .pipe resize
      width : 180
    .pipe gulp.dest tmpDir+'thumbs'
  return stream

# resizeImages
gulp.task 'resizeImages', (cb) ->
  gulp.src [tmpDir+'compressed/*.{png,jpg,jpeg,gif,svg}']
  .pipe gp.changed buildDir+'content/images'
  .pipe gp.cache resize
    width : 650
  .pipe gulp.dest buildDir+'content/images'
  cb()

# Make Sprite
gulp.task 'mksprite', (cb)->
  gulp.src [tmpDir+'icons/*', tmpDir+'thumbs/*']
    .pipe resize
      format: 'png'
    .pipe sprite
      name: 'sprite.png'
      style: '_sprite.styl'
      cssPath: '../content/images'
      processor: 'stylus'
    .pipe optimize
      optimizationLevel: 3
      progressive: true
      use: [pngcrush()]
    .pipe gulpif '*.styl', gulp.dest tmpDir
    .pipe gulpif '*.png', gulp.dest buildDir+'content/images'
  cb()

# Images
gulp.task 'images', ['compressImages'], (cb)->
  runSequence ['resizeIcons', 'resizeThumbs', 'resizeImages'], 'mksprite', cb

# copy libs
gulp.task 'copylibs', ->
  gulp.src [devDir+'lib/**/*'], base: devDir
    .pipe gulp.dest buildDir

# Clean
gulp.task 'clean', ->
  gulp.src [prodDir, revDir, tmpDir], read: false
    .pipe gp.clean force: true

# Clean Build
gulp.task 'cleanbuild', ->
  gulp.src [buildDir], read: false
    .pipe gp.clean force: true

# Clean Rev
gulp.task 'cleanrev', ->
  gulp.src [revDir], read: false
    .pipe gp.clean force: true

# Build
gulp.task 'build', (cb)->
  runSequence 'cleanbuild', 'copylibs', 'images', 'splash', 'css', 'coffee', 'react', 'jade', cb

# Dist
gulp.task 'dist', (cb)->
  runSequence 'clean', 'build', 'treat'
  cb()

# Treat
gulp.task 'treat', (cb)->
  js = gp.filter '**/*.js'
  css = gp.filter '**/*.css'
  html = gp.filter '**/*.html'
  gulp.src buildDir+'**'
    .pipe js
    .pipe gp.uglify()
    .pipe js.restore()
    .pipe css
    .pipe minifycss
      keepSpecialComments: 0
    .pipe css.restore()
    .pipe gulp.dest prodDir
  cb()

# Revall
gulp.task 'revall', ['cleanrev'], (cb)->
  gulp.src prodDir+'**'
  .pipe revall
    ignore: [
      /^\/favicon.ico$/g
      /^\/index.html/g
      /^\/main.html/g
      /^\/content\/images\//g
      /^\/content\/icons\//g
      /^\/lib\//g
      /^\/views\//g
    ]
  .pipe gulp.dest revDir
  cb()

gulp.task 'rsynclab', ->
  remotePath = config.labRemotePath
  log remotePath
  rsync
    ssh: true
    src: revDir
    dest: 'sfeagleftp@sf-eagle.com:'+remotePath
    recursive: true
    syncDest: true
    args: ['--verbose']
  , (error, stdout, stderr, cmd)->
      gutil.log stdout

gulp.task 'rsyncwww', ->
  remotePath = config.wwwRemotePath
  log remotePath
  rsync
    ssh: true
    src: revDir
    dest: 'sfeagleftp@sf-eagle.com:'+remotePath
    recursive: true
    syncDest: true
    args: ['--verbose']
  , (error, stdout, stderr, cmd)->
      gutil.log stdout

# Default task
gulp.task 'default', ['build'], (cb)->
  runSequence 'watch', cb

gulp.task 'loadindex', ['index'], ->
  gulp.src buildDir+'index.html'
    .pipe gp.connect.reload()
# Connect
gulp.task 'connect', ->
  log 'task: connect'
  gp.connect.server
    root: buildDir
    port: 9000
    livereload: true

# Watch
gulp.task 'watch', ['connect'], ->
  runall = (tasks...)->
    log "runall: "+tasks...
    tasklist = []
    for task in tasks
      tasklist.push '"'+task+'"'
    log "runall: "+tasklist
    runSequence(tasklist)

  gulp.watch [devDir+'**'], read:false, (event) ->
    log 'watch-----------------------------------'
    fullpath = event.path
    dir = (path.dirname event.path).match(/([^\/]*)\/*$/)[1]
    file = path.basename event.path
    log "file: "+file
    if file is 'tags'
      return
    ext = path.extname event.path
    log 'path: '+fullpath
    switch ext
      when '.jade'
        task1 = 'jade'
      when '.styl'
        if file is 'splash.styl'
          task1 = 'splash'
          task2 = 'css'
        else if file is 'defaults.styl'
          task1 = 'splash'
          task2 = 'css'
        else
          task1 = 'css'
      when '.coffee'
        if file is 'loader.coffee'
          task1 = 'splash'
        else if dir is 'components'
          task1 = 'react'
        else
          task1 = 'coffee'
      when '.js'
        if dir is 'lib'
          task1 = 'copylibs'
      when '.css'
        if dir is 'lib'
          task1 = 'copylibs'
        if dir is 'anim'
          task1 = 'splash'
          task2 = 'css'
      when '.jsx'
        task1 = 'react'
      when '.jpg', '.jpeg', '.png', '.gif'
        task1 = 'img'
      else
        return
    gulp.task 'reload', (cb)->
      if task1? then tasks = [task1] else return
      if task2? then tasks.push task2
      if task3? then tasks.push task3
      tasks.push 'loadindex'
      runSequence tasks...
      cb()
    log 'reload----------------------------------'
    gulp.start 'reload'

