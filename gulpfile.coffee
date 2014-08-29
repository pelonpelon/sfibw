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
  gulp.src splashDir+'splash.styl'
    .pipe stylus(
      'include css': true
      errors: true
    )
    .pipe gp.autoprefixer '> 1%', 'last 6 version', 'ff 17', 'opera 12.1', 'ios >= 5'
    .pipe gulp.dest devDir+"splash"
    .pipe gulpif(gulp.env.development, gulp.dest buildDir)
    .pipe gulpif(!gulp.env.development, gulp.dest prodDir)
gulp.task 'splash-coffee', ->
  gulp.src splashDir+'splash.coffee'
    .pipe coffee(
      bare:true
    )
    .pipe gulp.dest devDir+"splash"
gulp.task 'splash-jade', ->
  gulp.src splashDir+'splash.jade'
    .pipe gp.jade
      locals:
        pageTitle: config.pageTitle || 'MyApp'
        pretty: true
    .pipe gp.rename 'index.html'
    .pipe gulpif(gulp.env.development, gulp.dest buildDir)
    .pipe gulpif(!gulp.env.development, gulp.dest prodDir)

gulp.task 'splash', (cb)->
  runSequence ['splash-stylus', 'splash-coffee'], 'splash-jade', cb

# jade
gulp.task 'jade', ->
  gulp.src devDir+'**/*.jade', base: devDir
    .pipe gp.plumber()
    .pipe gp.jade
      locals:
        pageTitle: config.pageTitle || 'MyApp'
      pretty: true
    .pipe gulp.dest buildDir

# coffee
gulp.task 'coffee', ->
  gulp.src devDir+'main.coffee'
    .pipe coffee(
      bare: true
    ).on 'error', gutil.log
    .pipe(if !gulp.env.development then gp.uglify() else gutil.noop())
    .pipe gp.rename 'main.js'
    .pipe gulpif(gulp.env.development, gulp.dest buildDir)
    .pipe gulpif(!gulp.env.development, gulp.dest prodDir)

# React
gulp.task 'react', ->
  gulp.src devDir+'components/**/*.coffee', base: devDir
    .pipe coffee(
      bare: true
    ).on 'error', gutil.log
    .pipe gp.rename
      extname: ".jsx"
    .pipe gulp.dest devDir+'components'
  gulp.src devDir+'components/**/*.jsx', base: devDir
    .pipe gp.react()
    .pipe gulpif(gulp.env.development, gulp.dest buildDir)
    .pipe gulpif(!gulp.env.development, gulp.dest prodDir)

# stylus
gulp.task 'stylus', ->
  gulp.src devDir+'main.styl', base: devDir
    .pipe gp.stylus
      'include css': true
      errors: true
    .pipe gp.autoprefixer '> 1%', 'last 6 version', 'ff 17', 'opera 12.1', 'ios >= 5'
    .pipe gulpif(gulp.env.development, gulp.dest buildDir)
    .pipe gulpif(!gulp.env.development, gulp.dest prodDir)

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
  gulp.src [devDir+'lib/**/*.*'], base: devDir
    .pipe gulpif(gulp.env.development, gulp.dest buildDir)
    .pipe gulpif(!gulp.env.development, gulp.dest prodDir)

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

# Upload to server
#gulp.task 'upload', (callback)->
#  gulp.src prodDir+'/**/*',
#    baseUrl: './'
#    buffer: false
#  .pipe gp.sftp
#    host: config.host
#    username: config.username
#    remotePath: config.remotePath

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
  gulp.watch [devDir+'**'], read:false, (event) ->
    fullpath = event.path
    dir = (path.dirname event.path).match(/([^\/]*)\/*$/)[1]
    file = path.basename event.path
    if file is 'tags'
      return
    ext = path.extname event.path
    log 'path: '+fullpath
    # log 'dir: '+dir
    # log 'file: '+file
    # log 'ext: '+ext
    # if (path.basename event.path).match(/_.*$/)
      # log 'watch: skipping '+file
      # return
    taskname = null
    reloadasset = null
    if dir is 'lib'
      task1 = 'copylibs'
      reloadasset = buildDir+'index.html'
    else if dir is 'splash'
      log 'splash changes'
      switch ext
        # when '.css', '.js', '.html'
          # log 'watch: skipping '+file
          # return
        when '.jade'
          task1 = 'splash'
          task2 = 'jade'
          reloadasset = buildDir+'index.html'
        when '.styl'
          task1 = 'splash'
          task2 = 'stylus'
          reloadasset = "[buildDir+'main.css', buildDir+'index.html']"
        when '.coffee'
          task1 = 'splash'
          task2 = 'coffee'
          reloadasset = "[buildDir+'main.js', buildDir+'index.html']"
        when '.jpg', '.jpeg', '.png', '.gif'
          task1 = 'img'
          reloadasset = buildDir+"content/images/#{path.basename event.path}"
        else
          return
    else
      log 'dev changes'
      switch ext
        # when '.css', '.js', '.html'
          # log 'watch: skipping '+file
          # return
        when '.jade'
          task1 = 'jade'
          reloadasset = buildDir+'index.html'
        when '.styl'
          task1 = 'stylus'
          reloadasset = "[buildDir+'main.css', buildDir+'index.html']"
        when '.coffee', '.js'
          task1 = 'coffee'
          task2 = 'react'
          reloadasset = "[buildDir+'main.js', buildDir+'index.html']"
        when '.jsx'
          task1 = 'react'
          task2 = 'coffee'
          reloadasset = "[buildDir+'main.js', buildDir+'index.html']"
        when '.jpg', '.jpeg', '.png', '.gif'
          task1 = 'img'
          reloadasset = buildDir+"content/images/#{path.basename event.path}"
          log "calling task: img"
        else
          return
    gulp.task 'reload', [task1], ->
      if task2
        runSequence task2
      log "reloading: "+reloadasset
      gulp.src reloadasset
        .pipe gp.connect.reload()
    gulp.start 'reload'
    log '----------------------------------'

