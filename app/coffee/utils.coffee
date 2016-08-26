# TODO: make this more dynamic so that we aren't using hard coded variables but
# basing them off of the actual number of metrics...

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

    # convert the metrics object into an array of data arranged by metrics
    Object.keys(metrics).map (k) -> {metric: k, data: metrics[k]}

  # getServices
  @getServices : (data) ->
    services = []
    for service in data.services
      services.push service if service.type == "service"
    services

  # calculatePlatformUsage
  @calculatePlatformUsage : (data) ->
    metrics = {cpu: 0, ram: 0}
    for service in data.services
      if service.type == "internal"
        metrics.cpu += service.metrics.cpu
        metrics.ram += service.metrics.ram
    metrics

  # calculateSystemUsage
  @calculateSystemUsage : (data) ->
    [serviceCPU, serviceRAM] = [0, 0]
    for service in data.services
      serviceCPU += service.metrics.cpu
      serviceRAM += service.metrics.ram
    {cpu: data.hostStats.cpu - serviceCPU, ram: data.hostStats.ram - serviceRAM}

  # calculateUnusedResources
  @calculateUnusedResources : (data) ->
    [totalCPU, totalRAM] = [0, 0]
    for service in data.services
      totalCPU += service.metrics.cpu
      totalRAM += service.metrics.ram
    {cpu: data.hostStats.cpu - totalCPU, ram: data.hostStats.ram - totalRAM}
