'use strict';

/* Services */
angular.module('quizsApp')
.factory('SessionsApi', ['$resource', 'APP_PATH', function( $resource, APP_PATH ) {
  return $resource( APP_PATH + '/api/sessions/', {}, {
  	'get': {method: 'GET', url: APP_PATH + '/api/sessions/:id', params: {id: '@id'}},
  	'getAll': {method: 'GET', url: APP_PATH + '/api/sessions/', params: {quiz_id: '@quiz_id'}},
    'create': {method: 'POST', url: APP_PATH + '/api/sessions/create', params: {quiz_id: '@quiz_id'}},
    'exist':{method: 'GET', url: APP_PATH + '/api/sessions/exist/:quiz_id', params: {quiz_id: '@quiz_id'}},
    'delete': {method: 'POST', url: APP_PATH + '/api/sessions/delete', params: {ids: '@ids'}},
    'pdf': {method: 'POST', url: APP_PATH + '/api/sessions/pdf',responseType: "blob", params: {sessions: '@sessions'}}
  });
}]);