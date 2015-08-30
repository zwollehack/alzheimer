app.controller "HeatMapCtrl3",
  ["$scope", "$state",  "$interval", "$window", "$meteor", "_util", "uiGmapGoogleMapApi", "uiGmapIsReady",
  ($scope, $state, $interval,  $window, $meteor, _util, uiGmapGoogleMapApi, uiGmapIsReady) ->
    map = undefined
    uiGmapIsReady.promise(1).then (instances) ->
      instances.forEach (inst) ->
        map = inst.map
        # MockHeatLayer layer
    layer = undefined

    colors = ['rgb(255,255,204)','rgb(255,237,160)','rgb(254,217,118)','rgb(254,178,76)','rgb(253,141,60)','rgb(252,78,42)','rgb(227,26,28)','rgb(189,0,38)','rgb(128,0,38)']

    # MockHeatLayer = (heatLayer) ->
    #   pointarray = undefined
    #   houseData = []
    #   # pointArray = new (google.maps.MVCArray)(houseData)
    #   #heatLayer.setData(pointArray);
    #   $meteor
    #   .call("getUserData")
    #   .then((result) ->
    #     console.log result
    #     # result.forEach (record) ->
    #     #   houseData.push({location: new google.maps.LatLng(record.lat, record.lng), weight: record.count})
    #     # heatmap = new (google.maps.visualization.HeatmapLayer)(data: pointArray)
    #     # heatmap.setMap map
    #     # heatmap.set 'radius', 20
    #     $scope.polys = result.map (r, idx) ->
    #       id: idx
    #       clickable: true,
    #       draggable: false,
    #       editable: false,
    #       visible: true,
    #       geodesic: false,
    #       stroke: {weight: 1, color: "#000080", opacity: 0.1},
    #       fill: {color: "#FFCE00", opacity: 0.3},
    #       path: r.polygon
    #     console.log $scope.polys
    #   , (error) ->
    #     console.log(error)
    #   )


    $scope.heatLayerCallback = (layer) ->
      layer = layer
      #set the heat layers backend data

    $scope.map =
      center:
        latitude: 52.5142306
        longitude: 6.1069978
      zoom: 11
    $scope.showHeat = true
    $scope.locationCompanies = []
    $scope.polys = []
    $scope.ageGroups = [
      name: "All"
      min: 0
      max: 200
    ,
      name: "18 - 24"
      min: 0
      max: 24
    ,
      name: "25 - 39"
      min: 25
      max: 39
    ,
      name: "40 - 54"
      min: 40
      max: 54
    ,
      name: "55 - 64"
      min: 54
      max: 64
    ,
      name: "65 - 74"
      min: 65
      max: 74
    ,
      name: "75 - 84"
      min: 75
      max: 84
    ,
      name: "85 + "
      min: 85
      max: 200
    ]
    $scope.ageGroup = $scope.ageGroups[0]
    uiGmapGoogleMapApi.then (maps) ->
      map = maps

    $scope.updateHeatmap = ->
      $meteor
      .call("getUserData", $scope.ageGroup)
      .then((result) ->
        console.log result
        # result.forEach (record) ->
        #   houseData.push({location: new google.maps.LatLng(record.lat, record.lng), weight: record.count})
        # heatmap = new (google.maps.visualization.HeatmapLayer)(data: pointArray)
        # heatmap.setMap map
        # heatmap.set 'radius', 20
        $scope.polys = result.map (r, idx) ->
          id: idx
          stroke: {weight: 1, color: "#222222", opacity: 0.1},
          fill: {color: colors[r.level], opacity: 0.7},
          path: r.polygon
      , (error) ->
        console.log(error)
      )


    $scope.$watch("ageGroup", $scope.updateHeatmap)
 ]
