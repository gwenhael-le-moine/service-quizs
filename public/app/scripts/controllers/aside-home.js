'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('AsideHomeCtrl', ['$scope', '$state', '$rootScope', 'Notifications', 'Users', 'SessionsApi', 'QuizsApi', function($scope, $state, $rootScope, Notifications, Users, SessionsApi, QuizsApi) {
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
				$rootScope.quizs.push(quizDuplicated);
			};
		});
	}

	//ouvre la session de l'élève
	$scope.openSession = function(quiz_id, session_id){
		$state.go('quizs.marking_questions', {quiz_id: quiz_id, session_id: session_id});
	}
}]);