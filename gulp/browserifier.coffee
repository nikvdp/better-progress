browserify = require('browserify')
watchify = require('watchify')
glob = require('glob')
path = require('path')
gutil = require('gulp-util')
gulpif = require('gulp-if')
source = require('vinyl-source-stream')
gulp = require('gulp')
rename = require("gulp-rename")

browserifier = (infile, outfile, transforms, development) ->
  ###
  Wrapper to make using browserify's most common options
  easier
  ###

  filename = path.basename(infile)

  b = browserify(
    entries: './' + infile
    debug: development
    cache: {}
    packageCache: {})

  bundle = (b, infile, outfile, development) ->
    outdir = path.dirname(outfile)
    outfilename = path.basename(outfile)

    b.bundle()
    .on('error', (e) ->
      gutil.log gutil.colors.red('Browserify Error!!  ') + e.message
    )
    .pipe(source(infile))
    .pipe(rename(outfilename))
    .pipe gulp.dest(outdir)

  if development
    # Watch files
    b = watchify(b)
    # Rebundle on filechange
    b.on 'update', (file) ->
      gutil.log gutil.colors.cyan(filename), 'changed'
      bundle b, filename, outfile, development

  if transforms? and transforms instanceof Array
    transforms.forEach (transform) ->
      b.transform transform

  bundle b, infile, outfile, development

module.exports = browserifier
