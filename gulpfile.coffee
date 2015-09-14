fs              = require "fs"
path            = require "path"
gulp            = require "gulp"
watchify        = require "watchify"
source          = require "vinyl-source-stream"
gutil           = require "gulp-util"
browserifier    = require "./gulp/browserifier.coffee"

# optional
coffeeify       = require "coffeeify"

require("coffee-script").register()

config = {}

setup = () ->
  config =
    src:
      root: './src'
      js_dir: 'js', # should be relative to root dir
      entry: 'app.coffee' # should be inside js dir
    dest:
      root: './dist'
      bundle: 'js/bundle.js' # should be relative to root dir
    transforms: [
      coffeeify
    ]
  dev_mode: true

  normalizeConfigPaths(config)

normalizeConfigPaths = (config) ->
  config.src.root = path.normalize config.src.root
  config.dest.root = path.normalize config.dest.root
  config.src.js_dir = path.join(config.src.root, config.src.js_dir)
  config.src.entry = path.join(config.src.js_dir, config.src.entry)
  config.dest.bundle = path.join(config.dest.root, config.dest.bundle)

gulp.on "err", (err) ->
  console.log "Something went wrong!"
  process.exit 1


gulp.task "development", ->
  # hack to enable dev mode
  config.dev_mode = true

gulp.task "production", ->
  # hack to enable production mode
  config.dev_mode = false

gulp.task "browserify", ->
  browserifier(
    config.src.entry,
    config.dest.bundle,
    config.transforms,
    config.dev_mode
  )

gulp.task "watch", ["watchify", "watch-copy"]

gulp.task "watch-copy", ["development", "copy"], ->
  ignores = [
    "!#{config.src.js_dir}" # let browserify handle js
    "!#{config.src.js_dir}/**"
    "!#{config.src.root}/gulpfile.*" # don't trigger copy on gulpfile changes
  ]
  gulp.watch [path.join(config.src.root, "**")].concat(ignores), ["copy"]

gulp.task "copy", ->
  resolved_js_dir = path.resolve(config.src.js_dir)
  resolved_root_dir = path.resolve config.src.root
  gulp.src([
    "#{resolved_root_dir}/**"
    "!#{resolved_js_dir}/**"
  ])
  .pipe(gulp.dest(config.dest.root))


gulp.task "watchify", ["development", "browserify"]


gulp.task "default", [ "watch" ]


gulp.task "build", [
  "copy"
  "browserify"
]

setup()
