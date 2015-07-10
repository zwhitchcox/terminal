'use strict';

angular.module('app').controller('EditCtrl',['$scope','$http','$routeParams','curx', ($scope,$http,$routeParams,curx) ->
  $scope.getExercises = () ->
  
    if localStorage['clis']!= undefined
      $scope.subjects = JSON.parse(localStorage['clis'])
    else 
      $http.get('/clis.json')
        .success((data)->
          $scope.subjects = data
        )
  
  $scope.setCur = (x) ->
    $scope.editX = x
    $scope.curX = $.extend(true, {}, x)
  
  $scope.val = (it) ->
    new RegExp('^'+it.check+'$').test(it.sample)
  $scope.save = (state) ->
    $scope.save = state
  
  $scope.update = ->
    if $scope.save == 'create'
      $scope.subjects[$scope.curX.subject][$scope.curX.module].push($scope.curX)
      alert('created')
    else
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
    Object.keys(saveSubj).forEach((cur)->
      delete saveSubj[cur]['$$hashKey']
    )
    localStorage['clis'] = JSON.stringify saveSubj
    $('#single_clippy').clippy({text: localStorage['clis']})
  
  $scope.resetExercises = () ->
    $http.get('/clis.json')
      .success((data) ->
        $scope.subjects = data
        localStorage['clis'] = JSON.stringify $scope.subjects
      )
])
