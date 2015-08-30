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

    colors = ['rgb(255,255,204)','rgb(255,237,160)','rgb(254,217,118)','rgb(254,178,76)','rgb(253,141,60)','rgb(252,78,42)','rgb(227,26,28)','rgb(189,0,38)','rgb(128,0,38)']

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
    $scope.levelOfDetails = [
      name: "Neighbourhood"
      value: "neighbourhoodCode"
    ,
      name: "Individual"
      value: "single"
    ]
    $scope.levelOfDetail = $scope.levelOfDetails[0]
    uiGmapGoogleMapApi.then (maps) ->
      map = maps

    $scope.questions = [
      name: "VR1 - Wilt u Zwolle als geheel beoordelen met een rapportcijfer (van 1 tot en met 10)?"
      values: ["0", "1", "2", "3", "4"]
    ,
      name: "VR2 - Vindt u dat Zwolle de afgelopen 12 maanden vooruit of achteruit is gegaan?"
      values: [
        "Weet niet / geen mening"
        "Gelijk gebleven"
        "Vooruit gegaan"
      ]
    ]
    $scope.questionName = "VR2 - Vindt u dat Zwolle de afgelopen 12 maanden vooruit of achteruit is gegaan?"
    $scope.questionValue = ["Vooruit gegaan", "Vooruit gegaan"]

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
        .call("getUserData", $scope.levelOfDetail.value, $scope.ageGroup, "VR1 - Wilt u Zwolle als geheel beoordelen met een rapportcijfer (van 1 tot en met 10)?")
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
        'max': 105
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
       )


    $scope.$watch("ageGroup", $scope.updateHeatmap)
    $scope.$watch("levelOfDetail", $scope.updateHeatmap)

    $meteor
      .call( "getQuestionMeta" )
      .then(
        (result) ->
          $scope.questions = result
        , 
        (error) ->
          console.log(error)
      )
 
    $scope.questionChange = -> 
      $scope.answers = []
      $scope.questions.forEach (question) ->
        if( question.name == $scope.questionName )
          $scope.answers = question.values
        return
      return
    
 ]
