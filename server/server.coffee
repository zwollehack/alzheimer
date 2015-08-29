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

Meteor.startup ->
  entries = JSON.parse(Assets.getText("entries.json"))
  console.log("Loaded #{entries.length} entries for database")


Meteor.methods
  getUserData: ->
    entries
