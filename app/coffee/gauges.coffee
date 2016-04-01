module.exports = class Gauges

  #
  constructor : ($node, options = {}) ->

    #
    self = @

    #
    @$node       = $node[0] # D3 likes actual DOM elements not jQuery DOM
    data         = options.data
    size         = options.size || 150

    #
    width        = size
    height       = size
    outerRadius  = size/2
    innerRadius  = size/2.75

    # create a pie layout function
    @pieFn = d3.layout.pie()
      .startAngle(0)
      .endAngle(Math.PI)
      .padAngle(.025)
      .sort(null)
      .value (d) -> d.value

    # create an arc generator function
    @arcFn = d3.svg.arc()
      .innerRadius(innerRadius)
      .outerRadius(outerRadius)

    # create base svg ("stage")
    @svg = d3.select(@$node)
      .append("svg:svg")
      .append("svg:g")
        .attr
          class: "gauges"
          transform:  "translate(#{0}, #{height/2})"

    # gauge positions
    posx = 0

    # create each gauge
    gauges = @svg.selectAll().data(data).enter().append("svg:g")

    # for each gauge add a label and then draw all paths
    gauges.each (d) ->

      #
      gauge = d3.select(@)

      # position each gauge relative to others; right now the positioning is
      # twice the width of a gauge away from each other, in other words - a gauges
      # width inbetween each gauge
      gauge.attr
        class: "gauge #{d.metric}"
        transform:  "translate(#{posx}, 0)"

      #
      posx += width

      # add gauge label
      gauge.append("svg:text")
        .text(d.metric)
        .attr
          class: "label"
          x: (width/2)
          y: (height/2) - 10
          "text-anchor" : "middle"

      # add metrics
      gauge.selectAll("path").data(self.pieFn(d.data))
        .enter()
          .append("path")
            .attr
              class: (d) -> d.data.type
              d: self.arcFn
              transform: "translate(#{width/2}, #{height/2}) rotate(-90)"
            .each (d) -> @_curAngle = d

  #
  update : (data = @data) ->

    #
    self = @

    # for each gauge select all the paths and update each arc
    @svg.selectAll("g.gauge").data(data).each (d) ->

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
