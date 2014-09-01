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
log         = gutil.log

gulp.env['development'] = true
log gulp.env.development
config = require './.config'
devDir = config.devDir ? 'dev/'
splashDir = devDir+'splash/'
log "sd: "+splashDir
buildDir = config.buildDir ? 'build/development/'
prodDir = config.prodDir ? 'build/production/'
revDir = config.prodDir ? 'build/revisioned/'

# Splash
gulp.task 'splash-stylus', ->
  gulp.src devDir+'style.styl'
    .pipe stylus(
      'include css': true
      import: "css/required.styl"
      errors: true
    )
    .pipe gp.autoprefixer '> 1%', 'last 6 version', 'ff 17', 'opera 12.1', 'ios >= 5'
    .pipe gulp.dest devDir+"css"
gulp.task 'splash-coffee', ->
  gulp.src devDir+'loader.coffee'
    .pipe coffee(
      bare:true
    )
    .pipe gulp.dest devDir+"js"
gulp.task 'splash-jade', ->
  gulp.src devDir+'index.jade'
    .pipe gp.jade
      locals:
        pageTitle: config.pageTitle || 'MyApp'
        pretty: true
    .pipe gulp.dest buildDir

gulp.task 'splash', (cb)->
  runSequence ['splash-stylus', 'splash-coffee'], 'splash-jade', cb

# jade
gulp.task 'jade', ->
  gulp.src devDir+'views/**/*.jade', base: devDir
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

# coffee
gulp.task 'coffee', ->
  gulp.src devDir+'views/**/*.coffee', base: devDir
    .pipe coffee(
      bare: true
    ).on 'error', gutil.log
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
    .pipe gp.react()
    .pipe gulp.dest buildDir

# stylus
gulp.task 'stylus', ->
  gulp.src devDir+'views/**/*.styl', base: devDir
    .pipe gp.stylus
      'include css': true
      errors: true
      import: "../css/required.styl"
    .pipe gp.autoprefixer '> 1%', 'last 6 version', 'ff 17', 'opera 12.1', 'ios >= 5'
    .pipe gulp.dest buildDir

# Make Sprite
gulp.task 'mksprite', (cb)->
  gulp.src devDir+'content/spritesrc/*.png'
    .pipe gp.plumber()
    .pipe sprite
      name: 'sprite.png'
      style: '_sprite.styl'
      cssPath: '../content/images'
      processor: 'stylus'
    .pipe gulpif('*.styl', gulp.dest devDir+'css')
    .pipe gulpif('*.styl', gp.ignore.exclude '*.styl')
    .pipe gulpif(gulp.env.development, gulp.dest buildDir+'content/images')
    .pipe gulpif(!gulp.env.development, gulp.dest prodDir+'content/images')
  cb()

# Images
gulp.task 'img', ['mksprite'], (cb)->
  gulp.src [devDir+'content/images/**/*.{jpg,jpeg,png,svg,gif}'], base: devDir
    .pipe gp.cache gp.imagemin
      optimizationLevel: 3
      progressive: true
      interlaced: true
    .pipe gulpif(gulp.env.development, gulp.dest buildDir)
    .pipe gulpif(!gulp.env.development, gulp.dest prodDir)
  cb()

# copy libs
gulp.task 'copylibs', ->
  gulp.src [devDir+'lib/**/*', devDir+'content/icons/**/*'], base: devDir
    .pipe gulp.dest buildDir

# Clean
gulp.task 'clean', ->
  gulp.src [prodDir, revDir, 'tmp'], read: false
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
  runSequence 'cleanbuild', 'copylibs', 'img', 'splash', 'stylus', 'coffee', 'react', 'jade', cb

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

gulp.task 'rsyncwww', ['revall'], ->
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
        if file is 'index.jade'
          task1 = 'jade'
      when '.styl'
        if file is 'style.styl'
          task1 = 'splash'
        else if file is 'required.styl'
          task1 = 'splash'
          task2 = 'stylus'
          task2 = 'index'
        else
          task1 = 'stylus'
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
        if file is 'loader.js'
          task1 = 'index'
      when '.css'
        if file is 'style.js'
          task1 = 'index'
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
      log tasks...
      runSequence tasks...
      gulp.src buildDir+'index.html'
        .pipe gp.connect.reload()
      cb()
    log 'reload----------------------------------'
    gulp.start 'reload'

