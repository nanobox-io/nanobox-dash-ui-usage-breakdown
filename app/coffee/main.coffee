Gauges = require 'gauges'
Utils = require './utils'

#
component = require 'jade/component'

#
class UsageBreakdown

  #
  constructor : ($el, @options={}) ->

    # set defaults
    @options.metrics ||= ["cpu", "ram"]

    #
    @$node = $ component({metrics: @options.metrics})
    $el.append @$node

  #
  build : () ->
    @gauges = new Gauges $(".gauges", @$node)
    @$table = $("table.services", @$node)

    #
    @_updateData()

  #
  updateData : (data) =>

    #
    # data = Utils.normalize(data)

    #
    fmtData = Utils.getServices(data)
    fmtData.push {type: "internal", name: "platform", kind: "platform", metrics: Utils.calculatePlatformUsage(data)}
    fmtData.push {type: "internal", name: "system", kind: "system", metrics: Utils.calculateSystemUsage(data)}
    fmtData.push {type: "internal", name: "free", kind: "free", metrics: Utils.calculateUnusedResources(data)}

    @gauges.update(fmtData)
    @_updateTable(fmtData)

  #
  _updateTable : (data) ->

    #
    table = d3.select($("table.services tbody.stats", @$node).get(0))

    # UPDATE
    table.selectAll("tr").data(data)
      .each (d) ->
        d3.select(@).selectAll(".name").text(d.name)
        d3.select(@).selectAll(".ram").text(parseFloat((d.metrics.ram*100).toPrecision(2))+"%")
        d3.select(@).selectAll(".cpu").text(parseFloat((d.metrics.cpu*100).toPrecision(2))+"%")

    # CREATE
    table.selectAll("tr").data(data)
      .enter()
      .append("tr").attr("class", (d) -> "#{d.name} #{d.type}")
        .each (d) ->
          d3.select(@)
            .append("td").attr(class: "icon")
            .append("div").attr(class: "icon-wrap")
            .append("img").attr(class: "shadow-icon", "data-src": "hex-#{d.kind}", scalable: true)
          d3.select(@).append("td").attr(class: "stat name").text(d.name)
          d3.select(@).append("td").attr(class: "stat metric ram").text(parseFloat((d.metrics.ram*100).toPrecision(2))+"%")
          d3.select(@).append("td").attr(class: "stat metric cpu").text(parseFloat((d.metrics.cpu*100).toPrecision(2))+"%")

    #
    castShadows(@$node)

  #
  _updateData : () ->
    PubSub.publish 'STATS.SUBSCRIBE.USAGE_BREAKDOWN', {
      metrics       : @options.metrics
      services      : @options.services
      liveHostStats : @options.liveHostStats
      callback      : @updateData
    }

#
window.nanobox ||= {}
nanobox.UsageBreakdown = UsageBreakdown
