app.config [
  "$urlRouterProvider"
  "$stateProvider"
  ($urlRouterProvider, $stateProvider) ->
    $urlRouterProvider.otherwise "/home"
    $stateProvider.state("home",
      url: "/home"
      templateUrl: "client/templates/home.ng.html"
      controller: "HomeCtrl")
    $stateProvider.state("home2",
      url: "/home2"
      templateUrl: "client/templates/home2.ng.html"
      controller: "HomeCtrl")
    DZ.init({
      appId : '156051',
      channelUrl : 'http://localhost:3000/channel.html'
      player: {}
    });
]


# subscribe to the two collections we use
Meteor.subscribe "Projects"
Meteor.subscribe "Tasks"
