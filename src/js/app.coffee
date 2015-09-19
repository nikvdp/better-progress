$ = require "jquery"
d3 = require "d3"

class BetterProgressMeter

  constructor: (rootEl, size, start, expectedStart) ->
    @rootEl = rootEl
    @size = size
    @actual = start
    @expected = expectedStart

    @actualArc = null
    @expectedArc = null
    @actualArcPath = null
    @expectedArcPath = null

    if rootEl
      @drawArcs()

  pctToRadians: (pct) ->
    Math.PI * 2 * pct

  drawArcs: () ->
    start = @pctToRadians(@actual)
    expectedStart = @pctToRadians(@expected)
    radius = @size / 2

    @actualArc = d3.svg.arc()
    .innerRadius(Math.floor(radius))
    .outerRadius(radius - 5)
    .startAngle(0)

    @expectedArc = d3.svg.arc()
    .innerRadius(Math.floor(radius - 10))
    .outerRadius(radius - 15)
    .startAngle(0)

    svg = d3.select(@rootEl)
    .append('svg')
    .attr("width", @size)
    .attr("height", @size)
    .append('g')
    .attr('transform', "translate(#{Math.floor(radius)}, #{Math.floor(radius)})")

    @actualArcPath = svg.append("path")
    .datum(endAngle: start)
    .style('fill', 'green')
    .attr('d', @actualArc)

    @expectedArcPath = svg.append("path")
    .datum(endAngle: expectedStart)
    .style('fill', 'lightgreen')
    .attr('d', @expectedArc)


  _updateProgressMeter: (newProgress, path, arc) ->
    ###
    Animate a transition between the current progress and the provided progress
    for the given arc and arc path

    Params:
    newProgress: a float between 0 and 1 indicating the pct progress to update to
    path: the svg path of the existing arc to be updated
    arc: arc function describing the arc to be drawn
    ###

    arcTween = (transition, newAngle, arc) =>
      ###
      arcTween function adapted from http://bl.ocks.org/mbostock/5100636
      ###
      transition.attrTween 'd', (d) ->
        interpolate = d3.interpolate(d.endAngle, newAngle)
        return (t) ->
          d.endAngle = interpolate(t)
          return arc(d)

    path.transition()
    .duration(750)
    .call(arcTween, @pctToRadians(newProgress), arc)

  updateProgress: (expected, actual) ->
    @_updateProgressMeter(expected, @expectedArcPath, @expectedArc)
    @_updateProgressMeter(actual, @actualArcPath, @actualArc)




main = () ->
  a = new BetterProgressMeter("body", 400, .5, .25)
  button = $('<button>hello</button>')
  button.on "click", ->
    a._updateProgressMeter Math.random(), a.expectedArcPath, a.expectedArc
  window.u = a

  $('body').append button






$(document).ready(main)
