'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('AsideHomeCtrl', ['$scope', '$state', '$rootScope', 'Notifications', 'Users', 'SessionsApi', 'QuizsApi', 'APP_PATH', 'Modal', function($scope, $state, $rootScope, Notifications, Users, SessionsApi, QuizsApi, APP_PATH, Modal) {
	// Si personnel education
	$scope.roleMax = Users.getCurrentUser().roleMaxPriority;
	$scope.parents = Users.getCurrentUser().isParents;
	var tempLastsessions = [];
	// les dernières sessions des élèves
	SessionsApi.getAll().$promise.then(function(response){
		if(!response.error){
			tempLastsessions = response.sessions_found;
			$scope.lastSessions = response.sessions_found;						
		}
	});
	// les derniers quizs paratgés
	QuizsApi.quizs({shared: true}).$promise.then(function(response){
		if(!response.error){
			$scope.lastQuizsShare = response.quizs_shared;
		}
	});

	$rootScope.$watch("currentChild", function(){
		$scope.lastSessions = angular.copy(_.filter(tempLastsessions, function(session){
			return _.contains($rootScope.currentChild.quizs, session.quiz.id);
		}));
	});
	// duplique un quiz
	$scope.duplicateQuiz = function(quiz_id){
		QuizsApi.duplicate({id: quiz_id}).$promise.then(function(response){
			if (!response.error) {
				var quizDuplicated =  angular.copy(_.find($scope.lastQuizsShare, function(quiz){
					return quiz.id === quiz_id;
				}));
				quizDuplicated.id = response.quiz_duplicated.id;
				quizDuplicated.publishes = [];
				quizDuplicated.share = false;
				Modal.open($scope.modalNotifDupliquerQuizCtrl, APP_PATH + '/app/views/modals/notification.html', "md");
				$rootScope.quizs.push(quizDuplicated);
			};
		});
	}

// ouvre la session du quiz pour ce regroupement
	$scope.openAllSession = function(quiz_id, rgpt_id){
		$state.go('quizs.all-sessions', {quiz_id: quiz_id, rgpt_id: rgpt_id});
	}
	 $scope.filterFunction = function(element) {
    return element.name.match(/^Ma/) ? true : false;
  };

	 $scope.filterFunctionquiz = function(element) {
    return quiz.name.title(/^Ma/) ? true : false;
  };

  	 $scope.filterFunction = function(element) {
    return element.session.classe.name.match(/^Ma/) ? true : false;
  };

	//ouvre la session de l'élève
	$scope.openSession = function(quiz_id, session_id){
		$state.go('quizs.marking_questions', {quiz_id: quiz_id, session_id: session_id});
	}

	$scope.openBibliotheque = function(quiz_id, session_id){
		$state.go('quizs.bibliotheque', {});
	}

	$scope.openPublicationEnCours = function(){
		$state.go('quizs.publicationencours', {});
	}
	$scope.goHome = function(){
		$state.go('quizs.home', {});
	}
	// joue le quiz
	$scope.playQuiz = function(quiz_id){
		$state.go('quizs.start_quiz', {quiz_id: quiz_id});
	}

  $scope.predicate = '-age';
  $scope.isNavCollapsed = true;
  $scope.isCollapsed = false;
  $scope.isCollapsedHorizontal = false;
  $scope.isCollapsedsession = false;
  $scope.isCollapsedsessionHorizontal = false;
  $scope.isCollapsedpartage = false;
  $scope.isCollapsedpartageHorizontal = false;
 
 		//controller pour confirmer la duplication de sessions avec une modal
		$scope.modalNotifDupliquerQuizCtrl = ["$scope", "$rootScope", "$uibModalInstance", "$state", "$stateParams", function($scope, $rootScope, $uibModalInstance, $state, $stateParams){
			$scope.message = "Votre quiz a été bien dupliqué !";
		
				$scope.title = "dupliquer un quiz";
				// $scope.message += "Votre qui a été bien dupliquer";
		
			$scope.no = function(){
				$uibModalInstance.close();
			}
			$scope.ok = function(){
				$uibModalInstance.close();
			}
}];


}]);