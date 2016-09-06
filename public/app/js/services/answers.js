'use strict';

/* Services */
angular.module('quizsApp')
.factory('AnswersApi', ['$resource', 'APP_PATH', function( $resource, APP_PATH ) {
  return $resource( APP_PATH + '/api/answers/', {}, {
    'create': {method: 'POST', url: APP_PATH + '/api/answers/create', params: {session_id: '@session_id', question: '@question', quiz_id: '@quiz_id'}}
  });
}]);