var app = angular.module('app', ['ngRoute']);
app.config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.
    when('/:tech', {
      templateUrl: 'edit.html',
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
