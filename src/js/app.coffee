$ = require "jquery"
angular = require("angular")

angular.module 'BetterProgressTestApp', []

.controller 'MainCtrl', ($scope) ->
  $scope.name = "cool"
  $scope.expected = .30
  $scope.actual = .20

.directive 'betterProgress', require "./directives/betterProgress/index.coffee"

