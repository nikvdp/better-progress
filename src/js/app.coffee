$ = require "jquery"




BetterProgressMeter = require("./BetterProgressMeter.coffee")

main = () ->
  a = new BetterProgressMeter(rootEl: "body", size: 104, actual: .3, expected: .6)
  button = $('<button>hello</button>')
  button.on "click", ->
#    a._updateProgressMeter Math.random(), a.expectedArcPath, a.expectedArc, "red"
    a.updateProgress(Math.random(), Math.random())
  window.u = a

  $('body').append button


$(document).ready(main)

