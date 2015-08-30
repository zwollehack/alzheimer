app.controller "HomeCtrl",
  ["$scope", "$state",  "$interval", "$window", "$meteor", "_util",
  ($scope, $state, $interval,  $window, $meteor, _util) ->
    $meteor
    .call("getUserData")
    .then((result) ->
      topo = 80
      boto = 50

      topy = 50
      boty = 20

      neighbourhoodGroups = result.groupBy (e) ->
        e.neighbourhood

      neighbourhoodGroupsWithInfo = Object.keys(neighbourhoodGroups).map (e) ->
        o = neighbourhoodGroups[e].filter (b) ->
          b.age < topo and b.age > boto

        y = neighbourhoodGroups[e].filter (c) ->
          c.age < topy and c.age > boty

        total = o.length + y.length
        oper = (o.length * 100) / total
        yper = (y.length * 100) / total

        name: e
        people: neighbourhoodGroups[e]
        youthPercentage: yper
        elderPercentage: oper

      lowerPer = 50

      matchingGroups = neighbourhoodGroupsWithInfo.filter (e) ->
        e.youthPercentage <= lowerPer

      matchingGroups
    , (error) ->
      console.log(error)
    )
  ]