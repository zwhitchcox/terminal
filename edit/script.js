var app = angular.module('app', ['ngRoute','ui.bootstrap']);
app.config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.
    when('/:tech', {
      templateUrl: 'list.html',
      controller: 'EditCtrl'
    }).
    when('modules/:tech', {
      templateUrl: 'order.html',
      controller: 'OrderCtrl'
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
