'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('MainHomeCtrl', ['$scope', '$state', '$rootScope', 'APP_PATH', 'Notifications', 'Modal', 'Users', 'QuizsApi', function($scope, $state, $rootScope, APP_PATH, Notifications, Modal, Users, QuizsApi) {

	// Si personnel education
	$scope.roleMax = Users.getCurrentUser().roleMaxPriority;
	$scope.parents = Users.getCurrentUser().isParents;
	//on récupère les enfants du parents
	if ($scope.roleMax == 0 && $scope.parents) {
		$scope.childs = $rootScope.childs;
		//pour les parent fils courant
		$scope.currentChild = $scope.childs[0];
		$scope.quizs = angular.copy(_.filter($rootScope.quizs, function(quiz){
			return _.contains($scope.childs[0].quizs, quiz.id);
		}));
	} else {
		$scope.quizs = $rootScope.quizs;
	};
	// permet de changer d'enfant ainsi que de récupérer ses quizs
	$scope.changeCurrentChild = function(child){
		$scope.currentChild = child;
		$scope.quizs = angular.copy(_.filter($rootScope.quizs, function(quiz){
			return _.contains(child.quizs, quiz.id);
		}));
	}

	// ajoute un quiz et ouvre la création de ce quiz
	$scope.addQuiz = function(){
		QuizsApi.create().$promise.then(function(response){
			if (!response.error) {				
				$state.go('quizs.params', {quiz_id: response.quiz_created.id});
			} else {
				Notifications.add(response.error.msg, "error");
			};
		});
	}
	// ouvre la session du quiz pour ce regroupement
	$scope.openSession = function(quiz_id, rgpt_id){
		$state.go('quizs.sessions', {quiz_id: quiz_id, rgpt_id: rgpt_id});
	}
	// ouvre une modal avec tous les regroupements
	$scope.openRgpts = function(quiz_id){
		$rootScope.displayRgptsQuiz = _.find($scope.quizs, function(quiz){
			return quiz.id === quiz_id;
		});
		Modal.open($scope.modalDisplayRegroupementsCtrl, APP_PATH + '/app/views/modals/display-regroupements.html', 'md'); 
	}
	// joue le quiz
	$scope.playQuiz = function(quiz_id){
		$state.go('quizs.start_quiz', {quiz_id: quiz_id});
	}
	// edit le quiz
	$scope.updateQuiz = function(quiz_id){
		$state.go('quizs.params', {quiz_id: quiz_id});
	}
	// supprime le quiz
	$scope.deleteQuiz = function(quiz_id){
		$rootScope.quizs = $scope.quizs = _.reject($scope.quizs, function(quiz){
			return quiz.id === quiz_id;
		});
		//supprime le quiz coté backend
	}
	// duplique le quiz
	$scope.duplicateQuiz = function(quiz_id){
		var quizDuplicated =  angular.copy(_.find($scope.quizs, function(quiz){
			return quiz.id === quiz_id;
		}));
		// sert seulement pour la démo
		quizDuplicated.id = _.max($scope.quizs, function(quiz){
			return quiz.id;
		}).id +1;
		quizDuplicated.share = false;
		$scope.quizs.push(quizDuplicated);
		// duplique le quiz coté backend
	}
	// publie le quiz
	$scope.publishQuiz = function(quiz_id){
		$state.go('quizs.publish', {quiz_id: quiz_id});
	}
	// -------------- Controllers Modal --------------- //
		//controller pour afficher les regroupements dans lequel le quiz a été publié avec une modal
		$scope.modalDisplayRegroupementsCtrl = ["$scope", "$rootScope", "$modalInstance", function($scope, $rootScope, $modalInstance){
			$scope.rgpts = $rootScope.displayRgptsQuiz.publishes;
			$scope.close = function(){
				$rootScope.displayRgptsQuiz = {};
				$modalInstance.close();
			}
			$scope.openSession = function(rgpt_id){
				$modalInstance.close();
				$state.go('quizs.sessions', {quiz_id: $rootScope.displayRgptsQuiz.id, rgpt_id: rgpt_id});
			}
		}];
}]);