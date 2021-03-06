'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('ErreurCtrl', ['$scope', '$stateParams', 'Erreur', function($scope, $stateParams, Erreur) {
	$scope.code = $stateParams.code;
	$scope.message = Erreur.message($stateParams.code, $stateParams.message);
}]);