(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var TestData;

module.exports = TestData = (function() {
  function TestData() {
    this.createFakeStatDataProvider();
  }

  TestData.prototype.createFakeStatDataProvider = function() {
    return PubSub.subscribe('STATS.SUBSCRIBE.USAGE_BREAKDOWN', (function(_this) {
      return function(m, data) {
        return data.callback(usageBreakdownDataSimulator.generateUsageBreakdownData());
      };
    })(this));
  };

  TestData.prototype.generateUsageBreakdownData = function() {
    return {
      "liveHostStats": {
        "ram": 0.80,
        "cpu": 0.80
      },
      "services": [
        {
          "type": "service",
          "name": "web1",
          "kind": "ruby",
          "metrics": {
            "ram": 0.10,
            "cpu": 0.10
          }
        }, {
          "type": "service",
          "name": "web2",
          "kind": "node",
          "metrics": {
            "ram": 0.10,
            "cpu": 0.10
          }
        }, {
          "type": "service",
          "name": "dba1",
          "kind": "mongo",
          "metrics": {
            "ram": 0.10,
            "cpu": 0.10
          }
        }, {
          "type": "internal",
          "name": "inta",
          "kind": "router",
          "metrics": {
            "ram": 0.10,
            "cpu": 0.10
          }
        }, {
          "type": "internal",
          "name": "intb",
          "kind": "logvac",
          "metrics": {
            "ram": 0.10,
            "cpu": 0.10
          }
        }, {
          "type": "internal",
          "name": "intc",
          "kind": "mist",
          "metrics": {
            "ram": 0.10,
            "cpu": 0.10
          }
        }
      ]
    };
  };

  return TestData;

})();

},{}],2:[function(require,module,exports){
var TestData;

TestData = require('./shim/test-data');

window.usageBreakdownDataSimulator = new TestData();

window.init = function() {
  var usage;
  usage = new nanobox.UsageBreakdown($("body"), {});
  return usage.build();
};

},{"./shim/test-data":1}]},{},[2])
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uL25vZGVfbW9kdWxlcy9ndWxwLWNvZmZlZWlmeS9ub2RlX21vZHVsZXMvYnJvd3NlcmlmeS9ub2RlX21vZHVsZXMvYnJvd3Nlci1wYWNrL19wcmVsdWRlLmpzIiwic2hpbS90ZXN0LWRhdGEuY29mZmVlIiwic3RhZ2UuY29mZmVlIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiJBQUFBO0FDQUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FDOUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQSIsImZpbGUiOiJnZW5lcmF0ZWQuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlc0NvbnRlbnQiOlsiKGZ1bmN0aW9uIGUodCxuLHIpe2Z1bmN0aW9uIHMobyx1KXtpZighbltvXSl7aWYoIXRbb10pe3ZhciBhPXR5cGVvZiByZXF1aXJlPT1cImZ1bmN0aW9uXCImJnJlcXVpcmU7aWYoIXUmJmEpcmV0dXJuIGEobywhMCk7aWYoaSlyZXR1cm4gaShvLCEwKTt2YXIgZj1uZXcgRXJyb3IoXCJDYW5ub3QgZmluZCBtb2R1bGUgJ1wiK28rXCInXCIpO3Rocm93IGYuY29kZT1cIk1PRFVMRV9OT1RfRk9VTkRcIixmfXZhciBsPW5bb109e2V4cG9ydHM6e319O3Rbb11bMF0uY2FsbChsLmV4cG9ydHMsZnVuY3Rpb24oZSl7dmFyIG49dFtvXVsxXVtlXTtyZXR1cm4gcyhuP246ZSl9LGwsbC5leHBvcnRzLGUsdCxuLHIpfXJldHVybiBuW29dLmV4cG9ydHN9dmFyIGk9dHlwZW9mIHJlcXVpcmU9PVwiZnVuY3Rpb25cIiYmcmVxdWlyZTtmb3IodmFyIG89MDtvPHIubGVuZ3RoO28rKylzKHJbb10pO3JldHVybiBzfSkiLCJ2YXIgVGVzdERhdGE7XG5cbm1vZHVsZS5leHBvcnRzID0gVGVzdERhdGEgPSAoZnVuY3Rpb24oKSB7XG4gIGZ1bmN0aW9uIFRlc3REYXRhKCkge1xuICAgIHRoaXMuY3JlYXRlRmFrZVN0YXREYXRhUHJvdmlkZXIoKTtcbiAgfVxuXG4gIFRlc3REYXRhLnByb3RvdHlwZS5jcmVhdGVGYWtlU3RhdERhdGFQcm92aWRlciA9IGZ1bmN0aW9uKCkge1xuICAgIHJldHVybiBQdWJTdWIuc3Vic2NyaWJlKCdTVEFUUy5TVUJTQ1JJQkUuVVNBR0VfQlJFQUtET1dOJywgKGZ1bmN0aW9uKF90aGlzKSB7XG4gICAgICByZXR1cm4gZnVuY3Rpb24obSwgZGF0YSkge1xuICAgICAgICByZXR1cm4gZGF0YS5jYWxsYmFjayh1c2FnZUJyZWFrZG93bkRhdGFTaW11bGF0b3IuZ2VuZXJhdGVVc2FnZUJyZWFrZG93bkRhdGEoKSk7XG4gICAgICB9O1xuICAgIH0pKHRoaXMpKTtcbiAgfTtcblxuICBUZXN0RGF0YS5wcm90b3R5cGUuZ2VuZXJhdGVVc2FnZUJyZWFrZG93bkRhdGEgPSBmdW5jdGlvbigpIHtcbiAgICByZXR1cm4ge1xuICAgICAgXCJsaXZlSG9zdFN0YXRzXCI6IHtcbiAgICAgICAgXCJyYW1cIjogMC44MCxcbiAgICAgICAgXCJjcHVcIjogMC44MFxuICAgICAgfSxcbiAgICAgIFwic2VydmljZXNcIjogW1xuICAgICAgICB7XG4gICAgICAgICAgXCJ0eXBlXCI6IFwic2VydmljZVwiLFxuICAgICAgICAgIFwibmFtZVwiOiBcIndlYjFcIixcbiAgICAgICAgICBcImtpbmRcIjogXCJydWJ5XCIsXG4gICAgICAgICAgXCJtZXRyaWNzXCI6IHtcbiAgICAgICAgICAgIFwicmFtXCI6IDAuMTAsXG4gICAgICAgICAgICBcImNwdVwiOiAwLjEwXG4gICAgICAgICAgfVxuICAgICAgICB9LCB7XG4gICAgICAgICAgXCJ0eXBlXCI6IFwic2VydmljZVwiLFxuICAgICAgICAgIFwibmFtZVwiOiBcIndlYjJcIixcbiAgICAgICAgICBcImtpbmRcIjogXCJub2RlXCIsXG4gICAgICAgICAgXCJtZXRyaWNzXCI6IHtcbiAgICAgICAgICAgIFwicmFtXCI6IDAuMTAsXG4gICAgICAgICAgICBcImNwdVwiOiAwLjEwXG4gICAgICAgICAgfVxuICAgICAgICB9LCB7XG4gICAgICAgICAgXCJ0eXBlXCI6IFwic2VydmljZVwiLFxuICAgICAgICAgIFwibmFtZVwiOiBcImRiYTFcIixcbiAgICAgICAgICBcImtpbmRcIjogXCJtb25nb1wiLFxuICAgICAgICAgIFwibWV0cmljc1wiOiB7XG4gICAgICAgICAgICBcInJhbVwiOiAwLjEwLFxuICAgICAgICAgICAgXCJjcHVcIjogMC4xMFxuICAgICAgICAgIH1cbiAgICAgICAgfSwge1xuICAgICAgICAgIFwidHlwZVwiOiBcImludGVybmFsXCIsXG4gICAgICAgICAgXCJuYW1lXCI6IFwiaW50YVwiLFxuICAgICAgICAgIFwia2luZFwiOiBcInJvdXRlclwiLFxuICAgICAgICAgIFwibWV0cmljc1wiOiB7XG4gICAgICAgICAgICBcInJhbVwiOiAwLjEwLFxuICAgICAgICAgICAgXCJjcHVcIjogMC4xMFxuICAgICAgICAgIH1cbiAgICAgICAgfSwge1xuICAgICAgICAgIFwidHlwZVwiOiBcImludGVybmFsXCIsXG4gICAgICAgICAgXCJuYW1lXCI6IFwiaW50YlwiLFxuICAgICAgICAgIFwia2luZFwiOiBcImxvZ3ZhY1wiLFxuICAgICAgICAgIFwibWV0cmljc1wiOiB7XG4gICAgICAgICAgICBcInJhbVwiOiAwLjEwLFxuICAgICAgICAgICAgXCJjcHVcIjogMC4xMFxuICAgICAgICAgIH1cbiAgICAgICAgfSwge1xuICAgICAgICAgIFwidHlwZVwiOiBcImludGVybmFsXCIsXG4gICAgICAgICAgXCJuYW1lXCI6IFwiaW50Y1wiLFxuICAgICAgICAgIFwia2luZFwiOiBcIm1pc3RcIixcbiAgICAgICAgICBcIm1ldHJpY3NcIjoge1xuICAgICAgICAgICAgXCJyYW1cIjogMC4xMCxcbiAgICAgICAgICAgIFwiY3B1XCI6IDAuMTBcbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgIF1cbiAgICB9O1xuICB9O1xuXG4gIHJldHVybiBUZXN0RGF0YTtcblxufSkoKTtcbiIsInZhciBUZXN0RGF0YTtcblxuVGVzdERhdGEgPSByZXF1aXJlKCcuL3NoaW0vdGVzdC1kYXRhJyk7XG5cbndpbmRvdy51c2FnZUJyZWFrZG93bkRhdGFTaW11bGF0b3IgPSBuZXcgVGVzdERhdGEoKTtcblxud2luZG93LmluaXQgPSBmdW5jdGlvbigpIHtcbiAgdmFyIHVzYWdlO1xuICB1c2FnZSA9IG5ldyBuYW5vYm94LlVzYWdlQnJlYWtkb3duKCQoXCJib2R5XCIpLCB7fSk7XG4gIHJldHVybiB1c2FnZS5idWlsZCgpO1xufTtcbiJdfQ==
