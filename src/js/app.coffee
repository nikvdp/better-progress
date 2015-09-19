$ = require "jquery"
d3 = require "d3"

class BetterProgressMeter

  constructor: (rootEl, size, start, expectedStart) ->
    @rootEl = rootEl
    @size = size or 200
    @actual = start or 0
    @expected = expectedStart or 0

    @actualArc = null
    @expectedArc = null
    @actualArcPath = null
    @expectedArcPath = null

    if rootEl
      @drawArcs()
      @updateProgress(@expected, @actual)

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

    innerCircle = d3.svg.arc()
    .innerRadius(0)
    .outerRadius(radius - 25)
    .startAngle(0)
    .endAngle(@pctToRadians(1))

    svg.append("path")
    .style("fill", "lightgray")
    .attr('d', innerCircle)

    svg.append("text")
    .style("font-family", "sans-serif")
    .attr("data-hook", "actual-progress-text")
    .attr("text-anchor", "middle")
    .attr("dx", ".3em")
    .attr("fill", "black")

    svg.append("text")
    .style("font-family", "sans-serif")
    .attr("text-anchor", "middle")
    .attr("dy", "1em")
    .attr("fill", "black")
    .text("Progress")


    ###
  .style("font-size",20)
  .append("textPath")
//  .attr("textLength",function(d,i){return 90-i*5 ;})
  .attr("xlink:href",function(d,i){return "#s"+i;})
  .attr("startOffset",function(d,i){return 3/20;})
  .attr("dy","-1em")
  .text(function(d){return d.label;})
    ###
    @actualArcPath = svg.append("path")
    .datum(endAngle: start)
    .style('fill', 'green')
    .attr('d', @actualArc)

    @expectedArcPath = svg.append("path")
    .datum(endAngle: expectedStart)
    .style('fill', 'lightgreen')
    .attr('d', @expectedArc)


  _updateProgressMeter: (newProgress, path, arc, changeColor) ->
    ###
    Animate a transition between the current progress and the provided progress
    for the given arc and arc path

    Params:
    newProgress: a float between 0 and 1 indicating the pct progress to update to
    path: the svg path of the existing arc to be updated
    arc: arc function describing the arc to be drawn
    changeColor: the value of the color to change too (optional)
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

    trns = path.transition()
    .duration(750)

    if changeColor
      trns.style("fill", changeColor)

    trns.call(arcTween, @pctToRadians(newProgress), arc)

  updateProgress: (expected, actual) ->
    changeColor = null
    console.log
    if Math.abs(expected - actual) > .5
      changeColor = "red"
    else if Math.abs(expected - actual) > .25
      changeColor = "orange"
    else
      changeColor = "green"


    @_updateProgressMeter(expected, @expectedArcPath, @expectedArc)
    @_updateProgressMeter(actual, @actualArcPath, @actualArc, changeColor)

    # update the text count
    $(@rootEl)
    .find("[data-hook=actual-progress-text]")
    .text(Math.floor(actual*100) + "%")

    return


main = () ->
  a = new BetterProgressMeter("body", 175, .3, .6)
  button = $('<button>hello</button>')
  button.on "click", ->
#    a._updateProgressMeter Math.random(), a.expectedArcPath, a.expectedArc, "red"
    a.updateProgress(Math.random(), Math.random())
  window.u = a

  $('body').append button


$(document).ready(main)
