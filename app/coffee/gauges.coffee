module.exports = class Gauges

  #
  constructor : ($node, options = {}) ->

    # @$node        = $node[0]
    @data         = options.data
    @size         = 150
    @width        = @size
    @height       = @size
    @outerRadius  = @size/2
    @innerRadius  = @size/2.75
    @transform    = "translate(#{@width/2}, #{@height/2}) rotate(-90)"

    # add unused?
    # @data.push({type:"internal", value:.1})

    console.log "DATA!", @data

    # pie layout function
    @pie = d3.layout.pie()
      .startAngle(0)
      .endAngle(Math.PI)
      .value (d) -> d.value

    # arc generator function
    @arc = d3.svg.arc()
      .innerRadius(@innerRadius)
      .outerRadius(@outerRadius)

    # base svg
    @svg = d3.select($node[0])
              .append("svg:svg")
                # .datum(@data)
                .attr(
                  width  : 600
                  height : 300
                )


    # add title
    # @svg.append("svg:text")
    #   .text(options.title || 'TITLE')
    #   .attr(
    #     class : "title"
    #     x : @width/2
    #     y : @height/2 - 10
    #     "text-anchor" : "middle"
    #   )

    #
    gauges = @svg.selectAll("g.gauge")
      .data(@data)
      .enter()
        .append("svg:g")
          .attr(
            class: "gauge"
            # transform: @transform
            )
          .each (d) ->
            d3.select(@).append("svg:text")
              .text(d.metric)
              .attr(
                class : d.metric
              )




    #
    # paths = gauges.selectAll("path")
    #   .data(@pie)
    #   .enter()
    #     .append("path")
    #       .attr
    #         class: (d) ->
    #           console.log "DATA??", d
    #           d.data.type
    #         d: @arc
    #         transform: @transform
    #       # .each (d) -> @_curAngle = d

  #
  # update : (data) ->
  #   @pie.value (d) -> d.value
  #   @svg.datum(data)
  #       .selectAll("path")
  #       .data(@pie)
  #       .attr(
  #         d: @arc
  #         transform: @transform
  #       )
  #   paths.transition().duration(500).attrTween("d", @arcTween)

  #
  # arcTween : (newAngle) ->
  #   console.log "ARC?", @_curAngle, newAngle
  #   i = d3.interpolate(@_curAngle, newAngle)
  #   @_curAngle = i(0)
  #   (t) => arc i(t)

  ## util

  percToRad : (p) -> @degToRad @percToDeg(p)
  degToRad  : (d) -> d * (Math.PI/180)
  RadToDeg  : (r) -> r * (180/Math.PI)
  percToDeg : (p) -> p * 360
