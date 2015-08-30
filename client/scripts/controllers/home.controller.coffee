app.controller "HomeCtrl",
  ["$scope", "$state",  "$interval", "$window", "$meteor", "_util",
  ($scope, $state, $interval,  $window, $meteor, _util) ->
    $meteor
    .call("getGroupedData", 80, 40, 40, 16, 60)
    .then((result) ->
      console.log "XXX", result
    , (error) ->
      console.log(error)
    )
  ]