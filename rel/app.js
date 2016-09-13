!function t(e,a,s){function n(i,c){if(!a[i]){if(!e[i]){var o="function"==typeof require&&require;if(!c&&o)return o(i,!0);if(r)return r(i,!0);var u=new Error("Cannot find module '"+i+"'");throw u.code="MODULE_NOT_FOUND",u}var l=a[i]={exports:{}};e[i][0].call(l.exports,function(t){var a=e[i][1][t];return n(a?a:t)},l,l.exports,t,e,a,s)}return a[i].exports}for(var r="function"==typeof require&&require,i=0;i<s.length;i++)n(s[i]);return n}({1:[function(t,e,a){var s,n;n=t("./utils"),e.exports=s=function(){function t(t){this.$node=t,this.pieFn=d3.layout.pie().startAngle(0).endAngle(Math.PI).padAngle(.025).sort(null).value(function(t){return t.value}),this.arcFn=d3.svg.arc().innerRadius(this._size/1.35).outerRadius(this._size),this.svg=d3.select(this.$node[0]).append("svg:svg").attr({"class":"gauges",height:this._size,transform:"translate(0, "+this._size+")"})}return t.prototype._size=68,t.prototype.update=function(t){var e,a;return t=n.getDataByMetrics(t),a=this,e=this.svg.selectAll("g.gauge").data(t).enter().append("svg:g").each(function(t,e){var s;return s=d3.select(this),s.attr({"class":"gauge "+t.metric,transform:"translate("+(2*a._size*e+15*e+5)+", 0)"}),s.append("svg:text").text(t.metric).attr({"class":"label",x:a._size,y:a._size-10,"text-anchor":"middle"}),s.selectAll("path").data(a.pieFn(t.data)).enter().append("path").attr({"class":function(t){return t.data.type+" "+t.data.name},d:a.arcFn,transform:"translate("+a._size+", "+a._size+") rotate(-90)"}).each(function(t){return this._curAngle=t})}),this.svg.selectAll("g.gauge").data(t).each(function(t){return d3.select(this).selectAll("path").data(a.pieFn(t.data)).transition().duration(500).attrTween("d",function(t){var e;return e=d3.interpolate(this._curAngle,t),this._curAngle=e(0),function(t){return a.arcFn(e(t))}})})},t}()},{"./utils":3}],2:[function(t,e,a){var s,n,r,i,c=function(t,e){return function(){return t.apply(e,arguments)}};s=t("gauges"),r=t("./utils"),i=t("jade/component"),n=function(){function t(t,e){this.options=null!=e?e:{},this.updateData=c(this.updateData,this),this.options.metrics||(this.options.metrics=["cpu","ram"]),this.$node=$(i({metrics:this.options.metrics})),t.append(this.$node)}return t.prototype.build=function(){return this.gauges=new s($(".gauges",this.$node)),this.$table=$("table.services",this.$node),this._updateData()},t.prototype.updateData=function(t){var e;return e=r.getServices(t),e.push({type:"internal",name:"platform",kind:"platform",metrics:r.calculatePlatformUsage(t)}),e.push({type:"internal",name:"system",kind:"system",metrics:r.calculateSystemUsage(t)}),e.push({type:"internal",name:"free",kind:"free",metrics:r.calculateUnusedResources(t)}),this.gauges.update(e),this._updateTable(e)},t.prototype._updateTable=function(t){var e;return e=d3.select($("table.services tbody.stats",this.$node).get(0)),e.selectAll("tr").data(t).each(function(t){return d3.select(this).selectAll(".name").text(t.name),d3.select(this).selectAll(".ram").text(parseFloat((100*t.metrics.ram).toPrecision(2))+"%"),d3.select(this).selectAll(".cpu").text(parseFloat((100*t.metrics.cpu).toPrecision(2))+"%")}),e.selectAll("tr").data(t).enter().append("tr").attr("class",function(t){return t.name+" "+t.type}).each(function(t){return d3.select(this).append("td").attr({"class":"icon"}).append("div").attr({"class":"icon-wrap"}).append("img").attr({"class":"shadow-icon","data-src":"hex-"+t.kind,scalable:!0}),d3.select(this).append("td").attr({"class":"stat name"}).text(t.name),d3.select(this).append("td").attr({"class":"stat metric ram"}).text(parseFloat((100*t.metrics.ram).toPrecision(2))+"%"),d3.select(this).append("td").attr({"class":"stat metric cpu"}).text(parseFloat((100*t.metrics.cpu).toPrecision(2))+"%")}),castShadows(this.$node)},t.prototype._updateData=function(){return PubSub.publish("STATS.SUBSCRIBE.USAGE_BREAKDOWN",{metrics:this.options.metrics,services:this.options.services,liveHostStats:this.options.liveHostStats,callback:this.updateData})},t}(),window.nanobox||(window.nanobox={}),nanobox.UsageBreakdown=n},{"./utils":3,gauges:1,"jade/component":4}],3:[function(t,e,a){var s;e.exports=s=function(){function t(){}return t.getDataByMetrics=function(t){var e,a,s,n,r,i,c;for(r={},a=0,n=t.length;n>a;a++){e=t[a],i=e.metrics;for(s in i)c=i[s],r[s]||(r[s]=[]),r[s].push({type:e.type,name:e.name,value:c})}return Object.keys(r).map(function(t){return{metric:t,data:r[t]}})},t.getServices=function(t){var e,a,s,n,r;for(r=[],s=t.services,e=0,a=s.length;a>e;e++)n=s[e],"service"===n.type&&r.push(n);return r},t.calculatePlatformUsage=function(t){var e,a,s,n,r;for(s={cpu:0,ram:0},n=t.services,e=0,a=n.length;a>e;e++)r=n[e],"internal"===r.type&&(s.cpu+=r.metrics.cpu,s.ram+=r.metrics.ram);return s},t.calculateSystemUsage=function(t){var e,a,s,n,r,i,c;for(s=[0,0],i=s[0],c=s[1],n=t.services,e=0,a=n.length;a>e;e++)r=n[e],i+=r.metrics.cpu,c+=r.metrics.ram;return{cpu:t.liveHostStats.cpu-i,ram:t.liveHostStats.ram-c}},t.calculateUnusedResources=function(t){return{cpu:1-t.liveHostStats.cpu,ram:1-t.liveHostStats.ram}},t}()},{}],4:[function(t,e,a){e.exports=function(t){var e,a=[],s=t||{};return function(t,s){a.push('<div class="nanobox-dash-ui-usage-breakdown"><div class="component"><div class="gauges"></div><table class="services"><thead class="labels"><tr><th colspan="2"></th>'),function(){var s=t;if("number"==typeof s.length)for(var n=0,r=s.length;r>n;n++){var i=s[n];a.push('<th class="label">'+jade.escape(null==(e=i)?"":e)+"</th>")}else{var r=0;for(var n in s){r++;var i=s[n];a.push('<th class="label">'+jade.escape(null==(e=i)?"":e)+"</th>")}}}.call(this),a.push('</tr></thead><tbody class="stats"></tbody></table></div></div>')}.call(this,"metrics"in s?s.metrics:"undefined"!=typeof metrics?metrics:void 0,"undefined"in s?s.undefined:void 0),a.join("")}},{}]},{},[2]);