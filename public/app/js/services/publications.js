'use strict';

/* Services */
angular.module('quizsApp')
.factory('PublicationsApi', ['$resource', 'APP_PATH', function( $resource, APP_PATH ) {
  return $resource( APP_PATH + '/api/publications/', {}, {
    'getAll': {method: 'GET', url: APP_PATH + '/api/publications/:quiz_id', params: {quiz_id: '@quiz_id'}},
    'modify': {method: 'POST', url: APP_PATH + '/api/publications/:quiz_id', params: {quiz_id: '@quiz_id', added: '@added', deleted: '@deleted', fromDate: '@fromDate', toDate: '@toDate'}}
  });
}]);