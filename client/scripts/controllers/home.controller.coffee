app.controller "HomeCtrl",
  ["$scope", "$state",  "$interval", "$window", "$meteor", "_util",
  ($scope, $state, $interval,  $window, $meteor, _util) ->
    $meteor
    .call("getUserData")
    .then((result) ->
      console.log "XXX", result
    , (error) ->
      console.log(error)
    )
  ]