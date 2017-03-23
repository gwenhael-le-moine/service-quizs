'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('SessionsCtrl', ['$scope', '$state', '$stateParams', '$rootScope', '$http', 'APP_PATH', 'Notifications', 'Modal', 'SessionsApi', 'Users','QuizsApi', function($scope, $state, $stateParams, $rootScope, $http, APP_PATH, Notifications, Modal, SessionsApi, Users,QuizsApi) {
	
	// Si personnel education
	$scope.roleMax = Users.getCurrentUser().roleMaxPriority;
	$scope.parents = Users.getCurrentUser().isParents;
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


	//variables pour les filtres
	$scope.deleteRight = Users.getCurrentUser().roleMaxPriority > 0;
	$rootScope.filteredSessions = [];
	$rootScope.filteredSessionsQuiz = [];
	$rootScope.filteredSessionsPub = [];
	$scope.defaultClass = {id: "!", name: "Toutes"};
	$scope.defaultStudent = {uid: "!", name: "Tous"};
	$scope.defaultPublication = {id: "!", name: "Toutes"};
	$scope.defaultQuiz = {id: "!", quiz_title: "tous"};
	$scope.filters = {
		newest: true,
		oldest: false,
		classe: $scope.defaultClass,
		student: $scope.defaultStudent,
		publication: $scope.defaultPublication,
		quiz: $scope.defaultQuiz
	};
	//variables pour les deux selects
	$scope.selectClasses = [];
	$scope.selectStudents = [];
	$scope.selectPublications =[];
	$scope.selectQuizs =[];
	//on récupère les sessions
	SessionsApi.getAll({quiz_id: $stateParams.quiz_id}).$promise.then(function(response){
		if (!response.error) {
			$rootScope.sessions = response.sessions_found;
			$rootScope.filteredSessions = response.sessions_found;
			$rootScope.thisQuiz = $stateParams.quiz_id;
		};
		//on alimente les selects avec les données réelles des sessions
		if ($rootScope.sessions) {
			_.each($rootScope.sessions, function(session){
				console.log(session);
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
				if (!_.find($scope.selectPublications, function(publication){
					return publication.uid === session.publication.id})
				){
					$scope.selectPublications.push(session.publication);
				};
				if (!_.find($scope.selectQuizs, function(quiz){
					return quiz.uid === session.quiz.id})
				){
					$scope.selectQuizs.push(session.quiz);
				};
			});
			console.log("$scope.selectPublications")
			console.log($scope.selectPublications)
		};
		var i = $rootScope.filteredSessions.length;
		do{
			i--
			if ($rootScope.filteredSessions[i].quiz.id == $rootScope.thisQuiz){
				$rootScope.filteredSessionsQuiz.push($rootScope.filteredSessions[i]);
			};
			
		}while(i>0)


		console.log("$rootScope.filteredSessions")
		console.log($rootScope.filteredSessions)
		var j = $rootScope.filteredSessions.length;
		do{
			j--
			console.log("$rootScope.filteredSessions[j].quiz.id ")
			console.log($rootScope.filteredSessions[j].quiz.id)

			if ($rootScope.filteredSessions[j].publication.id == $rootScope.thisQuiz){
				$rootScope.filteredSessionsPub.push($rootScope.filteredSessions[j]);
			};
			
		}while(j>0)
		console.log("$rootScope.filteredSessionsQuiz")
		console.log($rootScope.filteredSessionsQuiz)
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
				return selectStudent.uid === $stateParams.student_id;
			});
			if (student) {
				$scope.filters.student = student;
			};
		};
		if ($stateParams.publication_id != null) {
			var publication = _.find($scope.selectStudents, function(selectPublication){
				return selectPublication.id === $stateParams.publication_id;
			});
			if (publication) {
				$scope.filters.publication = publication;
			};
		};
		if ($stateParams.quiz_id != null) {
			var quiz = _.find($scope.selectQuizs, function(selectQuiz){
				return selectQuiz.id === $stateParams.quiz_id;
			});
			if (quiz) {
				$scope.filters.quiz = quiz;
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
	//change la publication courante du select
	$scope.changePublication = function(publication){
		$scope.filters.publication = publication;
	};

	$scope.changeQuiz = function(quiz){
		$scope.filters.quiz = quiz;
	};
	

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

	$scope.resetQuiz = function(){
		$rootScope.ids = _.map($rootScope.filteredSessionsQuiz, function(session){
			console.log("$rootScope.ids")
			console.log($rootScope.ids)
			return session.id;
		});
		Modal.open($scope.modalConfirmDeletedSessionsCtrl, APP_PATH + '/app/views/modals/confirm.html', "md");
	} 

	$scope.resetPub = function(){
		$rootScope.ids = _.map($rootScope.filteredSessionsPub, function(session){
			console.log("$rootScope.ids")
			console.log($rootScope.ids)
			return session.id;
		});
		Modal.open($scope.modalConfirmDeletedSessionsCtrl, APP_PATH + '/app/views/modals/confirm.html', "md");
	} 


	$scope.reset = function(){
		$rootScope.ids = _.map($rootScope.filteredSessions, function(session){
			console.log("$rootScope.ids")
			console.log($rootScope.ids)
			return session.id;
		});
		Modal.open($scope.modalConfirmDeletedSessionsCtrl, APP_PATH + '/app/views/modals/confirm.html', "md");
	}
	$scope.delete = function(session){
		$rootScope.ids = [session.id];
		Modal.open($scope.modalConfirmDeletedSessionsCtrl, APP_PATH + '/app/views/modals/confirm.html', "md");
	}
	$scope.republish = function(id){
		$rootScope.quiz_id = id;
		console.log($rootScope.quiz_id);
		$state.go('quizs.publish', {quiz_id: $rootScope.quiz_id});
	}
	$scope.close = function(){
		$state.go('quizs.home');
	}

	//ouvre la session de l'élève
	$scope.openSession = function(session_id){
		$state.go('quizs.marking_questions', {quiz_id: $stateParams.quiz_id, session_id: session_id});
	}

	

	// -------------- Controllers Modal des quizs --------------- //
		//controller pour confirmer la suppression de sessions avec une modal
		$scope.modalConfirmDeletedSessionsCtrl = ["$scope", "$rootScope", "$uibModalInstance", "$state", "$stateParams", function($scope, $rootScope, $uibModalInstance, $state, $stateParams){
			$scope.message = "Êtes vous sûr de vouloir supprimer ";
			if ($rootScope.ids.length > 1) {
				$scope.title = "Supprimer les sessions";
				$scope.message += "toutes les sessions affichées ?";
			} else {
				$scope.title = "Supprimer la session";
				$scope.message += "cette session ?";
			};
			$scope.no = function(){
				$uibModalInstance.close();
			}
			$scope.ok = function(){
				// On supprime les sessions dans la bdd et dans le scope
				SessionsApi.delete({ids: $rootScope.ids}).$promise.then(function(response){
					if (!response.error) {
						$rootScope.sessions = _.reject($rootScope.sessions, function(session){
							return _.contains($rootScope.ids, session.id);
						});
						$uibModalInstance.close();
					};
				});
			}
}];

		
		// ----------------------------------------------------- //
}]);
