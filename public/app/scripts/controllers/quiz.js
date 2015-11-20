'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('QuizCtrl', ['$scope', '$state', '$stateParams', '$rootScope', 'Modal', 'Notifications', 'QuizsApi', 'Users', 'APP_PATH', function($scope, $state, $stateParams, $rootScope, Modal, Notifications, QuizsApi, Users, APP_PATH) {

	if ($state.current.name !== 'quizs.read_questions') {
		console.log('! read');
		QuizsApi.get({id: $stateParams.quiz_id}).$promise.then(function(response){
			if (!response.error) {
				$rootScope.quiz = response.quiz_found;
				$rootScope.quiz.questions = [];
				//selon si c'est le propriétaire ou pas on grise le bouton permettant de modifier le titre
				if (Users.getCurrentUser().uid === response.quiz_found.user_id) {
					$scope.owner = true;									
				};
			} else {
				$state.go('erreur', {code: "404", message: response.error.msg});
			};
		});
	};
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
			$scope.placeholder = "Insérez un titre pour votre quiz."
			$scope.required = false;
			$scope.no = function(){
				$modalInstance.close();
			}
			$scope.ok = function(){
				$scope.validate = true;
				if ($scope.text.length > 0) {
					QuizsApi.update({id: $rootScope.quiz.id, opt_show_score: $rootScope.quiz.opt_show_score, opt_show_correct: $rootScope.quiz.opt_show_correct, title: $scope.text}).$promise.then(function(response){
						if (!response.error) {
							$rootScope.quiz.title = $scope.text;											
						} else {
							Notifications.add(response.error.msg, 'error');
						};
						$modalInstance.close();					
					});
				};
			}
		}];
		// ----------------------------------------------------- //
}]);