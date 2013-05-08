svg = d3.select("#svg").append("svg")
colors = d3.scale.category20()
class_num = 5
width = 800
height = 200
bin = 50

xscale = d3.scale.linear()
  .domain([0, bin])
  .range([0, width])
yscale = d3.scale.linear()
  .range([height, 0])

change = ->
  d3.json "data/#{this.options[this.selectedIndex].value}", (data)->
    max = d3.max data, (d) ->
      d["speed"]
    binwidth = max / bin
    bins = []
    for d in data
      target = Math.floor(d["speed"]/binwidth)
      if bins[target] == undefined
        bins[target] = []
      bins[target].push(d)
    rects = []
    sumarray = []
    bins.forEach (one_bin, binid)->
      accum = []
      one_bin.forEach (d)->
        idx = d["class"]
        if accum[idx] == undefined
          accum[idx] = 0
        accum[idx] += 1
      sum = 0
      accum.forEach (d, cls)->
        rects.push {
          x: binid,
          klass: cls,
          value_from: sum,
          value_to: d + sum
        }
        sum += d
      sumarray.push(sum)
    yscale.domain([0, d3.max(sumarray)])
    svg.selectAll("rect").remove()
    target = svg.selectAll("rect").data(rects)
    target.enter()
      .append("rect")
      .attr("x", (d,i)->Math.floor(xscale(d["x"])))
      .attr("y", (d,i)->Math.floor(yscale(d["value_to"])))
      .attr("width", 10)
      .attr("height", (d)-> height - yscale(d["value_to"]-d["value_from"]))
      .attr("fill", (d)->colors(d["klass"]))
      .attr("stroke", "#333")
      .attr("stroke-width", 1)
    target.exit().remove()


d3.json "filename.json", (list)->
  d3.select("#filename").append("select")
    .on("change", change)
    .selectAll("option").data(list).enter().append("option")
    .text((d)->d)
  console.log "ok"
