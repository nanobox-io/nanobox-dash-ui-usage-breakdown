module.exports = class TestData

  services : ["web1", "db1", "cache1", "worker1", "storage1"]
  internals : ["platform", "system"]

  #
  constructor: () -> @createFakeStatDataProvider()

  #
  createFakeStatDataProvider : ()->
    PubSub.subscribe 'STATS.SUBSCRIBE.USAGE_BREAKDOWN', (m, data) =>
      usageBreakdownDataSimulator.waitForData(data)

    PubSub.subscribe 'STATS.UNSUBSCRIBE', (m, data) =>

  #
  waitForData : (data) ->
    data.callback usageBreakdownDataSimulator.generateUsageBreakdownNoData()
    setInterval () ->
      data.callback usageBreakdownDataSimulator.generateUsageBreakdownData()
    , 5000

  #
  generateUsageBreakdownNoData : () ->
    data = []
    data.push {type:"service", name:service, metrics: {ram:0, cpu:0}} for service in @services
    data.push {type:"internal", name:service, metrics: {ram:0, cpu:0}} for service in @internals
    data

  #
  generateUsageBreakdownData : () ->
    data = []

    # for this simple test data, the maximum size of a metric is calculated as a
    # random number that cannot exceed 100%/the number of metrics needed.
    n = 1/(@services.length + @internals.length + 1)

    #
    for service in @services
      data.push {type:"service", name:service, metrics: {ram:((Math.random() * n) + 0.05), cpu:((Math.random() * n) + 0.05)}}

    #
    for service in @internals
      data.push {type:"internal", name:service, metrics: {ram:((Math.random() * n) + 0.05), cpu:((Math.random() * n) + 0.05)}}

    data
