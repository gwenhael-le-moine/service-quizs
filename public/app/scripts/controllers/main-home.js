'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('MainHomeCtrl', ['$scope', '$state', '$rootScope', 'APP_PATH', 'Notifications', 'Modal', 'Users', 'QuizsApi', function($scope, $state, $rootScope, APP_PATH, Notifications, Modal, Users, QuizsApi) {

	// Si personnel education
	$scope.roleMax = Users.getCurrentUser().roleMaxPriority;
	$scope.parents = Users.getCurrentUser().isParents;
	console.log($scope.parents);
	//on récupère les enfants du parents
	if ($scope.roleMax == 0 && $scope.parents) {
		//pour les parent fils courant
		QuizsApi.quizs().$promise.then(function(response){
			$rootScope.quizs = response.quizs_found.quizs;
			$scope.childs = response.quizs_found.childs;
			$rootScope.currentChild = $scope.childs[0];
			$scope.quizs = angular.copy(_.filter($rootScope.quizs, function(quiz){
				return _.contains($scope.childs[0].quizs, quiz.id);
			}));
		});
	} else {
		QuizsApi.quizs().$promise.then(function(response){
			$rootScope.quizs = response.quizs_found;
		});
	};
	// permet de changer d'enfant ainsi que de récupérer ses quizs
	$scope.changeCurrentChild = function(child){
		$rootScope.currentChild = child;
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
		$rootScope.displayRgptsQuiz = _.find($rootScope.quizs, function(quiz){
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
		$rootScope.deleteQuizId = quiz_id; 
		Modal.open($scope.modalClearQuizCtrl, APP_PATH + '/app/views/modals/confirm.html', 'md');
	}
	// duplique le quiz
	$scope.duplicateQuiz = function(quiz_id){
		QuizsApi.duplicate({id: quiz_id}).$promise.then(function(response){
			if (!response.error) {
				var quizDuplicated =  angular.copy(_.find($rootScope.quizs, function(quiz){
					return quiz.id === quiz_id;
				}));
				quizDuplicated.id = response.quiz_duplicated.id;
				quizDuplicated.share = false;
				$rootScope.quizs.push(quizDuplicated);
			};
		});
	}
	// publie le quiz
	$scope.publishQuiz = function(quiz_id){
		$state.go('quizs.publish', {quiz_id: quiz_id});
	}
	$scope.shared = function(quiz){
		QuizsApi.update({id: quiz.id, opt_shared: !quiz.share}).$promise.then(function(response){
			if (!response.error){
				angular.forEach($rootScope.quizs, function(q, index){
					if (q.id === quiz.id) {
						$rootScope.quizs[index].share = !quiz.share;						
					};
				});
			}
		})
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

		//controller pour supprimer un quiz avec une modal
		$scope.modalClearQuizCtrl = ["$scope", "$rootScope", "$modalInstance", "QuizsApi", function($scope, $rootScope, $modalInstance, QuizsApi){
			$scope.title = "Supprimer un quiz";
			$scope.message = "Êtes vous sûr de vouloir supprimer ce quiz ?";
			$scope.no = function(){
				$modalInstance.close();
			}
			$scope.ok = function(){
				QuizsApi.delete({id: $rootScope.deleteQuizId}).$promise.then(function(response){
					if (!response.error) {
						$rootScope.quizs = _.reject($rootScope.quizs, function(quiz){
							return quiz.id === $rootScope.deleteQuizId;
						});
						$modalInstance.close();					
					};
				});			
			}
		}];
}]);