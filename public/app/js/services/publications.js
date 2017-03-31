'use strict';

/* Services */
angular.module('quizsApp')
.factory('PublicationsApi', ['$resource', 'APP_PATH', function( $resource, APP_PATH ) {
  return $resource( APP_PATH + '/api/publications/', {}, {
    'getAll': {method: 'GET', url: APP_PATH + '/api/publications/:quiz_id', params: {quiz_id: '@quiz_id'}},
     'getAllTut': {method: 'GET', url: APP_PATH + '/api/publications/users'},
     'modify': {method: 'POST', url: APP_PATH + '/api/publications/:quiz_id', params: {quiz_id: '@quiz_id', added: '@added', fromDate: '@fromDate', toDate: '@toDate', index_publication: '@index_publication'}},
    'republier': {method: 'POST', url: APP_PATH + '/api/publications/:quiz_id', params: {quiz_id: '@quiz_id', added: '@added', fromDate: '@fromDate', toDate: '@toDate', index_publication: '@index_publication'}},
 	'modifier': {method: 'PUT', url: APP_PATH + '/api/publications/:id', params: {id: '@id', fromDate: '@fromDate', toDate: '@toDate'}},
 	'delete': {method: 'DELETE', url: APP_PATH + '/api/publications/:quiz_id', params: {quiz_id: '@quiz_id', id: '@id', index_publication: '@index_publication'}},
  });
}]);