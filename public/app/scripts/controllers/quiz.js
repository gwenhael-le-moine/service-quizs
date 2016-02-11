'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('QuizCtrl', ['$scope', '$state', '$stateParams', '$rootScope', 'Modal', 'Notifications', 'QuizsApi', 'Users', 'APP_PATH', function($scope, $state, $stateParams, $rootScope, Modal, Notifications, QuizsApi, Users, APP_PATH) {

	if ($state.current.name !== 'quizs.read_questions' && $state.current.name !== 'quizs.marking_questions') {
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
		Modal.open('ModalChangeTitleQuizCtrl', APP_PATH+'/app/views/modals/add-change-object.html', 'md');
	}
}]);