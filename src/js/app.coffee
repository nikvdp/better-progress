$ = require "jquery"
d3 = require "d3"


main = () ->
  drawArcs(400, .5, .25)

pctToRadians = (pct) ->
  Math.PI * 2 * pct

drawArcs = (size, start, expectedStart) ->
  start = pctToRadians(start)
  expectedStart = pctToRadians(expectedStart)
  radius = size / 2

  outerArc = d3.svg.arc()
    .innerRadius(Math.floor(radius))
    .outerRadius(radius - 5)
    .startAngle(0)

  innerArc = d3.svg.arc()
    .innerRadius(Math.floor(radius - 10))
    .outerRadius(radius - 15)
    .startAngle(0)

  svg = d3.select('body')
    .append('svg')
    .attr("width", size)
    .attr("height", size)
    .append('g')
    .attr('transform', "translate(#{Math.floor(radius)}, #{Math.floor(radius)})")

  outerArcPath = svg.append("path")
    .datum(endAngle: start)
    .style('fill', 'green')
    .attr('d', outerArc)

  innerArcPath = svg.append("path")
    .datum(endAngle: expectedStart)
    .style('fill', 'lightgreen')
    .attr('d', innerArc)


  updateProgressMeter = (newProgress, path, arc) ->
    ###
    Animate a transition between the current progress and the provided progress
    for the given arc and arc path

    Params:
    newProgress: a float between 0 and 1 indicating the pct progress to update to
    path: the svg path of the existing arc to be updated
    arc: arc function describing the arc to be drawn
    ###

    arcTween = (transition, newAngle, arc) ->
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
      .call(arcTween, pctToRadians(newProgress), arc)

  addButton = ->
  # Temporary function to add a button to the document for easy testing
    button = $('<button>hello</button>')
    button.on "click", ->
      updateProgressMeter Math.random(), innerArcPath, innerArc

    $('body').append button

  addButton()



$(document).ready(main)
