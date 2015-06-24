'use strict';
// Subject service used for articles REST endpoint
angular.module('cli').factory('Exercises', ['$resource',
  function($resource) {
    return $resource('clis.json')
  }
]);
