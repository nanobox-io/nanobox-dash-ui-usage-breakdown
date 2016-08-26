Gauges = require 'gauges'
Utils = require './utils'

#
component = require 'jade/component'

#
class UsageBreakdown

  #
  constructor : ($el, @options={}) ->

    # set defaults
    if !@options.metrics then @options.metrics = ["cpu", "ram"]

    #
    @$node = $ component({metrics: @options.metrics})
    $el.append @$node

  #
  build : () ->

    #
    @gauges = new Gauges $(".gauges", @$node)
    @$table = $("table.services", @$node)

    #
    @_updateData()

  #
  updateData : (data) =>
    @gauges.update(Utils.getDataByMetrics(data))
    @_updateTable(data)

  #
  _updateTable : (data) ->

    # add unused data to the dataset
    data.push {type: "internal", name: "free", metrics: Utils.calculateUnused(data)}

    #
    table = d3.select($("table.services tbody.stats", @$node).get(0))

    # UPDATE
    table.selectAll("tr").data(data)
      .each (d) ->
        d3.select(@).selectAll(".name").text(d.name)
        d3.select(@).selectAll(".ram").text("#{(d.metrics.ram*100).toPrecision(2)}%")
        d3.select(@).selectAll(".cpu").text("#{(d.metrics.cpu*100).toPrecision(2)}%")

    # CREATE
    table.selectAll("tr").data(data)
      .enter()
      .append("tr").attr("class", (d) -> d.name)
        .each (d) ->
          d3.select(@)
            .append("td").attr(class: "icon")
            .append("div").attr(class: "icon-wrap")
            .append("img").attr(class: "shadow-icon", "data-src": "hex-#{d.kind}", scalable: true)
          d3.select(@).append("td").attr(class: "stat name").text(d.name)
          d3.select(@).append("td").attr(class: "stat metric ram").text("#{(d.metrics.ram*100).toPrecision(2)}%")
          d3.select(@).append("td").attr(class: "stat metric cpu").text("#{(d.metrics.cpu*100).toPrecision(2)}%")

    #
    castShadows $("tbody", @$table)

  #
  _updateData : () ->
    PubSub.publish 'STATS.SUBSCRIBE.USAGE_BREAKDOWN', {
      entity         : @options.entity
      entityId       : @options.entityId
      metrics        : @options.metrics
      callback       : @updateData
    }

#
window.nanobox ||= {}
nanobox.UsageBreakdown = UsageBreakdown
