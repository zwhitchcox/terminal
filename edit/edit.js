// Generated by CoffeeScript 1.9.3
(function() {
  'use strict';
  angular.module('app').controller('EditCtrl', [
    '$scope', '$http', '$routeParams', 'curx', function($scope, $http, $routeParams, curx) {
      $scope.getExercises = function() {
        if (localStorage['clis'] !== void 0) {
          return $scope.subjects = JSON.parse(localStorage['clis']);
        } else {
          return $http.get('/clis.json').success(function(data) {
            return $scope.subjects = data;
          });
        }
      };
      $scope.setCur = function(x) {
        $scope.editX = x;
        return $scope.curX = $.extend(true, {}, x);
      };
      $scope.val = function(it) {
        return new RegExp('^' + it.check + '$').test(it.sample);
      };
      $scope.save = function(state) {
        return $scope.save = state;
      };
      $scope.update = function() {
        if ($scope.save === 'create') {
          $scope.subjects[$scope.curX.subject][$scope.curX.module].push($scope.curX);
          alert('created');
        } else {
          $scope.editX.sample = $scope.curX.sample;
          $scope.editX.subject = $scope.curX.subject;
          $scope.editX.module = $scope.curX.module;
          $scope.editX.challenge = $scope.curX.challenge;
          $scope.editX.check = $scope.curX.check;
          $scope.editX.output = $scope.curX.output;
        }
        return $scope.updateLocalStorage();
      };
      $('#single_clippy').clippy({
        text: localStorage['clis']
      });
      $scope.remove = function(exercise) {
        $scope.subjects[exercise.subject][exercise.module].splice($scope.subjects[exercise.subject][exercise.module].indexOf(exercise), 1);
        return $scope.updateLocalStorage();
      };
      $scope.updateLocalStorage = function() {
        var saveSubj;
        saveSubj = $.extend(true, {}, $scope.subjects);
        Object.keys(saveSubj).forEach(function(cur) {
          return delete saveSubj[cur]['$$hashKey'];
        });
        localStorage['clis'] = JSON.stringify(saveSubj);
        return $('#single_clippy').clippy({
          text: localStorage['clis']
        });
      };
      return $scope.resetExercises = function() {
        return $http.get('/clis.json').success(function(data) {
          $scope.subjects = data;
          return localStorage['clis'] = JSON.stringify($scope.subjects);
        });
      };
    }
  ]);

}).call(this);
