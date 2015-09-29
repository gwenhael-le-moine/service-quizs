'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('QuizCtrl', ['$scope', '$state', '$rootScope', 'Modal', 'Notifications', 'APP_PATH', function($scope, $state, $rootScope, Modal, Notifications, APP_PATH) {
	//titre du quiz
	$rootScope.quiz.title = $rootScope.quiz.title;
	//selon si c'est le propriétaire ou pas on grise le bouton permettant de modifier le titre
	$scope.owner = true;		
	//et si on est pas dans les views d'action (modif params create) on supprime le bouton!
	if ($state.current.parent === 'quizs.back') {
		$scope.actionView = true;
	} else {
		$scope.actionView = false;
	};
	//ouvre la modal permettant de changer le titre
	$scope.changeTitle = function(){
		Modal.open($scope.modalChangeTitleQuizCtrl, APP_PATH+'/app/views/modals/add-change-object.html', 'md');
	}

	// -------------- Controllers Modal des quizs --------------- //
		//controller pour changer le titre du quiz avec une modal
		$scope.modalChangeTitleQuizCtrl = ["$scope", "$rootScope", "$modalInstance", function($scope, $rootScope, $modalInstance){
			$scope.title = "Modifier le titre du quiz";
			$scope.text = $rootScope.quiz.title;
			$scope.error = "Le titre du quiz ne peux pas être vide !";
			$scope.required = false;
			$scope.no = function(){
				$modalInstance.close();
			}
			$scope.ok = function(){
				$scope.validate = true;
				if ($scope.text.length > 0) {
					$rootScope.quiz.title = $scope.text;				
					$modalInstance.close();					
				};
			}
		}];
		// ----------------------------------------------------- //
}]);