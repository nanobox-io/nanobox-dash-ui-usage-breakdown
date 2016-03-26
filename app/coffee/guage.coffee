module.exports = class Guage

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

    # arc function
    @arc = d3.svg.arc()
      .innerRadius(@innerRadius)
      .outerRadius(@outerRadius)
      .startAngle(@degToRad(0))

    # base svg
    @svg = d3.select($node[0]).append("svg:svg")
      .attr(
        class  : options.name || "gauge"
        width  : @width
        height : @height/2
      )

    # draw title
    @svg.append("svg:text")
      .text(options.title || 'TITLE')
      .attr(
        class : "title"
        x : @width/2
        y : @height/2 - 10
        "text-anchor" : "middle"
      )

    # something about how this is used to affect the containing group so that
    # each path doesn't have to be modified
    g = @svg.append("g").attr("transform", @transform)

    # draw the background (unused)
    g.append("svg:path")
      .datum({endAngle: @degToRad(0)})
      .style("fill", "#ececec")
      .attr("d" : @arc)
      .transition()
        .duration(500)
        .call(@arcTween, @arc, @degToRad(180))

    # draw each "used" portion
    used = g.append("svg:g").attr(class : "used")

    from = 0
    to = 0

    for i, d of @data

      # *2 becuase this is a full circle cut in half
      to += (d*100)*2

      arc = d3.svg.arc().innerRadius(@innerRadius).outerRadius(@outerRadius).startAngle(@degToRad(from))

      used.append("svg:path")
        .datum({endAngle: @degToRad(from)})
        .style("stroke" : "white", "stroke-width" : 2)
        .attr("d" : arc)
        .transition()
          .delay(250*i)
          .duration(250)
          .call(@arcTween, arc, @degToRad(to))

      # *2 because this is a full circle cut in half
      from += (d*100)*2

  ## util

  percToRad : (p) -> @degToRad @percToDeg(p)
  degToRad  : (d) -> d * (Math.PI/180)
  RadToDeg  : (r) -> r * (180/Math.PI)
  percToDeg : (p) -> p * 360

  #
  arcTween : (transition, arc, newAngle) ->
    transition.attrTween 'd', (d) ->
      interpolate = d3.interpolate(d.endAngle, newAngle)
      (t) ->
        d.endAngle = interpolate(t)
        arc d
