component = require 'jade/component'
Guage = require 'guage'
View = require 'view'

class UsageBreakdown extends View

  #
  constructor : ($el, @services, @data) ->
    Eventify.extend @
    @build $el

  #
  build : ($el) ->
    @$node = $ component()
    @$node.css opacity: 0
    $el.append @$node

    @fadeIn()

  #
  updateData : (data) ->

    #
    @updateServices(data)

    #
    metrics = {}
    for d in data
      for k, v of d.stats
        metrics[k] ||= []
        metrics[k].push(v)

    @updateMetrics(metrics)

  #
  updateMetrics : (data) ->
    for k, v of data
      new Guage $(".gauges", @$node), {title:k, data:v}

  #
  updateServices : (data) ->
    $target = $("tbody.stats", @$node)

    #
    for d in data
      $d = $("
        <tr class='#{d.type}'>
          <td class='icon'>#{'icon'}</td>
          <td class='stat name'>#{d.name}</td>
          <td class='stat ram'>#{d.stats.ram*100}%</td>
          <td class='stat cpu'>#{d.stats.cpu*100}%</td>
        </tr>")

      $target.append($d)

#
window.nanobox ||= {}
nanobox.UsageBreakdown = UsageBreakdown
