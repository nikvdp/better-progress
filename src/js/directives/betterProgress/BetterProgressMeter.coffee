d3 = require "d3"
$ = require "jquery"

class BetterProgressMeter

  constructor: (options) ->

    if not options
      options = {}

    @rootEl = options.rootEl or document.createElement("div")
    @size = options.size or 104
    @actual = @normalizePcts(options.actual)
    @expected = @normalizePcts(options.expected)

    @actualArc = null
    @expectedArc = null
    @actualArcPath = null
    @expectedArcPath = null

    @drawArcs()
    @updateProgress(@expected, @actual)


  normalizePcts: (pct) ->
    num = Number(pct)
    return 0 if isNaN(num)
    return 1 if num > 1
    return 0 if num < 0
    return num

  pctToRadians: (pct) ->
    Math.PI * 2 * pct

  drawArcs: () ->
    start = @pctToRadians(@actual)
    expectedStart = @pctToRadians(@expected)
    radius = Math.floor(@size / 2)

    actualArcWidth = Math.floor(radius*0.1154) # calculate the width by ratio from original spec image

    edge = radius - actualArcWidth # keep decrementing this as we paint each of the inside arcs

    @actualArc = d3.svg.arc()
    .outerRadius(radius)
    .innerRadius(edge)
    .startAngle(0)

    edge -= 1 # allow a small gap between the two progress meters

    @expectedArc = d3.svg.arc()
    .outerRadius(edge)
    .innerRadius(edge - (actualArcWidth/2))
    .startAngle(0)

    edge -= actualArcWidth/2 # subtract the wihdt of the inner (expected) meter

    svg = d3.select(@rootEl)
    .append('svg')
    .attr("width", @size)
    .attr("height", @size)
    .append('g')
    .attr('transform', "translate(#{Math.floor(radius)}, #{Math.floor(radius)})")

    edge -= actualArcWidth # leave a gap between the inner meter and the gray circle

    innerCircle = d3.svg.arc()
    .outerRadius(edge)
    .innerRadius(0)
    .startAngle(0)
    .endAngle(@pctToRadians(1))

    svg.append("path")
    .style("fill", "#f4f4f4")
    .attr('d', innerCircle)

    svg.append("text")
    .style("font-family", "sans-serif")
    .attr("data-hook", "actual-progress-text")
    .attr("text-anchor", "middle")
    .attr("font-size", "#{edge * .8}px")
    .attr("y", "5")
    .attr("fill", "black")
    .text("0")

    svg.append("text")
    .style("font-family", "sans-serif")
    .attr("text-anchor", "start")
    .attr("font-size", "#{edge * .4}px")
    .attr("dx", "1.2em")
    .attr("fill", "black")
    .text("%")

    svg.append("text")
    .style("font-family", "sans-serif")
    .attr("text-anchor", "middle")
    .attr("font-size", "#{edge * .3}px")
    .attr("dy", "1.2em")
    .attr("fill", "black")
    .text("Progress")

    @actualArcPath = svg.append("path")
    .datum(endAngle: start)
    .style('fill', '#79c600')
    .attr('d', @actualArc)

    @expectedArcPath = svg.append("path")
    .datum(endAngle: expectedStart)
    .style('fill', '#c8e993')
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

    trns = path.transition().duration(500)

    if changeColor
      trns.style("fill", changeColor)

    trns.call(arcTween, @pctToRadians(newProgress), arc)

  updateProgress: (expected, actual) ->
    expected = @normalizePcts(expected)
    actual = @normalizePcts(actual)

    changeColor = null
    diff = Math.abs(expected - actual)
    if diff > .5
      changeColor = "red"
    else if diff > .25
      changeColor = "orange"
    else
      changeColor = "#79c600"

    @_updateProgressMeter(expected, @expectedArcPath, @expectedArc)
    @_updateProgressMeter(actual, @actualArcPath, @actualArc, changeColor)

    # update the text's percentage
    $(@rootEl)
    .find("[data-hook=actual-progress-text]")
    .text(Math.floor(actual*100))

    return

module.exports = BetterProgressMeter
