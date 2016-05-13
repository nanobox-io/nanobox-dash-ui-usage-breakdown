module.exports = class TestData

  services  : [
    {name:"web1", kind:"ruby"}, {name:"web2", kind:"node"}, {name:"web3", kind:"python"}, {name:"web4", kind:"java"}, {name:"web5", kind:"php"}, {name:"db1", kind:"maria-db"}, {name:"db2", kind:"postgres-db"}, {name:"db3", kind:"couch-db"}, {name:"db4", kind:"percona-db"}, {name:"storage", kind:"storage"}, {name:"db-8", kind:"redis"}, {name:"customers", kind:"default-db"}, {name:"admin", kind:"default"}
  ]
  services  : [
    {name:"web1", kind:"ruby"}, {name:"web2", kind:"mongo-db"}, {name:"web3", kind:"python"}, {name:"web4", kind:"java"}
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

    PubSub.subscribe 'STATS.UNSUBSCRIBE', (m, data) =>

  #
  waitForData : (data) ->
    data.callback usageBreakdownDataSimulator.generateUsageBreakdownNoData()
    setTimeout () ->

      # disable updates by default
      # if window.enableUpdates
      data.callback usageBreakdownDataSimulator.generateUsageBreakdownData()
    , 200

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
