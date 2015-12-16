'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('MarkingQuestionsCtrl', ['$scope', '$state', '$rootScope', '$stateParams', '$sce', '$timeout', 'APP_PATH', 'Notifications','Line', 'Modal', 'Users', 'Questions', 'SessionsApi', '$interval', function($scope, $state, $rootScope, $stateParams, $sce, $timeout, APP_PATH, Notifications, Line, Modal, Users, Questions, SessionsApi, $interval) {

	//id, et coord des deux extrémité de la ligne d'un association
  $scope.connect1 = {id: null, x1: null, y1: null};
  $scope.connect2 = {id: null, x2: null, y2: null};
  SessionsApi.get({id: $stateParams.session_id}).$promise.then(function(response){
  	if (!response.error) {
  		$scope.session = response.session_found;
  	};
  });
	//on récupère la question
	Questions.get($stateParams.quiz_id, $stateParams.id, true, $stateParams.session_id).$promise.then(function(response){
		if (response.question_found) {
			$scope.questions = [response.question_found];			
			var numQuestion = $scope.questions[0].sequence+1;
			$scope.actionTitle = "correction - question " + numQuestion + "/" + $rootScope.quiz.questions.length;
		};
		if (response.questions_found) {
			$scope.questions = response.questions_found;
			$scope.actionTitle = "correction des questions"
		};

		if (!$scope.questions){
			$state.go('erreur', {code: "404", message: "La question n'existe pas !"});
		}
		//recherche la question suivante et retourne l'id
		$scope.nextQuestion = function(){
			//on retrouve l'id de la question suivante
			var nextId = null;
			if ($stateParams.id) {
				var nextNumQuestion = $scope.questions[0].sequence + 1;
				_.each($rootScope.quiz.questions, function(q){
					if (q.sequence === nextNumQuestion) {
			 			nextId = q.id;			
					};
				});				
			};
			return nextId;
		}
		//retourne l'id de la question si on peut revenir en arriere
		$scope.preQuestion = function(){
			var preId = null;
			if ($stateParams.id && $rootScope.quiz.opt_can_rewind) {
 				preId = $scope.questions[0].id;
			};
			return preId;
		}
		//récupère les solutions du prof
		var getSolutions = function(question){
			var solutions = question.solutions;
			return solutions;
		}
		//vérifie la réponse de l'élève par rapport à la solution
		$scope.markingResponseQCM = function(proposition, question){
			var solutions = getSolutions(question);
			// si c'est une réponse de l'élève
			if (proposition.solution) {
				// et qu'elle se trouve dans les solutions du prof,
				// c'est une bonne réponse
				if (_.indexOf(solutions, proposition.id) != -1) {
					return 'correct';
				//sinon c'est un réponse fausse
				} else {
					return 'false';
				};
			} else {
				// l'élève n'a pas mis cette proposition comme solution 
				// si cette proposition se trouve dans les solutions par le profs
				if (_.indexOf(solutions, proposition.id) != -1) {
					// c'est un oubli
					return 'forgot';
				// sinon elle n'est pas solution
				} else {
					return 'none';
				};
			};			
		}
		$scope.markingResponseASS = function(proposition, question){
			// on récupère les solutions correspondant à la question
			var solutions = getSolutions(question);
			//on recherche dans les solutions du prof 
			//si l'id de la proposition de la question, si trouve !
			var propositionOfSolutions = _.find(solutions, function(s){ 
				return s.id === proposition.id
			});
			// si la proposition doit avoir des solutions
			if (propositionOfSolutions) {
				// et si l'élève à trouver des solutions pour cette proposition,
				if (proposition) {
					// pour chaque réponse de l'élève à la proposition,
					// on vérifie si elle est bonne ou non
					_.each(proposition.solutions, function(solution){
						// si la réponse est une solution du prof, c'est une bonne réponse
						if (_.indexOf(propositionOfSolutions.solutions, solution) != -1) {
							$scope.connect(proposition.id, "left", "markingCorrectLinesId");
							$scope.connect(solution, "right", "markingCorrectLinesId");
							// on supprime la solution du prof de la porposition 
							// afin qu'il nous reste que les oublis !!
							propositionOfSolutions.solutions = _.reject(propositionOfSolutions.solutions, function(s){
								return s === solution;
							});
						// sinon c'est une mauvaise réponse
						} else {
							$scope.connect(proposition.id, "left", "markingFalseLinesId");
							$scope.connect(solution, "right", "markingFalseLinesId");
						};
					});
				};
				// normalement il nous reste que les oublis de l'élève pour la proposition
				_.each(propositionOfSolutions.solutions, function(solutionForgot){
					$scope.connect(proposition.id, "left", "markingForgotLinesId");
					$scope.connect(solutionForgot, "right", "markingForgotLinesId");
				});
			// si la proposition ne doit pas avoir de solution, 
			// toute les réponses de l'élève pour cette proposition sont fausses
			} else {
				_.each(proposition.solutions, function(solution){
					$scope.connect(proposition.id, "left", "markingFalseLinesId");
					$scope.connect(solution, "right", "markingFalseLinesId");
				});
			}
		}
		$scope.markingResponseTAT = function(proposition, question){
			// on récupère les solutions correspondant à la question
			var solutions = getSolutions(question);
			//on recherche dans les solutions du prof 
			//si l'id de la proposition de la question, si trouve !
			var solutionOfProposition = _.find(solutions, function(s){ 
				return s.id === proposition.id
			});
			// si l'élève à mis une réponse
			if (proposition.solution) {
				// et si elle correspond alors c'est une bonne réponse
				if (solutionOfProposition && proposition.solution.id === solutionOfProposition.solution.id){
					return 'correct';
				// sinon c'est une mauvaise réponse
				} else {
					return 'false';
				};
			// si l'élève n'a pas mis de réponse
			} else {
				// alors qu'il y a une solution c'est un oublis
				if (solutionOfProposition && solutionOfProposition.solution) {
					return 'forgot';
				// sinon c'est qu'il n'y avait pas de réponse
				} else {
					return 'none';
				};
			};
		}
		
		//afin de laisser les élément se mettre en place on temporise
		
		_.each($scope.questions, function(question){
			if (question.type === 'ass') {
				$timeout(function(){
					for (var i = question.answers.length - 1; i >= 0; i--) {
						$scope.markingResponseASS(question.answers[i].leftProposition, question);	
					}; 
				}, 100); 					
			};				
		// si on est dans le cas d'un TAT, on recré la solution
			if (question.type === 'tat') {
				//on récupère les propositions avec les réponse de l'élève
				$scope.markingQuestionTAT = angular.copy(question.answers);
				//on récupère les solutions au proposition
				var solutions = getSolutions(question);
				for (var i = $scope.markingQuestionTAT.length - 1; i >= 0; i--) {
					$scope.markingQuestionTAT[i].solution = {id: null, libelle: null};
					_.each(solutions, function(solution){
						if (solution.id === $scope.markingQuestionTAT[i].id) {
							$scope.markingQuestionTAT[i].solution = solution.solution;
						};
					});			
				};
			};
		});


		//ouvre la modal pour afficher le média
		$scope.displayMedia = function(title, file, type, mime){
			$rootScope.media = {title: title, file: file, type: type, mime: mime};
			Modal.open($scope.modalDisplayMediaCtrl, APP_PATH + '/app/views/modals/display-media.html', 'lg');
		}

		//lit un media audio
		$scope.play = function(src){
			//on récupère la balise audio
			var audie = $('#audioId').get(0);
			// si on a la même source la laisse sinon on met a jour la source
			if (!audie.src || audie.src !== src) {
				audie.src = $sce.trustAsResourceUrl(src);			
			};
			// permet de mettre pause en recliquant dessus
			if (audie.paused == false) {
				audie.pause();
			} else {
				audie.play();			
			};
		}


		//fonction permettant de quitter la correction 
		$scope.quit = function(){
			$state.go('quizs.home');
		}
		//fonction permettant de passer à la question suivante 
		$scope.next = function(){
			var nextId = $scope.nextQuestion();
			if (nextId) {
				$state.go('quizs.read_questions', {quiz_id: $rootScope.quiz.id, id: nextId, session_id: $stateParams.session_id});
			};
		}
		//fonction permettant de passer à la question suivante 
		$scope.pre = function(){
			var preId = $scope.preQuestion();
			if (preId) {
				$state.go('quizs.read_questions', {quiz_id: $rootScope.quiz.id, id: preId, session_id: $stateParams.session_id});
			}
		}

		// ------- Fonction sur la ligne de connection pour les associations ------- /

		// Fonction qui enregistre le premier point de connection de la ligne, 
		// et lors du deuxième point, elle créé la ligne entre les deux points.
	  $scope.connect = function(idElement, typeProposition, divId){
	  	//on récupère les coordonnées de l'élément
	  	var element = angular.element($('#'+typeProposition+"connect"+idElement));
	  	var xElement = element.offset().left + element.width() / 2;
	  	var yElement = element.offset().top + element.height() / 2;
	  	// on enregistre les point de connections
	  	if (typeProposition === 'left') {
	  		$scope.connect1 = {id: idElement, x1: xElement, y1: yElement};
	  	} else {
	  		$scope.connect2 = {id: idElement, x2: xElement, y2: yElement};
	  	};
	  	//seulement lorsque l'on a les deux points, on créé la ligne et on enregistre les solutions
	  	if ($scope.connect1.x1 != null && $scope.connect1.y1 != null && $scope.connect2.x2 != null && $scope.connect2.y2 != null) {
	  		//on créé la ligne
	  		Line.create(divId, $scope.connect1.id+"_"+$scope.connect2.id, $scope.connect1.x1, $scope.connect1.y1, $scope.connect2.x2, $scope.connect2.y2, $scope);
	  		//on réinitialise les deux extrémités afin de pouvoir recréer une ligne 
		    $scope.connect1 = {id: null, x1: null, y1: null};
		    $scope.connect2 = {id: null, x2: null, y2: null}; 			
	  	};
	  }

		// -------------- Controllers Modal des questions --------------- //
			//controller pour afficher les médias avec une modal
			$scope.modalDisplayMediaCtrl = ["$scope", "$rootScope", "$modalInstance", function($scope, $rootScope, $modalInstance){
				$scope.title = $rootScope.media.title;
				$scope.file = function() {
			    return $sce.trustAsResourceUrl($rootScope.media.file);
			  }
				$scope.mime = $rootScope.media.mime;
				$scope.type = $rootScope.media.type.split("/")[0];
				$scope.close = function(){
					$modalInstance.close();
				}
			}];
	});
}]);
