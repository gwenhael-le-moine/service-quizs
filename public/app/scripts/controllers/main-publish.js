'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('MainPublishCtrl', ['$scope', '$state', '$stateParams', '$rootScope', 'Notifications', function($scope, $state, $stateParams, $rootScope, Notifications) {

	// fonction a supprimer juste pour la dinamic
	var getIdPublishes = function(){
		var publishesId = [];
		var quiz = angular.copy(_.find($rootScope.quizs, function(q){
			return q.id == $stateParams.quiz_id;
		}));
		_.each(quiz.publishes, function(publish){
			publishesId.push(publish.id);
		});
		return publishesId;
	}
	var getRegroupements = function(){
		var publishesId = getIdPublishes();
		var rgpts = [];
		_.each(angular.copy($rootScope.getRegroupements.regroupements), function(regroupement){
			if (_.contains(publishesId, regroupement.id)) {
				regroupement.selected = true;
			}
			rgpts.push(angular.copy(regroupement));
		});
		return rgpts;
	}
	//on récupère les regroupements du profs
	if ($rootScope.getRegroupements.erreur) {
		Notifications.add("Impossible de récupérer vos regroupements !", "erreur");
	} else if (!$rootScope.getRegroupements.erreur && $rootScope.getRegroupements.regroupements.length == 0) {
		Notifications.add("Vous n'avez aucun regroupement !", "warning");
	} else {
		$scope.regroupements = getRegroupements();
		$rootScope.tmpPublishesRegroupements = angular.copy(_.where($scope.regroupements, {selected: true}));
		console.log($rootScope.tmpPublishesRegroupements);
	};

	$scope.change = function(regroupement){
		if(regroupement.selected){
			$rootScope.tmpPublishesRegroupements = _.reject($rootScope.tmpPublishesRegroupements, function(tmpRgpt){
				return tmpRgpt.id === regroupement.id;
			});
			regroupement.selected = false;
		} else {
			$rootScope.tmpPublishesRegroupements.push(regroupement);
			regroupement.selected = true;
		};
	};
}]);