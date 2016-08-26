TestData = require './shim/test-data'
window.usageBreakdownDataSimulator = new TestData()

window.init = () ->
  usage = new nanobox.UsageBreakdown $("body"), {}
  usage.build()
