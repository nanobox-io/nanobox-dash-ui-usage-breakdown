module.exports = class Utils

  # getMetrics iterates over data creating an alternate representation of the data
  # values aggregated by metrics
  @getDataByMetrics : (data) ->

    #
    metrics = {}

    # iterate over each set of data then each stat for that set, creating a new
    # object that represents the data aggregated by metric
    for d in data
      for k, v of d.metrics
        metrics[k] ||= []
        metrics[k].push {type:d.type, name: d.name, value:v}

    # calculate and add unused data (this should ensure it's always the last thing added)
    for k, v of @calculateUnused(data)
      metrics[k].push {type:"internal", name:"unused", value: v}

    # convert the metrics object into an array of data arranged by metrics
    Object.keys(metrics).map (k) -> {metric: k, data: metrics[k]}

  # calculateUnused first iterates over data aggregating all values into a "total"
  # it then iterates over each total and calculates the remaining value of
  # 100% - total (1 - total)
  @calculateUnused : (data) ->

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
