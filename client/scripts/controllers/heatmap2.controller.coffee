app.controller "HeatMapCtrl2",
  ["$scope", "$state",  "$interval", "$timeout", "$window", "$meteor", "_util", "uiGmapGoogleMapApi", "uiGmapIsReady",
  ($scope, $state, $interval, $timeout, $window, $meteor, _util, uiGmapGoogleMapApi, uiGmapIsReady) ->
    map = undefined
    heatmap = undefined
    uiGmapIsReady.promise(1).then (instances) ->
      instances.forEach (inst) ->
        map = inst.map
        heatmap = new (google.maps.visualization.HeatmapLayer)(data: $scope.heatMapData)
        heatmap.setMap map
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
        latitude: 52.5125000
        longitude: 6.094440
      zoom: 12
      options:
        disableDefaultUI: true
        zoomControl: true
        zoomControlOptions:
          style: google.maps.ZoomControlStyle.SMALL

    $scope.polys = []
    $scope.ageGroup =
      min: 0
      max: 120
    $scope.levelOfDetails = [
      name: "Individual"
      value: "single"
    ,
      name: "Neighbourhood"
      value: "neighbourhoodCode"
    ]
    $scope.levelOfDetail = $scope.levelOfDetails[0]
    uiGmapGoogleMapApi.then (maps) ->
      map = maps

    $scope.questions = []
    $scope.questionName = null
    $scope.questionValues = []

    $scope.heatMapData = []

    updateTimeout = null
    $scope.updateHeatmap = ->
      if (updateTimeout?)
        $timeout.cancel(updateTimeout)
        updateTimeout = null

      updateTimeout = $timeout(->
        $scope.polys = []
        $scope.heatMapData = [];
        $meteor
        .call("getUserData", $scope.levelOfDetail.value, $scope.ageGroup, $scope.questionName, $scope.questionValues )
        .then((result) ->
          if ($scope.levelOfDetail.value is "single")
            $scope.showHeat = true
            result.forEach (r) ->
              $scope.heatMapData.push({location: new google.maps.LatLng(r.lat, r.lng), weight: r.count})
            heatmap.setData $scope.heatMapData
            heatmap.setMap map
          else if ($scope.levelOfDetail.value is "neighbourhoodCode")
            $scope.showHeat = false
            $scope.polys = result.map (r, idx) ->
              id: idx
              stroke: {weight: 1, color: "#222222", opacity: 0.1},
              fill: {color: colors[r.level], opacity: 0.7},
              path: r.polygon

        , (error) ->
          console.log(error)
        )
      , 250)
    slider = document.getElementById('range')
    noUiSlider.create(slider, {
      range: 'range_all_sliders'
      start: [ $scope.ageGroup.min, $scope.ageGroup.max]
      connect: true
      step: 1
      margin: 5
      direction: 'ltr'
      orientation: 'horizontal'
      behaviour: 'tap-drag'
      range: {
        'min': 0
        'max': 120
      }
      pips: {
        mode: 'range'
        density: 3
      }
    })
    slider.noUiSlider.on 'update', (values, handle) ->
      $timeout(->
        if(handle)
          $scope.ageGroup.max = values[handle]
        else
          $scope.ageGroup.min = values[handle]
        $scope.updateHeatmap()
       ,1000)


    $scope.$watch("ageGroup", $scope.updateHeatmap)
    $scope.$watch("levelOfDetail", $scope.updateHeatmap)

    $meteor
      .call( "getQuestionMeta" )
      .then(
        (result) ->
          $scope.questions = result
          $scope.questionName = $scope.questions[0].name
          $scope.questionChange()
        ,
        (error) ->
          console.log(error)
      )

    $scope.questionChange = ->
      $scope.answers = []
      $scope.questions.forEach (question) ->
        if( question.name == $scope.questionName )
          $scope.answers = question.values
          $scope.questionValues = question.values

    $scope.$watch("questionName", $scope.updateHeatmap)
    $scope.$watch("questionValues", $scope.updateHeatmap)

 ]
