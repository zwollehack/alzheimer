app.controller "RegisterCtrl",
  ["$scope", "$state", "$window", "$meteor", "_util",
  ($scope, $state, $window, $meteor, _util) ->
    $scope.user =
      username: null
      password: "" + Math.random()
      profile:
        gender: null
        accessToken: null
        accessTokenExpirationTime: null
        deezerID: null

    $scope.creatingUser = false

    $scope.deezerLogin = ->
      DZ.login ((response) ->
        if response.authResponse
          DZ.api '/user/me', (response) ->
            $scope.user.username = response.name
            $scope.user.profile.gender = response.gender
            $scope.register()
          console.log 'Welcome!  Fetching your information.... '
          $scope.user.profile.accessToken = response.authResponse.accessToken
          $scope.user.profile.accessTokenExpirationTime = response.authResponse.expire
          $scope.user.profile.deezerID = response.userID
        else
          console.log 'User cancelled login or did not fully authorize.'
      ),perms: 'basic_access,email,offline_access,listening_history,manage_library'

    $scope.register = ->
      $scope.creatingUser = true
      if (_util.str.isEmpty($scope.user.username))
        $window.alert("Please fill out all fields")
        return

      $meteor.createUser($scope.user).then( ->
        console.log($scope.currentUser)
        $state.go("home")
      , (error) ->
        console.log(error)
        $window.alert(error)
      ).finally(->
        $scope.creatingUser = false
      )
  ]