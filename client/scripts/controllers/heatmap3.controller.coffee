app.controller "HeatMapCtrl3",
  ["$scope", "$state",  "$interval", "$timeout", "$window", "$meteor", "_util", "uiGmapGoogleMapApi", "uiGmapIsReady",
  ($scope, $state, $interval, $timeout, $window, $meteor, _util, uiGmapGoogleMapApi, uiGmapIsReady) ->
    map = undefined
    heatmap = undefined
    $scope.heatMapData = [];
    uiGmapIsReady.promise(1).then (instances) ->
      instances.forEach (inst) ->
        map = inst.map
        heatmap = new (google.maps.visualization.HeatmapLayer)(data: $scope.heatMapData)
        heatmap.setMap map
        # MockHeatLayer layer
    layer = undefined

    colors = ['rgb(247,251,255)','rgb(222,235,247)','rgb(198,219,239)','rgb(158,202,225)','rgb(107,174,214)','rgb(66,146,198)','rgb(33,113,181)','rgb(8,81,156)','rgb(8,48,107)']

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
    $scope.elderMin = 40
    $scope.elderMax = 60
    $scope.youngMin = 18
    $scope.youngMax = 30
    $scope.percentage = 50
    uiGmapGoogleMapApi.then (maps) ->
      map = maps

    updateTimeout = null
    $scope.updateHeatmap = ->
      if (updateTimeout)
        $timeout.cancel(updateTimeout)
        updateTimeout = null

      updateTimeout = $timeout(->
        $meteor
        .call("getGroupedData", $scope.elderMax, $scope.elderMin, $scope.youngMax, $scope.youngMin, $scope.percentage)
        .then((result) ->
          $scope.polys = result.map (r, idx) ->
            id: idx
            stroke: {weight: 1, color: "#222222", opacity: 0.1},
            fill: {color: colors[r.level], opacity: 0.3},
            path: r.polygon
        , (error) ->
          console.log(error)
        )
        $meteor
        .call("getIndividualData")
        .then((result) ->
          $scope.heatMapData = [];
          result.forEach (record) ->
            $scope.heatMapData.push({location: new google.maps.LatLng(record.lat, record.lng), weight: record.count})
          heatmap.setData $scope.heatMapData
          heatmap.setMap map
          heatmap.set 'radius', 20
        )
      , 250)

    $scope.$watch("elderMin", $scope.updateHeatmap)
    $scope.$watch("elderMax", $scope.updateHeatmap)
    $scope.$watch("youngMax", $scope.updateHeatmap)
    $scope.$watch("youngMin", $scope.updateHeatmap)
    $scope.$watch("percentage", $scope.updateHeatmap)
 ]
