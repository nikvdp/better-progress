$ = window.jQuery = require "jquery"
angular = require("angular")

angular.module 'BetterProgressTestApp', []

.controller 'MainCtrl', ($scope) ->
  $scope.name = "cool"
  $scope.expected = .30
  $scope.actual = .20

  $scope.expected_human = $scope.expected * 100
  $scope.actual_human = $scope.actual * 100

.directive 'betterProgress', require "./directives/betterProgress/index.coffee"

