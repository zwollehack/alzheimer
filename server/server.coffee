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
  getUserData: ->
    minLat = 180
    maxLat = 0
    minLng = 180
    maxLng = 0
    entries.forEach (e) ->
      minLat = Math.min(e.lat, minLat)
      maxLat = Math.max(e.lat, maxLat)
      minLng = Math.min(e.lng, minLng)
      maxLng = Math.max(e.lng, maxLng)


    x = entries.groupBy (e) -> e.neighbourhoodCode
    Object.keys(x).map (nCode) ->
      nb = neighbourhoods.find((e) -> e.id is "0193#{nCode}0")
      name: nb.name
      polygon: nb.polygon
      count: x[nCode].length
