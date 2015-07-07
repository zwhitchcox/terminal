'use strict';

angular.module('app').controller('EditCtrl',['$scope','$http','$routeParams','curx', ($scope,$http,$routeParams,curx) ->
  $scope.getExercises = () ->
    if localStorage['clis']!= undefined
      $scope.subjects = JSON.parse(localStorage['clis'])
    else 
      $http.get('/clis.json')
        .success((data)->
        )
  
  $scope.setCur = (x) ->
    $scope.curX = x
  $scope.val = (it) ->
    return new RegExp('^'+it.check+'$').test(it.sample)
  
  $scope.create = () ->
    $scope.subjects[$scope.exercise.subject][$scope.exercise.module].push($scope.exercise)
    $scope.updateLocalStorage()
    alert('created')
  $('#single_clippy').clippy({text: localStorage['clis']})


  $scope.remove = (module, idx) ->
    $scope.subjects[$scope.asubj][module].splice(idx,1)
    $scope.updateLocalStorage()
  

  $scope.change = () ->
  $scope.updateLocalStorage = () ->
    localStorage['clis'] = JSON.stringify($scope.subjects)
    $('#single_clippy').clippy({text: localStorage['clis']})
  $scope.resetExercises = () ->
    $http.get('/clis.json')
          .success((data) ->
            $scope.subjects = data
            localStorage['clis'] = JSON.stringify $scope.subjects
          )
])
