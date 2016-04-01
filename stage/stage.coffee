
#
genData = () ->
    data = []

    #
    for service in ["web1", "db1"]
      data.push {type:"service",  name:service, metrics: {ram:((Math.random() * 0.25) + 0.05), cpu:((Math.random() * 0.25) + 0.05)}}

    #
    for service in ["platform", "other"]
      data.push {type:"internal",  name:service, metrics: {ram:((Math.random() * 0.25) + 0.05), cpu:((Math.random() * 0.25) + 0.05)}}

    data

#
app = new nanobox.UsageBreakdown $("body"), genData()

#
setInterval () ->
  app.update(genData())
, 3000
