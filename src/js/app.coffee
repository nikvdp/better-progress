$ = require "jquery"
d3 = require "d3"

size = 70
pct = .5
angleSize = Math.PI * 2 * pct

console.log '≥≥ Size is: ', size
console.log '≥≥ Angle size is: ', angleSize

# some test data
data = [ {
  start: 0
  size: angleSize
  color: 'green'
} ]

data2 = [ {
  start: 0
  size: angleSize / 2
  color: 'red'
} ]

$(document).ready ->
  arc = d3.svg.arc()
    .innerRadius(Math.floor(size * .95))
    .outerRadius(size)
    .startAngle((d, i) ->
      d.start
    ).endAngle((d, i) ->
      d.start + d.size
    )

  arc2 = d3.svg.arc()
    .innerRadius(Math.floor(size * .80))
    .outerRadius(size - 20)
    .startAngle((d, i) ->
      d.start
    ).endAngle((d, i) ->
      d.start + d.size
    )

  chart = d3.select('body')
    .append('svg:svg')
    .attr('class', 'chart')
    .append('svg:g')
    .attr('transform', 'translate(' + Math.floor(size) + ',' + Math.floor(size) + ')')

  path = chart.selectAll('path')

  path
    .data(data)
    .enter()
    .append('svg:path')
    .style('fill', (d, i) ->
      d.color
    ).attr 'd', arc

  path
    .data(data2)
    .enter()
    .append('svg:path')
    .style('fill', (d, i) ->
      d.color
    ).attr 'd', arc2

