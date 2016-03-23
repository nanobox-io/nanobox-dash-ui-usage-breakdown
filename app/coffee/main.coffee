example = require 'jade/example'

class UsageBreakdown

  constructor: ($el) ->
    data  = { message: 'Live long and prosper.', source:'(See app/coffee/main.js)' }
    $node = $ example( data )
    $el.append $node

window.nanobox ||= {}
nanobox.UsageBreakdown = UsageBreakdown
