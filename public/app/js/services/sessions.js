'use strict';

/* Services */
angular.module('quizsApp')
.factory('SessionsApi', ['$resource', 'APP_PATH', function( $resource, APP_PATH ) {
  return $resource( APP_PATH + '/api/sessions/', {}, {
  	'get': {method: 'GET', url: APP_PATH + '/api/sessions/:id', params: {id: '@id'}},
  	'getAll': {method: 'GET', url: APP_PATH + '/api/sessions/', params: {publication_id: '@publication_id'}},
    'create': {method: 'POST', url: APP_PATH + '/api/sessions/create', params: {publication_id: '@publication_id'}},
    'exist':{method: 'GET', url: APP_PATH + '/api/sessions/exist/:publication_id', params: {publication_id: '@publication_id'}},
    'delete': {method: 'POST', url: APP_PATH + '/api/sessions/delete', params: {ids: '@ids'}},
    'pdf': {method: 'POST', url: APP_PATH + '/api/sessions/pdf',responseType: "blob", params: {sessions: '@sessions'}}
  });
}]);