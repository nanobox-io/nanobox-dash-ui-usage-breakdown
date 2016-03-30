
#
data = [
  {type:"service",  name:"web1",     metrics: {ram:.30, cpu:.25}},
  {type:"service",  name:"db1",      metrics: {ram:.20, cpu:.25}},
  {type:"internal", name:"platform", metrics: {ram:.10, cpu:.10}},
  {type:"internal", name:"other",    metrics: {ram:.10, cpu:.10}}
]

#
app = new nanobox.UsageBreakdown $("body"), data

#
# setInterval () ->
#
#   data = [
#     { type:"service",  name:"web1",     stats: {ram:((Math.random() * 0.50) + 0.05), cpu:((Math.random() * 0.50) + 0.05)}},
#     { type:"service",  name:"db1",      stats: {ram:((Math.random() * 0.50) + 0.05), cpu:((Math.random() * 0.50) + 0.05)}},
#     { type:"internal", name:"platform", stats: {ram:((Math.random() * 0.50) + 0.05), cpu:((Math.random() * 0.50) + 0.05)}},
#     { type:"internal", name:"other",    stats: {ram:((Math.random() * 0.50) + 0.05), cpu:((Math.random() * 0.50) + 0.05)}},
#   ]
#
#   app.updateData(data)
# , 3000
