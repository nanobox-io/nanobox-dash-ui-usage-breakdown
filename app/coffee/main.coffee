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

    # create gauges
    @gauges = new Gauges $("#gauges", @$node), {data: @_getDataByMetrics()}

    # dynamically append table.thead headers for each metric
    for m in @_getDataByMetrics()
      $("thead tr", @$table).append($("<td class='label'>#{m.metric}</td>"))

    # add unused data to the dataset
    @data.push {type: "internal", name: "unused", metrics: @_calculateUnused()}

    # iterate through each data point and attach a "tr" for each piece of data;
    # the "tr" will be attached to either a "services" or "internal" table.tbody
    # depending on what type of data it is
    for d, i in @data

      # determine the target attach point for the new row
      $target = if d.type == "service" then $("tbody#services", @$table) else $("tbody#internals", @$table)

      # create the new row
      $row = $("<tr id='#{d.name}'>
                  <td class='icon'>#{'icon'}</td>
                  <td class='stat name'>#{d.name}</td>
                </tr>")

      # dynamically append column values for each metric to the row
      for m in @_getDataByMetrics()
        $row.append($("<td class='stat #{m.metric}'>#{m.data[i].value*100}%</td>"))

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
  updateMetrics : (data) -> @gauges.update(@_getDataByMetrics(data))

  # update services takes data and updates the table with the new values
  updateServices : (data) ->

    # add unused data to the dataset
    data.push {type: "internal", name: "unused", metrics: @_calculateUnused(data)}

    for d, i in data
      for m in @_getDataByMetrics(data)
        $("##{d.name} .#{m.metric}", @$node).html("#{(m.data[i].value*100).toPrecision(2)}%")

  ##

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

    # calculate and add unused data (this should ensure it's always the last thing added)
    for k, v of @_calculateUnused(data)
      metrics[k].push {type:"internal", name:"unused", value: v}

    # convert the metrics object into an array of data arranged by metrics
    Object.keys(metrics).map (k) -> {metric: k, data: metrics[k]}

  # calculateUnused first iterates over data aggregating all values into a "total"
  # it then iterates over each total and calculates the remaining value of
  # 100% - total (1 - total)
  _calculateUnused : (data = @data) ->

    #
    totals = {}
    unused = {}

    # iterate over each set of data then each stat for that set, reducing each
    # value into a singe "total" value
    for d in data
      for k, v of d.metrics
        totals[k] ||= 0
        totals[k] += v

    # iterate over each total calculating the remaining out of 100% (1)
    unused[k] = (1 - v) for k, v of totals

    # return the unused
    unused

#
window.nanobox ||= {}
nanobox.UsageBreakdown = UsageBreakdown
