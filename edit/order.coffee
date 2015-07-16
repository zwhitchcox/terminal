'use strict';

angular.module('app').controller('OrdeCtrl',['$scope','$http','$routeParams', ($scope,$http,$routeParams) ->
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

  
  $('#single_clippy').clippy({text: localStorage['clis']})
  
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

  $scope.reset = () ->
    $http.get("/#{$scope.url}.json")
      .success((data)->
        $scope.subjects = data
        $scope.updateLocalStorage()
      )
])
