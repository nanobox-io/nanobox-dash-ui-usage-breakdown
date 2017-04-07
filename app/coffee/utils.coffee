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

  # normalize; apparently we no longer need to do this, but I didn't write a note
  # as to why when I commented this out, so... not sure.
  # @normalize : (data) ->
  #   for service in data.services
  #     for k, v of service.metrics
  #       if v <= 0 then v = 0
  #   data

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
    {cpu: data.liveHostStats.cpu - serviceCPU, ram: data.liveHostStats.ram - serviceRAM}

  # calculateUnusedResources
  @calculateUnusedResources : (data) ->
    {cpu: 1 - data.liveHostStats.cpu, ram: 1 - data.liveHostStats.ram}
