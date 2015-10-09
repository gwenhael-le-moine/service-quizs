'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('AsideHomeCtrl', ['$scope', '$state', '$rootScope', 'Notifications', function($scope, $state, $rootScope, Notifications) {
	// les dernières sessions des élèves
	$scope.lastSessions = $rootScope.lastSessions;
	// les derniers quizs paratgés
	$scope.lastQuizsShare = $rootScope.lastQuizsShare;

	// duplique un quiz
	$scope.duplicateQuiz = function(quiz_id){
		var quizDuplicated =  angular.copy(_.find($rootScope.quizs, function(quiz){
			return quiz.id === quiz_id;
		}));
		// sert seulement pour la démo
		quizDuplicated.id = _.max($rootScope.quizs, function(quiz){
			return quiz.id;
		}).id +1;
		quizDuplicated.share = false;
		$rootScope.quizs.push(quizDuplicated);
		// duplique le quiz coté backend
	}

	//ouvre la session de l'élève
	$scope.openSession = function(session_id){
		// $state.go('quizs.session', {session_id: session_id});
	}
}]);