'use strict';

angular.module('app').controller('EditCtrl',['$scope','$http','$routeParams', ($scope,$http,$routeParams) ->
  $scope.asubj = {active:''}
  if /cli/i.test $routeParams.tech
      $scope.url = 'clis'
  else if /python/i.test $routeParams.tech
    $scope.url = 'pythons'
  $scope.getExercises = () ->
    if localStorage[$scope.url]!= undefined
      $scope.subjects = JSON.parse(localStorage[$scope.url])
    else 
      $scope.resetExercises()
    $scope.subjectNames = Object.keys $scope.subjects

  $scope.setCur = (x) ->
    $scope.editX = x
    $scope.curX = $.extend(true, {}, x)
  
  $scope.val = (it) ->
    try
      new RegExp('^'+it.check+'$').test(it.sample)
    catch e
  $scope.save = (state) ->
    $scope.state = state

  $scope.update = ->
    if !$scope.subjects.hasOwnProperty($scope.curX.subject)
        $scope.subjects[$scope.curX.subject] = {}
    if !$scope.subjects[$scope.curX.subject].hasOwnProperty($scope.curX.module)
      $scope.subjects[$scope.curX.subject][$scope.curX.module] = []
    if $scope.state == 'create'
      $scope.subjects[$scope.curX.subject][$scope.curX.module].push($scope.curX)
      alert('created')
    else
      if $scope.editX.module != $scope.curX.module
        $scope.subjects[$scope.editX.subject][$scope.editX.module].splice(
          $scope.subjects[$scope.editX.subject][$scope.editX.module].indexOf($scope.editX),1
        )
        $scope.state = 'create'
        $scope.update()
        $scope.state = 'edit'
        return
      $scope.editX.sample    = $scope.curX.sample
      $scope.editX.subject   = $scope.curX.subject
      $scope.editX.module    = $scope.curX.module
      $scope.editX.challenge = $scope.curX.challenge
      $scope.editX.check     = $scope.curX.check
      $scope.editX.output    = $scope.curX.output
    $scope.updateLocalStorage()
  
  $('#single_clippy').clippy({text: localStorage['clis']})


  $scope.remove = (exercise) ->
    $scope.subjects[exercise.subject][exercise.module].splice(
      $scope.subjects[exercise.subject][exercise.module].indexOf(exercise),1
    )
    $scope.updateLocalStorage()
  
  $scope.updateLocalStorage = () ->
    saveSubj = $.extend(true,{},$scope.subjects)
    Object.keys(saveSubj).forEach((curSubj) ->
      Object.keys(saveSubj[curSubj]).forEach((curMod) ->
        if saveSubj[curSubj][curMod].length == 0
          delete saveSubj[curSubj][curMod]
          delete $scope.subjects[curSubj][curMod]
      )
    )
    Object.keys(saveSubj).forEach((cur)->
      delete saveSubj[cur]['$$hashKey']
    )
    localStorage[$scope.url] = JSON.stringify saveSubj
    $('#single_clippy').clippy({text: localStorage[$scope.url]})

  $scope.resetExercises = () ->
    $http.get("/#{$scope.url}.json")
      .success((data)->
        $scope.subjects = data
        $scope.updateLocalStorage()
      )
])
