'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('SessionsCtrl', ['$scope', '$state', '$stateParams', '$rootScope', '$http', 'APP_PATH', 'Notifications', 'Modal', 'SessionsApi', function($scope, $state, $stateParams, $rootScope, $http, APP_PATH, Notifications, Modal, SessionsApi) {
	//variables pour les filtres
	$rootScope.filteredSessions = [];
	$scope.defaultClass = {id: "!", name: "Toutes"};
	$scope.defaultStudent = {uid: "!", name: "Tous"};
	$scope.filters = {
		newest: true,
		oldest: false,
		classe: $scope.defaultClass,
		student: $scope.defaultStudent
	};
	//variables pour les deux selects
	$scope.selectClasses = [];
	$scope.selectStudents = [];
	//on récupère les sessions
	SessionsApi.getAll({quiz_id: $stateParams.quiz_id}).$promise.then(function(response){
		if (!response.error) {
			$rootScope.sessions = response.sessions_found;
			$rootScope.filteredSessions = response.sessions_found;	
		};
		//on alimente les selects avec les données réelles des sessions
		if ($rootScope.sessions) {
			_.each($rootScope.sessions, function(session){
				if (!_.find($scope.selectClasses, function(classe){
					return classe.id === session.classe.id})
				){
					$scope.selectClasses.push(session.classe);
				};
				if (!_.find($scope.selectStudents, function(student){
					return student.uid === session.student.uid})
				){
					$scope.selectStudents.push(session.student);
				};
			});
		};
		//si on veut arriver directement sur les sessions d'une classe ou d'un élève,
		//on change les valeurs des selects
		if ($stateParams.rgpt_id != null) {
			var classe = _.find($scope.selectClasses, function(selectClass){
				return selectClass.id == $stateParams.rgpt_id;
			});
			if (classe) {
				$scope.filters.classe = classe;
			};
		};
		if ($stateParams.student_id != null) {
			var student = _.find($scope.selectStudents, function(selectStudent){
				return selectStudent.uid == $stateParams.student_id;
			});
			if (student) {
				$scope.filters.student = student;
			};
		};
	});
	//Change l'ordre par date (croissant/décroissant)
	//sert seulement à changer la case mode coché ou décoché
	$scope.changeDate = function(order){
		if (order == "newest") {
			$scope.filters.newest = true;
			$scope.filters.oldest = false;
		} else {
			$scope.filters.newest = false;
			$scope.filters.oldest = true;
		};
	};
	//change la classe courante du select
	$scope.changeClass = function(classe){
		$scope.filters.classe = classe;
	};
	//change l'élève courant du select
	$scope.changeStudent = function(student){
		$scope.filters.student = student;
	};

	//fonction des boutons de l'ihm sessions
	$scope.quiz = function(){
		$state.go('quizs.start_quiz', {quiz_id: $stateParams.quiz_id});
	}
	$scope.print = function(){
		// SessionsApi.pdf({sessions: $rootScope.filteredSessions}).$promise.then(function(response){
		$http.post(APP_PATH + '/api/sessions/pdf', {'sessions': $rootScope.filteredSessions}, {'responseType' :'blob'}).success(function(data, status) {
			var blob = new Blob([data], {type: 'application/pdf'});
			var link = document.createElement('a');
			var currentDate = new Date();
			link.href = window.URL.createObjectURL(blob);
			link.download = "Résultat_sessions_"+currentDate.toString();
			link.click();
		});
	}
	$scope.reset = function(){
		$rootScope.ids = _.map($rootScope.filteredSessions, function(session){
			return session.id;
		});
		Modal.open($scope.modalConfirmDeletedSessionsCtrl, APP_PATH + '/app/views/modals/confirm.html', "md");
	}
	$scope.delete = function(session){
		$rootScope.ids = [session.id];
		Modal.open($scope.modalConfirmDeletedSessionsCtrl, APP_PATH + '/app/views/modals/confirm.html', "md");
	}
	$scope.close = function(){
		$state.go('quizs.home');
	}


	// -------------- Controllers Modal des quizs --------------- //
		//controller pour confirmer la suppression de sessions avec une modal
		$scope.modalConfirmDeletedSessionsCtrl = ["$scope", "$rootScope", "$modalInstance", "$state", "$stateParams", function($scope, $rootScope, $modalInstance, $state, $stateParams){
			$scope.message = "Êtes vous sûr de vouloir supprimer ";
			if ($rootScope.ids.length > 1) {
				$scope.title = "Supprimer les sessions";
				$scope.message += "toutes les sessions affichées ?";
			} else {
				$scope.title = "Supprimer la session";
				$scope.message += "cette session ?";
			};
			$scope.no = function(){
				$modalInstance.close();
			}
			$scope.ok = function(){
				// On supprime les sessions dans la bdd et dans le scope
				SessionsApi.delete({ids: $rootScope.ids}).$promise.then(function(response){
					if (!response.error) {
						$rootScope.sessions = _.reject($rootScope.sessions, function(session){
							return _.contains($rootScope.ids, session.id);
						});
						$modalInstance.close();
					};
				});
			}
		}];
		// ----------------------------------------------------- //
}]);