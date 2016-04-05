## Usage
```coffeescript

# initialize
usage = new nanobox.UsageBreakdown $("body")
usage.build()

# update
usage.update(data)
```

## Data structure
The data structure is an array of "service objects"

##### Single Service Object
``` coffeescript
{type:"service", name:"web1", metrics: {ram:.30, cpu:.25}}
```

##### Full Data Structure (array of time objects)
```coffeescript
data = [
  {type:"service",  name:"web1",     metrics: {ram:.30, cpu:.25}},
  {type:"service",  name:"db1",      metrics: {ram:.20, cpu:.25}},
  {type:"internal", name:"platform", metrics: {ram:.10, cpu:.10}},
  {type:"internal", name:"other",    metrics: {ram:.10, cpu:.10}}
]
```

NOTE: There are only two types of services, `internal` and `service`. `internal` services are ones that Pagoda Box has installed on the system, while `service`'s are actual services running as part of a users app.
