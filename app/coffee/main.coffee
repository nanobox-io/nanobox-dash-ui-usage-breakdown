component = require 'jade/component'
Gauges = require 'gauges'
View = require 'view'

class UsageBreakdown extends View

  # builds the initial state of the component
  constructor : ($el, @data) ->

    #
    Eventify.extend @

    # set the jade template for the component and get some reusable elements
    @$node  = $ component()
    @$table = $("table.services", @$node)

    ## build component

    # dynamically create gauge for each metric
    # for k, v of @_getDataByMetrics()
    #   @gauge.push new Gauges $(".gauges", @$node), {title:k, data:v}

    new Gauges $(".gauges", @$node), {data: @_getDataByMetrics()}

    # dynamically append table.thead headers for each metric
    for k, v of @_getDataByMetrics()
      $("thead tr", @$table).append($("<td class='label'>#{k}</td>"))

    # dynamically append table.tbody column values for each metric to the "unused"
    # portion of the table
    for k, v of @_calculateUnused()
      $("tbody#unused tr", @$table).append($("<td class='stat #{k}'>#{(v*100).toPrecision(2)}%</td>"))

    # iterate through each data point and attach a "tr" for each piece of data;
    # the "tr" will be attached to either a "services" or "internal" table.tbody
    # depending on what type of data it is
    for d in @data

      # determine the target attach point for the new row
      $target = if d.type == "service" then $("tbody#services", @$table) else $("tbody#internals", @$table)

      # create the new row
      $row = $("<tr id='#{d.name}'>
                  <td class='icon'>#{'icon'}</td>
                  <td class='stat name'>#{d.name}</td>
                </tr>")

      # dynamically append column values for each metric to the row
      for k of @_getDataByMetrics()
        $row.append($("<td class='stat #{k}'>#{d.metrics[k]*100}%</td>"))

      # attach the new row
      $target.append($row)

    # set the opacity of the component to 0, attach it, and fade it in
    @$node.css opacity: 0
    $el.append @$node
    @fadeIn()

  # update data will take data and update both gauge and table data
  updateData : (data) ->
    @updateMetrics(data)
    @updateServices(data)

  # update metrics takes data and updates each gauge with the new values
  updateMetrics : (data) ->
    for g in @gauge
      g.update(data)

  # update services takes data and updates the table with the new values
  updateServices : (data) ->
    for d in data
      for k, v of @_getDataByMetrics(data)
        $("##{d.name} .#{k}", @$node).html("#{(d.metrics[k]*100).toPrecision(2)}%")

    #
    for k, v of @_calculateUnused(data)
      $("tbody#unused .#{k}", @$table).html("#{(v*100).toPrecision(2)}%")

  ##

  # getTotals iterates over data reducing each value for each metric down to a
  # "total value"
  _getTotals : (data = @data) ->

    #
    totals = {}

    # iterate over each set of data then each stat for that set, reducing each
    # value into a singe "total" value
    for d in data
      for k, v of d.metrics
        totals[k] ||= 0
        totals[k] += v

    totals

  {metric: "ram", data: [{}, {}]}

  # getMetrics iterates over data converting creating an alternate representation
  # of the data values aggregated by metrics
  _getDataByMetrics : (data = @data) ->

    #
    metrics = {}

    # iterate over each set of data then each stat for that set, creating a new
    # object that represents the data aggregated by metric
    for d in data
      for k, v of d.metrics
        metrics[k] ||= []
        metrics[k].push {type:d.type, name: d.name, value:v}

    # convert the metrics object into an array of data arranged by metrics
    Object.keys(metrics).map (k) -> {metric: k, data: metrics[k]}

  # calculateUnused iterates over "total" data and calculates the remaining value
  # of 100 - total
  _calculateUnused : (data = @data) ->
    unused = {}
    unused[k] = (1 - v) for k, v of @_getTotals(data)
    unused

#
window.nanobox ||= {}
nanobox.UsageBreakdown = UsageBreakdown
