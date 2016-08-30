Utils = require './utils'

#
module.exports = class Gauges

  # this is used to calculate width, height, and inner and outer radii
  _size: 68

  #
  constructor : (@$node) ->

    # create a pie layout function
    @pieFn = d3.layout.pie()
      .startAngle(0)
      .endAngle(Math.PI)
      .padAngle(.025)
      .sort(null)
      .value (d) -> d.value

    # create an arc generator function
    @arcFn = d3.svg.arc()
      .innerRadius(@_size/1.35)
      .outerRadius(@_size)

    # create base svg ("stage")
    @svg = d3.select(@$node[0])
      .append("svg:svg")
        .attr
          class:     "gauges"
          height:    @_size
          transform: "translate(#{0}, #{@_size})"

  #
  update : (data) ->

    #
    data = Utils.getDataByMetrics(data)

    #
    self = @

    # create each gauge
    gauges = @svg.selectAll("g.gauge").data(data)
      .enter()
      .append("svg:g")
        # .style("opacity", 0)
        # .transition().duration(500).delay(250).style('opacity', 1)

      # for each gauge add a label and then draw all paths
      .each (d, i) ->

        #
        gauge = d3.select(@)

        # position each gauge relative to others
        gauge.attr
          class:      "gauge #{d.metric}"
          transform:  "translate(#{(self._size*2)*i + i*15 + 5}, 0)"

        # add gauge label
        gauge.append("svg:text").text(d.metric)
          .attr
            class: "label"
            x: (self._size)
            y: (self._size) - 10
            "text-anchor" : "middle"

        # add metrics
        gauge.selectAll("path").data(self.pieFn(d.data))
          .enter()
          .append("path")
            .attr
              class: (d) -> "#{d.data.type} #{d.data.name}"
              d: self.arcFn
              transform: "translate(#{self._size}, #{self._size}) rotate(-90)"
            .each (d) -> @_curAngle = d

    # for each gauge select all the paths and update each arc
    @svg.selectAll("g.gauge").data(data)
      .each (d) ->

        # select each path
        d3.select(@).selectAll("path").data(self.pieFn(d.data))

          # no tween update
          # .attr(d: arcFn)

          # tween update
          .transition().duration(500).attrTween("d", (newAngle) ->
            i = d3.interpolate(@_curAngle, newAngle)
            @_curAngle = i(0)
            (t) -> self.arcFn i(t)
          )
