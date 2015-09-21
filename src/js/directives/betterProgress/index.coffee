BetterProgressMeter = require "./BetterProgressMeter.coffee"

module.exports = ->
  return {
    restrict: 'E'
    link: (scope, el, attrs) ->
      meter = new BetterProgressMeter(actual: attrs.actual, expected: attrs.expected)
      el.append(meter.rootEl)
      attrs.$observe 'expected', (val) ->
        meter.updateProgress(val, attrs.actual)
      attrs.$observe 'actual', (val) ->
        meter.updateProgress(attrs.expected, val)
  }
