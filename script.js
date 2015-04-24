(function(angular) {
  'use strict';
var app = angular.module('app', []);

app.controller('Ctrl', ['$scope', function($scope) {
    $scope.message = 'very';
}]);
})(window.angular);
