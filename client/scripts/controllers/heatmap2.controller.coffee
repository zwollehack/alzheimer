app.controller "HeatMapCtrl2",
  ["$scope", "$state",  "$interval", "$window", "$meteor", "_util", "uiGmapGoogleMapApi", "uiGmapIsReady",
  ($scope, $state, $interval,  $window, $meteor, _util, uiGmapGoogleMapApi, uiGmapIsReady) ->
    map = undefined
    uiGmapIsReady.promise(1).then (instances) ->
      instances.forEach (inst) ->
        map = inst.map
        MockHeatLayer layer
    layer = undefined

    MockHeatLayer = (heatLayer) ->
      pointarray = undefined
      houseData = []
      # pointArray = new (google.maps.MVCArray)(houseData)
      #heatLayer.setData(pointArray);
      $meteor
      .call("getUserData")
      .then((result) ->
        console.log result
        # result.forEach (record) ->
        #   houseData.push({location: new google.maps.LatLng(record.lat, record.lng), weight: record.count})
        # heatmap = new (google.maps.visualization.HeatmapLayer)(data: pointArray)
        # heatmap.setMap map
        # heatmap.set 'radius', 20
        $scope.polys = [
          id: 1,
          clickable: true,
          draggable: false,
          editable: false,
          visible: true,
          geodesic: false,
          stroke: {weight: 1, color: "#000080", opacity: 1},
          fill: {color: "#FFCE00", opacity: 1},
          path: [
            {latitude: -22.840109991554, longitude: -43.604843616486},
            {latitude: -22.895785581504, longitude: -43.660461902618},
            {latitude: -22.923614814482, longitude: -43.480560779572}
          ]
        ]
        console.log($scope.polys[0].path)
        $scope.polys = result.map (r, idx) ->
          id: idx
          clickable: true,
          draggable: false,
          editable: false,
          visible: true,
          geodesic: false,
          stroke: {weight: 1, color: "#000080", opacity: 0.1},
          fill: {color: "#FFCE00", opacity: 0.3},
          path: r.polygon
        console.log $scope.polys
      , (error) ->
        console.log(error)
      )
  #      gradient = [
  #        'rgba(0, 255, 255, 0)'
  #        'rgba(0, 255, 255, 1)'
  #        'rgba(0, 191, 255, 1)'
  #        'rgba(0, 127, 255, 1)'
  #        'rgba(0, 63, 255, 1)'
  #        'rgba(0, 0, 255, 1)'
  #        'rgba(0, 0, 223, 1)'
  #        'rgba(0, 0, 191, 1)'
  #        'rgba(0, 0, 159, 1)'
  #        'rgba(0, 0, 127, 1)'
  #        'rgba(63, 0, 91, 1)'
  #        'rgba(127, 0, 63, 1)'
  #        'rgba(191, 0, 31, 1)'
  #        'rgba(255, 0, 0, 1)'
  #      ]
  #      heatmap.set 'gradient', gradient
      return

    $scope.heatLayerCallback = (layer) ->
      layer = layer
      #set the heat layers backend data
      return

    $scope.map =
      center:
        latitude: 52.465527
        longitude: 5.565698
      zoom: 10
    $scope.showHeat = true
    $scope.locationCompanies = []
    $scope.polys = []
    uiGmapGoogleMapApi.then (maps) ->
      map = maps
 ]
