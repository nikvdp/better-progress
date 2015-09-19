$ = require "jquery"
d3 = require "d3"

size = 70
pct = .5
outerArcAngle = Math.PI * 2 * pct
innerArcAngle = outerArcAngle / 2

console.log '≥≥ Size is: ', size
console.log '≥≥ Angle size is: ', outerArcAngle

$(document).ready ->
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


  svg.append("path")
    .datum(endAngle: outerArcAngle)
    .style('fill', 'green')
    .attr('d', outerArc)

  svg.append("path")
    .datum(endAngle: innerArcAngle)
    .style('fill', 'lightgreen')
    .attr('d', innerArc)

