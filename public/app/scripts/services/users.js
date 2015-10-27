'use strict';

/* Services */
angular.module('quizsApp')
// .factory('UsersApi', ['$resource', 'APP_PATH', function( $resource, APP_PATH ) {
//   return $resource( APP_PATH + '/api/users/', {});
// }])
.service('Users', [ '$rootScope', function( $rootScope) {
	this.getCurrentUser = function(){
		return {uid: "VAA60000", roleMaxPriority: 1, isParents: false};
	}
}]);