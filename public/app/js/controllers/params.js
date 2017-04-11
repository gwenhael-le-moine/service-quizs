'use strict';

/* Controllers */

angular.module('quizsApp')
.controller('ParamsCtrl', ['$scope', '$state', '$stateParams',  '$rootScope', 'Notifications', 'QuizsApi', 'Quizs', 'QuestionsApi', 'Modal', 'APP_PATH', function($scope, $state, $stateParams, $rootScope, Notifications, QuizsApi, Quizs, QuestionsApi, Modal, APP_PATH) {
	// titre de l'action mis en majuscule par angular
	$scope.actionTitle = 'paramètres';

	QuizsApi.get({id: $stateParams.quiz_id}).$promise.then(function(response){
		if (!response.error) {
			$rootScope.quiz = response.quiz_found;
			// les différentes options avec l'initialisation des boutons
			$rootScope.quiz.opts = Quizs.getFormatOpt(response.quiz_found);
			QuestionsApi.getAll({quiz_id: $rootScope.quiz.id}).$promise.then(function(responseQuesionApi){
				$rootScope.quiz.questions = responseQuesionApi.questions_found;
			});

			// ouverture et fermeture de l'accordion
			$scope.open = false;

			// fonction permettante de changer l'état des boutons des options
			$scope.changeRadioButton = function(opt, buttonChanged, without_update){
				_.each($rootScope.quiz.opts[opt], function(button, key){
					if (key === buttonChanged) {
						$rootScope.quiz.opts[opt][key] = true;
						if (!without_update) {
							if (opt == 'modes') {
								$rootScope.quiz.opts = Quizs.changeOptsAdvanced(buttonChanged);
							};
							QuizsApi.update(Quizs.updateOpt($rootScope.quiz, opt, buttonChanged));							
						};
					} else{
						$rootScope.quiz.opts[opt][key] = false;
					};
				});
			}
			// fonction qui remet les paramètres par défaut
			$scope.reEstablish = function(){
				$scope.changeRadioButton('randQuestion', 'no');
				$scope.changeRadioButton('modes', 'training');
				$scope.changeRadioButton('correction', 'afterEach');
				$scope.changeRadioButton('canRewind', 'yes');
				$scope.changeRadioButton('score', 'afterEach');
				$scope.changeRadioButton('canRedo', 'yes');
			}

			// fonction qui supprime une question
			$scope.deleteQuestion= function(id){
				QuestionsApi.delete({id: id}).$promise.then(function(response){
					if (!response.error) {
						var indexQuestion = -1;
						_.each(_.sortBy($rootScope.quiz.questions, 'sequence'), function(question, index){
							if (question.id == id) {
								indexQuestion = index;
							};
							if (index > indexQuestion && indexQuestion != -1){
								$rootScope.quiz.questions[index].sequence -= 1;
							}
						});
						QuestionsApi.updateOrder({quiz: $rootScope.quiz});
						$rootScope.quiz.questions = _.reject($rootScope.quiz.questions, function(question){
							return question.id == id;
						});
					} else {
						Notifications.add(response.error.msg, 'error');
					};
				});
			}
			// fonction qui met à jour une question
			$scope.add = function(){
				$state.go('quizs.create_questions', {quiz_id: $rootScope.quiz.id});
			}

			// à revoir
			$scope.back = function(){
				if ($rootScope.quiz.title) {
					$state.go('quizs.home');					
				} else {
					Modal.open('ModalChangeTitleQuizCtrl', APP_PATH+'/app/views/modals/add-change-object.html', 'md');
				};
			}
			// retour vers la page d'accueil
			$scope.close = function(){
			// QuizsApi.delete({id: $rootScope.quiz.id});
			$state.go('quizs.home');
			}

			// retour vers la page d'accueil
			$scope.retour = function(){
			// QuizsApi.delete({id: $rootScope.quiz.id});
			$state.go('quizs.home');
			}

			// fonction qui met à jour une question
			$scope.updateQuestion = function(id){
				$state.go('quizs.update_questions', {quiz_id: $rootScope.quiz.id, id: id});
			}

			// cette fonction permet de renseigner l'odre des questions
			$scope.kanbanSortOptions = {
		    orderChanged: function (event) {
		    	//pour avoir l'ordre on récupère dans event dest index
		    	//et pour l'ancien cest dans event source index
		    	//on remplace les sequence des questions par les bonnes
		    	if (event.dest.index >= event.source.index) {
				    for (var i = event.dest.index; i >= event.source.index; i--) {
				    	$rootScope.quiz.questions[i].sequence = i;
				    };
		    	} else {
		    		for (var i = event.source.index; i >= event.dest.index; i--) {
				    	$rootScope.quiz.questions[i].sequence = i;
				    };
		    	};
		    	// $rootScope.quiz.questions[event.dest.index].sequence = event.dest.index
		    	// $rootScope.quiz.questions[event.source.index].sequence = event.source.index
		    	QuestionsApi.updateOrder({quiz: $rootScope.quiz});
		    },
		    containment: '#board'
		  };

			// si on referme les params avancés, on regarde si on a une config prédéfinie ou pas
			$scope.$watch("open", function(newVal, oldVal){
				if (!newVal) {
					//par simplification je récupère les opts dans une variable
					var opts = $rootScope.quiz.opts;
					// on se met par défaut en mode perso
					$scope.changeRadioButton('modes', 'perso', true);
					//mais si on a une config du mode entrainement on se met dans ce mode
					if (opts.correction.afterEach && opts.canRewind.yes && opts.score.afterEach && opts.canRedo.yes) {
						$scope.changeRadioButton('modes', 'training', true);
					};
					//pareil pour les autres modes
					if (opts.correction.atEnd && opts.canRewind.no && opts.score.atEnd && opts.canRedo.no) {
						$scope.changeRadioButton('modes', 'exercise', true);
					};
					if (opts.correction.none && opts.canRewind.no && opts.score.atEnd && opts.canRedo.no) {
						$scope.changeRadioButton('modes', 'assessment', true);
					};
				};
			});
		} else {
			$state.go('erreur', {code: "404", message: response.error.msg});
		};
	});
}]);