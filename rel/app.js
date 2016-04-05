!function t(e,n,a){function s(i,u){if(!n[i]){if(!e[i]){var o="function"==typeof require&&require;if(!u&&o)return o(i,!0);if(r)return r(i,!0);var c=new Error("Cannot find module '"+i+"'");throw c.code="MODULE_NOT_FOUND",c}var l=n[i]={exports:{}};e[i][0].call(l.exports,function(t){var n=e[i][1][t];return s(n?n:t)},l,l.exports,t,e,n,a)}return n[i].exports}for(var r="function"==typeof require&&require,i=0;i<a.length;i++)s(a[i]);return s}({1:[function(t,e,n){var a;e.exports=a=function(){function t(t,e){var n,a,s,r,i,u,o,c,l;null==e&&(e={}),o=this,this.$node=t[0],n=e.data,c=e.size||150,l=c,s=c,i=c/2,r=c/2.75,this.pieFn=d3.layout.pie().startAngle(0).endAngle(Math.PI).padAngle(.025).sort(null).value(function(t){return t.value}),this.arcFn=d3.svg.arc().innerRadius(r).outerRadius(i),this.svg=d3.select(this.$node).append("svg:svg").append("svg:g").attr({"class":"gauges",transform:"translate(0, "+s/2+")"}),u=0,a=this.svg.selectAll().data(n).enter().append("svg:g"),a.each(function(t){var e;return e=d3.select(this),e.attr({"class":"gauge "+t.metric,transform:"translate("+u+", 0)"}),u+=l,e.append("svg:text").text(t.metric).attr({"class":"label",x:l/2,y:s/2-10,"text-anchor":"middle"}),e.selectAll("path").data(o.pieFn(t.data)).enter().append("path").attr({"class":function(t){return t.data.type},d:o.arcFn,transform:"translate("+l/2+", "+s/2+") rotate(-90)"}).each(function(t){return this._curAngle=t})})}return t.prototype.update=function(t){var e;return null==t&&(t=this.data),e=this,this.svg.selectAll("g.gauge").data(t).each(function(t){return d3.select(this).selectAll("path").data(e.pieFn(t.data)).transition().duration(500).attrTween("d",function(t){var n;return n=d3.interpolate(this._curAngle,t),this._curAngle=n(0),function(t){return e.arcFn(n(t))}})})},t}()},{}],2:[function(t,e,n){var a,s,r,i=function(t,e){return function(){return t.apply(e,arguments)}};r=t("jade/component"),a=t("gauges"),s=function(){function t(t,e){this.id=e,this.update=i(this.update,this),this.$node=$(r()),t.append(this.$node),this.build()}return t.prototype.build=function(){return this._subscribeToUsageBreakdownData(this.id)},t.prototype.update=function(t){return this.$gauges=$("#gauges",this.$node),this.$table=$("table.services",this.$node),$("svg",this.$gauges).length?this._updateGauges(t):this._buildGauges(t),$("tbody#services",this.$table).length?this._updateTable(t):this._buildTable(t)},t.prototype._buildGauges=function(t){return this.gauges=new a(this.$gauges,{data:this._getDataByMetrics(t)})},t.prototype._buildTable=function(t){var e,n,a,s,r,i,u,o,c,l,d,h,p,g;for(this.$services=$("<tbody id='services' class='stats'></tbody>"),this.$internals=$("<tbody id='internals' class='stats'></tbody>"),h=this._getDataByMetrics(t),r=0,u=h.length;u>r;r++)l=h[r],$("thead tr",this.$table).append($("<td class='label'>"+l.metric+"</td>"));for(t.push({type:"internal",name:"unused",metrics:this._calculateUnused(t)}),this.$table.append(this.$services,this.$internals),g=[],s=i=0,o=t.length;o>i;s=++i){for(a=t[s],n="service"===a.type?this.$services:this.$internals,e=$("<tr id='"+a.name+"'> <td class='icon'>icon</td> <td class='stat name'>"+a.name+"</td> </tr>"),p=this._getDataByMetrics(t),d=0,c=p.length;c>d;d++)l=p[d],e.append($("<td class='stat "+l.metric+"'>"+100*l.data[s].value+"%</td>"));g.push(n.append(e))}return g},t.prototype._updateGauges=function(t){return this.gauges.update(this._getDataByMetrics(t))},t.prototype._updateTable=function(t){var e,n,a,s,r,i;for(t.push({type:"internal",name:"unused",metrics:this._calculateUnused(t)}),i=[],n=a=0,s=t.length;s>a;n=++a)e=t[n],i.push(function(){var a,s,i,u;for(i=this._getDataByMetrics(t),u=[],a=0,s=i.length;s>a;a++)r=i[a],u.push($("#"+e.name+" ."+r.metric,this.$node).html((100*r.data[n].value).toPrecision(2)+"%"));return u}.call(this));return i},t.prototype._subscribeToUsageBreakdownData=function(t){return PubSub.publish("STATS.SUBSCRIBE.USAGE_BREAKDOWN",{statProviderId:t,callback:this.update})},t.prototype._getDataByMetrics=function(t){var e,n,a,s,r,i,u,o;for(r={},n=0,s=t.length;s>n;n++){e=t[n],i=e.metrics;for(a in i)o=i[a],r[a]||(r[a]=[]),r[a].push({type:e.type,name:e.name,value:o})}u=this._calculateUnused(t);for(a in u)o=u[a],r[a].push({type:"internal",name:"unused",value:o});return Object.keys(r).map(function(t){return{metric:t,data:r[t]}})},t.prototype._calculateUnused=function(t){var e,n,a,s,r,i,u,o;for(i={},u={},n=0,s=t.length;s>n;n++){e=t[n],r=e.metrics;for(a in r)o=r[a],i[a]||(i[a]=0),i[a]+=o}for(a in i)o=i[a],u[a]=1-o;return u},t}(),window.nanobox||(window.nanobox={}),nanobox.UsageBreakdown=s},{gauges:1,"jade/component":3}],3:[function(t,e,n){e.exports=function(t){var e=[];return e.push('<div class="component"><h4 class="title">Resouce Usage Breakdown</h4><div id="gauges"></div><table class="services"><thead class="labels"><tr><td colspan="2"></td></tr></thead></table></div>'),e.join("")}},{}]},{},[2]);