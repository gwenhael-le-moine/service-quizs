'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('QuizCtrl', ['$scope', '$state', '$rootScope', 'Modal', 'Notifications', 'APP_PATH', function($scope, $state, $rootScope, Modal, Notifications, APP_PATH) {
	//titre du quiz
	$rootScope.titleQuiz = "le compositeur j. brahms";
	//selon si c'est le propriétaire ou pas on grise le bouton permettant de modifier le titre
	$scope.owner = true;
	//ouvre la modal permettant de changer le titre
	$scope.changeTitle = function(){
		Modal.open($scope.modalChangeTitleQuizCtrl, APP_PATH+'/app/views/modals/change-title-quiz.html', 'md');
	}

	// -------------- Controllers Modal des quizs --------------- //
		//controller pour changer le titre du quiz avec une modal
		$scope.modalChangeTitleQuizCtrl = ["$scope", "$rootScope", "$modalInstance", function($scope, $rootScope, $modalInstance){
			$scope.title = $rootScope.titleQuiz;
			$scope.required = false;
			$scope.no = function(){
				$modalInstance.close();
			}
			$scope.ok = function(){

				if ($scope.title.length > 0) {
					$rootScope.titleQuiz = $scope.title;				
					$modalInstance.close();					
				};
			}
		}];
		// ----------------------------------------------------- //
}]);