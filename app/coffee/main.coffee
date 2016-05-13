component = require 'jade/component'
Gauges = require 'gauges'
statRow = require 'jade/stats-row'

class UsageBreakdown

  # builds the initial state of the component
  constructor : ($el, @options={}) ->

    # set the jade template for the component and get some reusable elements
    @$node = $ component()
    $el.append @$node

    #
    @build()

  #
  build : () ->

    #
    @$gauges = $(".gauges", @$node)
    @$table = $("table.services", @$node)

    #
    @_subscribeToUsageBreakdownData(@options.id)

  # update will take a set of data and build the component if it's the first data
  # received, or update the component if it's new data
  update : (data) =>

    # if the guages have already exist update them, otherwise build them
    if $("svg", @$gauges).length then @_updateGauges(data) else @_buildGauges(data)

    # if the table's already been built update date it, otherwise build it
    if $("tbody.stats", @$table).children().length then @_updateTable(data) else @_buildTable(data)

  #
  _buildGauges : (data) -> @gauges = new Gauges @$gauges, {data: @_getDataByMetrics(data)}

  #
  _buildTable : (data) ->

    # dynamically append table.thead headers for each metric
    for m in @_getDataByMetrics(data)
      $("thead tr", @$table).append($("<th class='label'>#{m.metric}</td>"))

    # add unused data to the dataset
    data.push {type: "internal", name: "free", metrics: @_calculateUnused(data)}

    # iterate through each data point and attach a "tr" for each piece of data;
    # the "tr" will be attached to either a "services" or "internal" table.tbody
    # depending on what type of data it is
    for d, i in data

      rows = []
      # grab the column values for each metric
      for m in @_getDataByMetrics(data)
        rows.push {metric: m.metric, val:m.data[i].value*100 }

      # create a new row
      $row = $ statRow( {name:d.name, kind:d.kind, rows:rows} )

      # attach the new row
      $("tbody", @$table).append($row)

    castShadows $("tbody", @$table)

  # update metrics takes data and updates each gauge with the new values
  _updateGauges : (data) -> @gauges.update(@_getDataByMetrics(data))

  # update services takes data and updates the table with the new values
  _updateTable : (data) ->

    # add unused data to the dataset
    data.push {type: "internal", name: "free", metrics: @_calculateUnused(data)}

    #
    for d, i in data
      for m in @_getDataByMetrics(data)
        $(".#{d.name} .#{m.metric}", @$node).html("#{(m.data[i].value*100).toPrecision(2)}%")

  #
  _subscribeToUsageBreakdownData : (id) ->
    PubSub.publish 'STATS.SUBSCRIBE.USAGE_BREAKDOWN', {
      statProviderId : id
      callback       : @update
    }

  # getMetrics iterates over data converting creating an alternate representation
  # of the data values aggregated by metrics
  _getDataByMetrics : (data) ->

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
  _calculateUnused : (data) ->

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
