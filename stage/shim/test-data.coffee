module.exports = class TestData

  #
  constructor: () -> @createFakeStatDataProvider()

  #
  createFakeStatDataProvider : ()->
    PubSub.subscribe 'STATS.SUBSCRIBE.USAGE_BREAKDOWN', (m, data) =>
      data.callback usageBreakdownDataSimulator.generateUsageBreakdownData()

  #
  generateUsageBreakdownData : () ->
    {
      "liveHostStats": {"ram": 0.80, "cpu": 0.80},
      "services": [
        {"type": "service", "name": "web1", "kind": "ruby", "metrics": {"ram": 0.10, "cpu": 0.10}},
        {"type": "service", "name": "web2", "kind": "node", "metrics": {"ram": 0.10, "cpu": 0.10}},
        {"type": "service", "name": "dba1", "kind": "mongo", "metrics": {"ram": 0.10, "cpu": 0.10}},
        {"type": "internal", "name": "inta", "kind": "rout", "metrics": {"ram": 0.10, "cpu": 0.10}},
        {"type": "internal", "name": "intb", "kind": "logv", "metrics": {"ram": 0.10, "cpu": 0.10}},
        {"type": "internal", "name": "intc", "kind": "mist", "metrics": {"ram": 0.10, "cpu": 0.10}}
      ]
    }
