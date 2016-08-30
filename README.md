## Usage
```coffeescript

# initialize
usage = new nanobox.UsageBreakdown $("body"), options
usage.build()

# update
usage.update(data)
```

#### Options
| Option=default | Description |
|---|---|
| id="" | The `id` of the service the component belongs to |

## Data structures
The data structure is an array of "service objects"

##### Single Service Object
``` coffeescript
{type:"service", name:"web1", kind:"ruby", metrics: {ram:.30, cpu:.25}}
```

##### Data by service structure (array of service objects)
```coffeescript
data = {
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
```

##### Data by metric structure
``` coffeescript
data = [
  {
    metric: "ram",
    data: [
      {type:"service",  name:"web1",     value:.30},
      {type:"service",  name:"db1",      value:.20},
      {type:"internal", name:"platform", value:.10},
      {type:"internal", name:"system",   value:.10}
    ]
  },
  {
    metric: "cpu",
    data: [
      {type:"service",  name:"web1",     value:.25},
      {type:"service",  name:"db1",      value:.25},
      {type:"internal", name:"platform", value:.10},
      {type:"internal", name:"system",   value:.10}
   ]
  }
]
```

NOTE: There are only two types of services, `internal` and `service`. `internal` services are ones that Nanobox has installed on the system, while `service`'s are actual services running as part of a users app.
