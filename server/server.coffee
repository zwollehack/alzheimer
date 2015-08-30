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
groupedData = []
answers = []

Meteor.startup ->
  entries = JSON.parse(Assets.getText("entries.json"))
  console.log("Loaded #{entries.length} entries for users")
  answers = JSON.parse(Assets.getText("answers.json"))
  console.log("Loaded #{answers.length} answers for users")
  neighbourhoods = JSON.parse(Assets.getText("bu_2014.json")).features.map (f) ->
    id: f.properties["BU_2014"]
    name: f.properties["BU_NAAM"]
    polygon: f.geometry.coordinates[0].map ([x, y]) ->
      latitude: y
      longitude: x
  console.log("Loaded #{neighbourhoods.length} entries for neighbourhoods")

Meteor.methods
  getUserData: (levelOfDetail, ageGroup, question = "none") ->
    minLat = 180
    maxLat = 0
    minLng = 180
    maxLng = 0
    entries.forEach (e) ->
      minLat = Math.min(e.lat, minLat)
      maxLat = Math.max(e.lat, maxLat)
      minLng = Math.min(e.lng, minLng)
      maxLng = Math.max(e.lng, maxLng)

    if (levelOfDetail is "single")
      entries
      .filter (e) ->
        e.age >= ageGroup.min and e.age <= ageGroup.max
      .map (e) ->
        lat: e.lat
        lng: e.lng
        count: 1
    else if (levelOfDetail is "neighbourhoodCode" and question is "none")
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
    else if (levelOfDetail is "neighbourhoodCode")
      answer = answers.find((a) -> a.question is question)
      groupedAnswers = answer.data.groupBy((d) -> d.neighbourhood)
      Object.keys(groupedAnswers).map (neighbourhood) ->
        neighbourhoodData = neighbourhoods.find((e) -> e.name.toLowerCase().replace("-", " ") is neighbourhood.toLowerCase().replace("-", " "))
        if (not neighbourhoodData?)
          console.log neighbourhood
        sum = groupedAnswers[neighbourhood]
        console.log neighbourhoodData?.id

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

    groupedData = matchingGroups

    sortedResult = matchingGroups.map (e) ->
      nb = neighbourhoods.find((b) -> b.id is "0193#{e.code}0")
      name: nb.name
      polygon: nb.polygon
      count: neighbourhoods[e.code]?.length

    sortedResult.map (e, idx) ->
      e.level = Math.floor(idx / sortedResult.length * 10)
      e

  getIndividualData: ->
    console.log "X"
    people = groupedData.flatMap ((s) -> s.people)
    anwsers = JSON.parse(Assets.getText("questionary.json"))
    filteredPeople = people.map (e) ->

      anwsers2 = anwsers.filter((f) -> f.postalCode is e.postalCode)
      anwser = anwsers2[0]
      console.log "AAA", anwser
      wth = 0
      nh = 0

      if(anwser?)
        Object.keys(anwser).forEach (a) ->
          console.log 5, a
          if (a is 1)
            console.log 4, a
            wth++
          else if (a is 2)
            console.log 6, a
            nh++
          console.log 2, a
        weight = 0

        if (nh > wth)
          weight = 10
        else if( nh < wth)
          weight = 1

        console.log 3
        if (weight > 0)
          lat: e.latitude
          lng: e.longitude
          count: weight
      else
        null

    console.log "Finished questionary matching"

    x = filteredPeople.filter (fp) ->
      fp is not null

    x
