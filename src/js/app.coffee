$ = require "jquery"
angular = require("angular")


BetterProgressMeter = require("./BetterProgressMeter.coffee")

angular.module 'BetterProgressTestApp', []

.controller 'MainCtrl', ($scope) ->
  $scope.name = "cool"
  $scope.expected = .30
  $scope.actual = .20

.directive 'betterProgress', ->
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

