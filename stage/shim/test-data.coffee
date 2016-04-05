module.exports = class TestData

  #
  constructor: () -> @createFakeStatDataProvider()

  #
  createFakeStatDataProvider : ()->
    PubSub.subscribe 'STATS.SUBSCRIBE.USAGE_BREAKDOWN', (m, data) =>
      usageBreakdownDataSimulator.waitForData(data)

    PubSub.subscribe 'STATS.UNSUBSCRIBE', (m, data) =>

  #
  waitForData : (data) ->
    data.callback usageBreakdownDataSimulator.generateUsageBreakdown()
    setInterval () ->
      data.callback usageBreakdownDataSimulator.generateUsageBreakdown()
    , 5000

  #
  generateUsageBreakdown : () ->
    data = []

    #
    for service in ["web1", "db1"]
      data.push {type:"service",  name:service, metrics: {ram:((Math.random() * 0.25) + 0.05), cpu:((Math.random() * 0.25) + 0.05)}}

    #
    for service in ["platform", "other"]
      data.push {type:"internal",  name:service, metrics: {ram:((Math.random() * 0.25) + 0.05), cpu:((Math.random() * 0.25) + 0.05)}}

    data
