$ = require "jquery"
d3 = require "d3"

size = 70
pct = .5

pctToRadians = (pct) ->
  Math.PI * 2 * pct

outerArcAngle = pctToRadians(pct)
innerArcAngle = pctToRadians(pct/2)

main = () ->
  drawArcs()

drawArcs = ->

  outerArc = d3.svg.arc()
    .innerRadius(Math.floor(size))
    .outerRadius(size - 5)
    .startAngle(0)

  innerArc = d3.svg.arc()
    .innerRadius(Math.floor(size - 10))
    .outerRadius(size - 15)
    .startAngle(0)

  svg = d3.select('body')
    .append('svg')
    .attr('class', 'chart')
    .append('g')
    .attr('transform', "translate(#{Math.floor(size)}, #{Math.floor(size)})")

  outerArcPath = svg.append("path")
    .datum(endAngle: outerArcAngle)
    .style('fill', 'green')
    .attr('d', outerArc)

  innerArcPath = svg.append("path")
    .datum(endAngle: innerArcAngle)
    .style('fill', 'lightgreen')
    .attr('d', innerArc)


  updateProgress = (newProgress, path, arc) ->
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
      updateProgress Math.random(), innerArcPath, innerArc

    $('body').append button

  addButton()



$(document).ready(main)
