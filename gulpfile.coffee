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
      tmpDir+'_sprite.styl'
      devDir+'splash.styl'
      devDir+'anim/**/*.styl'
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
    devDir+'bootstrap/**/*.styl'
    devDir+'defaults.styl'
    tmpDir+'_sprite.styl'
    devDir+'components/**/*.styl'
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


# cjsx Coffeescript version of jsx
gulp.task 'cjsx', ->
  gulp.src devDir+'components/**/*.cjsx', base: devDir
    .pipe gp.cjsx(
      bare: true
    ).on 'error', gutil.log
    .pipe concat 'cjsx.js'
    .pipe gulp.dest tmpDir

# jsx
gulp.task 'jsx', ->
  gulp.src devDir+'components/**/*.jsx', base: devDir
    .pipe gp.react()
    .pipe concat 'jsx.js'
    .pipe gulp.dest tmpDir

# React
gulp.task 'react',['cjsx', 'jsx'], ->
  gulp.src [tmpDir+'jsx.js', tmpDir+'cjsx.js'], base: devDir
    .pipe concat 'components.js'
    .pipe gulp.dest buildDir

# compressImages
gulp.task 'compressImages', ->
  stream = gulp.src [devDir+'content/images/*.{png,jpg,jpeg,gif,svg}']
    .pipe optimize
      optimizationLevel: 3
      cache: true
      progressive: true
      interlaced: true
      use: [pngcrush()]
    .pipe gulp.dest tmpDir+'compressed'
  return stream

# resizeIcons
gulp.task 'resizeIcons', ->
  stream = gulp.src [devDir+'content/icons/*.{png,jpg,jpeg,gif}']
    .pipe resize
      format: 'png'
      width: 50
      height: 50
      crop: true
      upscale: false
    .pipe gulp.dest tmpDir+'icons'
  return stream

# resizeThumbs
gulp.task 'resizeThumbs', ->
  stream = gulp.src [tmpDir+'compressed/*.{png,jpg,jpeg,gif,svg}']
    .pipe resize
      width : 180
    .pipe gulp.dest tmpDir+'thumbs'
  return stream

# resizeImages
gulp.task 'resizeImages', ->
  stream = gulp.src [tmpDir+'compressed/*.{png,jpg,jpeg,gif,svg}']
    .pipe gp.cache resize
      width : 650
    .pipe gulp.dest buildDir+'content/images'
  return stream

# Make Sprite
gulp.task 'mksprite', ->
  stream = gulp.src [tmpDir+'icons/*', tmpDir+'thumbs/*']
    .pipe resize
      format: 'png'
    .pipe sprite
      name: 'sprite.png'
      style: '_sprite.styl'
      cssPath: 'content/images'
      processor: 'stylus'
  return stream
    .pipe optimize
      optimizationLevel: 3
      use: [pngcrush()]
    .pipe gulpif '*.styl', gulp.dest tmpDir
    .pipe gulpif '*.png', gulp.dest buildDir+'content/images'

# Images
gulp.task 'images', ['compressImages'], (cb)->
  runSequence 'resizeIcons', 'resizeThumbs', 'resizeImages', 'mksprite', cb

# copy favicons
gulp.task 'copyfavicons', ->
  gulp.src [devDir+'content/favicons/**/*'], base: devDir
    .pipe gulp.dest buildDir

# cat libs
gulp.task 'catlibs', ->
  gulp.src [devDir+'lib/**/*.js'], base: devDir
    .pipe gp.ignore.exclude "*.min.js"
    .pipe concat 'libs.js'
    .pipe gulp.dest buildDir
  gulp.src [devDir+'lib/**/*.css', tmpDir+'views.css'], base: devDir
    .pipe gp.ignore.exclude "*.min.js"
    .pipe concat 'all.css'
    .pipe gulp.dest buildDir

# cat minified libs
gulp.task 'catminlibs', ->
  gulp.src [devDir+'lib/**/*.min.js'], base: devDir
    .pipe concat 'libs.js'
    .pipe gulp.dest prodDir
  gulp.src [devDir+'lib/**/*.min.css', tmpDir+'views.css'], base: devDir
    .pipe concat 'all.css'
    .pipe gulp.dest buildDir

# Treat
gulp.task 'treat', (cb)->
  js = gp.filter '**/*.js'
  css = gp.filter '**/*.css'
  html = gp.filter '**/*.html'
  gulp.src buildDir+'**/*', base: buildDir
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
      /^\/content\/favicons\//g
      /^\/lib\//g
    ]
  .pipe gulp.dest revDir
  cb()

# Clean
gulp.task 'clean', ->
  gulp.src [buildDir, prodDir, revDir, tmpDir], read: false
    .pipe gp.clean force: true

# Clean Build
gulp.task 'cleanbuild', ->
  gulp.src [buildDir], read: false
    .pipe gp.clean force: true

# Clean Rev
gulp.task 'cleanrev', ->
  gulp.src [revDir], read: false
    .pipe gp.clean force: true

# Copy Misc Files
gulp.task 'copymisc', ->
  gulp.src [devDir+'offline.manifest'], base: devDir
    .pipe gulp.dest buildDir

# Build
gulp.task 'build', (cb)->
  runSequence 'cleanbuild', 'images', 'splash', 'stylus', 'coffee', 'react', 'catlibs', 'copymisc', cb

# Dist
gulp.task 'dist', (cb)->
  runSequence 'clean', 'images', 'splash', 'stylus', 'coffee', 'react', 'catminlibs', 'copyfavicons', 'copymisc', 'treat', cb

# Default task
gulp.task 'default', ['build'], (cb)->
  runSequence 'watch', cb

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
    src: prodDir
    dest: 'sfeagleftp@sf-eagle.com:'+remotePath
    recursive: true
    syncDest: true
    args: ['--verbose']
  , (error, stdout, stderr, cmd)->
      gutil.log stdout

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
        log "in styl"
        if file is 'splash.styl'
          task1 = 'splash'
          task2 = 'stylus'
          task3 = 'catlibs'
        else if file is 'defaults.styl'
          task1 = 'splash'
          task2 = 'stylus'
          task3 = 'catlibs'
        else if dir is 'anim'
          task1 = 'splash'
          task2 = 'stylus'
          task3 = 'catlibs'
        else
          task1 = 'stylus'
          task2 = 'catlibs'
      when '.coffee'
        if file is 'loader.coffee'
          task1 = 'splash'
          task2 = 'catlibs'
        else
          task1 = 'coffee'
          task2 = 'catlibs'
      when '.js'
        if dir is 'lib'
          task1 = 'catlibs'
      when '.css'
        if dir is 'lib'
          task1 = 'catlibs'
        if dir is 'anim'
          task1 = 'splash'
          task2 = 'stylus'
          task3 = 'catlibs'
      when '.jsx'
        task1 = 'react'
      when '.cjsx'
        task1 = 'react'
      when '.jpg', '.jpeg', '.png', '.gif'
        task1 = 'images'
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

