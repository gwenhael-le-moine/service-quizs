'use strict';

/* Services */
angular.module('quizsApp')
.factory('UsersApi', ['$resource', 'APP_PATH', function( $resource, APP_PATH ) {
  return $resource( APP_PATH + '/api/users/', {} , {
  	'current': {method: 'GET', url: APP_PATH + '/api/users/current' },
  	'regroupements': {method: 'GET', url: APP_PATH + '/api/users/regroupements/:quiz_id', params: {quiz_id: '@quiz_id'}}
  });
}])
.service('Users', [ 'UsersApi', function( UsersApi) {
	var uid = null;
	var roleMaxPriority = 0;
	var isParents = false;
	var current = null;
	this.getCurrentUserRequest = function(){
		return UsersApi.current();
	}
	this.setCurrentUser = function(user){
		current = user;
	}
	this.getCurrentUser = function(){
		// console.log(curent);
		var profil_id = current.user_detailed.profil_actif.profil_id;
		if (profil_id == 'TUT' || profil_id == "ELV") {
			roleMaxPriority = 0;				
		} else {
			roleMaxPriority = current.roles_max_priority_etab_actif;
		};
		uid = current.uid;
		isParents = profil_id == 'TUT';
		return {uid: uid, roleMaxPriority: roleMaxPriority, isParents: isParents};
	}
}]);