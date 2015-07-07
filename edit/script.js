var app = angular.module('app', ['ngRoute','ui.bootstrap']);
app.config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.
    when('/', {
      templateUrl: 'views/list.html',
      controller: 'EditCtrl'
    }).
    when('/:subject/:module/:index', {
      templateUrl: 'views/edit.html',
      controller: 'EditCtrl'
    }).
    when('/create', {
      templateUrl: 'views/create.html',
      controller: 'EditCtrl'
    }).
    when('/json', {
      templateUrl: 'views/json.html',
      controller: 'EditCtrl'
    }).
    otherwise({
      redirectTo: '/'
    })
    
  }])
.controller('Ctrl',['$scope',function($scope) {
}])
.filter('module', function() {
  return function(items, field) {
    if (field===undefined) return items
    var result = {};
    angular.forEach(items, function(value, key) {
        if (key===field) {
            result[key] = value;
        }
    });
    return result;
  };
})
.factory('curx',[function(){
  var exercise = {}
  return exercise
}])
