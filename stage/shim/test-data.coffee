module.exports = class TestData

  services  : [
    {name:"web1", kind:"ruby"}, {name:"web2", kind:"node"}, {name:"web3", kind:"python"}, {name:"web4", kind:"java"}, {name:"web5", kind:"php"}, {name:"db1", kind:"maria"}, {name:"db2", kind:"postgres"}, {name:"db3", kind:"couch"}, {name:"db4", kind:"percona"}, {name:"storage", kind:"storage"}, {name:"db-8", kind:"redis"}, {name:"customers", kind:"default"}, {name:"admin", kind:"default"}
  ]
  services  : [
    {name:"web1", kind:"ruby"}, {name:"web2", kind:"mongo"}, {name:"web3", kind:"python"}, {name:"web4", kind:"java"}
  ]
  internals : [
    {name:"platform", kind:"platform"}, {name:"system", kind:"system"}
  ]

  #
  constructor: () ->
    @createFakeStatDataProvider()
    # window.enableUpdates = true
  #
  createFakeStatDataProvider : ()->
    PubSub.subscribe 'STATS.SUBSCRIBE.USAGE_BREAKDOWN', (m, data) =>
      usageBreakdownDataSimulator.waitForData(data)

  #
  waitForData : (data) ->
    data.callback usageBreakdownDataSimulator.generateUsageBreakdownNoData()
    setInterval () ->
      # if window.enableUpdates
      data.callback usageBreakdownDataSimulator.generateUsageBreakdownData()
    , 3000

  #
  generateUsageBreakdownNoData : () ->
    data = []
    data.push {type:"service",  name:service.name, kind:service.kind, metrics: {ram:0, cpu:0}} for service in @services
    data.push {type:"internal", name:service.name, kind:service.kind, metrics: {ram:0, cpu:0}} for service in @internals
    data

  #
  generateUsageBreakdownData : () ->
    data = []

    # for this simple test data, the maximum size of a metric is calculated as a
    # random number that cannot exceed 100%/the number of metrics needed.
    n = 1/(@services.length + @internals.length + 1)

    #
    for service in @services
      metrics = {ram:((Math.random() * n) + 0.05), cpu:((Math.random() * n) + 0.05)}
      data.push {type:"service", name:service.name, kind:service.kind, metrics: metrics}

    #
    for service in @internals
      metrics = {ram:((Math.random() * n)*0.4), cpu:((Math.random() * n)*0.2)}
      data.push {type:"internal", name:service.name, kind:service.kind, metrics: metrics}

    data
