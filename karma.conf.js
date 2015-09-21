module.exports = function(karma) {
  karma.set({

    frameworks: [ 'jasmine', 'browserify' ],

    files: [
      'test/**/*.js',
      'test/**/*.coffee'
    ],

    reporters: [ 'spec' ],

    preprocessors: {
      'test/**/*.js': [ 'browserify' ],
      'test/**/*.coffee': [ 'browserify' ]
    },

    browsers: [ 'PhantomJS' ],

    logLevel: 'LOG_DEBUG',

    singleRun: true,
    autoWatch: false,

    // browserify configuration
    browserify: {
      debug: true,
      transform: [ 'coffeeify' ]
    }
  });
};
