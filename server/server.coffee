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
  fullUrl = "http://api.deezer.com#{url}&access_token=frMHLvY5Rn5538e52355b6cFG4em2dj5538e52355ba42KmaS4"
  console.log fullUrl
  Meteor.http.get(fullUrl, {}, callback)

doMeteorSync = (url) ->
  response = Meteor.wrapAsync(doMeteor)(url)
  JSON.parse(response.content)


Meteor.methods
  getTracks: (genre, mood) =>
    doMeteorSync("/search?q=#{mood}")

  getGenres: ->
    doMeteorSync("/genre")
