// Generated by CoffeeScript 1.9.3
(function() {
  'use strict';
  angular.module('app').controller('OrdeCtrl', [
    '$scope', '$http', '$routeParams', function($scope, $http, $routeParams) {
      $scope.asubj = {
        active: ''
      };
      if (/cli/i.test($routeParams.tech)) {
        $scope.url = 'clis';
      } else if (/python/i.test($routeParams.tech)) {
        $scope.url = 'pythons';
      }
      $scope.getExercises = function() {
        if (localStorage[$scope.url] !== void 0) {
          $scope.subjects = JSON.parse(localStorage[$scope.url]);
        } else {
          $scope.resetExercises();
        }
        return $scope.subjectNames = Object.keys($scope.subjects);
      };
      $('#single_clippy').clippy({
        text: localStorage['clis']
      });
      $scope.updateLocalStorage = function() {
        var saveSubj;
        saveSubj = $.extend(true, {}, $scope.subjects);
        Object.keys(saveSubj).forEach(function(curSubj) {
          return Object.keys(saveSubj[curSubj]).forEach(function(curMod) {
            if (saveSubj[curSubj][curMod].length === 0) {
              delete saveSubj[curSubj][curMod];
              return delete $scope.subjects[curSubj][curMod];
            }
          });
        });
        Object.keys(saveSubj).forEach(function(cur) {
          return delete saveSubj[cur]['$$hashKey'];
        });
        localStorage[$scope.url] = JSON.stringify(saveSubj);
        return $('#single_clippy').clippy({
          text: localStorage[$scope.url]
        });
      };
      return $scope.reset = function() {
        return $http.get("/" + $scope.url + ".json").success(function(data) {
          $scope.subjects = data;
          return $scope.updateLocalStorage();
        });
      };
    }
  ]);

}).call(this);
