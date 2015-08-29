app.controller "HomeCtrl",
  ["$scope", "$state",  "$interval", "$window", "$meteor", "_util",
  ($scope, $state, $interval,  $window, $meteor, _util) ->
    updateImageUrl = (filter) ->
      Meteor.http.call "GET", "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=706f3c16ed8d9bd4ba62f6aa311c704a&text=#{filter}&sort=interestingness-desc&per_page=25&page=1&format=json&nojsoncallback=1", (error, result) ->
        photos = JSON.parse(result.content).photos
        randomPos = Math.floor(Math.random() * photos.photo.length - 1)
        photoId = photos.photo[randomPos].id
        Meteor.http.call "GET", "https://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=706f3c16ed8d9bd4ba62f6aa311c704a&photo_id=#{photoId}&format=json&nojsoncallback=?", (error, result) ->
          list = JSON.parse(result.content).sizes.size
          $scope.$apply ->
            console.log list
            $scope.currentImageUrl = list[list.length - 1].source


    $scope.genres = []
    $scope.track = []
    $scope.playing = false
    $scope.currentTrack = null
    $scope.currentImageUrl = null
    currentIntervalTimer = null

    $scope.pause = ->
      DZ.player.pause()
      $scope.playing = false

    $scope.resume = ->
      DZ.player.play()
      $scope.playing = true

    $scope.playTrack = (track) =>
      if (not currentIntervalTimer?)
        currentIntervalTimer = $interval(->
          updateImageUrl(track.name)
        , 5000)
      DZ.player.playTracks([track.id], (response) ->
        $scope.$apply(->
          $scope.playing = true
          $scope.currentTrack = track
        )

      )

    $scope.next = ->
      index = -1
      $scope.tracks.forEach((t, i) ->
        if t is $scope.currentTrack
          index = i
      )
      $scope.playTrack($scope.tracks[index + 1])

    $scope.getGenres = ->
      DZ.api "/genre", (response) ->
        $scope.genres = response.data
        console.log $scope.genres

    $meteor
    .call("getTracks", "electro", "happy")
    .then((result) ->
      console.log(result)
      $scope.tracks = result.data
    , (error) ->
      console.log(error)
    )
  ]