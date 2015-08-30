Meteor.publish 'Projects', ->
  Projects.find {}
Meteor.publish 'Tasks', ->
  Tasks.find {}

Projects.allow
  insert: ->
    true
  update: ->
    true
  remove: ->
    true
Tasks.allow
  insert: ->
    true
  update: ->
    true
  remove: ->
    true

doMeteor = (url, callback) ->
  Meteor.http.get(url, {}, callback)

doMeteorSync = (url) ->
  response = Meteor.wrapAsync(doMeteor)(url)
  JSON.parse(response)

entries = []
neighbourhoods = []

Meteor.startup ->
  entries = JSON.parse(Assets.getText("entries.json"))
  console.log("Loaded #{entries.length} entries for users")
  neighbourhoods = JSON.parse(Assets.getText("bu_2014.json")).features.map (f) ->
    id: f.properties["BU_2014"]
    name: f.properties["BU_NAAM"]
    polygon: f.geometry.coordinates[0].map ([x, y]) ->
      latitude: y
      longitude: x
  console.log("Loaded #{neighbourhoods.length} entries for neighbourhoods")

Meteor.methods
  getUserData: (ageGroup) ->
    minLat = 180
    maxLat = 0
    minLng = 180
    maxLng = 0
    entries.forEach (e) ->
      minLat = Math.min(e.lat, minLat)
      maxLat = Math.max(e.lat, maxLat)
      minLng = Math.min(e.lng, minLng)
      maxLng = Math.max(e.lng, maxLng)

    groupedResult = entries
    .filter (e) ->
      e.age >= ageGroup.min and e.age <= ageGroup.max
    .groupBy (e) -> e.neighbourhoodCode
    calculatedResult = Object.keys(groupedResult).map (nCode) ->
      nb = neighbourhoods.find((e) -> e.id is "0193#{nCode}0")
      name: nb.name
      polygon: nb.polygon
      count: groupedResult[nCode].length
    sortedResult = calculatedResult.sort (a, b) -> a.count - b.count
    sortedResult.map (e, idx) ->
      e.level = Math.floor(idx / sortedResult.length * 10)
      e

  getGroupedData: (elderTop, elderBot, youthTop, youthBot, lPer, groupByCondition = "neighbourhoodCode") ->
    neighbourhoodGroups = entries.groupBy (e) ->
      e.neighbourhoodCode

    neighbourhoodGroupsWithInfo = Object.keys(neighbourhoodGroups).map (e) ->
      o = neighbourhoodGroups[e].filter (b) ->
        b.age < elderTop and b.age > elderBot

      y = neighbourhoodGroups[e].filter (c) ->
        c.age < youthTop and c.age > youthBot

      total = o.length + y.length
      oper = (o.length * 100) / total
      yper = (y.length * 100) / total

      code: e
      people: neighbourhoodGroups[e]
      youthPercentage: yper
      elderPercentage: oper

    matchingGroups = neighbourhoodGroupsWithInfo.filter (e) ->
      e.youthPercentage <= lPer

    sortedMatchingGroups = matchingGroups.sort (a, b) ->
      a.youthPercentage - b.youthPercentage

    sortedResult = sortedMatchingGroups.map (e) ->
      nb = neighbourhoods.find((b) -> b.id is "0193#{e.code}0")
      name: nb.name
      polygon: nb.polygon
      count: x[e.code].length

    sortedResult.map (e, idx) ->
      e.level = Math.floor(idx / sortedResult.length * 10)
      e

