app.controller "GenresCtrl",
  ["$scope", "$state", "$window", "$meteor", "_util",
    ($scope, $state, $window, $meteor, _util) ->
      $scope.genres = []
      $scope.mood = ['Happy', 'Party','Relax', 'Love', 'Focus', 'Sad']
      $scope.myGenre = null

      $scope.$watch "myGenre", ->
        refreshTracks()

      $scope.$watch "myMood", ->
        refreshTracks()

      $meteor
      .call("getGenres")
      .then((result) ->
        console.log(result)
        $scope.genres = result.data.map((res) -> res.name)
      , (error) ->
        console.log(error)
      )

      refreshTracks = ->
        if $scope.myGenre and $scope.myMood
          $meteor
          .call("getTracks", $scope.myGenre, $scope.myMood)
          .then((result) ->
            console.log(result)
            $scope.tracks = result
          , (error) ->
            console.log(error)
          )
  ]