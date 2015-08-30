app.config [
  "$urlRouterProvider"
  "$stateProvider"
  ($urlRouterProvider, $stateProvider) ->
    $urlRouterProvider.otherwise "/heatmap"
    $stateProvider.state("genres",
      url: "/genres"
      templateUrl: "client/templates/genres.ng.html"
      controller: "GenresCtrl")
    $stateProvider.state("home",
      url: "/home"
      templateUrl: "client/templates/home.ng.html"
      controller: "HomeCtrl")
    $stateProvider.state("home2",
      url: "/home2"
      templateUrl: "client/templates/home2.ng.html"
      controller: "HomeCtrl")
    $stateProvider.state("register",
      url: "/register"
      templateUrl: "client/templates/register.ng.html"
      controller: "RegisterCtrl")
    $stateProvider.state("heatmap",
      url: "/heatmap"
      templateUrl: "client/templates/heatMap.ng.html"
      controller: "HeatMapCtrl")
    $stateProvider.state("heatmap2",
      url: "/heatmap2"
      templateUrl: "client/templates/heatMap.ng.html"
      controller: "HeatMapCtrl2")
    DZ.init({
      appId : '156051',
      channelUrl : 'http://localhost:3000/channel.html'
      player: {}
    });
]


# subscribe to the two collections we use
Meteor.subscribe "Projects"
Meteor.subscribe "Tasks"
