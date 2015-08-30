app.controller "HomeCtrl",
  ["$scope", "$state",  "$interval", "$window", "$meteor", "_util",
  ($scope, $state, $interval,  $window, $meteor, _util) ->
    console.log "HOME"
    $meteor
    .call("getIndividualData")
    .then((result) ->
      console.log "YYY"
    , (error) ->
      console.log(error)
    )
  ]